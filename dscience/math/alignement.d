/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

/**
 * Implements algorith to align biological sequence.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/math/alignement.d
 */
module dscience.math.alignement;

import std.stdio;
import std.path;
import std.string;
import std.conv;
import std.algorithm;
import dscience.physic.molecule;
import dscience.exception;

abstract class Alignement{
    protected:
        SubstitutionMatrix    substitutionMatrix;
        long                  insertPenality;
        long                  deletePenality;
        long                  gapExtend;
        long[][][]            costMatrix;
        long[][][]            coordMatrix;
        uint                  alignementNumber;

    public:
        this(SubstitutionMatrix substitutionMatrix, long insertPenality, long deletePenality, long gapExtend){
            this.substitutionMatrix = substitutionMatrix;
            this.insertPenality     = insertPenality;
            this.deletePenality     = deletePenality;
            this.gapExtend          = gapExtend;
            this.costMatrix         = new long[][][](3);
            this.coordMatrix        = new long[][][](3);
            this.alignementNumber   = 0;
        }


        this(SubstitutionMatrix substitutionMatrix){
            this.substitutionMatrix = substitutionMatrix;
            this.insertPenality     = 0;
            this.deletePenality     = 0;
            this.gapExtend          = 1;
            this.costMatrix         = new long[][][](3);
            this.coordMatrix        = new long[][][](3);
        }

        string[] pairwiseAlignment(ISymbol[] sequence1, ISymbol[] sequence2){
            return pairwiseAlignment(symbolToString(sequence1), symbolToString(sequence2));
        }

        abstract string[] pairwiseAlignment(string sequence1, string sequence2, bool isVerbose=true);

        /**
         * This gives the edit distance according to the given parameters of this
         * certain object. It returns just the last element of the internal cost
         * matrix (left side down).
         *
         * Returns:
         * returns the edit_distance computed with the given parameters.
         */
        long getEditDistance(){
            return costMatrix[alignementNumber][costMatrix[alignementNumber].length - 1][costMatrix[alignementNumber][costMatrix[alignementNumber].length - 1].length - 1];
        }

    abstract:
        void calculateMatrix(ref string sequence1, ref string sequence2, ref size_t[] sequence1Array, ref size_t[] sequence2Array);

    protected:
        string symbolToString(ref ISymbol[] sequence){
            char[] result = new char[](sequence.length);
            foreach(index, symbol; sequence)
                result[index] = symbol.letter;

            return to!string( result );
        }

        bool checkSequence(ref string sequence){
            bool    result  = true;
            size_t  index   = 0;
            while(result && index < sequence.length){
                result = substitutionMatrix.isIn(sequence[index]);
                index++;
            }
            return result;
        }

}

class NeedlemanWunsh: Alignement{
    public:

        this(SubstitutionMatrix substitutionMatrix, long insertPenality, long deletePenality, long gapExtend){
            super(substitutionMatrix, insertPenality, deletePenality, gapExtend);
        }

            this(SubstitutionMatrix substitutionMatrix){
            super(substitutionMatrix);
        }


        string[] searchAllSolutions(string sequence1, string sequence2,  bool isVerbose=true){
            size_t arrayLen     = max(sequence1.length,sequence2.length);
            string seq1reverse  = to!string( sequence1.dup.reverse );
            string seq2reverse  = to!string( sequence2.dup.reverse );
            string[] result     = new string[](6,arrayLen);
            result[0..2]        = pairwiseAlignment(sequence1, sequence2);
            alignementNumber++;
            result[2..4]        = pairwiseAlignment(seq1reverse, sequence2);
            alignementNumber++;
            result[4..6]        = pairwiseAlignment(seq1reverse, seq2reverse);
            alignementNumber = 0;
            return result;
        }

        override:
            string[] pairwiseAlignment(string sequence1, string sequence2,  bool isVerbose=true){
                size_t[]    sequence1Array  = substitutionMatrix.convertSequenceToArray(sequence1);
                size_t[]    sequence2Array  = substitutionMatrix.convertSequenceToArray(sequence2);
                calculateMatrix(sequence1, sequence2, sequence1Array, sequence2Array);

                debug{
                    writefln( "array1: %s", sequence1Array );
                    writefln( "array2: %S", sequence2Array );
                    writeln( "--------------------------" );
                    writeln( "Matrice (penality):" );
                    foreach(ref line; costMatrix[alignementNumber]){
                        foreach(ref column; line){
                            if(column >= 0 && column < 10)
                                writefln("   %d",column );
                            else if((column >= 10 && column < 100) || (column < 0 && column > -10))
                                Swritefln("  %d",column );
                            else if((column >= 100 && column < 1000) || (column <= -10 && column > -100))
                                writefln(" %d",column );
                        }
                        writeln();
                    }
                    writeln("--------------------------");
                    writeln("Matrice (substitution):");
                    foreach(ref line; substitutionMatrix.getMatrix())
                        writeln( line );
                    writeln("--------------------------");
                }

                string alignement1 = "";
                string alignement2 = "";
                size_t i = sequence1.length;
                size_t j = sequence2.length;

                size_t coordArrayLength = coordMatrix[alignementNumber].length;

                while(i > 0  && j > 0){
                    long score          = costMatrix[alignementNumber][i][j];
                    long scoreDiagonale = costMatrix[alignementNumber][i-1][j-1];
                    long scoreLeft      = costMatrix[alignementNumber][i-1][j];
                    long scoreUp        = costMatrix[alignementNumber][i][j-1];
                    debug{
                        writeln("Alignement optimale");
                        writefln("i: %d\tj: %d",i,j);
                        writefln("substitution matrix:\t%d",substitutionMatrix[sequence1Array[i-1],sequence2Array[j-1]]);
                    }
                    if(score == scoreDiagonale + substitutionMatrix[sequence1Array[i-1],sequence2Array[j-1]]){
                        alignement1 = sequence1[--i] ~ alignement1;
                        alignement2 = sequence2[--j] ~ alignement2;
                    }
                    else if (score == scoreLeft + insertPenality){
                        alignement1 = sequence1[--i] ~ alignement1;
                        alignement2 = "-" ~ alignement2;
                    }
                    else if (score == scoreUp + deletePenality){
                        alignement1 = "-" ~ alignement1;
                        alignement2 = sequence2[--j] ~ alignement2;
                    }
                    else{
                        alignement1 = "-" ~ alignement1;
                        alignement2 = sequence2[--j] ~ alignement2;
                    }

                    if(coordArrayLength == coordMatrix[alignementNumber].length)
                        coordMatrix[alignementNumber].length = coordMatrix[alignementNumber].length +10;
                    coordMatrix[alignementNumber][coordArrayLength] = [i,j];
                    coordArrayLength++;

                    debug{
                        writefln("score:\t\t\t%d",score);
                        writefln("score diagonale:\t%d",scoreDiagonale);
                        writefln("score up:\t\t%d",scoreLeft);
                        writefln("score left:\t\t%d",scoreUp);
                        writefln("Sequence 1:\t%d",alignement1);
                        writefln("Sequence 2:\t%d",alignement2);
                        writeln("--------------------------");
                    }
                }
                while(i > 0){
                    alignement1 = sequence1[--i] ~ alignement1;
                    alignement2 = "-" ~ alignement2;
                    if(coordArrayLength == coordMatrix.length)
                        coordMatrix.length = coordMatrix.length +10;

                    coordMatrix[alignementNumber][coordArrayLength] = [i,j];
                    coordArrayLength++;
                }
                while(j > 0){
                    alignement1 = "-" ~ alignement1;
                    alignement2 = sequence2[--j] ~ alignement2;
                    if(coordArrayLength == coordMatrix.length)
                        coordMatrix.length = coordMatrix.length +10;

                    coordMatrix[alignementNumber][coordArrayLength] = [i,j];
                    coordArrayLength++;
                }
                // resize array to content
                coordMatrix.length = coordArrayLength;
                if(isVerbose){
                    writefln("Result");
                    writefln("Sequence 1:\t%d",sequence1);
                    writefln("Sequence 2:\t%d",sequence2);
                    writefln("The edit distance:\t%d", getEditDistance());
                    writeln("Alignement:");
                    writeln(alignement1);
                    writeln(alignement2);
                }
                return [alignement1, alignement2].dup;
            }

            void calculateMatrix(ref string sequence1, ref string sequence2, ref size_t[] sequence1Array, ref size_t[] sequence2Array){
            costMatrix[alignementNumber] = new long[][](sequence1Array.length+1,sequence2Array.length+1);
            for( size_t j = 1; j <= sequence2Array.length; j++){
                // j do not be > long.max or the result can not be store in matrix.
                // for this reason sequence length can not be > long.max.
                //we can not use ulong because they are negative value in matrix
                costMatrix[alignementNumber][0][j] = deletePenality * j * gapExtend;
                costMatrix[alignementNumber][1][j] = deletePenality * j * gapExtend;// * deletePenality * gapExtend;
            }
            for(size_t i = 1; i <= sequence1Array.length; i++){
                costMatrix[alignementNumber][i][0] = insertPenality * i * gapExtend;
                costMatrix[alignementNumber][i][1] = insertPenality * i * gapExtend;// * insertPenality * gapExtend;
                for(size_t j = 1; j <= sequence2Array.length; j++){
                    debug{
                        writeln("Calculate Matrix:");
                        writefln("i:\t%d\tj:\t%d",i,j);
                        writefln("match:%d,%d =>\t%d", sequence1Array[i-1], sequence2Array[j-1], substitutionMatrix[sequence1Array[i-1], sequence2Array[j-1]]);
                        writefln("matrix[i-1][j-1]:\t%d", costMatrix[alignementNumber][i-1][j-1]);
                        writefln("matrix[i-1][j]:\t\t%d", costMatrix[alignementNumber][i-1][j]);
                        writefln("matrix[i][j-1]:\t\t%d", costMatrix[alignementNumber][i][j-1]);
                        writeln("--------------------------");
                    }
                    long scoreDiagonale = costMatrix[alignementNumber][i-1][j-1] + substitutionMatrix[sequence1Array[i-1],sequence2Array[j-1]];
                    long scoreLeft      = costMatrix[alignementNumber][i-1][j] + insertPenality;
                    long scoreUp        = costMatrix[alignementNumber][i][j-1] + deletePenality;
                    costMatrix[alignementNumber][i][j] = max(scoreDiagonale,scoreLeft,scoreUp);
                }
            }
        }
}

class SubstitutionMatrix{
    private:
        short[][]   matrix;
        short       min;
        short       max;
        string      alphabet;

    public:
        /**
         * Construct an identity matrix
         */
        this(string alphabetList, short match, short replace){
            this.alphabet   = alphabetList;
            this.matrix     = new short[][](alphabetList.length, alphabetList.length);
            foreach(r, ref row; matrix){
                foreach(c, ref column; row){
                    if(r == c)
                        column = match;
                    else
                        column = replace;
                }
            }
            this.min = replace;
            this.max = match;
        }

        /**
         * Construct an identity matrix
         * match    = 1
         * replace  = 0
         */
        this(string alphabetList){
            this.alphabet   = alphabetList;
            this.matrix     = new short[][](alphabetList.length, alphabetList.length);
            foreach(r, ref row; matrix){
                foreach(c, ref column; row){
                    if(r == c)
                        column = 1;
                    else
                        column = 0;
                }
            }
            this.min = 0;
            this.max = 1;
        }

        /**
         * Construct a subtitution matrix from given matrix
         * Element in alphabetList need be in right order!
         */
        this (string alphabetList, short[][] matrix){
            this.min        = short.min;
            this.max        = short.min;
            this.alphabet   = alphabetList;
            this.matrix     = matrix;
            foreach(row; matrix){
                foreach(column; row){
                    if (column < min)
                        min = column;
                    else if (column > max)
                        max = column;
                }
            }
        }

        /**
         * Copy a substitution Matrix object
         */
        this(SubstitutionMatrix substitutionMatrix){
            this.matrix     = substitutionMatrix.getMatrix();
            this.alphabet   = substitutionMatrix.getAlphabet();
            this.min        = substitutionMatrix.getMin();
            this.max        = substitutionMatrix.getMax();
        }

        short[][] getMatrix(){
            return matrix.dup;
        }

        string getAlphabet(){
            return alphabet.idup;
        }

        short getMin(){
            return min;
        }

        short getMax(){
            return max;
        }

        bool isIn(char symbol){
            bool    isSearching = true;
            bool    isPresent   = false;
            short   index       = 0;
            while(isSearching && index < alphabet.length){
                if (alphabet[index] == symbol){
                    isPresent   = true;
                    isSearching = false;
                }
                else
                    index++;
            }
            return isPresent;
        }

        short getSymbolPosition(char symbol){
            bool    isSearching = true;
            bool    isPresent   = false;
            short   index       = 0;
            while(isSearching && index < alphabet.length){
                if (alphabet[index] == symbol){
                    isPresent   = true;
                    isSearching = false;
                }
                else
                    index++;
            }
            if (isPresent == false)
                throw new SymbolNotFoundException(__FILE__,__LINE__);
            return index;
        }

        size_t[] convertSequenceToArray(string sequence){
            size_t[] result = new size_t[](sequence.length);
            foreach(index, letter; sequence)
                result[index] = getSymbolPosition(letter);
            return result.dup;
        }

        char getSymbol(size_t number){
            return alphabet[number];
        }

        short getValue(size_t i, size_t j){
            return matrix[i][j];
        }

        short opIndex(size_t i, size_t j){
            return getValue(i,j);
        }

}


class PositionWeightMatrix(T){
    private:
        string          _name;
        T[][]           _matrix;
        string[size_t]  _label;

    public:
        this( string name, T[][] matrix, string[size_t] label ){
            _name   = name;
            _matrix = matrix;
            _label  = label;
        }

        /**
         * Load simple matrix file, something like(contain only number tab delimited) :
         *  0.5   0.25  0.25  0
         *  0.25  0.5   0.25  0
         *  0.5   0     0.25  0.25
         *  0.25  0.5   0.25  0
         * For an advanced parser see module format and his class Mat
         */
        this( string filePath, string[size_t] label, string separator = "\t" ){
            File pwmFile    = File( filePath, "r" );
            _label          = label;
            if( extension( filePath ).empty )
                _name           = baseName( filePath );
            else
                _name           = baseName( filePath, extension( filePath ) );
            size_t length   = 10;
            size_t counter  = 0;
            _matrix.length  = 10;

            foreach( counter, line; pwmFile.byLine() ){
                if( length == counter ){ // save time by not increase at each step matrix size
                    length += 10;
                    _matrix.length = length;
                }
                _matrix[counter] = array( map!(to!T)( line.splitter(separator) ) );
            }
            _matrix.length = counter;
        }
}

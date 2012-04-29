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
 * Sequence definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/sequence.d
 */
module dscience.molecules.sequence;

import std.string;
import std.array;

import dscience.exception;
import dscience.molecules.amino_acid;
import dscience.molecules.nucleic_acid;

class Sequence{
    protected:
        /**
         * Raw sequence
         */
        string _seq;

        /**
         * Id of the sequence
         */
        string _id;
        /**
         * Allowed alphabet from sequence nature (protein or dna)
         * Default : dna alphabet
         */
        Alphabet _alphabet;

        bool checkSequence(ref string seq){
            bool    result  = true;
            size_t  index   = 0;
            while(result && index < seq.length){
                result = isInAlphabet(seq[index]);
                index++;
            }
            return result;
        }

        bool isInAlphabet(char symbol){
                bool    isSearching = true;
                bool    isPresent   = false;
                short   index       = 0;
                string  letters     = alphabetFactory( _alphabet );
                while(isSearching && index < letters.length){
                    if (letters[index] == symbol){
                        isPresent   = true;
                        isSearching = false;
                    }
                    else
                        index++;
                }
                return isPresent;
            }

    public:
        /**
         * Basic Constructor
         *
         * @param seq
         * @param alphabet
         *
         * @return
         */
        this( string seq, Alphabet alphabet = Alphabet.Unknown ){
            _seq        = seq;
            _alphabet   = alphabet;

            // Clean sequence
            toUpper(_seq);

            // check for forbidden caracter
            //~ if(alphabet && !checkSequence(_cleanSeq) )
                //~ throw new BadSymbolException(__FILE__,__LINE__);
        }

        int opApply( int delegate(char) dg ){
            int result = 0;
            foreach( letter; _seq )
                result = dg( letter );
            return result;
        }

        int opApply( int delegate(size_t, char) dg ){
            int result = 0;
            foreach( size_t counter, letter; _seq )
                result = dg(counter, letter );
            return result;
        }

        string opSlice(size_t start, size_t end ){
            return _seq[start .. end].idup;
        }

        char opIndex(size_t n){
            assert(n < length);
            return _seq[n];
        }

        void opIndexAssign(char letter, size_t n){
            assert(n < length);
            if( n == _seq.length -1 )
                _seq = _seq[0 .. n] ~ letter;
            else
                _seq  = _seq[0 .. n] ~ letter ~ _seq[n + 1 .. $];
        }

        void popFront(){
            assert( _seq.length, "Attempting to fetch the front of an empty array of " ~ typeof(_seq[0]).stringof );
            _seq = _seq[1..$];
        }

        void popBack(){
            assert( _seq.length, "Attempting to fetch the front of an empty array of " ~ typeof(_seq[0]).stringof );
            _seq = _seq[0 .. $ - 1];
        }

        void put( char letter ){
            _seq ~= std.conv.to!string( letter );
        }

        void put( char[] seq ){
            _seq ~= std.conv.to!string( seq );
        }

        void put( string seq ){
            _seq ~= seq;
        }

        void put( Sequence seq ){
            _seq ~= seq.toString();
        }

        override string toString(){
            return _seq;
        }

    @property:

       Alphabet alphabet(){
            return _alphabet;
       }

        char back(){
            assert( _seq.length, "Attempting to fetch the front of an empty array of " ~ typeof(_seq[0]).stringof );
            return _seq[ $ - 1 ];
        }

        bool empty(){
            return _seq.length == 0;
        }

        dchar front(){
            assert( _seq.length, "Attempting to fetch the front of an empty array of " ~ typeof(_seq[0]).stringof );
            return _seq[0];
        }

        /**
         * Return the sequence id
         */
        string id(){
            return _id;
        }

        /**
         * Set the sequence id
         */
        void id(string id){
            _id = id;
        }

        /**
         * Return the sequence length
         */
        size_t length(){
            return _seq.length;
        }

        Sequence save(){
            return this;
        }

        string data(){
            return _seq;
        }
}

enum Alphabet{
    Amino,
    DNA,
    Nucleic,
    RNA,
    Unknown
}

string alphabetFactory( Alphabet alphabet ){
    string result;
    switch( alphabet ){
        case Alphabet.Amino:
            result = aminoLetters;
            break;
        case Alphabet.DNA:
            result = dnaLetters;
            break;
        case Alphabet.Nucleic:
            result = nucleicLetters;
            break;
        case Alphabet.RNA:
            result = rnaLetters;
            break;
        case Alphabet.Unknown:
        default:
            result = "";
    }
    return result;
}

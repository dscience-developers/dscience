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
 * Implements functionality to read fasta files from a input range of $(D dchar).
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/parser/fasta.d
 */
module dscience.parser.fasta;

import std.stdio;
import std.string;
import std.conv;
import std.file;
import std.array;
import dscience.math.matrix;
import dscience.molecules.sequence;

struct FastaData{
    string   header;
    Sequence sequence;

    this( string header ){
        this.header     = header;
        this.sequence   = null;
    }

    this( string header = "", Sequence sequence = null ){
        this.header     = header;
        this.sequence   = sequence;
    }

    string toString(){
        assert( header != "" && sequence !is null, "Can not convert to string an empty data." );
        return "> %s\n%s".format(header, sequence);
    }

    @property bool empty(){
        return ( header == "" && sequence is null);
    }
}

struct Fasta{
    private:
        FastaData[]  _data;
        size_t  _length;

    public:

        this( FastaData[] data = []){
            _data   = data;
            // ensure array do not contain null element from end
            //~ while( _data.length > 0  && _data[ $ - 1 ] is null )
                //~ _data = _data[ 0 .. $ - 1];
            _length = _data.length;
        }

        void popFront(){
            assert( _data.length, "Attempting to fetch the front of an empty array of " ~ typeof(_data[0]).stringof );
            _data = _data[1..$];
        }

        void popBack(){
            assert( _data.length, "Attempting to fetch the front of an empty array of " ~ typeof(_data[0]).stringof );
            _data = _data[0 .. $ - 1];
        }

        int opApply( int delegate(FastaData) dg ){
            int result = 0;
            foreach( item; _data )
                result = dg( item );
            return result;
        }

        int opApply( int delegate(size_t, FastaData) dg ){
            int result = 0;
            foreach( size_t counter, item; _data )
                result = dg(counter, item );
            return result;
        }

        FastaData opIndex(size_t n){
            assert(n < length);
            return _data[n];
        }

        void opIndexAssign(FastaData value, size_t n){
            assert(n < length);
            _data[n] = value;
        }

        void put( FastaData[] values... ){
            foreach( counter, value; values){
                size_t index = _length + counter;
                if( _length + counter >= _data.length )
                    _data.length = _data.length + 10;
                _data[ index ] = value;
                _length++;
            }
            shrink();
        }

        string toString(){
            string result = "";
            foreach( item; _data )
                result ~= item.toString();
            return result;
        }

        @property:
            bool empty(){
                return _data.length == 0;
            }

            ref FastaData front(){
                assert( _data.length, "Attempting to fetch the front of an empty array of " ~ typeof(_data[0]).stringof );
                return _data[0];
            }

            ref FastaData back(){
                assert( _data.length, "Attempting to fetch the front of an empty array of " ~ typeof(_data[0]).stringof );
                return _data[ $ - 1 ];
            }

            Fasta save(){
                return this;
            }

            size_t length() const{
                return _length;
            }

            FastaData[] data(){
                return _data;
            }

            void shrink(){
                _data.length = _length;
            }
}

/**
 * fastaReader
 * Parse fasta file
 * Params:
 *  filePath  = path where data are stored
 *  alphabet  = Amino, DNA, Nucleic, RNA  ... default Unknown
 * Returns:
 *  A Fasta structure
 * Throws: $(D FileException) if file does not exist
 */
Fasta fastaReader( string filePath, Alphabet alphabet = Alphabet.Unknown ){
    File        fastaFile   = File( filePath, "r" );
    scope(exit) fastaFile.close();
    Fasta       fasta       = Fasta();
    FastaData   current;

    foreach( char[] line; fastaFile.byLine() ){
        line = line.stripLeft().stripRight();           // remove extra space
        if( line.empty )
            continue;
        else if( line[0] == '>' ){                      // add header to FastaData structure and store previous FastaData structure into Fasta structure
            if( ! current.empty )
                fasta.put( current );
            current = FastaData( line[1..$].idup );     // Do not store char '>' in header
        }
        else{                                           // it is a sequence line
            if( current.sequence is null )
                current.sequence = new Sequence( to!string(line), alphabet );
            else
                current.sequence.put( new Sequence( to!string(line), alphabet ) );
        }
    }
    if( current.empty )                                 // Store the latest element
        fasta.put( current );

    fasta.shrink;
    return fasta;
}
/**
 * Write a Sequence object to fasta file format
 * Params:
 *  ouputPath = path where data will be written
 *  sequence  = a Sequence object
 *  header    = a string, can to be null
 *  column    = number of letter by line, default 80
 * Throws: $(D FileException) if file does not exist
 */
void fastaWriter( string ouputPath, Sequence sequence, string header = "unknow", size_t column = 80 ){
    File outFasta           = File( ouputPath, "a+");
    scope(exit) outFasta.close();
    size_t maxIter          = sequence.length / column;
    size_t start            = 0;
    size_t end              = 0;
    outFasta.writeln( "> %s".format(header) );
    foreach( iter; 0 .. maxIter ){
        start   = end;
        end     += column;
        outFasta.writeln( sequence[ start .. end ] );
    }
    start = end;
    if( start < sequence.length )
        outFasta.writeln( sequence[ start .. sequence.length ] );
}

/**
 * Write a Sequence object to fasta file format
 * Params:
 *  ouputPath = path where data will be written
 *  sequences = an associative array where key is a heder and value a Sequence object
 *  column    = number of letter by line, default 80
 * Throws: $(D FileException) if file does not exist
 */
 void fastaWriter( string ouputPath, FastaData[] datas, size_t column = 80 ){
    foreach( data; datas )
        fastaWriter( ouputPath, data.sequence, data.header, column );
 }


/**
 * Write a Sequence object to fasta file format
 * Params:
 *  ouputPath = path where data will be written
 *  sequences = an array of Sequence object
 *  headers   = an array of string, can to be null
 *  column    = number of letter by line, default 80
 * Throws:
 *  $(D FileException) if file does not exist
 *  $(D Exception) headers length not equal to sequences length
 */
 void fastaWriter( string ouputPath, Sequence[] sequences, string[] headers = null, size_t column = 80 ){
    if( headers.length != sequences.length )
        throw new Exception( "Array headers and array sequences does not have same length: %d != %d".format(headers.length, sequences.length) );
    string currentHeader;
    foreach( index, sequence; sequences ){
        if( headers is null ) currentHeader = "unknow_%d".format( index );
        else currentHeader = headers[index];
        fastaWriter( ouputPath, sequence, currentHeader, column );
    }
 }

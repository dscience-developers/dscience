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
 * Implements functionality works around motif searching.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/math/motif.d
 */
 module dscience.motif;

import std.string;
import std.stdio;
import std.conv : to;
import std.array : array, map, split, empty, appender;
import std.math : log2;
import std.algorithm : filter, reduce;

/**
 * scanning
 * scan the whole sequence against a position Weight matrix
 * Params:
 *  matrix      = a normalized position weight matrix
 *  sequence    = sequence to scan
 *  label       = name / position to each column ( ["A":0, "C":1, "G":2, "T":3] )
 *  background  = ["A":0.25, "T":0.25, "G":0.25, "C":0.25];
 *  treshold    = minimum score to filter, default value 0
 * Returns:
 *  scanning score to corresponding sequence / matrix
 */
T[][] scanning( T )( ref T[][] motif, size_t[string] label, string sequence, T[string] backgroung, double treshold = 0 ){ // sequence.length > motif.length
    size_t  startPosition   = 0;
    T       currentScore    = 0;
    T[][]   score;
    auto   list             = appender(score);

    while( startPosition < (sequence.length - motif.length) ){              // iterate over sequence to scan letter by letter
        foreach( size_t motifPosition, ref T[] letterWeight; motif ){       // compute score if motif are located at this poition
            char    letter      = sequence[motifPosition + startPosition];  // get which letter are into sequence at this position
            size_t  letterIndex = label[ to!string(letter) ];               // take at which position are located the letter into the pwm matrix
            currentScore       += letterWeight[letterIndex];                // get is corresponding score
        }
        if( currentScore >= treshold )
            list.put( [startPosition, (startPosition + motif.length), currentScore] );
        startPosition++;
        currentScore = 0;
    }
    return list.data;
}

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
 * Implements functionality to use read a matrix froma  file.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/math/matrix.d
 */
module dscience.parser.matrix;

import std.conv;
import std.file;
import std.array;
import std.algorithm;
import std.string;

/**
 * matrixReader
 * load a matrix from a file.
 * Params:
 *  filePath    = path to file who contain matrix
 *  separator   = set delimiter used into the file for separate each column default it is tab
 * Returns:
 * A 2D array
 */
T[][] matrixReader( T )( string filePath, string separator = "\t" ){
    File matrixFile = File( filePath, "r");
    T[][] matrix;
    size_t length   = 10;
    size_t counter  = 0;
    matrix.length   = 10;
    foreach( line; matrixFile.byLine() ){
        if( length == counter ){
            length += 10;
            matrix.length = length;
        }
        matrix[counter] = array( map!(to!T)( filter!"!a.empty"(line.split( separator ) ) ) );// Use filter like split bug and do not merge consecutive delimiter
        counter++;
    }
    matrix.length = counter;
    return matrix;
}

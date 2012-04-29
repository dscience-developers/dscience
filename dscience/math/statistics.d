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
 * Implements functionality to do basic statistics.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/math/statistics.d
 */
module dscience.math.statistics;
import std.string;
import std.exception;
import std.math     : ceil, floor, sqrt;
import std.algorithm: sort;;
import std.array;

real[] quartile(T)( T[] data ){
    T[3] result;
    size_t effective = data.length;
    real q1        = ceil(effective / 4) - 1; // array tart at 0 so - 1
    real q2        = (effective % 2 == 0) ? data[(effective/2) - 1] + data[effective/2] / 2 : data[effective/2];
    real q3        = q1 *3;
    result[0] = q1; // 25%
    result[1] = q2; // 50% median
    result[2] = q3; // 75%
    return result;

}

size_t[string] sampling(T)( T[] data, double frame=1 ){
    size_t[string] hash;
    foreach( item; data ){
        real result,  start, end;
        string key;
        result = item / frame;
        start  = floor( result ) * frame;
        end    = ceil( result )  * frame;
        key    = "%.2f - %.2f".format(start, end);
        if( key in hash )
            hash[key] += 1u;
        else
            hash[key] = 1u;
    }
    return hash;
}

real average(T)( T[] data ){
    return cast(T) reduce!("a + b")(data) / data.length;
}

real variance(T)( T[] data ){
    real avg = average!T( data );
    real var = 0;
    foreach(T item; data )
        var +=  ( item - avg )^^2 ;
    return var / data.length;
}

real standard_deviation(T)( T[] data ){
    return sqrt( variance!T(data) );
}

/**
 * Benjamini & Hochberg
 * Params:
 * pv        = p value list
 * threshold = level at which FDR rate should be controlled
 */
T[] bh_rejected(T)( T[] pv, double threshold = 0.05, bool isSorted = false){
    T[]    result;
    size_t m, index;
    bool   isComputing = true;
    if( threshold < 0 || threshold > 1 )
        throw new Exception("The threshold must be between 0 and 1");
    if ( pv !is null ){
        if( !isSorted )
            pv = array( sort!("a < b")( pv ) );
        if( pv[0] < 0 || pv[$-1] > 1 )
            throw new Exception("p-values must be between 0 and 1");
        m       = pv.length;
        index   = m - 1;
        while( isComputing ){
            writefln( "Index: %d, p value: %s, compute: %f", index, pv[index] , (index+1) * threshold / m );
            if( pv[index] <= (index+1) * threshold / m ){
                result      = pv[0..index+1];
                isComputing = false;
            }
            if( index == 0 )
                isComputing = false;
            else
                index--;
        }
    }
    return result;
}

real accuracy(T)( T positive, T negative, T true_positive, T true_negative ){
    return (true_positive + true_negative) / (positive + negative);
}

real specificity(T)( T true_negative, T false_positive ){
      return true_negative / (false_positive + true_negative);
}

real precision(T)(T true_positive, T false_positive){
    return true_positive / (true_positive + false_positive);
}

real false_discovery_rate(T)(T true_positive, T false_positive){
    return false_positive / (false_positive + true_positive);
}

real true_positive_rate(T)(T true_positive, T false_negative){
    return true_positive / (true_positive + false_negative);
}

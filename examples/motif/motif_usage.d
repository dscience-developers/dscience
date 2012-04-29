import std.file;
import std.string;
import std.stdio;
import dscience.parser.csv;
import dscience.math.motif;

void main(){
    string filename = "/home/jonathan/pwm.mat";
    writefln( "> Writing a position weight matrix into file: %s", filename );
    // write Motif into a file as position weight matrix
    File pwmFile = File( filename, "w" );
    //  letters:     A      C     G     T     # Position num°
    pwmFile.writeln("0.3   0.2   0.2   0.3");   // 1
    pwmFile.writeln("0.1   0.4   0.4   0.1");   // 2
    pwmFile.writeln("0.25  0.25   0.25  0.25"); // 3
    pwmFile.writeln("0.35  0.15  0.15  0.35");  // 4
    pwmFile.writeln("0.25  0.25   0.25  0.25"); // 5
    pwmFile.writeln("0.35  0.15  0.15  0.35");  // 6
    pwmFile.writeln("0.1   0.4   0.4   0.1");   // 7
    pwmFile.writeln("0.3   0.2   0.2   0.3");   // 8
    pwmFile.writeln("0.3   0.2   0.2   0.3");   // 9
    pwmFile.close();


    string          sequence1           = "ACGTACGGACTGTACGTAGTCGTGCATGTACGTAGTCTAGCTCGAT";
    string          sequence2           = "GCTAGTCGACCAGACTTCGATCGATCGATAGCTAGTCGATAGTAGA";

    writefln( "> Loading matrix file: %s", filename );
    double[][]      matrix              = loadMatrixFile!double( filename, " " );       // delimiter used here is space
    size_t[string] label                = ["A":0, "C":1, "G":2, "T":3];                 // Letters position in corresponding file
    double[string] background           = ["A":0.25, "C":0.25, "G":0.25, "T":0.25];     // Frequencies of each letter on whole genome by example, sum = 1
    writeln( "> Normalizing mosition weight matrix" );
    double[][]     normalizedMatrix     = normalize!double( matrix, label, background );// In first you need to normalize matrix motif
    writeln( "> Result" );
    foreach( ref double[] row; normalizedMatrix)                                        // print normalized matrix
        writeln( row );
    writeln( "> scanning 1" );
    double[][]      result1             = scanning!double( normalizedMatrix, label, sequence1, background );
    writeln( "> Result" );
    foreach( result; result1 )
        writefln( "start: %d, end: %d, score: %f", cast(size_t)result[0], cast(size_t)result[1], result[2] );
    writeln( "> scanning 2" );
    double[][]      result2             = scanning!double( normalizedMatrix, label, sequence2, background );
    writeln( "> Result" );
    foreach( result; result2 )
        writefln( "start: %d, end: %d, score: %f", cast(size_t)result[0], cast(size_t)result[1], result[2] );
    remove( filename );
    writeln( "> information" );
    writeln( information!double( normalizedMatrix, label, background ) );
}


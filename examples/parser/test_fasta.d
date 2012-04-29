import std.stdio;
import dscience.parser.fasta;
import dscience.molecules.sequence;

void main(){
    enum string fastaInFilePath     = "test.fasta";
    enum string fastaOutFilePath    = "test_out.fasta";

    writeln( "1/4 Starting to parse file "~fastaFilePath );

    Fasta fasta = fastaReader(fastaFilePath, Alphabet.DNA);
    foreach( data; fasta){
        writeln( "Sequence: " ~ data.header );
        writeln( data.sequence.toString() );
    }

    writeln( "2/4 Creating a Sequence object" );
    Sequence insulin = new Sequence( "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN", Alphabet.Amino );

    writeln( "3/4 Creating a FastaData instance" );
    FastaData data = FastaData( "sp|P01308|INS_HUMAN Insulin OS=Homo sapiens GN=INS PE=1 SV=1", insulin );

    writeln( "4/4 Writingting fasta data into "~fastaOutFilePath~" file" );
    fastaWriter( fastaOutFilePath, [data] );
}

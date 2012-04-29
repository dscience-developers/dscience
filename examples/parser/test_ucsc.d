import dscience.parser.ucsc;

import std.stdio;
import std.string;

void main(){
    //-------------BED-------------------
    enum string bedInFilePath   = "test.bed";
    enum string bedOutFilePath  = "test_out.bed";

    writeln("== BED ==");

    writeln( "1/5 Starting to parse file "~bedInFilePath );
    auto bedData = ucscReader!BedData6( bedInFilePath, '\t' );
    writeln( bedData );

    writeln("2/5 Creating some Bed data");
    BedData3 data1;
    data1.chrom     = "chrI";
    data1.chromStart= 2750;
    data1.chromEnd  = 10850;
    BedData3 data2;
    data2.chrom     = "chrI";
    data2.chromStart= 58697;
    data2.chromEnd  = 80591;

    writeln("3/5 Creating a UCSC instance");
    UCSC!(BedData3) b1  = toUCSC( [data1, data2] );

    writeln("4/5 Creating a Bed file");
    ucscWriter!(BedData3)(bedOutFilePath, b1);

    writeln("5/5 Appending to an existing Bed file");
    File bedFile = File( bedOutFilePath, "a+" );
    BedData3 data3;
    data3.chrom     = "chrIV";
    data3.chromStart= 978121;
    data3.chromEnd  = 1257908;

    ucscWriter!(BedData3)(bedOutFilePath, toUCSC( [data3] ) );
    bedFile.close();

    //-------------GFF-------------------

    enum string gffInFilePath   = "test.gff";
    enum string gffOutFilePath  = "test_out.gff";
    writeln("== GFF==");

    writeln( "1/4 Starting to parse file "~gffInFilePath );
    auto gffData = ucscReader!GffData( gffInFilePath, '\t' );
    writeln( gffData );

    writeln("2/4 Creating some GFF data");
    GffData data4;
    data4.seqname   = "chr7";
    data4.source    = "dsience";
    data4.feature   = "exon";
    data4.start     = 14528;
    data4.end       = 24581;
    data4.score     = 100;
    data4.strand    = '-';
    data4.frame     = 2;
    data4.group     = "awesome";

    writeln("3/4 Creating a UCSC instance");
    UCSC!(GffData) g1  = toUCSC( [data4] );

    writeln("4/4 Creating a Bed file");
    ucscWriter!(GffData)(gffOutFilePath, g1);

    //-------------GTF-------------------

    enum string gtfInFilePath   = "test.gtf";
    enum string gtfOutFilePath  = "test_out.gtf";
    writeln("== GTF==");

    writeln( "1/4 Starting to parse file "~gtfInFilePath );
    auto gtfData = ucscReader!GtfData( gtfInFilePath, '\t' );
    writeln( gtfData );

    writeln("2/4 Creating some GTF data");

    GtfData data5;
    data5.seqname   = "GL192437.1";
    data5.source    = "dsience";
    data5.feature   = "CDS";
    data5.start     = 24110;
    data5.end       = 24278;
    data5.score     = 0;
    data5.strand    = '-';
    data5.frame     = 1;
    data5.group     = "gene_id \"ENSAMEG00000006897\"; transcript_id \"ENSAMET00000007606\"; exon_number \"11\"; gene_name \"D2H1Z4_AILME\"; gene_biotype \"protein_coding\"; protein_id \"ENSAMEP00000007299\";";

    assert(data5.attributes["gene_id"]          == "ENSAMEG00000006897");
    assert(data5.attributes["transcript_id"]    == "ENSAMET00000007606");
    assert(data5.attributes["exon_number"]      == "11");
    assert(data5.attributes["gene_name"]        == "D2H1Z4_AILME");
    assert(data5.attributes["gene_biotype"]     == "protein_coding");
    assert(data5.attributes["protein_id"]       == "ENSAMEP00000007299");

    writeln("3/4 Creating a UCSC instance");
    UCSC!(GtfData) g2  = toUCSC( [data5] );

    writeln("4/4 Creating a Bed file");
    ucscWriter!(GtfData)(gtfOutFilePath, g2);


}

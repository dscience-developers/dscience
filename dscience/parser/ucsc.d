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
 * The module dscience.parser.ucsc is a set of function to parse ucsc format using a delimitter as csv file
 * Supported format:
 *  - bed
 *  - bed detail format
 * See_Also:
 * Format specification http://genome.ucsc.edu/FAQ/FAQformat
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/parser/ini.d
 */
module dscience.parser.ucsc;
import std.ascii;
import std.conv;
import std.stdio;
import std.csv;
import std.file;
import std.array;
import std.algorithm;
import std.range;
import std.string;
import std.exception;

struct BedData3{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2

    string toString(){
        return "%s\t%d\t%d%s".format(chrom, chromStart, chromEnd, newline );
    }
}

struct BedData4{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3

    string toString(){
        return "%s\t%d\t%d\t%s%s".format(chrom, chromStart, chromEnd, name, newline );
    }
}

struct BedData5{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4

    string toString(){
        return "%s\t%d\t%d\t%s\t%d%s".format(chrom, chromStart, chromEnd, name, score, newline );
    }
}

struct BedData6{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s%s".format(chrom, chromStart, chromEnd, name, score, strand, newline );
    }
}

struct BedData7{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, newline );
    }
}

struct BedData8{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6
    size_t    thickEnd;     // 7
    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d\t%d%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, thickEnd, newline );
    }
}

struct BedData9{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6
    size_t    thickEnd;     // 7
    size_t[3] itemRgb;      // 8

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d\t%d\t%s%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, thickEnd, itemRgb, newline );
    }

}

struct BedData10{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6
    size_t    thickEnd;     // 7
    size_t[3] itemRgb;      // 8
    size_t    blockCount;   // 9

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d\t%d\t%s\t%d%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, thickEnd, itemRgb, blockCount, newline );
    }
}

struct BedData11{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6
    size_t    thickEnd;     // 7
    size_t[3] itemRgb;      // 8
    size_t    blockCount;   // 9
    size_t    blockSizes;   // 10
    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, thickEnd, itemRgb, blockCount, blockSizes, newline );
    }
}

struct BedData12{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    score;        // 4
    char      strand;       // 5
    size_t    thickStart;   // 6
    size_t    thickEnd;     // 7
    size_t[3] itemRgb;      // 8
    size_t    blockCount;   // 9
    size_t    blockSizes;   // 10
    size_t    blockStarts;  // 11

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d\t%d%s".format(chrom, chromStart, chromEnd, name, score, strand, thickStart, thickEnd, itemRgb, blockCount, blockSizes, blockStarts, newline );
    }
}

/**
 * GFF (General Feature Format) lines are based on the GFF standard file format. GFF lines have nine required fields that must be tab-separated. If the fields are separated by spaces instead of tabs, the track will not display correctly. For more information on GFF format, refer to http://www.sanger.ac.uk/resources/software/gff/.
 *
 * If you would like to obtain browser data in GFF (GTF) format, please refer to Genes in gtf or gff format on the Wiki.
 *
 * Here is a brief description of the GFF fields:
 * seqname - The name of the sequence. Must be a chromosome or scaffold.
 * source - The program that generated this feature.
 * feature - The name of this type of feature. Some examples of standard feature types are "CDS", "start_codon", "stop_codon", and "exon".
 * start - The starting position of the feature in the sequence. The first base is numbered 1.
 * end - The ending position of the feature (inclusive).
 * score - A score between 0 and 1000. If the track line useScore attribute is set to 1 for this annotation data set, the score value will determine the level of gray in which this feature is displayed (higher numbers = darker gray). If there is no score value, enter ".".
 * strand - Valid entries include '+', '-', or '.' (for don't know/don't care).
 * frame - If the feature is a coding exon, frame should be a number between 0-2 that represents the reading frame of the first base. If the feature is not a coding exon, the value should be '.'.
 * group - All lines with the same group are linked together into a single item.
 */
struct GffData{
    public  string  seqname;
    public  string  source;
    public  string  feature;
    public  size_t  start;
    public  size_t  end;
    private string  _score;
    public  char    strand;
    private char    _frame;
    public  string  group;

    /**
     * toString
     * GffData struct to string conversion
     */
    string toString(){
        return "%s\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s%s".format(seqname, source, feature, start, end, _score, strand, _frame, group, newline);
    }

    /**
     * score
     * Setter for score
     */
    @property
    void score( double value ){
        _score = to!string( value );
    }

    /**
     * score
     * Getter for score return nan (Not a Number) if score is a dot as not know
     */
    @property
    double score( ){
        return ( _score == "." )? double.nan : to!double( _score );
    }

    /**
     * frame
     * Setter for frame
     * value should be between 0 and 2
     */
    @property
    void frame( size_t value ){
        assert( value <= 2u, "Frame can be 0, 1 or 2. Not: %d".format( value ) );
        _frame = to!char( value );
    }

    /**
     * frame
     * Setter for frame
     * value should be a dot
     */
    @property
    void frame( char value ){
        assert( value != '.' , "Frame can be 0, 1, 2 or a '.' not: %s".format( value ) );
        _frame = value;
    }

    /**
     * frame
     * Getter frame
     * Returns:
     *    nan (Not a Number) if score is a dot as not know
     */
    @property
    double frame(){
        return ( _frame == '.' )? double.nan : _frame - '0';
    }
}

struct GtfData{
    public  string          seqname;
    public  string          source;
    public  string          feature;
    public  size_t          start;
    public  size_t          end;
    private string          _score;
    public  char            strand;
    private char            _frame;
    private string          _group;
    private string[string]  _attributes;

    /**
     * toString
     * GtfData struct to string conversion
     */
    string toString(){
        return "%s\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s%s".format(seqname, source, feature, start, end, score, strand, frame, group, newline);
    }

    /**
     * attributes
     * Setter for both attributes / group
     */
    @property
    void attributes( string[string] items ){
        _attributes = items;
        foreach( key, value; _attributes )
            _group ~= " " ~ key ~ " \"" ~ value ~ "\";";
    }

    /**
     * attributes
     * Getter for both attributes / group
     */
    @property
    string[string] attributes(){
        return _attributes;
    }

    /**
     * group
     * Getter for both attributes / group
     */
    @property
    string group(){
        return _group;
    }

    /**
     * group
     * Setter for both attributes / group
     */
    @property
    void group( string values ){
        _group = values;
        foreach( item; _group.split(";") ){
            item = item.stripLeft();
            if( !item.empty ){
                string[] keyValue = item.split(" ");
                _attributes[keyValue[0]] = (keyValue[1][0] == '"') ? keyValue[1][1..$-1] : keyValue[1]; // do not save quote
            }
        }
    }

    /**
     * score
     * Setter for score
     */
    @property
    void score( double value ){
        _score = to!string( value );
    }

    /**
     * score
     * Getter for score return nan (Not a Number) if score is a dot as not know
     */
    @property
    double score( ){
        return ( _score == "." )? double.nan : to!double( _score );
    }

    /**
     * frame
     * Setter for frame
     * value should be between 0 and 2
     */
    @property
    void frame( size_t value ){
        assert( value <= 2u, "Frame can be 0, 1, 2 or a '.' not: %d".format( value ) );
        _frame = to!char( value );
    }

    /**
     * frame
     * Setter for frame
     * value should be a dot
     */
    @property
    void frame( char value ){
        assert( value != '.' , "Frame can be 0, 1, 2 or a '.' not: %s".format( value ) );
        _frame = value;
    }

    /**
     * frame
     * Getter frame
     * Returns:
     *    nan (Not a Number) if score is a dot as not know
     */
    @property
    double frame(){
        return ( _frame == '.' )? double.nan : _frame - '0';
    }

}

/**
 * BedDetailData
 * A structure for allow to parse BED detail format
 *
 * See_Also:
 * BED detail format specification http://genome.ucsc.edu/FAQ/FAQformat#format1.7
 *
 * Examples:
 * ---
 * import dscience.parser.ucsc;
 * import std.stdio;
 *
 * BedDetailData data;
 * auto data = bedReader!BedDetailData( filePath );
 * foreach( track; data.trackList ){
 *     writeln( track );        // print all by using toString()
 *     writeln( track.chrom );  // print only vhrome value for this track
 * }
 * ---
 */
struct BedDetailData{
    string    chrom;        // 0
    size_t    chromStart;   // 1
    size_t    chromEnd;     // 2
    string    name;         // 3
    size_t    id;           // 4
    string    description;  // 5

    string toString(){
        return "%s\t%d\t%d\t%s\t%d\t%s%s".format(chrom, chromStart, chromEnd, name, id, description, newline );
    }
}

struct BrowserLines{
    size_t      browserStart    = 0;
    size_t      browserEnd      = 0;
    string      chromosome      = "";
    bool        hide_all        = false;
    string[]    hide            = [];
    bool        dense_all       = false;
    string[]    dense           = [];
    bool        pack_all        = false;
    string[]    pack            = [];
    bool        squish_all      = false;
    string[]    squish          = [];
    bool        full_all        = false;
    string[]    full            = [];

    string toString(){
        string result = "";
        if(  chromosome != "" && browserStart != 0 && browserEnd != 0 )
            result ~= "browser position %s%s".format( position, newline );
        if( hide.length > 0 )
            result ~= "browser hide %s%s".format( join(hide), newline );
        if( hide_all )
            result ~= "browser hide all" ~ newline;
        if( dense.length > 0 )
            result ~= "browser hide %s%s".format( join(dense), newline );
        if( dense_all )
            result ~= "browser dense all" ~ newline;
        if( pack.length > 0 )
            result ~= "browser pack %s%s".format( join(pack), newline );
        if( pack_all )
            result ~= "browser pack all" ~ newline;
        if( squish.length > 0 )
            result ~= "browser squish %s%s".format( join(squish), newline );
        if( squish_all )
            result ~= "browser result all" ~ newline;
        if( full.length > 0 )
            result ~= "browser full %s%s".format( join(full), newline );
        if( full_all )
            result ~= "browser full all" ~ newline;
        return result;
    }

    @property
    string position(){
        return "%s:%d-%d".format( chromosome, browserStart, browserEnd );
    }
}

/**
 * TrackLine
 * This struct store information to related tracline
 * See_Also:
 * track line specifiaction http://genome.ucsc.edu/goldenPath/help/customTrack.html#TRACK
 */
struct TrackLine{
    string      name            = defaultName;
    string      description     = defaultDescription;
    string      type            = defaultType;
    DisplayMode visibility      = defaultVisibility;
    size_t[3]   color           = defaultColor;
    string      itemRgb         = defaultItemRgb;
    size_t[6]   colorByStrand   = defaultColorByStrand;
    size_t      useScore        = defaultUseScore;
    string      group           = defaultGroup;
    string      priority        = defaultPriority;
    string      db              = defaultDb;
    size_t      offset          = defaultOffset;
    size_t      maxItems        = defaultMaxItems;
    string      url             = defaultUrl;
    string      htmlUrl         = defaultHtmlUrl;
    string      bigDataUrl      = defaultBigDataUrl;

    /**
     * toDefaultAll
     * Set all trackLine member to corresponding default vavlue
     */
    void toDefaultAll(){
        name            = defaultName;
        description     = defaultDescription;
        type            = defaultType;
        visibility      = defaultVisibility;
        color           = defaultColor;
        itemRgb         = defaultItemRgb;
        colorByStrand   = defaultColorByStrand;
        useScore        = defaultUseScore;
        group           = defaultGroup;
        priority        = defaultPriority;
        db              = defaultDb;
        offset          = defaultOffset;
        maxItems        = defaultMaxItems;
        url             = defaultUrl;
        htmlUrl         = defaultHtmlUrl;
        bigDataUrl      = defaultBigDataUrl;
    }

    /**
     * toString
     * format a string as track line specification
     *
     * Returns:
     *  A formmated string with all TrackLine member if different to default
     */
    string toString(){ // TODO
        string result = "track";
        if( name != defaultName || ! name.empty)
            result ~= " name=\"%s\"".format(name);
        if( description != defaultDescription || ! description.empty)
            result ~= " description=\"%s\"".format(description);
        if( type != defaultType || ! type.empty)
            result ~= " type=\"%s\"".format(type);
        if( visibility != defaultVisibility)
            result ~= " visibility=%d".format(visibility);
        if( color != defaultColor || ! color.empty)
            result ~= " color=\"%d,%d,%d\"".format( color[0], color[1], color[2] );
        if( itemRgb != defaultItemRgb || ! itemRgb.empty)
            result ~= " itemRgb=\"%s\"".format(itemRgb);
        if( colorByStrand != defaultColorByStrand || ! colorByStrand.empty)
            result ~= " colorByStrand=\"%d,%d,%d %d,%d,%d\"".format( colorByStrand[0], colorByStrand[1], colorByStrand[2], colorByStrand[3], colorByStrand[4], colorByStrand[5] );
        if( useScore != defaultUseScore )
            result ~= " useScore=%d".format(useScore);
        if( group != defaultGroup || ! group.empty)
            result ~= " group=\"%s\"".format(group);
        if( priority != defaultPriority || ! priority.empty)
            result ~= " priority=\"%s\"".format(priority);
        if( db != defaultDb || ! db.empty)
            result ~= " db=\"%s\"".format(db);
        if( offset != defaultOffset )
            result ~= " offset=%d".format(offset);
        if( maxItems != defaultMaxItems )
            result ~= " maxItems=%d".format(maxItems);
        if( url != defaultUrl || ! url.empty)
            result ~= " url=\"%s\"".format(url);
        if( htmlUrl != defaultHtmlUrl || ! htmlUrl.empty)
            result ~= " htmlUrl=\"%s\"".format(htmlUrl);
        if( bigDataUrl != defaultBigDataUrl || ! bigDataUrl.empty)
            result ~= " bigDataUrl=\"%s\"".format(bigDataUrl);
        if( result == "track")
            result = "";
        else
            result ~= newline;
        return result;
    }

    enum string      defaultName         = "User Track";
    enum string      defaultDescription  = "User Supplied Track";
    enum string      defaultType         = "";
    enum DisplayMode defaultVisibility   = DisplayMode.dense;
    enum size_t[3]   defaultColor        = [0, 0, 0];
    enum string      defaultItemRgb      = "Off";
    enum size_t[6]   defaultColorByStrand= [0, 0, 0, 0, 0, 0];
    enum size_t      defaultUseScore     = 0;
    enum string      defaultGroup        = "user";
    enum string      defaultPriority     = "user";
    enum string      defaultDb           = "";
    enum size_t      defaultOffset       = 0;
    enum size_t      defaultMaxItems     = 250;
    enum string      defaultUrl          = "";
    enum string      defaultHtmlUrl      = "";
    enum string      defaultBigDataUrl   = "";

}

enum DisplayMode: size_t{
    hide    = 0,
    dense   = 1,
    full    = 2,
    pack    = 3,
    squish  = 4
}

/**
 * Track
 * Is a template structure for store Track
 * Using template allow to store various bed format:
 * - bed file with optional field ( 3 fields to 12 )
 * - bed detail format
 * - big bed
 * - others ...
 *
 * It is easy to save Bed struct into a file with right formating just use toString()
 *
 * Examples:
 * ---
 * import dscience.parser.ucsc;
 * import std.stdio;
 *
 * BedData3 data1;
 * BedData3 data2;
 *
 * data1.chrom      = "chr1";
 * data1.chromStart = "1254";
 * data1.chromEnd   = "3545";
 *
 * data2.chrom      = "chrX";
 * data2.chromStart = "984274";
 * data2.chromEnd   = "1008427";
 *
 * BrowserLines browserLines;
 * browserLines.chromosome = "chr1";
 *
 * TrackLine trackLine;
 * trackLine.name       = "ourTarget"
 * trackLine.description= "with this i will got a paper"
 *
 * auto ucsc = toUCSC([ data1, data2 ], browserLines);
 *
 * ucscWriter( "./data/trackYY.bed", ucsc);
 * ---
 */
struct Track( T ){
    TrackLine   trackLine;
    T[]         ucscDataList;

    string toString(){
        return reduce!("a ~= b.toString()")(  trackLine.toString(), ucscDataList );
    }
}

/**
 * Bed
 * Is a template structure for store ucsc file format content
 *
 **/
struct UCSC( T ){
    private:
        size_t  _length;

    public:
        BrowserLines    browserLines;
        Track!(T)[]     trackList;

        this( Track!(T)[] trackList = []){
            this.trackList   = trackList;
            _length = trackList.length;
        }

        string toString(){
            return reduce!("a ~= b.toString()")( browserLines.toString(),  trackList );
        }

        void popFront(){
            assert( trackList.length, "Attempting to fetch the front of an empty array of " ~ typeof(trackList[0]).stringof );
            trackList = trackList[1..$];
        }

        void popBack(){
            assert( trackList.length, "Attempting to fetch the front of an empty array of " ~ typeof(trackList[0]).stringof );
            trackList = trackList[0 .. $ - 1];
        }

        int opApply( int delegate(Track!(T)) dg ){
            int result = 0;
            foreach( item; trackList )
                result = dg( item );
            return result;
        }

        int opApply( int delegate(size_t, Track!(T)) dg ){
            int result = 0;
            foreach( size_t counter, item; trackList )
                result = dg(counter, item );
            return result;
        }

        Track!(T) opIndex(size_t n){
            assert(n < length);
            return trackList[n];
        }

        void opIndexAssign(Track!(T) value, size_t n){
            assert(n < length);
            trackList[n] = value;
        }

        void put( Track!(T)[] values... ){
            foreach( counter, value; values){
                size_t index = _length + counter;
                if( _length + counter >= trackList.length )
                    trackList.length = trackList.length + 10;
                trackList[ index ] = value;
                _length++;
            }
        }

        @property
        bool empty(){
            return trackList.length == 0;
        }

        @property
        ref Track!(T) front(){
            assert( trackList.length, "Attempting to fetch the front of an empty array of " ~ typeof(trackList[0]).stringof );
            return trackList[0];
        }

        @property
        ref Track!(T) back(){
            assert( trackList.length, "Attempting to fetch the front of an empty array of " ~ typeof(trackList[0]).stringof );
            return trackList[ $ - 1 ];
        }

        @property
        UCSC!(T) save(){
            return this;
        }

        @property
        size_t length() const{
            return _length;
        }

        @property
        Track!(T)[] data(){
            return trackList;
        }

        @property
        void shrink(){
            trackList.length = _length;
        }

}

/**
 * trackLineReader
 * Parse a line in track line format.
 *
 * See_Also:
 *  Track Lines http://genome.ucsc.edu/goldenPath/help/customTrack.html#TRACK
 *
 * Returns:
 *  TrackLine structure
 */
TrackLine trackLineReader( in char[] trackLine ){
    TrackLine result;
    enum string[] tokens = ["name=", "description=", "type=", "visibility=", "color=", "itemRgb=", "useScore=", "group=", "colorByStrand=", "priority=", "db=", "offset=", "maxItems=", "url=", "htmlUrl=", "bigDataUrl="];

    foreach( token; tokens){
        size_t start =  trackLine.countUntil(token);
        if( start != -1 ){
            start += token.length;
            char    endDelimiter;
            if( trackLine[ start ] == '"' ){
                endDelimiter = '"';
                start++;
            }
            else
                endDelimiter = ' ';
            size_t  end             = trackLine[start .. $ ].countUntil( endDelimiter );
            if( end == -1 )
                end = trackLine.length;
            else
                end += start;
            string value            = trackLine[start .. end].idup;
            switch(token){
                case "name=":
                    result.name         = value;
                    break;
                case "description=":
                    result.description  = value;
                    break;
                case "type=":
                    result.type         = value;
                    break;
                case "visibility=":
                    result.visibility   = cast(DisplayMode)to!size_t(value);
                    break;
                case "color=":
                    result.color        = array( map!(to!size_t)(value.split(",")) );
                    break;
                case "itemRgb=":
                    result.itemRgb      = value;
                    break;
                case "useScore=":
                    result.useScore     = to!size_t(value);
                    break;
                case "group=":
                    result.group        = value;
                    break;
                case "colorByStrand=":
                    string[] colors     = value.split(" ");
                    result.colorByStrand= array( map!(to!size_t)(colors[0].split(",")) ) ~ array( map!(to!size_t)(colors[1].split(",")) );
                    break;
                case "priority=":
                    result.priority     = value;
                    break;
                case "db=":
                    result.db           = value;
                    break;
                case "offset=":
                    result.offset       = to!size_t(value);
                    break;
                case "maxItems=":
                    result.maxItems     = to!size_t(value);
                    break;
                case "url=":
                    result.url          = value;
                    break;
                case "htmlUrl=":
                    result.htmlUrl      = value;
                    break;
                case "bigDataUrl=":
                    result.bigDataUrl   = value;
                    break;
                default:
                    throw new Exception( "Unknow token: %s".format(token) );
            }
        }
    }
    return result;
}

/**
 * browserLineReader
 * Parse a line in browser line format.
 *
 * Params:
 *  browserLine  Line to parse
 *  browserLines A BrowserLines struct where wile be saved into data from the browser line
 *
 * See_Also:
 *  Browser Lines http://genome.ucsc.edu/goldenPath/help/customTrack.html#BROWSER
 *
 * Examples:
 * ---
 * import dscience.parser.ucsc;
 *
 * char[] line1 = "browser position chr7:127471196-127495720";
 * char[] line2 = "browser hide all";
 * BrowserLines browserLines;
 *
 * browserLineReader( line1, browserLines );
 * assert( browserLines.chromosome   == "chr7" );
 * assert( browserLines.browserStart == 127471196 );
 * assert( browserLines.browserEnd   == 127495720 );
 *
 * browserLineReader( line2, browserLines );
 * assert( browserLines.hide_all   == true );
 *
 * ---
 */
void browserLineReader( in char[] browserLine, ref BrowserLines browserLines){
    const string browserToken   = "browser ";
    const string positionToken  = browserToken ~ "position";
    const string[] othersToken  = [ "hide", "dense", "pack", "squish", "full" ];

    if( browserLine.startsWith( positionToken ) ){  // browser position browserLine
        size_t colonIndex               = browserLine.countUntil(':');
        size_t minusIndex               = browserLine[colonIndex .. $].countUntil('-') + colonIndex;
        string reversed                 = to!string( retro( browserLine[positionToken.length .. colonIndex] ) );
        size_t spaceIndexBeforeChrom    = reversed.countUntil(' ');
        size_t spaceIndexAfterPosition  = browserLine[minusIndex..$].countUntil(' ');
        size_t endPositionIndex         = 0;
        if(spaceIndexAfterPosition == -1)
            endPositionIndex = browserLine.length;
        else
            endPositionIndex = minusIndex + spaceIndexAfterPosition;
        browserLines.chromosome     = to!string( retro(reversed[0 .. spaceIndexBeforeChrom]) );
        browserLines.browserStart   = to!size_t( browserLine[colonIndex + 1 .. minusIndex]);
        browserLines.browserEnd     = to!size_t( browserLine[minusIndex + 1 .. endPositionIndex]);
    }
    else{
        string[] lineSplitted = to!string( browserLine ).split();
        if( lineSplitted.length < 3 )
            throw new Exception("Malformed browser lines %s".format(browserLine));
        if( othersToken.canFind(lineSplitted[1]) ){
            if( lineSplitted[2] == "all" ){
                if      ( lineSplitted[1] == "hide"   ) browserLines.hide_all     = true;
                else if ( lineSplitted[1] == "dense"  ) browserLines.dense_all    = true;
                else if ( lineSplitted[1] == "pack"   ) browserLines.pack_all     = true;
                else if ( lineSplitted[1] == "squish" ) browserLines.squish_all   = true;
                else if ( lineSplitted[1] == "full"   ) browserLines.full_all     = true;
            }
            else{
                if      ( lineSplitted[1] == "hide"   ) browserLines.hide     = lineSplitted[2 .. $].dup ;
                else if ( lineSplitted[1] == "dense"  ) browserLines.dense    = lineSplitted[2 .. $].dup ;
                else if ( lineSplitted[1] == "pack"   ) browserLines.pack     = lineSplitted[2 .. $].dup ;
                else if ( lineSplitted[1] == "squish" ) browserLines.squish   = lineSplitted[2 .. $].dup ;
                else if ( lineSplitted[1] == "full"   ) browserLines.full     = lineSplitted[2 .. $].dup ;
            }
        }
    }
}

/**
 * ucscReader
 * This function parse bed file and derived as big bed, bed detail, bed.
 * Easy to use git path to corresponding file and it will return the data in a structure.
 * By default delimiter is tab as is explain into ucsc website, but in more this parser allow to you to set an another delimiter.
 * Commonly space, comma, semi-colon could used
 *
 * Examples:
 * ---
 * import dscience.parser.ucsc;
 * import std.stdio;
 *
 * string pathToBedFile       = "./data/trackX.bed"; // this bed use five first field
 * string pathToBedDetailFile = "./data/trackY.bed"; // this file use space as delimiter
 * string pathToBigBedFile    = "./data/trackZ.bed";
 *
 * auto bed         = bedReader!BedData5( pathToBedFile );
 * writeln( bed );
 *
 * auto bedDetail   = bedReader!BedData5( pathToBedFile );
 * writeln( bedDetail );
 *
 * auto bigbBed     = bedReader!BedData5( pathToBedFile );
 * writeln( bigbBed );
 * ---
 */
auto ucscReader( T = BedData3 )(  in char[] filePath, char delimiter='\t' ){
    if( !filePath.exists )
        throw new  FileException( "File %s is do not exist".format(filePath) );
    else if( !filePath.isFile )
        throw new  FileException( "File %s is not a file".format(filePath) );

    File        ucscFile        = File( to!string(filePath), "r" );
    UCSC!(T)    ucsc            = UCSC!(T)();
    Track!(T)   currentTrack;
    enum string browserToken   = "browser";
    enum string trackToken     = "track";

    foreach( char[] line; ucscFile.byLine() ){
        if( line.startsWith( '#' ) )                // comment
            continue;
        else if( line.empty )                       // empty line
            continue;
        else if( line.startsWith(browserToken ~ " ") || line.startsWith(browserToken ~ "\t") ){   // browser lines
            BrowserLines browserLines;
            browserLineReader(line, browserLines);
            ucsc.browserLines = browserLines;
        }
        else if( line.startsWith(trackToken ~ " ") || line.startsWith(trackToken ~ "\t") ){     // track line
            if( ucsc.length > 0 ){
                ucsc.put( currentTrack );
            }
            currentTrack = Track!(T)();
            currentTrack.trackLine = trackLineReader( line );
        }
        else{                                       // data in csv format
            auto records = csvReader!(T,Malformed.ignore)(line, delimiter);
            currentTrack.ucscDataList ~= records.front;
        }
    }
    ucsc.put( currentTrack );
    ucsc.shrink;
    return ucsc;
}

/**
 * ucscWriter
 * Write a bed file from a Bed structure
 * If file already exist append data at end of file
 */
void ucscWriter( T = BedData3 )( string ouputPath, UCSC!(T) data ){
    File ucscFile = File( ouputPath, "a+");
    scope(exit) ucscFile.close();
    ucscFile.write( data );

}

UCSC!(T) toUCSC( T = BedData3 )( Track!(T)[] trackList, BrowserLines browserLines = BrowserLines() ){
    UCSC!(T)     ucsc;
    ucsc.trackList       = trackList;
    ucsc.browserLines    = browserLines;
    return ucsc;
}

UCSC!(T) toUCSC( T = BedData3 )( T[] ucscDataList, TrackLine trackLine = TrackLine() ){
    Track!(T)           track;
    track.ucscDataList  = ucscDataList;
    track.trackLine     = trackLine;
    return toUCSC!(T)( [track] );
}

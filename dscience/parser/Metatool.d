module dscience.parser.Metatool;

//~ private import tango.io.stream.Lines;
//~ private import tango.io.device.Conduit                  : InputStream;
//~ private import tango.io.device.File                     : File;
//~ private import tango.text.Regex                         : Regex;
//~ private import tango.io.Stdout                          : Stderr;
//~ private import std.exception                     : Exception;
//~ private import Text = tango.text.Util                   : containsPattern;
//~ private import tango.stdc.posix.sys.types               : ssize_t;
//~ private import dscience.biology.matrix.Stoichiometric   : Stoichiometric;
//~ private import Convert = tango.util.Convert             : to;

// class ParserMetaTool{
//  /**
//   * inputFile attribute for accessing external data
//   */
//  private File inputFile;
//  /**
//   * enzrev store enzrev data
//   */
//  private string[] enzrev;
//  /**
//   * enzirrev store enzirrev data
//   */
//  private string[] enzirrev;
//  /**
//   * metint store metint data
//   */
//  private string[] metint;
//  /**
//   * metext store metext data
//   */
//  private string[] metext;
//  /**
//   * cat store cat data
//   */
//  private string[][][] cat;
//  /**
//   *
//   */
//     private size_t[string] metabolites;
//  /**
//   *
//   */
//     private size_t[string] reactions;
//  /**
//   *
//   */
//     private size_t[string] built;
//  /**
//   *
//   */
//     private size_t[string] consumed;
//  /**
//   * stoichiometric matrix
//   */
//     private Stoichiometric  matrix;
//  /**
//   * Constructor
//   * Params:
//   *     inputFile = param for accessing external data
//   */
//  this(string inputFile){
//      this.inputFile  = new File(inputFile);
//      this.enzrev     = null;
//         this.enzirrev   = null;
//         this.metint     = null;
//         this.metext     = null;
//         this.cat        = null;
//         this.metabolites= null;
//         this.reactions  = null;
//         this.built      = null;
//         this.consumed   = null;
//         this.matrix     = null; //stoichiometric matrix
//  }
//  /**
//   * block
//   * Params:
//   *     data = store data in array
//   *     stream= contain information who need parsed
//   *     blockType= which block is parsed
//   * Returns: data scanned from block
//   */
//  private InputStream block ( ref string[] data, InputStream  stream, string blockType){
//      bool isParsing = true;
//      // define regexp
//      auto lines              = new Lines!(char)(stream);
//      auto linePattern        = new Regex(r"[a-zA-Z0-9_]+");
//      auto whiteSpace         = new Regex(r"\s");

//      //Iterate line until it is not empty
//      while(isParsing && lines.next){
//          auto tmpString = lines.get;
//          if (linePattern.test(tmpString)){
//                             debug{
//                                 Stdout(blockType,tmpString).newline;
//                             }
//                             data = whiteSpace.split(tmpString);
//          }
//          else{
//              isParsing = false;
//          }
//      }
//      return lines;
//  }
//  /**
//   * block
//   * Params:
//   *     data  = store data in array
//   *     stream= contain information who need parsed
//   * Returns: data scanned from block
//   */
//  private InputStream block ( ref string[][][] data, InputStream  stream,){
//      uint i = 0;
//      bool isParsing = true;
//      // define regexp
//      auto lines              = new Lines!(char)(stream);
//      auto statementPattern   = new Regex(r"(\w+)\s+:\s+(.+)\s+<?=>?\s+(.+)\s?");
//      auto metabolite         = new Regex(r"[0-9\.]*\s*\w+");
//      while(isParsing && lines.next){
//          auto tmpString = lines.get;
//          if (statementPattern.test(tmpString)){
//              debug{Stdout.formatln("[CAT]: {}",tmpString);}
//              //store matched string
//              auto matcher = statementPattern.search(tmpString);
//              debug{Stdout.formatln("Match0: {}",matcher.match(0));}
//              debug{Stdout.formatln("Match1: {}",matcher.match(1));}
//              debug{Stdout.formatln("Match2: {}",matcher.match(2));}
//              debug{Stdout.formatln("Match3: {}",matcher.match(3));}
//              //Resisze array
//              if(data.length == i)
//                     data.length     = data.length *2;
//              data[i].length      = 3; //data[i][0] data[i][1] data[i][2]
//              data[i][0].length   = 1; //data[i][0][0]
//              //Iterate line until it is not empty
//              //Resize array
//              //Store in array
//              data[i][0][0]       ~= matcher.match(1);
//              if(metabolite.test(matcher.match(3))){
//                  data[i][1]      ~= metabolite.search(matcher.match(3)).match(0);
//              }
//              else
//                     throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);

//              if(metabolite.test(matcher.match(2))){
//                     data[i][2]       ~= metabolite.search(matcher.match(2)).match(0);
//              }
//              else
//                     throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);
//              i++;
//          }
//          else{
//              isParsing = false;
//          }
//      }
//      data.length = i + 1;
//      return lines;
//  }


//      /**
//      * searchPosition
//      * Param:
//      *  name
//      *  reactionsTable
//      * Return:
//      * An array of two element:
//      *  - first contain 1 or 0, if reaction is found or not
//      *  - second index value of reaction (used if first element equal 1)
//      */
//     private size_t[] searchPosition(string name, ref string[]reactionsTable){
//         bool        isRunning   = true;
//         size_t      index       = 0;
//         size_t[2]   result      = null;

//         while(isRunning){
//             if(Text.containsPattern(name, reactionsTable[index])){
//                 isRunning = false;
//                 result[0..2] = [cast(size_t)1,index];
//             }
//             else if (reactionsTable.length == index){
//                 isRunning = false;
//                 result[0..2] = [cast(size_t)0,index];
//             }
//             else
//                 ++index;
//         }
//         return result.dup;
//     }

//  /**
//   * parse input file
//   */
//  public void parse(){
//      auto enzrevPattern  = new Regex("-ENZREV");
//      auto enzirrevPattern= new Regex("-ENZIRREV");
//      auto metintPattern  = new Regex("-METINT");
//      auto metextPattern  = new Regex("-METEXT");
//      auto catPattern     = new Regex("-CAT");

//      /**
//       * Create line iterator
//       */
//      auto lines = new Lines!(char) (inputFile);
//      while (lines.next) {
//          auto tmpString = lines.get;

//          if (enzrevPattern.test(tmpString)){
//              debug{Stdout.formatln("[ENZREV]: \t{}",tmpString);}
//              InputStream stream = block(enzrev,lines, "[ENZREV]");
//              lines.set(stream);
//          }
//          else if (enzirrevPattern.test(tmpString)){
//                 debug{Stdout.formatln("[ENZIRREV]: \t{}",tmpString);}
//              InputStream stream = block(enzirrev,lines, "[ENZIRREV]");
//              lines.set(stream);
//          }
//          else if (metintPattern.test(tmpString)){
//                 debug{Stdout.formatln("[METINT]: \t{}",tmpString);}
//              InputStream stream = block(metint,lines, "[METINT]");
//              lines.set(stream);
//          }
//          else if (metextPattern.test(tmpString)){
//                 debug{Stdout.formatln("[METEXT]: \t{}",tmpString);}
//              InputStream stream = block(metext,lines, "[METEXT]");
//              lines.set(stream);
//          }
//          else if (catPattern.test(tmpString)){
//                 debug{Stdout.formatln("[CAT]: \t{}",tmpString);}
//              InputStream stream = block(cat,lines);
//              lines.set(stream);
//          }
//          else{
//                 debug{Stdout.formatln("line: \t{}",tmpString);}
//          }
//      }
//  }

//  /**
//   * Check data
//   */
//  public void check(){
//      auto intersection = intersect(metext,metint);
//      if (intersection.length != 0){
//          Stderr("Error: the following reactions were both declared as reversible and irreversible").newline;
//          Stderr("Data:").newline;
//          foreach(item; intersection){
//              Stderr(item).newline;
//          }
//          throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);
//      }
//  }

//     /**
//      * createStoichiometricMatrix
//      */
//     public void createStoichiometricMatrix(){
//     auto statement      = new Regex(r"([0-9\.]*)\s*\w+");
//     matrix              = new Stoichiometric(enzrev.length + enzirrev.length, metint.length + metext.length);

//     debug{Stdout.formatln("Create stoichiometric matrix\nReaction name:");}

//     foreach(elements; cat){
//         size_t      column, raw = 0;
//         // multiplier for stoichiometric coefficient
//         // it is -1 for left part of reaction and 1 for right part
//         double      multiplier  = -1;
//         // stoichiometric coefficient
//         double      coefficient = 1;
//         size_t[2]   result1     = searchPosition(elements[0][0], enzirrev);
//         size_t[2]   result2     = searchPosition(elements[0][0], enzrev);
//         size_t[2]   result3     = null;
//         size_t[2]   result4     = null;
//         string      equation    = null;

//         debug{Stdout.formatln("\t"~elements[0][0]);}

//         // if reaction name is not irreversible and reversible reaction
//         if(result1[0] == 0 && result2[0] == 0){
//             Stderr("{} has not been found among declared reactions.", elements[0][0]).nl;
//             Stderr("Check your input file.").nl;
//             throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);
//         }
//         //if reaction name is in irreversible reactions
//         else if(result1[0] == 0){
//             column  = result2[1] + enzirrev.length;
//         }
//         else{
//             column  = result1[1];
//         }

//         debug{Stdout.formatln("\tColumn:\t"~to!(string)(column));}

//         foreach(metabolite;elements){
//             equation        = metabolite[1] ~ metabolite[2];
//             result3[0..2]   = searchPosition(equation, metint);
//             result4[0..2]   = searchPosition(equation, metext);
//             // if reaction name is not irreversible and reversible reaction
//             if(result3[0] == 0 && result4[0] == 0){
//                 Stderr("{} has not been found among declared metabolites.", metabolite).nl;
//                 Stderr("Check your input file.").nl;
//                 throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);
//             }
//             //if reaction name is in irreversible reactions
//             else if(result3[0] == 0){
//                 raw  = result4[1] + enzirrev.length;
//             }
//             else{
//                 raw  = result4[1];
//             }

//             debug{Stdout.formatln("\t\tRaw:\t"~to!(string)(raw));}

//             if(statement.test()){
//                 auto matcher    = statement.search(equation);
//                 //it is -1 for left part of reaction and 1 for right part
//                 multiplier      = raw < metabolite[1].length ? -1 : 1;
//                 //X A + Y B = Z C
//                 //Where X, Y, Z are stoichiometric coeficent, if 1 than not required;
//                 //A, B, C - metabolites.
//                 coefficient         = matcher.match(1) is null ? Convert.to!(double)(matcher.match(1)) : 1;
//                 matrix[column,raw]  = matrix[column,raw] + coefficient * multiplier;
//                 debug{Stdout.formatln("\t\tAssigned value:\t{}",matrix[column,raw]);}
//             }
//             else
//                 throw new CorruptedDataException(inputFile.toString(), __FILE__,__LINE__);
//         }
//     }
// }

//  /**
//   * getEnzrev getter for enzrev array
//   */
//  public string[] getEnzrev(){
//      return enzrev.dup;
//  }
//  /**
//   * getEnzirrev getter for enzirrev array
//   */
//  public string[] getEnzirrev(){
//      return enzirrev.dup;
//  }
//  /**
//   * getMetint getter for metint array
//   */
//  public string[] getMetint(){
//      return metint.dup;
//  }
//  /**
//   * getMetext getter for metext array
//   */
//  public string[] getMetext(){
//      return metext.dup;
//  }
//  /**
//   * getCat getter for cat array
//   */
//  public string[][][] getCat(){
//      return cat.dup;
//  }
//  /**
//   * getStoichiometricMatrix for matrix array
//   */
//   public Stoichiometric getStoichiometricMatrix(){
//         return matrix.dup;
//   }
// }

// class CorruptedDataException : Exception{
//     public this(string fileName, string file, ssize_t line){
//         super("Data file '"~fileName~"' is corrupted please check and retry", file, line);
//     }
// }

// char [][] intersect(string[] data1, string[] data2){
//  string[] data;
//  data.length = data1.length < data2.length ? data1.length : data2.length;
//  size_t len,j =0;
//  for(size_t i=0; i < data1.length;i++){
//      bool searching = true;
//      while(searching && j < data2.length){
//          if(data1[i] == data2[j]){
//              data[len] = data1[i];
//              len++;
//              searching = false;
//          }
//          j++;
//      }
//      i++;
//  }
//  data.length = len;
//  return data;
// }

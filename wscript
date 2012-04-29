VERSION = "0.0.1"
APPNAME = "dscience"
top     = "dscience"
out     = "build"

def getCompilerFlag( ctx ):
    import platform
    import os.path
    import sys

    is64 = sys.maxsize > 2**32

    compilerFlag = {
                        "os":               "",
                        "static_lib_ext":   "",
                        "dynamic_lib_ext":  "",
                        "filter":           [],
                        "DFLAGS":           "",
                        "dir":  {
                                "bin":              "",
                                "data":             "",
                                "doc":              "",
                                "include":          "",
                                "lib":              "",
                                "pkgconfig":        ""
                                },
                        "flag": {
                                    "arch":         "",
                                    "linker":       "",
                                    "ld":           "",
                                    "fpic":         "",
                                    "output":       "",
                                    "header_file":  "",
                                    "doc_file":     "",
                                    "no_obj":       "",
                                    "deprecated":   "",
                                    "ddoc_macro":   "",
                                    "version":      "",
                                    "soname":       "",
                                    "phobos":       "",
                                    "druntime":     ""
                                }
                    }

    if( ctx.options.compiler == "ldc2"  or ctx.options.compiler == "ldmd" ):
        compilerFlag["DFLAGS"]              = "-O2"
        compilerFlag["flag"]["linker"]      = "-L"
        compilerFlag["flag"]["fpic"]        = "-relocation-model=pic"
        compilerFlag["flag"]["output"]      = "-of"
        compilerFlag["flag"]["header_file"] = "-Hf"
        compilerFlag["flag"]["doc_file"]    = "-Df"
        compilerFlag["flag"]["no_obj"]      = "-o-"
        compilerFlag["flag"]["deprecated"]  = "-d"
        compilerFlag["flag"]["ddoc_macro"]  = ""
        compilerFlag["flag"]["version"]     = "-d-version"
        compilerFlag["flag"]["soname"]      = "-soname"
        compilerFlag["flag"]["phobos"]      = "phobos-ldc"
        compilerFlag["flag"]["druntime"]    = "druntime-ldc"
    elif( ctx.options.compiler == "gdc" or ctx.options.compiler == "gdmd" ):
        compilerFlag["DFLAGS"]              = "-O2"
        compilerFlag["flag"]["linker"]      = "-Xlinker"
        compilerFlag["flag"]["fpic"]        = "-fPIC"
        compilerFlag["flag"]["output"]      = "-o"
        compilerFlag["flag"]["header_file"] = "-fintfc-file="
        compilerFlag["flag"]["doc_file"]    = "-fdoc-file="
        compilerFlag["flag"]["no_obj"]      = "-fsyntax-only"
        compilerFlag["flag"]["deprecated"]  = "-fdeprecated"
        compilerFlag["flag"]["ddoc_macro"]  = "-fdoc-inc="
        compilerFlag["flag"]["version"]     = "-fversion"
        compilerFlag["flag"]["soname"]      = compilerFlag["flag"]["linker"] + "soname"
        compilerFlag["flag"]["phobos"]      = "gphobos2"
        compilerFlag["flag"]["druntime"]    = "gdruntime"
    elif( ctx.options.compiler == "dmd" or ctx.options.compiler == "dmd2" ):
        compilerFlag["DFLAGS"]              = "-O2"
        compilerFlag["flag"]["linker"]      = "-L"
        compilerFlag["flag"]["fpic"]        = "-fPIC"
        compilerFlag["flag"]["output"]      = "-of"
        compilerFlag["flag"]["header_file"] = "-Hf"
        compilerFlag["flag"]["doc_file"]    = "-Df"
        compilerFlag["flag"]["no_obj"]      = "-o-"
        compilerFlag["flag"]["deprecated"]  = "-d"
        compilerFlag["flag"]["ddoc_macro"]  = ""
        compilerFlag["flag"]["version"]     = "-version"
        compilerFlag["flag"]["soname"]      = compilerFlag["flag"]["linker"] + "-soname"
        compilerFlag["flag"]["phobos"]      = "phobos2"
        compilerFlag["flag"]["druntime"]    = "druntime"
    else:
        raise Exception("compiler %r not supported" % ctx.options.compiler);

    if( platform.system() == "Linux" ):
        compilerFlag["os"]                  = "Linux"
        compilerFlag["static_lib_ext"]      = ".a"
        compilerFlag["dynamic_lib_ext"]     = ".so"
        compilerFlag["filter"]              = ["windows", "darwin", "freebsd", "solaris"]
        compilerFlag["flag"]["ld"]          = compilerFlag["flag"]["linker"] + "-ldl"
        compilerFlag["dir"]["bin"]          = os.path.join( ctx.options.prefix          , "bin" )
        compilerFlag["dir"]["data"]         = os.path.join( ctx.options.prefix          , "share"   , APPNAME )
        compilerFlag["dir"]["doc"]          = os.path.join( compilerFlag["dir"]["data"] , "doc"     , APPNAME )
        compilerFlag["dir"]["include"]      = os.path.join( ctx.options.prefix          , "include" , "d"       , APPNAME )
        compilerFlag["dir"]["lib"]          = os.path.join( ctx.options.prefix          , "lib" )
        compilerFlag["dir"]["pkgconfig"]    = os.path.join(  compilerFlag["dir"]["data"], "pkgconfig" )
    elif( platform.system() == "Darwin" ):
        compilerFlag["os"]                  = "Darwin"
        compilerFlag["static_lib_ext"]      = ".a"
        compilerFlag["dynamic_lib_ext"]     = ".so"
        compilerFlag["filter"]              = ["windows", "linux", "freebsd", "solaris"]
        compilerFlag["flag"]["ld"]          = ""
        compilerFlag["dir"]["bin"]          = os.path.join( ctx.options.prefix          , "bin" )
        compilerFlag["dir"]["data"]         = os.path.join( ctx.options.prefix          , "share"   , APPNAME )
        compilerFlag["dir"]["doc"]          = os.path.join( compilerFlag["dir"]["data"] , "doc"     , APPNAME )
        compilerFlag["dir"]["include"]      = os.path.join( ctx.options.prefix          , "include" , "d"       , APPNAME )
        compilerFlag["dir"]["lib"]          = os.path.join( ctx.options.prefix          , "lib" )
        compilerFlag["dir"]["pkgconfig"]    = os.path.join(  compilerFlag["dir"]["data"], "pkgconfig" )
    elif( platform.system() == "Windows" ):
        compilerFlag["os"]                  = "Windows"
        compilerFlag["static_lib_ext"]      = ".lib"
        compilerFlag["dynamic_lib_ext"]     = ".dll"
        compilerFlag["filter"]              = ["linux", "darwin", "freebsd", "solaris"]
        compilerFlag["flag"]["ld"]          = ""
        compilerFlag["dir"]["bin"]          = os.path.join( ctx.options.prefix, APPNAME , "bin" )
        compilerFlag["dir"]["data"]         = os.path.join( ctx.options.prefix, APPNAME , "data" )
        compilerFlag["dir"]["doc"]          = os.path.join( ctx.options.prefix, APPNAME , "doc" )
        compilerFlag["dir"]["include"]      = os.path.join( ctx.options.prefix, APPNAME , "import" )
        compilerFlag["dir"]["lib"]          = os.path.join( ctx.options.prefix, APPNAME , "lib" )
        compilerFlag["dir"]["pkgconfig"]    = os.path.join( ctx.options.prefix, APPNAME , "pkgconfig" )
    else:
        raise Exception("Platform %r not supported" % platform.system());

    if( is64 ):
        compilerFlag["flag"]["arch"] = "-m64"
    else:
        compilerFlag["flag"]["arch"] = "-m32"

    return compilerFlag

def options(ctx):
    ctx.add_option("--compiler"     , action="store", default="ldc2", help="Set which compiler to use, default: ldc2")
    ctx.add_option("--bindir"       , action="store", default=""    , help="Set bin directory to install")
    ctx.add_option("--datadir"      , action="store", default=""    , help="Set data directory to install")
    ctx.add_option("--docdir"       , action="store", default=""    , help="Set doc directory to install")
    ctx.add_option("--includedir"   , action="store", default=""    , help="Set include directory to install")
    ctx.add_option("--libdir"       , action="store", default=""    , help="Set library directory to install")
    ctx.add_option("--pkgconfigdir" , action="store", default=""    , help="Set pkgconfig directory to install")
    ctx.add_option("--dflags"       , action="store", default=""    , help="Set pkgconfig directory to install")
    ctx.add_option("--import"       , action="store", default=""    , help="Set a list of dir path needed for build")
    ctx.add_option("--linktolib"    , action="store", default=""    , help="Set a list of library name to link")
    ctx.add_option("--lib"          , action="store",               , help="Build as static library")
    ctx.add_option("--shared"       , action="store",               , help="Build as shered library")

def configure(ctx):
    print "→ Executing the configuration"
    CompilerFlag = getCompilerFlag( ctx )
    if( ctx.options.bindir != "" ):
        compilerFlag["dir"]["bin"]      = ctx.options.bindir
    if( ctx.options.datadir  != "" ):
        compilerFlag["dir"]["data"]     = ctx.options.datadir
    if( ctx.options.docdir  != "" ):
        compilerFlag["dir"]["doc"]      = ctx.options.docdir
    if( ctx.options.includedir  != "" ):
        compilerFlag["dir"]["include"]  = ctx.options.includedir
    if( ctx.options.libdir  != "" ):
        compilerFlag["dir"]["lib"]      = ctx.options.libdir
    if( ctx.options.pkgconfigdir  != "" ):
        compilerFlag["dir"]["pkgconfig"]= ctx.options.pkgconfigdir
    if( ctx.options.dflags  != "" ):
        compilerFlag["DFLAGS"]= ctx.options.dflags

def build(bld):
    print "→ Building the project"


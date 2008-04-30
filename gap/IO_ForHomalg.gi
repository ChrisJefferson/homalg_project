#############################################################################
##
##  HomalgExternalRing.gi     IO_ForHomalg package           Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for IO_ForHomalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( HOMALG_IO,
        rec(
            SaveHomalgMaximumBackStream := false,
            color_display := false,
	    DirectoryForTemporaryFiles := "./",
	    DoNotFigureOutAnAlternativeDirectoryForTemporaryFiles := false,
	    DoNotDeleteTemporaryFiles := false,
	    ListOfAlternativeDirectoryForTemporaryFiles := [ "/dev/shm/", "/var/tmp/", "/tmp/" ],
            FileNameCounter := 1,
            PID := IO_getpid(),
            Pictograms := rec(
                ## good morning computer algebra system:
                initialize				:= "ini",	## initialize
                define					:= "def",	## define macros
                
                ## create rings:
                CreateHomalgRing			:= "R:=",	## define a ring
                
                ## ring operations:
                Minus					:= "a-b",	## substract two ring elements
                
                ## create matrices:
                HomalgMatrix				:= "A:=",	## define a matrix
                LoadDataOfHomalgMatrixFromFile 		:= "<<A",	## load a matrix from file
                SaveDataOfHomalgMatrixToFile		:= "A>>",	## save a matrix to file
                GetEntryOfHomalgMatrixAsString		:= "<ij",	## get a matrix entry as a string
                SetEntryOfHomalgMatrix			:= "ij>",	## set a matrix entry from a string
                GetListOfHomalgMatrixAsString		:= "\"A\"",	## get a list of the matrix entries as a string
                GetListListOfHomalgMatrixAsString	:= "\"A\"",	## get a listlist of the matrix entries as a string
                GetSparseListOfHomalgMatrixAsString	:= ".A.",	## get a "sparse" list of the matrix entries as a string
                sparse					:= "spr",	## assign a "sparse" list of matrix entries to a variable
                
                ## matrix operations:
                IsZeroMatrix				:= "A=0",	## test if a matrix is the zero matrix
                ZeroRows				:= "0==",	## get the positions of the zero rows
                ZeroColumns				:= "0||",	## get the positions of the zero columns
                AreEqualMatrices			:= "A=B",	## test if two matrices are equal
                ZeroMatrix				:= "(0)",	## create a zero matrix
                IdentityMatrix				:= "(1)",	## create an identity matrix                                     
                Involution				:= "A^*",	## "transpose" a matrix (with "the" involution of the ring)
                CertainRows				:= "===",	## get certain rows of a matrix
                CertainColumns				:= "|||",	## get certain columns of a matrix
                UnionOfRows				:= "A_B",	## stack to matrices vertically
                UnionOfColumns				:= "A|B",	## glue to matrices horizontally
                DiagMat					:= "A\\B",	## create a block diagonal matrix
                KroneckerMat				:= "AoB",	## the Kronecker (tensor) product of two matrices
                MulMat					:= "a*A",	## multiply a matrix with a ring element
                AddMat					:= "A+B",	## add two matrices
                SubMat					:= "A-B",	## substract two matrices
                Compose					:= "A*B",	## multiply two matrices
                NrRows					:= "#==",	## number of rows
                NrColumns				:= "#||",	## number of columns
                
                ## operations to compute a simpler equivalent matrix (one also needs Minus and DivideByUnit from above):
                GetUnitPosition				:= "gup",	## get the position of the "first" unit in the matrix
                GetCleanRowsPositions			:= "crp",	## get the positions of the rows with a single one
                
                ## basic operations:
                TriangularBasis				:= "TRI",	## compute a triangular basis
                BasisOfModule				:= "BAS",	## compute a "basis" of a given set of module elements
                DecideZero				:= "DC0",	## decide the ideal/submodule membership problem
                SyzygiesGenerators			:= "SYZ",	## compute a generating set of syzygies
                
                ## optional operations:
                BestBasis				:= "(\\)",	## compute a better equivalent matrix (Smith, Krull)
                ElementaryDivisors			:= "div",	## compute elementary divisors
                
                ## for the eye:
                Display					:= "dsp",	## display whatever you want ;)
                homalgLaTeX				:= "TeX",	## the LaTeX code of the mathematical entity
              )
           )
);

####################################
#
# global functions and operations:
#
####################################

##
InstallGlobalFunction( FigureOutAnAlternativeDirectoryForTemporaryFiles,
  function( file )
    local list, separator, directory, filename, fs;
    
    if IsBound( HOMALG_IO.ListOfAlternativeDirectoryForTemporaryFiles ) then
        list := HOMALG_IO.ListOfAlternativeDirectoryForTemporaryFiles;
    else
        list := [ "/dev/shm/", "/var/tmp/", "/tmp/" ];
    fi;
    
    ## figure out the directory separtor:
    if IsBound( GAPInfo.UserHome ) then
        separator := GAPInfo.UserHome{[1]};
    else
        separator := "/";
    fi;
    
    for directory in list do
        
        if directory{[Length(directory)]} <> separator then
            filename := Concatenation( directory, separator, file );
        else
            filename := Concatenation( directory, file );
        fi;
        
        fs := IO_File( filename, "w" );
        
        if fs <> fail then
	    IO_Close( fs );
            return directory;
        fi;
        
    od;
    
    return fail;
    
end );

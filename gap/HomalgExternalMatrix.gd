#############################################################################
##
##  HomalgExternalMatrix.gd   IO_ForHomalg package           Mohamed Barakat
##                                                            Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg matrices.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "homalgPointer",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystem",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystemVersion",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgStream",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystemPID",
        [ IsHomalgMatrix ] );

# constructor methods:

## ConvertHomalgMatrix have been declared in homalg since it is called there

DeclareOperation( "ConvertHomalgMatrixViaFile",
        [ IsHomalgMatrix, IsHomalgRing ]
        );

DeclareOperation( "SaveDataOfHomalgMatrixToFile",
        [ IsString, IsHomalgMatrix, IsHomalgRing ]
        );

DeclareOperation( "SaveDataOfHomalgMatrixToFile",
        [ IsString, IsHomalgMatrix ]
        );

DeclareOperation( "LoadDataOfHomalgMatrixFromFile",
        [ IsString, IsHomalgRing ]
        );

DeclareOperation( "LoadDataOfHomalgMatrixFromFile",
        [ IsString, IsInt, IsInt, IsHomalgRing ]
        );

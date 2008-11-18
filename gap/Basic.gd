#############################################################################
##
##  Basic.gd                    homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declarations of homalg basic procedures.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "BasisOfRows",
        [ IsHomalgMatrix ] );

DeclareOperation( "BasisOfRows",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "BasisOfColumns",
        [ IsHomalgMatrix ] );

DeclareOperation( "BasisOfColumns",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "DecideZero",
        [ IsHomalgMatrix ] );

DeclareOperation( "SyzygiesOfRows",
        [ IsHomalgMatrix ] );

DeclareOperation( "SyzygiesOfRows",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "SyzygiesOfColumns",
        [ IsHomalgMatrix ] );

DeclareOperation( "SyzygiesOfColumns",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "SyzygiesBasisOfRows",
        [ IsHomalgMatrix ] );

DeclareOperation( "SyzygiesBasisOfColumns",
        [ IsHomalgMatrix ] );

DeclareOperation( "SyzygiesBasisOfRows",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "SyzygiesBasisOfColumns",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "RightDivide",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "RightDivide",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "RightDivide",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "LeftDivide",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "LeftDivide",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "LeftDivide",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix ] );

# global functions:

DeclareGlobalFunction( "BestBasis" );

DeclareGlobalFunction( "ReducedBasisOfModule" );

DeclareGlobalFunction( "SimplerEquivalentMatrix" );


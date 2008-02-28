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

DeclareOperation( "BasisOfRowsCoeff",
        [ IsMatrixForHomalg ] );

DeclareOperation( "BasisOfColumnsCoeff",
        [ IsMatrixForHomalg ] );

DeclareOperation( "EffectivelyDecideZeroRows",
        [ IsMatrixForHomalg, IsMatrixForHomalg ] );

DeclareOperation( "EffectivelyDecideZeroColumns",
        [ IsMatrixForHomalg, IsMatrixForHomalg ] );

DeclareOperation( "SyzygiesBasisOfRows",
        [ IsMatrixForHomalg ] );

DeclareOperation( "SyzygiesBasisOfColumns",
        [ IsMatrixForHomalg ] );

DeclareOperation( "SyzygiesBasisOfRows",
        [ IsMatrixForHomalg, IsMatrixForHomalg ] );

DeclareOperation( "SyzygiesBasisOfColumns",
        [ IsMatrixForHomalg, IsMatrixForHomalg ] );

DeclareOperation( "RightDivide",
        [ IsMatrixForHomalg, IsMatrixForHomalg ] );

DeclareOperation( "Leftinverse",
        [ IsMatrixForHomalg ] );

# global functions:

DeclareGlobalFunction( "BetterGenerators" );


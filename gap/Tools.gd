#############################################################################
##
##  Tools.gd                                                 Modules package
##
##  Copyright 2011, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations of tool procedures.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "VariableForHilbertPolynomial" );

DeclareGlobalFunction( "SumCoefficientsOfLaurentPolynomials" );

DeclareGlobalFunction( "_Binomial" );

# basic operations:

DeclareOperation( "HilbertPolynomial",
        [ IsList, IsInt, IsRingElement ] );

DeclareOperation( "HilbertPolynomial",
        [ IsList, IsInt ] );

DeclareOperation( "PrimaryDecompositionOp",
        [ IsHomalgMatrix ] );

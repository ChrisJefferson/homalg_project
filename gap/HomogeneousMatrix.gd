#############################################################################
##
##  HomogeneousMatrix.gd    GradedRingForHomalg package      Mohamed Barakat
##                                                    Markus Lange-Hegermann
##
##  Copyright 2009-2010, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH-Aachen University
##
##  Declarations for homogeneous matrices.
##
#############################################################################

####################################
#
# attributes:
#
####################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "UnderlyingNonGradedRing",
        [ IsHomalgMatrix ] );

DeclareOperation( "UnderlyingNonHomogeneousMatrix",
        [ IsHomalgMatrix ] );

DeclareOperation( "MonomialMatrix",
        [ IsInt, IsHomalgRing, IsList ] );

DeclareOperation( "MonomialMatrix",
        [ IsInt, IsHomalgRing ] );

DeclareOperation( "MonomialMatrix",
        [ IsList, IsHomalgRing, IsList ] );

DeclareOperation( "MonomialMatrix",
        [ IsList, IsHomalgRing ] );

DeclareOperation( "RandomMatrixBetweenGradedFreeLeftModules",
        [ IsList, IsList, IsHomalgRing ] );

DeclareOperation( "RandomMatrixBetweenGradedFreeRightModules",
        [ IsList, IsList, IsHomalgRing ] );

# constructor methods:

DeclareOperation( "BlindlyCopyMatrixPropertiesToHomogeneousMatrix",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "HomogeneousMatrix",
        [ IsHomalgMatrix, IsHomalgGradedRing ] );

DeclareOperation( "HomogeneousMatrix",
        [ IsHomalgMatrix, IsInt, IsInt, IsHomalgGradedRing ] );

DeclareOperation( "HomogeneousMatrix",
        [ IsList, IsInt, IsInt, IsHomalgGradedRing ] );


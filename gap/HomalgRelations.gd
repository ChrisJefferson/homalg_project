#############################################################################
##
##  HomalgRelations.gd          homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for a set of relations.
##
#############################################################################

####################################
#
# categories:
#
####################################

# A new category of objects:

DeclareCategory( "IsHomalgRelations",
        IsAttributeStoringRep );

## CAUTION: in the code we use the the following the following two categories
##          are the only ones for sets of relations!!!!

DeclareCategory( "IsHomalgRelationsOfLeftModule",
        IsHomalgRelations );

DeclareCategory( "IsHomalgRelationsOfRightModule",
        IsHomalgRelations );

####################################
#
# properties:
#
####################################

DeclareProperty( "CanBeUsedToDecideZeroEffectively",
        IsHomalgRelations );

DeclareProperty( "IsReducedSetOfRelations",
        IsHomalgRelations );

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

# constructor methods:

DeclareGlobalFunction( "HomalgRelationsForLeftModule" );
DeclareGlobalFunction( "HomalgRelationsForRightModule" );

# basic operations:

DeclareOperation( "MatrixOfRelations",
        [ IsHomalgRelations ] );

DeclareOperation( "HomalgRing",
        [ IsHomalgRelations ] );

DeclareOperation( "NrGenerators",
        [ IsHomalgRelations ] );

DeclareOperation( "NrRelations",
        [ IsHomalgRelations ] );

DeclareOperation( "UnionOfRelations",
        [ IsHomalgRelations, IsHomalgRelations ] );

DeclareOperation( "UnionOfRelations",
        [ IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "UnionOfRelations",
        [ IsHomalgRelations, IsHomalgMatrix ] );

DeclareOperation( "BasisOfModule",
        [ IsHomalgRelations ] );

DeclareOperation( "DecideZero",
        [ IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "DecideZero",
        [ IsHomalgRelations, IsHomalgRelations ] );

DeclareOperation( "BasisCoeff",
        [ IsHomalgRelations ] );

DeclareOperation( "DecideZeroEffectively",
        [ IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "SyzygiesGenerators",
        [ IsHomalgMatrix, IsHomalgRelations ] );

DeclareOperation( "SyzygiesGenerators",
        [ IsHomalgRelations, IsHomalgRelations ] );

DeclareOperation( "SyzygiesGenerators",
        [ IsHomalgRelations ] );

DeclareOperation( "NonZeroGenerators",
        [ IsHomalgRelations ] );

DeclareOperation( "GetRidOfTrivialRelations",
        [ IsHomalgRelations ] );

####################################
#
# synonyms:
#
####################################

DeclareSynonym ( "Reduce",
        DecideZero );

DeclareSynonym ( "ReduceCoeff",
        DecideZeroEffectively );

DeclareSynonym ( "BetterBasis",
        GetRidOfTrivialRelations );


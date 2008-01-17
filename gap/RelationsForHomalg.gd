#############################################################################
##
##  RelationsForHomalg.gd       homalg package               Mohamed Barakat
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

DeclareCategory( "IsRelationsForHomalg",
        IsAttributeStoringRep );

####################################
#
# properties:
#
####################################

DeclareProperty( "CanBeUsedToEffictivelyDecideZero",
        IsRelationsForHomalg );

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

DeclareGlobalFunction( "CreateRelationsForLeftModule" );
DeclareGlobalFunction( "CreateRelationsForRightModule" );

# basic operations:

DeclareOperation( "BasisOfModule",
        [ IsRelationsForHomalg ] );

DeclareOperation( "NrRelations",
        [ IsRelationsForHomalg ] );


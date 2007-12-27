#############################################################################
##
##  ModuleForHomalg.gd          homalg package               Mohamed Barakat
##
##  Copyright 2007 Lehrstuhl B f�r Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg modules.
##
#############################################################################


####################################
#
# categories:
#
####################################

# a new category of objects:

DeclareCategory( "IsModuleForHomalg",
        IsAttributeStoringRep );

####################################
#
# global variables:
#
####################################

DeclareGlobalVariable( "SimpleLogicalImplicationsForHomalgModules" );

####################################
#
# properties:
#
####################################

## left modules:

DeclareProperty( "IsFreeModule", ## FIXME: the name should be changed to IsFreeLeftModule
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsStablyFreeLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsProjectiveLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsReflexiveLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsTorsionFreeLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsArtinianLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsCyclicLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsTorsionLeftModule",
        IsLeftModule and IsModuleForHomalg );

DeclareProperty( "IsHolonomicLeftModule",
        IsLeftModule and IsModuleForHomalg );

## all modules:

DeclareProperty( "IsZeroModule",
        IsModuleForHomalg );

####################################
#
# attributes:
#
####################################

DeclareAttribute( "NumberOfDefaultSetOfRelations",
        IsModuleForHomalg, "mutable" );

DeclareSynonymAttr( "NumberOfDefaultSetOfGenerators",
        NumberOfDefaultSetOfRelations );

####################################
#
# global functions and operations:
#
####################################

# constructor methods:

DeclareOperation( "Presentation",
        [ IsList, IsSemiringWithOneAndZero ] );

DeclareOperation( "Presentation",
        [ IsList, IsList, IsSemiringWithOneAndZero ] );

# basic operations:

DeclareOperation( "GeneratorsOfModule",
        [ IsModuleForHomalg ] );

DeclareOperation( "RelationsOfModule",
        [ IsModuleForHomalg ] );

DeclareOperation( "NrGenerators",
        [ IsModuleForHomalg ] );

DeclareOperation( "NrRelations",
        [ IsModuleForHomalg ] );

DeclareOperation( "NumberOfKnownGeneratorRelationPairs",
        [ IsModuleForHomalg ] );


#############################################################################
##
##  HomalgRing.gd               homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg rings.
##
#############################################################################

####################################
#
# categories:
#
####################################

# a new category of objects:

DeclareCategory( "IsHomalgRing",
        IsAttributeStoringRep );

DeclareCategory( "IsHomalgExternalRingElement",
        IsExtAElement
        and IsExtLElement
        and IsExtRElement
        and IsAdditiveElementWithInverse
        and IsMultiplicativeElementWithInverse
        and IsAssociativeElement
        and IsAdditivelyCommutativeElement
        and IsHomalgExternalObject );

####################################
#
# global variables:
#
####################################

DeclareGlobalVariable( "SimpleLogicalImplicationsForHomalgRings" );

####################################
#
# properties:
#
####################################

DeclareProperty( "IsHomalgExternalRingElementWithIOStream",
        IsHomalgExternalRingElement );

## properties listed alphabetically (ignoring left/right):

DeclareProperty( "IsGlobalDimensionFinite",
        IsHomalgRing );

DeclareProperty( "IsLeftGlobalDimensionFinite",
        IsHomalgRing );

DeclareProperty( "IsRightGlobalDimensionFinite",
        IsHomalgRing );

DeclareProperty( "IsIntegralDomain",
        IsHomalgRing );

DeclareProperty( "IsNoetherian", 
        IsHomalgRing );

DeclareProperty( "IsLeftNoetherian",
        IsHomalgRing );

DeclareProperty( "IsRightNoetherian",
        IsHomalgRing );

DeclareProperty( "IsOreDomain", 
        IsHomalgRing );

DeclareProperty( "IsLeftOreDomain",
        IsHomalgRing );

DeclareProperty( "IsRightOreDomain",
        IsHomalgRing );

DeclareProperty( "IsPrincipalIdealRing",
        IsHomalgRing );

DeclareProperty( "IsLeftPrincipalIdealRing",
        IsHomalgRing );

DeclareProperty( "IsRightPrincipalIdealRing",
        IsHomalgRing );

DeclareProperty( "IsRegular",
        IsHomalgRing );

DeclareProperty( "IsSimpleRing",
        IsHomalgRing );

####################################
#
# attributes:
#
####################################

## The homalg ring package conversion table:
DeclareAttribute( "HomalgTable",
        IsHomalgRing, "mutable" );

## residue class rings for homalg:
DeclareAttribute( "RingRelations",
        IsHomalgRing );

## zero:
DeclareAttribute( "Zero",
        IsHomalgRing );

## one:
DeclareAttribute( "One",
        IsHomalgRing );

## minus one:
DeclareAttribute( "MinusOne",
        IsHomalgRing );

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "HomalgPointer",
        [ IsHomalgRing ] );

DeclareOperation( "HomalgExternalCASystem",
        [ IsHomalgRing ] );

DeclareOperation( "HomalgExternalCASystemVersion",
        [ IsHomalgRing ] );

DeclareOperation( "HomalgStream",
        [ IsHomalgRing ] );

DeclareOperation( "HomalgExternalCASystemPID",
        [ IsHomalgRing ] );

# constructor methods:

DeclareGlobalFunction( "CreateHomalgRing" );

DeclareGlobalFunction( "HomalgExternalRingElement" );

DeclareGlobalFunction( "StringToElementStringList" );


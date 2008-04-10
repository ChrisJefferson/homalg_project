#############################################################################
##
##  HomalgMorphism.gd           homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg morphism.
##
#############################################################################

####################################
#
# categories:
#
####################################

# four new category of objects:

DeclareCategory( "IsHomalgMorphism",
        IsAdditiveElementWithInverse
        and IsExtLElement
        and IsAttributeStoringRep ); ## CAUTION: never let homalg morphisms (which are not endomorphisms) be multiplicative elements!!

DeclareCategory( "IsHomalgEndomorphism", ## it is extremely important to let this filter be a category and NOT a representation or a property,
        IsHomalgMorphism                 ## since endomorphisms should be multiplicative elements from the beginning!!
        and IsMultiplicativeElementWithInverse );

DeclareCategory( "IsHomalgMorphismOfLeftModules",
        IsHomalgMorphism );

DeclareCategory( "IsHomalgMorphismOfRightModules",
        IsHomalgMorphism );

####################################
#
# properties:
#
####################################

DeclareProperty( "IsZeroMorphism",
        IsHomalgMorphism );

DeclareProperty( "IsIdentityMorphism",
        IsHomalgMorphism );

DeclareProperty( "IsMonomorphism",
        IsHomalgMorphism );

DeclareProperty( "IsEpimorphism",
        IsHomalgMorphism );

DeclareProperty( "IsSplitMonomorphism",
        IsHomalgMorphism );

DeclareProperty( "IsSplitEpimorphism",
        IsHomalgMorphism );

DeclareProperty( "IsIsomorphism",
        IsHomalgMorphism );

DeclareProperty( "IsAutomorphism",
        IsHomalgMorphism );

####################################
#
# global functions and operations:
#
####################################

# constructor methods:

DeclareGlobalFunction( "HomalgMorphism" );

# basic operations:

DeclareOperation( "HomalgRing",
        [ IsHomalgMorphism ] );

DeclareOperation( "SourceOfMorphism",
        [ IsHomalgMorphism ] );

DeclareOperation( "TargetOfMorphism",
        [ IsHomalgMorphism ] );

DeclareOperation( "PairOfPositionsOfTheDefaultSetOfRelations",
        [ IsHomalgMorphism ] );

DeclareOperation( "MatrixOfMorphism",
        [ IsHomalgMorphism ] );

DeclareOperation( "AreComparableMorphisms",
        [ IsHomalgMorphism, IsHomalgMorphism ] );

DeclareOperation( "AreComposableMorphisms",
        [ IsHomalgMorphism, IsHomalgMorphism ] );

DeclareOperation( "LeftInverse",
        [ IsHomalgMorphism ] );

DeclareOperation( "RightInverse",
        [ IsHomalgMorphism ] );

DeclareOperation( "*",					## this must remain, since an element in IsHomalgMorphism
        [ IsHomalgMorphism, IsHomalgMorphism ] );	## is not a priori IsMultiplicativeElement

DeclareOperation( "DecideZero",
        [ IsHomalgMorphism, IsHomalgRelations ] );

DeclareOperation( "DecideZero",
        [ IsHomalgMorphism ] );

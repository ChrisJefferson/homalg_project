#############################################################################
##
##  homalg.gd                   homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg.
##
#############################################################################


# our info classes:
DeclareInfoClass( "InfoHomalg" );
SetInfoLevel( InfoHomalg, 1 );

DeclareInfoClass( "InfoHomalgBasicOperations" );
SetInfoLevel( InfoHomalgBasicOperations, 1 );

# a central place for configurations:
DeclareGlobalVariable( "HOMALG" );

####################################
#
# categories:
#
####################################

# seven new categories:

DeclareCategory( "IsHomalgRingOrObjectOrMorphism",	## this is the super super GAP-category which will include the GAP-categories IsHomalgRingOrObject and IsHomalgObjectOrMorphism:
        IsAttributeStoringRep );			## we need this GAP-category for convenience

DeclareCategory( "IsHomalgRingOrObject",	## this is the super GAP-category which will include the GAP-categories IsHomalgRing, IsHomalgModule, IsHomalgRingOrModule and IsHomalgComplex
        IsHomalgRingOrObjectOrMorphism );

DeclareCategory( "IsHomalgRingOrModule",	## this is the super GAP-category which will include the GAP-categories IsHomalgRing, IsHomalgModule:
        IsHomalgRingOrObject );			## we need this GAP-category to define things like Hom(M,R) as easy as Hom(M,N) without distinguishing between rings and modules

DeclareCategory( "IsHomalgObjectOrMorphism",	## this is the super GAP-category which will include the GAP-categories IsHomalgModule, IsHomalgMap, IsHomalgComplex and IsHomalgChainMap:
        IsExtLElement and			## with this GAP-category we can have a common declaration for things like OnLessGenerators, BasisOfModule, DecideZero
        IsHomalgRingOrObjectOrMorphism );

DeclareCategory( "IsHomalgObject",		## this is the super GAP-category which will include the GAP-categories IsHomalgModule and IsHomalgComplex:
        IsHomalgObjectOrMorphism and		## we need this GAP-category to be able to build complexes with *objects* being modules or again complexes!
        IsHomalgRingOrObject and
        IsAdditiveElementWithZero );

DeclareCategory( "IsHomalgMorphism",		## this is the super GAP-category which will include the GAP-categories IsHomalgMap and IsHomalgChainMap:
        IsHomalgObjectOrMorphism and		## we need this GAP-category to be able to build chain maps with *morphisms* being homomorphisms or again chain maps!
        IsAdditiveElementWithInverse );		## CAUTION: never let homalg morphisms (which are not endomorphisms) be multiplicative elements!!

DeclareCategory( "IsHomalgEndomorphism",	## this is the super GAP-category which will include the GAP-categories IsHomalgSelfMap and IsHomalgChainSelfMap
        IsHomalgMorphism and
        IsMultiplicativeElementWithInverse );

DeclareCategory( "IsHomalgLeftObjectOrMorphismOfLeftObjects",
        IsHomalgObjectOrMorphism );

DeclareCategory( "IsHomalgRightObjectOrMorphismOfRightObjects",
        IsHomalgObjectOrMorphism );

# a new GAP-category:

DeclareCategory( "IsContainerForWeakPointers",
        IsComponentObjectRep );

####################################
#
# properties:
#
####################################

DeclareProperty( "IsMorphism",
        IsHomalgMorphism );

DeclareProperty( "IsGeneralizedMorphism",
        IsHomalgMorphism );

DeclareProperty( "IsGeneralizedEpimorphism",
        IsHomalgMorphism );

DeclareProperty( "IsGeneralizedMonomorphism",
        IsHomalgMorphism );

DeclareProperty( "IsGeneralizedIsomorphism",
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

DeclareProperty( "IsAutomorphism",	## do not make an ``and''-filter out of this property (I hope the other GAP packages respect this)
        IsHomalgMorphism );

####################################
#
# attributes:
#
####################################

DeclareAttribute( "Source",
        IsHomalgMorphism );

DeclareAttribute( "Range",
        IsHomalgMorphism );

DeclareAttribute( "DegreeOfMorphism",
        IsHomalgMorphism );

DeclareAttribute( "AsCokernel",
        IsHomalgObjectOrMorphism );

DeclareAttribute( "AsKernel",
        IsHomalgObjectOrMorphism );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "ContainerForWeakPointers" );

DeclareGlobalFunction( "homalgTotalRuntimes" );

DeclareGlobalFunction( "AddLeftRightLogicalImplicationsForHomalg" );

DeclareGlobalFunction( "LogicalImplicationsForOneHomalgObject" );

DeclareGlobalFunction( "LogicalImplicationsForTwoHomalgObjects" );

DeclareGlobalFunction( "InstallLogicalImplicationsForHomalg" );

DeclareGlobalFunction( "LeftRightAttributesForHomalg" );

DeclareGlobalFunction( "InstallLeftRightAttributesForHomalg" );

DeclareGlobalFunction( "LogicalImplicationsForHomalgSubobjects" );

DeclareGlobalFunction( "InstallLogicalImplicationsForHomalgSubobjects" );

DeclareGlobalFunction( "AddToAhomalgTable" );

DeclareGlobalFunction( "homalgNamesOfComponentsToIntLists" );

DeclareGlobalFunction( "homalgMode" );

# basic operations:

DeclareOperation( "HomalgRing",
        [ IsHomalgObjectOrMorphism ] );

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

DeclareOperation( "POW",				## this must remain, since an element in IsHomalgMorphism
        [ IsHomalgMorphism, IsInt ] );			## is not a priori IsMultiplicativeElement

DeclareOperation( "BasisOfModule",
        [ IsHomalgObjectOrMorphism ] );

DeclareOperation( "DecideZero",
        [ IsHomalgObjectOrMorphism ] );

DeclareOperation( "OnLessGenerators",
        [ IsHomalgObjectOrMorphism ] );

DeclareOperation( "ByASmallerPresentation",
        [ IsHomalgObjectOrMorphism ] );

DeclareOperation( "homalgLaTeX",
        [ IsObject ] );

DeclareOperation( "ExamplesForHomalg",
        [ ] );

DeclareOperation( "ExamplesForHomalg",
        [ IsInt ] );


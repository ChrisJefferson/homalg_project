#############################################################################
##
##  BasicFunctors.gd            homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for basic functors.
##
#############################################################################

####################################
#
# global variables:
#
####################################

## Cokernel
DeclareGlobalFunction( "_Functor_Cokernel_OnObjects" );

DeclareGlobalVariable( "functor_Cokernel" );

## ImageModule
DeclareGlobalFunction( "_Functor_ImageModule_OnObjects" );

DeclareGlobalVariable( "functor_ImageModule" );

## Kernel
DeclareGlobalFunction( "_Functor_Kernel_OnObjects" );

DeclareGlobalVariable( "functor_Kernel" );

## DefectOfExactness
DeclareGlobalFunction( "_Functor_DefectOfExactness_OnObjects" );

DeclareGlobalVariable( "functor_DefectOfExactness" );

## Hom
DeclareGlobalFunction( "_Functor_Hom_OnObjects" );

DeclareGlobalFunction( "_Functor_Hom_OnMorphisms" );

DeclareGlobalVariable( "Functor_Hom" );

## TensorProduct
DeclareGlobalFunction( "_Functor_TensorProduct_OnObjects" );

DeclareGlobalFunction( "_Functor_TensorProduct_OnMorphisms" );

DeclareGlobalVariable( "Functor_TensorProduct" );

####################################
#
# attributes:
#
####################################

DeclareAttribute( "CokernelEpi",
        IsHomalgMap );

DeclareAttribute( "CokernelNaturalGeneralizedEmbedding",
        IsHomalgMap );

DeclareAttribute( "KernelEmb",
        IsHomalgMap );

DeclareAttribute( "ImageModuleEmb",
        IsHomalgMap );

DeclareAttribute( "ImageModuleEpi",
        IsHomalgMap );

DeclareAttribute( "NatTrIdToHomHom_R",
        IsHomalgModule );

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "Cokernel",
        [ IsHomalgMap ] );

DeclareOperation( "ImageModule",	## Image is unfortunately declared in the GAP library as a global function :(
        [ IsHomalgMap ] );

## Kernel is already declared in the GAP library via DeclareOperation("Kernel",[IsObject]); (why so general?)

DeclareOperation( "DefectOfExactness",
        [ IsHomalgComplex ] );

DeclareOperation( "DefectOfExactness",
        [ IsHomalgMap, IsHomalgMap ] );

DeclareOperation( "Hom",
        [ IsHomalgModule, IsHomalgModule ] );

DeclareOperation( "LeftDualizingFunctor",
        [ IsHomalgRing, IsString ] );

DeclareOperation( "LeftDualizingFunctor",
        [ IsHomalgRing ] );

DeclareOperation( "RightDualizingFunctor",
        [ IsHomalgRing, IsString ] );

DeclareOperation( "RightDualizingFunctor",
        [ IsHomalgRing ] );

DeclareOperation( "TensorProduct",
        [ IsHomalgModule, IsHomalgModule ] );

####################################
#
# synonyms:
#
####################################

DeclareSynonym( "DefectOfHoms",
        DefectOfExactness );


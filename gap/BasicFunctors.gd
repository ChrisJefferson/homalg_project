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

DeclareGlobalVariable( "Functor_Cokernel" );

## Kernel
DeclareGlobalFunction( "_Functor_Kernel_OnObjects" );

DeclareGlobalVariable( "Functor_Kernel" );

## DefectOfExactness
DeclareGlobalFunction( "_Functor_DefectOfExactness_OnObjects" );

DeclareGlobalVariable( "Functor_DefectOfExactness" );

## Hom
DeclareGlobalFunction( "_Functor_Hom_OnObjects" );

DeclareGlobalFunction( "_Functor_Hom_OnMorphisms" );

DeclareGlobalVariable( "Functor_Hom" );

## Hom
DeclareGlobalVariable( "Functor_Ext" );

####################################
#
# attributes:
#
####################################

DeclareAttribute( "CokernelEpi",
        IsHomalgMap );

DeclareAttribute( "KernelEmb",
        IsHomalgMap );

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "Cokernel",
        [ IsHomalgMap ] );

## Kernel is already declared in the GAP library via DeclareOperation("Kernel",[IsObject]); (why so general?)

DeclareOperation( "DefectOfExactness",
        [ IsHomogeneousList ] );

DeclareOperation( "Hom",
        [ IsHomalgModule, IsHomalgModule ] );

DeclareOperation( "Ext",
        [ IsHomalgModule, IsHomalgModule ] );

####################################
#
# synonyms:
#
####################################

DeclareSynonym( "DefectOfHoms",
        DefectOfExactness );


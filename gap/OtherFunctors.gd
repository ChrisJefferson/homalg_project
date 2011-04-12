#############################################################################
##
##  OtherFunctors.gd            Graded Modules package
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH Aachen
##
##  Declaration stuff for some other graded functors.
##
#############################################################################

####################################
#
# global variables:
#
####################################

## DirectSum
DeclareGlobalFunction( "_Functor_DirectSum_OnGradedModules" );

DeclareGlobalFunction( "_Functor_DirectSum_OnGradedMaps" );

DeclareGlobalVariable( "Functor_DirectSum_for_graded_modules" );

## LinearPart

DeclareOperation( "LinearPart",
        [ IsHomalgMorphism ] );

DeclareGlobalFunction( "_Functor_LinearPart_OnGradedModules" );

DeclareGlobalFunction( "_Functor_LinearPart_OnGradedMaps" );

DeclareGlobalVariable( "Functor_LinearPart_ForGradedModules" );

## LinearStrand

DeclareOperation( "LinearStrand",
        [ IsInt, IsHomalgMorphism ] );

DeclareGlobalFunction( "_Functor_LinearStrand_OnFreeCocomplexes" );

DeclareGlobalFunction( "_Functor_LinearStrand_OnCochainMaps" );

DeclareGlobalVariable( "Functor_LinearStrand_ForGradedModules" );

## HomogeneousExteriorComplexToModule

DeclareOperation( "HomogeneousExteriorComplexToModule",
        [ IsHomalgComplex ] );

DeclareOperation( "SplitLinearMapAccordingToIndeterminates",
        [ IsHomalgGradedMap ] );

DeclareOperation( "ExtensionMapsFromExteriorComplex",
        [ IsHomalgGradedMap, IsHomalgGradedMap ] );

DeclareOperation( "CompareArgumentsForHomogeneousExteriorComplexToModuleOnObjects",
        [ IsList, IsList ] );

DeclareGlobalFunction( "_Functor_HomogeneousExteriorComplexToModule_OnGradedModules" );

DeclareGlobalFunction( "_Functor_HomogeneousExteriorComplexToModule_OnGradedMaps" );

DeclareGlobalVariable( "Functor_HomogeneousExteriorComplexToModule_ForGradedModules" );

## GlobalSectionsModule

DeclareAttribute( "MapFromHomogenousPartOverExteriorAlgebraToHomogeneousPartOverSymmetricAlgebra",
        IsHomalgGradedModule );

# DeclareAttribute( "MapToTensor",
DeclareAttribute( "MapFromHomogenousPartOverSymmetricAlgebraToHomogeneousPartOverExteriorAlgebra",
        IsHomalgGradedModule );

DeclareOperation( "ModulefromExtensionMap",
        [ IsHomalgGradedMap ] );

DeclareOperation( "GlobalSectionsModule",
        [ IsHomalgGradedMap ] );

DeclareOperation( "GlobalSectionsModule",
        [ IsHomalgGradedModule ] );

DeclareGlobalFunction( "_Functor_GlobalSectionsModule_OnGradedModules" );

DeclareGlobalFunction( "_Functor_GlobalSectionsModule_OnGradedMaps" );

DeclareGlobalVariable( "Functor_GlobalSectionsModule_ForGradedModules" );

DeclareSynonym( "StandardModule", GlobalSectionsModule );

# DeclareAttribute( "NaturalMapToGlobalSectionsModule",
#         IsHomalgGradedModule );

## GuessGlobalSectionsModuleFromATateMap

DeclareOperation( "GuessGlobalSectionsModuleFromATateMap",
        [ IsHomalgGradedMap ] );

DeclareOperation( "GuessGlobalSectionsModuleFromATateMap",
        [ IsInt, IsHomalgGradedMap ] );

DeclareGlobalFunction( "_Functor_GuessGlobalSectionsModuleFromATateMap_OnGradedMaps" );

DeclareGlobalVariable( "Functor_GuessGlobalSectionsModuleFromATateMap_ForGradedMaps" );


####################################
#
# temporary
#
####################################

# DeclareGlobalFunction( "_UCT_Homology" );	## FIXME: generalize
# 
# DeclareGlobalFunction( "_UCT_Cohomology" );	## FIXME: generalize


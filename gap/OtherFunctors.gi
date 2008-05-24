#############################################################################
##
##  OtherFunctors.gi            homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for some other functors.
##
#############################################################################

####################################
#
# install global functions/variables:
#
####################################

##
## TorsionSubmodule
##

InstallGlobalFunction( _Functor_TorsionSubmodule_OnObjects,	### defines: TorsionSubmodule(Emb)
  function( M )
    local par, emb, tor;
    
    if HasTorsionSubmoduleEmb( M ) then
        return Source( TorsionSubmoduleEmb( M ) );
    fi;
    
    par := ParametrizeModule( M );
    
    emb := KernelEmb( par );
    
    ## set the attribute TorsionSubmoduleEmb (specific for TorsionSubmodule):
    SetTorsionSubmoduleEmb( M, emb );
    
    tor := Source( emb );
    
    SetIsTorsion( tor, true );
    
    return tor;
    
end );

InstallValue( Functor_TorsionSubmodule,
        CreateHomalgFunctor(
                [ "name", "TorsionSubmodule" ],
                [ "natural_transformation", "TorsionSubmoduleEmb" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ "covariant", IsHomalgRingOrFinitelyPresentedModuleRep, IsMorphismOfFinitelyGeneratedModulesRep,
                        [ IsComplexOfFinitelyPresentedModulesRep, IsCocomplexOfFinitelyPresentedModulesRep ] ] ],
                [ "OnObjects", _Functor_TorsionSubmodule_OnObjects ]
                )
);

Functor_TorsionSubmodule!.ContainerForWeakPointersOnComputedMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## TorsionFreeFactor
##

InstallGlobalFunction( _Functor_TorsionFreeFactor_OnObjects,	### defines: TorsionFreeFactor(Epi)
  function( M )
    local emb, epi, M0;
    
    if HasTorsionFreeFactorEpi( M ) then
        return Target( TorsionFreeFactorEpi( M ) );
    fi;
    
    emb := TorsionSubmoduleEmb( M );
    
    epi := CokernelEpi( emb );
    
    ## set the attribute TorsionFreeFactorEpi (specific for TorsionFreeFactor):
    SetTorsionFreeFactorEpi( M, epi );
    
    M0 := Target( epi );
    
    SetIsTorsionFree( M0, true );
    
    return M0;
    
end );

InstallValue( Functor_TorsionFreeFactor,
        CreateHomalgFunctor(
                [ "name", "TorsionFreeFactor" ],
                [ "natural_transformation", "TorsionFreeFactorEpi" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ "covariant", IsHomalgRingOrFinitelyPresentedModuleRep, IsMorphismOfFinitelyGeneratedModulesRep,
                        [ IsComplexOfFinitelyPresentedModulesRep, IsCocomplexOfFinitelyPresentedModulesRep ] ] ],
                [ "OnObjects", _Functor_TorsionFreeFactor_OnObjects ]
                )
);

Functor_TorsionFreeFactor!.ContainerForWeakPointersOnComputedMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

####################################
#
# methods for operations & attributes:
#
####################################

##
## TorsionSubmodule( M ) and TorsionSubmoduleEmb( M )
##

InstallFunctor( Functor_TorsionSubmodule );

##
## TorsionFreeFactor( M ) and TorsionFreeFactorEpi( M )
##

InstallFunctor( Functor_TorsionFreeFactor );

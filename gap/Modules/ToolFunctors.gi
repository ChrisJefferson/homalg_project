#############################################################################
##
##  ToolFunctors.gi             Modules package              Mohamed Barakat
##
##  Copyright 2007-2010 Mohamed Barakat, RWTH Aachen
##
##  Implementation stuff for some tool functors.
##
#############################################################################

####################################
#
# install global functions/variables:
#
####################################

##
## TheZeroMorphism
##

InstallGlobalFunction( _Functor_TheZeroMorphism_OnModules,	### defines: TheZeroMorphism
  function( M, N )
    
    return HomalgZeroMap( M, N );
    
end );

InstallValue( functor_TheZeroMorphism_ForModules,
        CreateHomalgFunctor(
                [ "name", "TheZeroMorphism for modules" ],
                [ "operation", "TheZeroMorphism" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "contravariant" ] ] ],
                [ "2", [ [ "covariant" ] ] ],
                [ "OnObjects", _Functor_TheZeroMorphism_OnModules ]
                )
        );

functor_TheZeroMorphism_ForModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## MulMorphism
##

InstallGlobalFunction( _Functor_MulMorphism_OnModules,	### defines: MulMorphism
  function( a, phi )
    local a_phi;
    
    a_phi := HomalgMap( a * MatrixOfMap( phi ), Source( phi ), Range( phi ) );
    
    if IsUnit( HomalgRing( phi ), a ) then
        if HasIsIsomorphism( phi ) and IsIsomorphism( phi ) then
            SetIsIsomorphism( a_phi, true );
        else
            if HasIsSplitMonomorphism( phi ) and IsSplitMonomorphism( phi ) then
                SetIsSplitMonomorphism( a_phi, true );
            elif HasIsMonomorphism( phi ) and IsMonomorphism( phi ) then
                SetIsMonomorphism( a_phi, true );
            fi;
            
            if HasIsSplitEpimorphism( phi ) and IsSplitEpimorphism( phi ) then
                SetIsSplitEpimorphism( a_phi, true );
            elif HasIsEpimorphism( phi ) and IsEpimorphism( phi ) then
                SetIsEpimorphism( a_phi, true );
            elif HasIsMorphism( phi ) and IsMorphism( phi ) then
                SetIsMorphism( a_phi, true );
            fi;
        fi;
    elif HasIsMorphism( phi ) and IsMorphism( phi ) then
        SetIsMorphism( a_phi, true );
    fi;
    
    return a_phi;
    
end );

InstallValue( functor_MulMorphism,
        CreateHomalgFunctor(
                [ "name", "MulMorphism" ],
                [ "operation", "MulMorphism" ],	## don't install the method for \* automatically, since it needs to be endowed with a high rank (see below)
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsRingElement ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_MulMorphism_OnModules ]
                )
        );

functor_MulMorphism!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

## for convenience
InstallMethod( \*,
        "of two homalg maps",
        [ IsRingElement, IsMapOfFinitelyGeneratedModulesRep ], 999, ## it could otherwise run into the method ``PROD: negative integer * additive element with inverse'', value: 24
        
  function( a, phi )
    
    return MulMorphism( a, phi );
    
end );

##
## AddMorphisms
##

InstallGlobalFunction( _Functor_AddMorphisms_OnModules,	### defines: AddMorphisms
  function( phi1, phi2 )
    local phi;
    
    if not AreComparableMorphisms( phi1, phi2 ) then
        return Error( "the two maps are not comparable" );
    fi;
    
    phi := HomalgMap( MatrixOfMap( phi1 ) + MatrixOfMap( phi2 ), Source( phi1 ), Range( phi1 ) );
    
    if HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
       HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( phi, true );
    fi;
    
    return phi;
    
end );

InstallValue( functor_AddMorphisms,
        CreateHomalgFunctor(
                [ "name", "+" ],
                [ "operation", "+" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_AddMorphisms_OnModules ]
                )
        );

functor_AddMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## SubMorphisms
##

InstallGlobalFunction( _Functor_SubMorphisms_OnModules,	### defines: SubMorphisms
  function( phi1, phi2 )
    local phi;
    
    if not AreComparableMorphisms( phi1, phi2 ) then
        return Error( "the two maps are not comparable" );
    fi;
    
    phi := HomalgMap( MatrixOfMap( phi1 ) - MatrixOfMap( phi2 ), Source( phi1 ), Range( phi1 ) );
    
    if HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
       HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( phi, true );
    fi;
    
    return phi;
    
end );

InstallValue( functor_SubMorphisms,
        CreateHomalgFunctor(
                [ "name", "-" ],
                [ "operation", "-" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_SubMorphisms_OnModules ]
                )
        );

functor_SubMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## Compose
##

InstallGlobalFunction( _Functor_Compose_OnModules,	### defines: Compose
  function( cpx_post_pre )
    local pre, post, S, T, phi, morphism_aid_pre;
    
    if not ( IsHomalgComplex( cpx_post_pre ) and Length( ObjectDegreesOfComplex( cpx_post_pre ) ) = 3 ) then
        Error( "expecting a complex containing two morphisms\n" );
    fi;
    
    pre := HighestDegreeMorphism( cpx_post_pre );
    post := LowestDegreeMorphism( cpx_post_pre );
    
    S := Source( pre );
    T := Range( post );
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( pre ) then
        phi := HomalgMap( MatrixOfMap( pre ) * MatrixOfMap( post ), S, T );
    else
        phi := HomalgMap( MatrixOfMap( post ) * MatrixOfMap( pre ), S, T );
    fi;
    
    if HasIsSplitMonomorphism( pre ) and IsSplitMonomorphism( pre ) and
       HasIsSplitMonomorphism( post ) and IsSplitMonomorphism( post ) then
        SetIsSplitMonomorphism( phi, true );
    elif HasIsMonomorphism( pre ) and IsMonomorphism( pre ) and
       HasIsMonomorphism( post ) and IsMonomorphism( post ) then
        SetIsMonomorphism( phi, true );
    fi;
    
    ## cannot use elif here:
    if HasIsSplitEpimorphism( pre ) and IsSplitEpimorphism( pre ) and
       HasIsSplitEpimorphism( post ) and IsSplitEpimorphism( post ) then
        SetIsSplitEpimorphism( phi, true );
    elif HasIsEpimorphism( pre ) and IsEpimorphism( pre ) and
       HasIsEpimorphism( post ) and IsEpimorphism( post ) then
        SetIsEpimorphism( phi, true );
    elif HasIsMorphism( pre ) and IsMorphism( pre ) and
      HasIsMorphism( post ) and IsMorphism( post ) then
        SetIsMorphism( phi, true );
    fi;
    
    ## the following is crucial for spectral sequences:
    if HasMorphismAid( pre ) then
        
        morphism_aid_pre := PreCompose( MorphismAid( pre ), RemoveMorphismAid( post ) );
        
        if HasMorphismAid( post ) then
            SetMorphismAid( phi, CoproductMorphism( MorphismAid( post ), morphism_aid_pre ) );
        else
            SetMorphismAid( phi, morphism_aid_pre );
        fi;
        
        if HasIsGeneralizedMonomorphism( pre ) and IsGeneralizedMonomorphism( pre ) and
           HasIsGeneralizedMonomorphism( post ) and IsGeneralizedMonomorphism( post ) then
            SetIsGeneralizedMonomorphism( phi, true );
        fi;
        
        ## cannot use elif here:
        if HasIsGeneralizedEpimorphism( pre ) and IsGeneralizedEpimorphism( pre ) and
           HasIsGeneralizedEpimorphism( post ) and IsGeneralizedEpimorphism( post ) then
            SetIsGeneralizedEpimorphism( phi, true );
        elif HasIsGeneralizedMorphism( pre ) and IsGeneralizedMorphism( pre ) and
          HasIsGeneralizedMorphism( post ) and IsGeneralizedMorphism( post ) then
            SetIsGeneralizedMorphism( phi, true );
        fi;
        
    elif HasMorphismAid( post ) then
        
        SetMorphismAid( phi, MorphismAid( post ) );
        
        if HasIsGeneralizedMonomorphism( pre ) and IsGeneralizedMonomorphism( pre ) and
           HasIsGeneralizedMonomorphism( post ) and IsGeneralizedMonomorphism( post ) then
            SetIsGeneralizedMonomorphism( phi, true );
        fi;
        
        ## cannot use elif here:
        if HasIsGeneralizedEpimorphism( pre ) and IsGeneralizedEpimorphism( pre ) and
           HasIsGeneralizedEpimorphism( post ) and IsGeneralizedEpimorphism( post ) then
            SetIsGeneralizedEpimorphism( phi, true );
        elif HasIsGeneralizedMorphism( pre ) and IsGeneralizedMorphism( pre ) and
          HasIsGeneralizedMorphism( post ) and IsGeneralizedMorphism( post ) then
            SetIsGeneralizedMorphism( phi, true );
        fi;
        
    fi;
    
    return phi;
    
end );

InstallValue( functor_Compose,
        CreateHomalgFunctor(
                [ "name", "Compose" ],
                [ "operation", "Compose" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgComplex and IsATwoSequence ] ] ],
                [ "OnObjects", _Functor_Compose_OnModules ]
                )
        );

functor_Compose!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

## for convenience
InstallMethod( \*,
        "for homalg composable maps",
        [ IsMapOfFinitelyGeneratedModulesRep and IsHomalgLeftObjectOrMorphismOfLeftObjects,
          IsMapOfFinitelyGeneratedModulesRep ], 1001,	## this must be ranked higher than multiplication with a ring element, which could be an endomorphism
        
  function( phi1, phi2 )
    
    if not AreComposableMorphisms( phi1, phi2 ) then
        Error( "the two morphisms are not composable, since the target of the left one and the source of right one are not \033[01midentical\033[0m\n" );
    fi;
    
    return Compose( AsATwoSequence( phi1, phi2 ) );
    
end );

##
InstallMethod( \*,
        "for homalg composable maps",
        [ IsMapOfFinitelyGeneratedModulesRep and IsHomalgRightObjectOrMorphismOfRightObjects,
          IsMapOfFinitelyGeneratedModulesRep ], 1001,	## this must be ranked higher than multiplication with a ring element, which it could be an endomorphism
        
  function( phi2, phi1 )
    
    if not AreComposableMorphisms( phi2, phi1 ) then
        Error( "the two morphisms are not composable, since the source of the left one and the target of the right one are not \033[01midentical\033[0m\n" );
    fi;
    
    return Compose( AsATwoSequence( phi2, phi1 ) );
    
end );

##
## CoproductMorphism
##

InstallGlobalFunction( _Functor_CoproductMorphism_OnModules,	### defines: CoproductMorphism
  function( phi, psi )
    local T, phi_psi, SpS, p;
    
    T := Range( phi );
    
    if not IsIdenticalObj( T, Range( psi ) ) then
        Error( "the two morphisms must have identical target modules\n" );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( phi ) then
        phi_psi := UnionOfRows( MatrixOfMap( phi ), MatrixOfMap( psi ) );
    else
        phi_psi := UnionOfColumns( MatrixOfMap( phi ), MatrixOfMap( psi ) );
    fi;
    
    SpS := Source( phi ) + Source( psi );
    
    ## get the position of the set of relations immediately after creating SpS;
    p := Genesis( SpS ).("PositionOfTheDefaultSetOfRelationsOfTheOutput");
    
    phi_psi := HomalgMap( phi_psi, [ SpS, p ], T );
    
    if HasIsEpimorphism( phi ) and IsEpimorphism( phi ) and
       HasIsMorphism( psi ) and IsMorphism( psi ) then
        SetIsEpimorphism( phi_psi, true );
    elif HasIsMorphism( phi ) and IsMorphism( phi ) and
       HasIsEpimorphism( psi ) and IsEpimorphism( psi ) then
        SetIsEpimorphism( phi_psi, true );
    elif HasIsMorphism( phi ) and IsMorphism( phi ) and
       HasIsMorphism( psi ) and IsMorphism( psi ) then
        SetIsMorphism( phi_psi, true );
    fi;
    
    return phi_psi;
    
end );

InstallValue( functor_CoproductMorphism,
        CreateHomalgFunctor(
                [ "name", "CoproductMorphism" ],
                [ "operation", "CoproductMorphism" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_CoproductMorphism_OnModules ]
                )
        );

functor_CoproductMorphism!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## ProductMorphism
##

InstallGlobalFunction( _Functor_ProductMorphism_OnModules,	### defines: ProductMorphism
  function( phi, psi )
    local S, phi_psi, TpT, p;
    
    S := Source( phi );
    
    if not IsIdenticalObj( S, Source( psi ) ) then
        Error( "the two morphisms must have identical source modules\n" );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( phi ) then
        phi_psi := UnionOfColumns( MatrixOfMap( phi ), MatrixOfMap( psi ) );
    else
        phi_psi := UnionOfRows( MatrixOfMap( phi ), MatrixOfMap( psi ) );
    fi;
    
    TpT := Range( phi ) + Range( psi );
    
    ## get the position of the set of relations immediately after creating TpT;
    p := Genesis( TpT ).("PositionOfTheDefaultSetOfRelationsOfTheOutput");
    
    phi_psi := HomalgMap( phi_psi, S, [ TpT, p ] );
    
    if HasIsMonomorphism( phi ) and IsMonomorphism( phi ) and
       HasIsMorphism( psi ) and IsMorphism( psi ) then
        SetIsMonomorphism( phi_psi, true );
    elif HasIsMorphism( phi ) and IsMorphism( phi ) and
       HasIsMonomorphism( psi ) and IsMonomorphism( psi ) then
        SetIsMonomorphism( phi_psi, true );
    elif HasIsMorphism( phi ) and IsMorphism( phi ) and
       HasIsMorphism( psi ) and IsMorphism( psi ) then
        SetIsMorphism( phi_psi, true );
    fi;
    
    return phi_psi;
    
end );

InstallValue( functor_ProductMorphism,
        CreateHomalgFunctor(
                [ "name", "ProductMorphism" ],
                [ "operation", "ProductMorphism" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_ProductMorphism_OnModules ]
                )
        );

functor_ProductMorphism!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

#=======================================================================
# PostDivide
#
# M_ is free or beta is injective ( cf. [BR08, Subsection 3.1.1] )
#
#     M_
#     |   \
#  (psi=?)  \ (gamma)
#     |       \
#     v         v
#     N_ -(beta)-> N
#
#
# row convention (left modules): psi := gamma * beta^(-1)	( -> RightDivide )
# column convention (right modules): psi := beta^(-1) * gamma	( -> LeftDivide )
#_______________________________________________________________________

##
## PostDivide
##

InstallGlobalFunction( _Functor_PostDivide_OnModules,	### defines: PostDivide
  function( chm_pb )
    local gamma, beta, N, psi, M_;
    
    gamma := LowestDegreeMorphism( chm_pb );
    beta := LowestDegreeMorphism( Range( chm_pb ) );
    
    N := Range( beta );
    
    ## thanks Yunis, Yusif and Mariam for playing that other saturday
    ## so cheerfully and loudly, inspiring me to this idea :-)
    ## this is the most decisive part of the code
    ## (the idea of generalized embeddings in action):
    if HasMorphismAid( beta ) then
        N := UnionOfRelations( MorphismAid( beta ) );	## this replaces [BR08, Footnote 13]
        if HasMorphismAid( gamma ) then
            N := UnionOfRelations( N, MatrixOfMap( MorphismAid( gamma ) ) );
        fi;
    elif HasMorphismAid( gamma ) then
        N := UnionOfRelations( MorphismAid( gamma ) );
    else
        N := RelationsOfModule( N );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( chm_pb ) then
        
        psi := RightDivide( MatrixOfMap( gamma ), MatrixOfMap( beta ), N );
        
        if IsBool( psi ) then
            Error( "the second argument of RightDivide is not a right factor of the first modulo the third, i.e. the rows of the second and third argument are not a generating set!\n" );
        fi;
        
    else
        
        psi := LeftDivide( MatrixOfMap( beta ), MatrixOfMap( gamma ), N );
        
        if IsBool( psi ) then
            Error( "the first argument of LeftDivide is not a left factor of the second modulo the third, i.e. the columns of the first and third arguments are not a generating set!\n" );
        fi;
        
    fi;
    
    M_ := Source( gamma );
    
    psi := HomalgMap( psi, M_, Source( beta ) );
    
    if HasIsMorphism( gamma ) and IsMorphism( gamma ) and
       ( ( HasNrRelations( M_ ) and NrRelations( M_ ) = 0 ) or		## [BR08, Subsection 3.1.1,(1)]
         ( HasIsMonomorphism( beta ) and IsMonomorphism( beta ) ) or	## [BR08, Subsection 3.1.1,(2)]
         ( HasIsGeneralizedMonomorphism( beta ) and IsGeneralizedMonomorphism( beta ) ) ) then	## "generalizes" [BR08, Subsection 3.1.1,(2)]
        
        Assert( 2, IsMorphism( psi ) );
        
        SetIsMorphism( psi, true );
        
    elif HasMorphismAid( gamma ) and not HasMorphismAid( beta ) then
        
        #### we cannot activate the following lines, since MorphismAid( gamma ) / beta fails in general (cf. the example Grothendieck.g)
        #### instead one should activate them where they make sense (cf. SpectralSequences.gi)
        #SetMorphismAid( psi, MorphismAid( gamma ) / beta );
        #SetIsGeneralizedMorphism( psi, true );
        
    fi;
    
    return psi;
    
end );

InstallValue( functor_PostDivide,
        CreateHomalgFunctor(
                [ "name", "PostDivide" ],
                [ "operation", "PostDivide" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgChainMap and IsChainMapForPullback ] ] ],
                [ "OnObjects", _Functor_PostDivide_OnModules ]
                )
        );

functor_PostDivide!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

#=======================================================================
# PreDivide
#
# beta is surjective ( cf. [BLH, 2.5,(13): colift] )
#
#     L
#     ^  ^
#     |     \ (eta)
#  (eta0=?)    \
#     |           \
#     C <-(epsilon)- N
#
#
# row convention (left modules): eta0 := epsilon^(-1) * eta
# column convention (right modules): eta0 := eta * epsilon^(-1)
#_______________________________________________________________________

##
## PreDivide
##

InstallGlobalFunction( _Functor_PreDivide_OnModules,	### defines: PreDivide
  function( chm_po )
    local epsilon, eta, gen_iso, eta0;
    
    epsilon := HighestDegreeMorphism( Source( chm_po ) );
    eta := HighestDegreeMorphism( chm_po );
    
    if not ( HasIsEpimorphism( epsilon ) and IsEpimorphism( epsilon ) ) then
        Error( "the first morphism is either not an epimorphism or not yet known to be one\n" );
    fi;
    
    ## this is in general not a morphism;
    ## it would be a generalized isomorphism if we would
    ## add the appropriate morphism aid, but we don't need this here
    gen_iso := GeneralizedInverse( epsilon );
    
    ## make a copy without the morphism aid map
    gen_iso := RemoveMorphismAid( gen_iso );
    
    eta0 := PreCompose( gen_iso, eta );
    
    ## check assertion
    Assert( 2, IsMorphism( eta0 ) );
    
    SetIsMorphism( eta0, true );
    
    return eta0;
    
end );

InstallValue( functor_PreDivide,
        CreateHomalgFunctor(
                [ "name", "PreDivide" ],
                [ "operation", "PreDivide" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgChainMap and IsChainMapForPushout ] ] ],
                [ "OnObjects", _Functor_PreDivide_OnModules ]
                )
        );

functor_PreDivide!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

####################################
#
# methods for operations & attributes:
#
####################################

##
## TheZeroMorphism( M, N )
##

InstallFunctorOnObjects( functor_TheZeroMorphism_ForModules );

##
## MulMorphism( a, phi ) = a * phi
##

InstallFunctorOnObjects( functor_MulMorphism );

##
## phi1 + phi2
##

InstallFunctorOnObjects( functor_AddMorphisms );

##
## phi1 - phi2
##

InstallFunctorOnObjects( functor_SubMorphisms );

##
## Compose( phi, psi ) = phi * psi
##

InstallFunctorOnObjects( functor_Compose );

##
## CoproductMorphism( phi, psi )
##

InstallFunctorOnObjects( functor_CoproductMorphism );

##
## ProductMorphism( phi, psi )
##

InstallFunctorOnObjects( functor_ProductMorphism );

##
## gamma / beta = PostDivide( gamma, beta )
##

InstallFunctorOnObjects( functor_PostDivide );

##
## PreDivide( gamma, beta )
##

InstallFunctorOnObjects( functor_PreDivide );


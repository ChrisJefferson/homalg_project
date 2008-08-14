#############################################################################
##
##  ToolFunctors.gi             homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
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
## TheZeroMap
##

InstallGlobalFunction( _Functor_TheZeroMap_OnObjects,	### defines: TheZeroMap
  function( M, N )
    
    return HomalgZeroMap( M, N );
    
end );

InstallValue( functor_TheZeroMap,
        CreateHomalgFunctor(
                [ "name", "TheZeroMap" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "contravariant" ] ] ],
                [ "2", [ [ "covariant" ] ] ],
                [ "OnObjects", _Functor_TheZeroMap_OnObjects ]
                )
        );

functor_TheZeroMap!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## AsATwoSequence
##

InstallGlobalFunction( _Functor_AsATwoSequence_OnObjects,	### defines: AsATwoSequence
  function( phi, psi )
    local pre, post, C;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( phi ) and IsHomalgLeftObjectOrMorphismOfLeftObjects( psi ) then
        pre := phi;
        post := psi;
    elif IsHomalgRightObjectOrMorphismOfRightObjects( phi ) and IsHomalgRightObjectOrMorphismOfRightObjects( psi ) then
        pre := psi;
        post := phi;
    else
        Error( "the two morphisms must either be both left or both right morphisms\n" );
    fi;
    
    C := HomalgComplex( post, 0 );
    Add( C, pre );
    
    if HasIsMorphism( pre ) and IsMorphism( pre ) and
       HasIsMorphism( post ) and IsMorphism( post ) then
        SetIsSequence( C, true );
    fi;
    
    SetIsATwoSequence( C, true );
    
    return C;
    
end );

InstallValue( functor_AsATwoSequence,
        CreateHomalgFunctor(
                [ "name", "AsATwoSequence" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_AsATwoSequence_OnObjects ]
                )
        );

functor_AsATwoSequence!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
InstallMethod( AsATwoSequence,
        "for complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and
          IsHomalgLeftObjectOrMorphismOfLeftObjects and
          IsATwoSequence ],
        
  function( C )
    
    return AsATwoSequence( HighestDegreeMorphismInComplex( C ), LowestDegreeMorphismInComplex( C ) );
    
end );

##
InstallMethod( AsATwoSequence,
        "for complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and
          IsHomalgRightObjectOrMorphismOfRightObjects and
          IsATwoSequence ],
        
  function( C )
    
    return AsATwoSequence( HighestDegreeMorphismInComplex( C ), LowestDegreeMorphismInComplex( C ) );
    
end );

##
InstallMethod( AsATwoSequence,
        "for complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and
          IsHomalgLeftObjectOrMorphismOfLeftObjects and
          IsATwoSequence ],
        
  function( C )
    
    return AsATwoSequence( LowestDegreeMorphismInComplex( C ), HighestDegreeMorphismInComplex( C ) );
    
end );

##
InstallMethod( AsATwoSequence,
        "for complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and
          IsHomalgRightObjectOrMorphismOfRightObjects and
          IsATwoSequence ],
        
  function( C )
    
    return AsATwoSequence( LowestDegreeMorphismInComplex( C ), HighestDegreeMorphismInComplex( C ) );
    
end );

##
## MulMap
##

InstallGlobalFunction( _Functor_MulMap_OnObjects,	### defines: MulMap
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

InstallValue( functor_MulMap,
        CreateHomalgFunctor(
                [ "name", "MulMap" ],	## don't install the method for \* automatically, since it needs to be endowed with a high rank (see below)
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsRingElement ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_MulMap_OnObjects ]
                )
        );

functor_MulMap!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

## for convenience
InstallMethod( \*,
        "of two homalg maps",
        [ IsRingElement, IsMapOfFinitelyGeneratedModulesRep ], 999, ## it could otherwise run into the method ``PROD: negative integer * additive element with inverse'', value: 24
        
  function( a, phi )
    
    return MulMap( a, phi );
    
end );

##
## AddMap
##

InstallGlobalFunction( _Functor_AddMap_OnObjects,	### defines: AddMap
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

InstallValue( functor_AddMap,
        CreateHomalgFunctor(
                [ "name", "+" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_AddMap_OnObjects ]
                )
        );

functor_AddMap!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## SubMap
##

InstallGlobalFunction( _Functor_SubMap_OnObjects,	### defines: SubMap
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

InstallValue( functor_SubMap,
        CreateHomalgFunctor(
                [ "name", "-" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_SubMap_OnObjects ]
                )
        );

functor_SubMap!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
## Compose
##

InstallGlobalFunction( _Functor_Compose_OnObjects,	### defines: Compose
  function( cpx_post_pre )
    local pre, post, S, T, phi, modulo_image_pre;
    
    if not ( IsHomalgComplex( cpx_post_pre ) and Length( ObjectDegreesOfComplex( cpx_post_pre ) ) = 3 ) then
        Error( "expecting a complex containing two morphisms\n" );
    fi;
    
    pre := HighestDegreeMorphismInComplex( cpx_post_pre );
    post := LowestDegreeMorphismInComplex( cpx_post_pre );
    
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
    if HasMonomorphismModuloImage( pre ) then
        modulo_image_pre := PreCompose( MonomorphismModuloImage( pre ), post );
        if HasMonomorphismModuloImage( post ) then
            SetMonomorphismModuloImage( phi, StackMaps( MonomorphismModuloImage( post ),  modulo_image_pre ) );
        else
            SetMonomorphismModuloImage( phi, modulo_image_pre );
        fi;
    elif HasMonomorphismModuloImage( post ) then
        SetMonomorphismModuloImage( phi, MonomorphismModuloImage( post ) );
    fi;
    
    return phi;
    
end );

InstallValue( functor_Compose,
        CreateHomalgFunctor(
                [ "name", "Compose" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgComplex and IsATwoSequence ] ] ],
                [ "OnObjects", _Functor_Compose_OnObjects ]
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
## AsChainMapForPullback
##

InstallGlobalFunction( _Functor_AsChainMapForPullback_OnObjects,	### defines: AsChainMapForPullback
  function( phi, beta1 )
    local S, T, c;
    
    S := HomalgComplex( Source( phi ), 0 );
    T := HomalgComplex( beta1 );
    
    c := HomalgChainMap( phi, S, T, 0 );
    
    if HasIsMorphism( phi ) and IsMorphism( phi ) and
       HasIsMorphism( beta1 ) and IsMorphism( beta1 ) then
        SetIsMorphism( c, true );
    fi;
    
    SetIsChainMapForPullback( c, true );
    
    return c;
    
end );

InstallValue( functor_AsChainMapForPullback,
        CreateHomalgFunctor(
                [ "name", "AsChainMapForPullback" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_AsChainMapForPullback_OnObjects ]
                )
        );

functor_AsChainMapForPullback!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

#=======================================================================
# PostDivide
#
# M_ is free or beta is injective ( cf. [BR, Subsection 3.1.1] )
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

InstallGlobalFunction( _Functor_PostDivide_OnObjects,	### defines: PostDivide
  function( chm_pb )
    local gamma, beta, N, psi, M_;
    
    gamma := LowestDegreeMorphismInChainMap( chm_pb );
    beta := LowestDegreeMorphismInComplex( Range( chm_pb ) );
    
    N := Range( beta );
    
    ## thanks Yunis, Yusif and Mariam for playing that other saturday
    ## so cheerfully and loudly, inspiring me to this idea :-)
    ## this is the most decisive part of the code
    ## (the idea of generalized embeddings in action):
    if HasMonomorphismModuloImage( beta ) then
        N := UnionOfRelations( MonomorphismModuloImage( beta ) );	## this replaces [BR, Footnote 13]
        if HasMonomorphismModuloImage( gamma ) then
            N := UnionOfRelations( N, MatrixOfMap( MonomorphismModuloImage( gamma ) ) );
        fi;
    elif HasMonomorphismModuloImage( gamma ) then
        N := UnionOfRelations( MonomorphismModuloImage( gamma ) );
    else
        N := RelationsOfModule( N );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( chm_pb ) then
        
        psi := RightDivide( MatrixOfMap( gamma ), MatrixOfMap( beta ), N );
        
        if psi = fail then
            Error( "the second argument of RightDivide is not a right factor of the first modulo the third, i.e. the rows of the second and third argument are not a generating set!\n" );
        fi;
        
    else
        
        psi := LeftDivide( MatrixOfMap( beta ), MatrixOfMap( gamma ), N );
        
        if psi = fail then
            Error( "the first argument of LeftDivide is not a left factor of the second modulo the third, i.e. the columns of the first and third arguments are not a generating set!\n" );
        fi;
        
    fi;
    
    M_ := Source( gamma );
    
    psi := HomalgMap( psi, M_, Source( beta ) );
    
    if HasIsMorphism( gamma ) and IsMorphism( gamma ) and
       ( ( HasNrRelations( M_ ) and NrRelations( M_ ) = 0 ) or		## [BR, Subsection 3.1.1,(1)]
         ( HasIsMonomorphism( beta ) and IsMonomorphism( beta ) ) or	## [BR, Subsection 3.1.1,(2)]
         HasMonomorphismModuloImage( beta ) ) then
        
        SetIsMorphism( psi, true );
        
    fi;
    
    return psi;
    
end );

InstallValue( functor_PostDivide,
        CreateHomalgFunctor(
                [ "name", "PostDivide" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgChainMap and IsChainMapForPullback ] ] ],
                [ "OnObjects", _Functor_PostDivide_OnObjects ]
                )
        );

functor_PostDivide!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

## for convenience
InstallMethod( \/,
        "for homalg composable maps",
        [ IsMapOfFinitelyGeneratedModulesRep, IsMapOfFinitelyGeneratedModulesRep ],
        
  function( gamma, beta )
    
    if not IsIdenticalObj( Range( gamma ), Range( beta ) ) then
        Error( "the two morphisms don't have have identically the same target module\n" );
    fi;
    
    return PostDivide( AsChainMapForPullback( gamma, beta ) );
    
end );

InstallMethod( PostDivide,
        "for homalg composable maps",
        [ IsMapOfFinitelyGeneratedModulesRep, IsMapOfFinitelyGeneratedModulesRep ],
        
  function( gamma, beta )
    
    if not IsIdenticalObj( Range( gamma ), Range( beta ) ) then
        Error( "the two morphisms don't have have identically the same target module\n" );
    fi;
    
    return PostDivide( AsChainMapForPullback( gamma, beta ) );
    
end );

##
## AsChainMapForPushout
##

InstallGlobalFunction( _Functor_AsChainMapForPushout_OnObjects,	### defines: AsChainMapForPushout
  function( alpha1, psi )
    local S, T, c;
    
    S := HomalgComplex( alpha1 );
    T := HomalgComplex( Range( psi ) );
    
    c := HomalgChainMap( psi, S, T, 1 );
    
    if HasIsMorphism( psi ) and IsMorphism( psi ) and
       HasIsMorphism( alpha1 ) and IsMorphism( alpha1 ) then
        SetIsMorphism( c, true );
    fi;
    
    SetIsChainMapForPushout( c, true );
    
    return c;
    
end );

InstallValue( functor_AsChainMapForPushout,
        CreateHomalgFunctor(
                [ "name", "AsChainMapForPushout" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "2", [ [ "covariant" ], [ IsMapOfFinitelyGeneratedModulesRep ] ] ],
                [ "OnObjects", _Functor_AsChainMapForPushout_OnObjects ]
                )
        );

functor_AsChainMapForPushout!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

####################################
#
# methods for operations & attributes:
#
####################################

##
## TheZeroMap( M, N )
##

InstallFunctorOnObjects( functor_TheZeroMap );

##
## AsATwoSequence( phi, psi )
##

InstallFunctorOnObjects( functor_AsATwoSequence );

##
## MulMap( a, phi ) = a * phi
##

InstallFunctorOnObjects( functor_MulMap );

##
## phi1 + phi2
##

InstallFunctorOnObjects( functor_AddMap );

##
## phi1 - phi2
##

InstallFunctorOnObjects( functor_SubMap );

##
## Compose( phi, psi ) = phi * psi
##

InstallFunctorOnObjects( functor_Compose );

##
## AsChainMapForPullback( phi, beta1 )
##

InstallFunctorOnObjects( functor_AsChainMapForPullback );

##
## gamma / beta = PostDivide( gamma, beta )
##

InstallFunctorOnObjects( functor_PostDivide );

##
## AsChainMapForPushout( alpha1, psi )
##

InstallFunctorOnObjects( functor_AsChainMapForPushout );


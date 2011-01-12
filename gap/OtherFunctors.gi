#############################################################################
##
##  OtherFunctors.gi                                  Graded Modules package
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH Aachen
##
##  Implementation stuff for some other graded functors.
##
#############################################################################

####################################
#
# install global functions/variables:
#
####################################

##
## DirectSum
##

InstallGlobalFunction( _Functor_DirectSum_OnGradedModules,	### defines: DirectSum
  function( M, N )
    local S, degMN, sum, iotaM, iotaN, piM, piN, natural, phi;
    
    CheckIfTheyLieInTheSameCategory( M, N );
    
    S := HomalgRing( M );
    
    degMN := Concatenation( DegreesOfGenerators( M ), DegreesOfGenerators( N ) );
    
    sum := DirectSum( UnderlyingModule( M ), UnderlyingModule( N ) );
    
    # take the non-graded natural transformations
    iotaM := MonoOfLeftSummand( sum );
    iotaN:= MonoOfRightSummand( sum );
    piM := EpiOnLeftFactor( sum );
    piN := EpiOnRightFactor( sum );
    
    # create the graded sum with the help of its natural generalized embedding
    natural := NaturalGeneralizedEmbedding( sum );
    natural := GradedMap( natural, "create", degMN, S );
    sum := Source( natural );
    sum!.NaturalGeneralizedEmbedding := natural;
    
    # grade the natural transformations
    iotaM := GradedMap( iotaM, M, sum, S );
    iotaN := GradedMap( iotaN, N, sum, S );
    piM := GradedMap( piM, sum, M, S );
    piN := GradedMap( piN, sum, N, S );
    
    return SetPropertiesOfDirectSum( [ M, N ], sum, iotaM, iotaN, piM, piN );
    
end );

InstallValue( Functor_DirectSum_for_graded_modules,
        CreateHomalgFunctor(
                [ "name", "DirectSum" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "DirectSumOp" ],
                [ "natural_transformation1", "EpiOnLeftFactor" ],
                [ "natural_transformation2", "EpiOnRightFactor" ],
                [ "natural_transformation3", "MonoOfLeftSummand" ],
                [ "natural_transformation4", "MonoOfRightSummand" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "2", [ [ "covariant" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_DirectSum_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_DirectSum_OnMaps ]
                )
        );

Functor_DirectSum_for_graded_modules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_DirectSum_for_graded_modules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_DirectSum_for_graded_modules );

##
## LinearPart
##
## (cf. Eisenbud, Floystad, Schreyer: Sheaf Cohomology and Free Resolutions over Exterior Algebras)

InstallGlobalFunction( _Functor_LinearPart_OnGradedModules,    ### defines: LinearPart (object part)
  function( M )
    return M;
end );

##
InstallGlobalFunction( _Functor_LinearPart_OnGradedMaps, ### defines: LinearPart (morphism part)
  function( mor )
    local S, zero, mat, deg, i, j;
    
    if IsZero( mor ) then
        return MatrixOfMap( mor );
    fi;
    
    S := HomalgRing( mor );
    
    zero := Zero( S );
    
    mat := ShallowCopy( MatrixOfMap( mor ) );
    
    SetIsMutableMatrix( mat, true );
    
    deg := DegreesOfEntries( mat );
    
    if not ( deg <> [] and IsHomogeneousList( deg ) and IsHomogeneousList( deg[1] ) and IsInt( deg[1][1] ) ) then
      Error( "Multigraduations are not yet supported" );
    fi;
    
    for i in [ 1 .. Length( deg ) ] do
      for j in [ 1 .. Length( deg[1] ) ] do
        if deg[i][j]>1 then
          SetEntryOfHomalgMatrix( mat, i, j, zero );
        fi;
      od;
    od;
    
    SetIsMutableMatrix( mat, false );
    
    return mat;
    
end );

InstallValue( Functor_LinearPart_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "LinearPart" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "LinearPart" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_LinearPart_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_LinearPart_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ],
                [ "IsIdentityOnObjects", true ]
                )
        );

Functor_LinearPart_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_LinearPart_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_LinearPart_ForGradedModules );

##
## MinimallyGeneratedHomogeneousSummand
##

InstallGlobalFunction( _Functor_MinimallyGeneratedHomogeneousSummand_OnGradedModules,    ### defines: MinimallyGeneratedHomogeneousSummand (object part)
  function( M )
  local deg, m, l, phi, result;
    if not HasIsFree( UnderlyingModule( M ) ) or not IsFree( UnderlyingModule( M ) ) then
        Error( "the Module either is not free or not known to be free" );
    fi;
    deg := DegreesOfGenerators( M );
    m := Minimum(deg);
    l := Filtered( [ 1 .. Length( deg ) ], a -> deg[a] <> m );
    if l = [] then
        if not IsBound( M!.NaturalGeneralizedEmbedding ) then
            M!.NaturalGeneralizedEmbedding := TheIdentityMorphism( M );
        fi;
        return M;
    fi;
    phi := GradedMap( CertainGenerators( M, l ), "free", M );
    result := Cokernel( phi );
    ByASmallerPresentation( result );
    return result;
end );

InstallValue( Functor_MinimallyGeneratedHomogeneousSummand_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "MinimallyGeneratedHomogeneousSummand" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "MinimallyGeneratedHomogeneousSummand" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_MinimallyGeneratedHomogeneousSummand_OnGradedModules ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_MinimallyGeneratedHomogeneousSummand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_MinimallyGeneratedHomogeneousSummand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_MinimallyGeneratedHomogeneousSummand_ForGradedModules );

##
## HomogeneousExteriorComplexToModule
##

##
InstallMethod( ExtensionMapsFromExteriorComplex,
        "for linear complexes over the exterior algebra",
        [ IsMapOfGradedModulesRep, IsGradedModuleRep ],

  function( phi, N )
      local E, S, K, l_var, left, map_E, map_S, t, var_s_morphism, k, matrix_of_extension, extension_map, T, c, TT, M;
      
      E := HomalgRing( phi );
      
      S := KoszulDualRing( E );
      
      K := CoefficientsRing( E );
      
      Assert( 3, IsIdenticalObj( K, CoefficientsRing( S ) ) );
      
      l_var := Length( Indeterminates( S ) );
      
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( phi );
      
      if left then
          map_E := MaximalIdealAsLeftMorphism( E );
          map_S := MaximalIdealAsLeftMorphism( S );
      else
          map_E := MaximalIdealAsRightMorphism( E );
          map_S := MaximalIdealAsRightMorphism( S );
      fi;
      
      t := NrGenerators( Range( phi ) );
      if left then
          var_s_morphism := - TensorProduct( map_S , FreeLeftModuleWithDegrees( NrGenerators( Source( phi ) ), S, -DegreesOfGenerators( Range( phi ) )[1]-1 ) );
      else
          var_s_morphism := - TensorProduct( map_S , FreeRightModuleWithDegrees( NrGenerators( Source( phi ) ), S, -DegreesOfGenerators( Range( phi ) )[1]-1 ) );
      fi;
      matrix_of_extension := PostDivide( phi, TensorProduct( map_E, Range( phi ) ) );
      matrix_of_extension := K * MatrixOfMap( matrix_of_extension );
      if left then
          extension_map := HomalgZeroMatrix( 0, NrGenerators( Range( phi ) ), K );
          T := HomalgZeroMatrix( 0, 0, K );
          for k in [ 1 .. l_var ] do
              c := CertainColumns( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              TT := HomalgVoidMatrix( K );
              BasisOfRowsCoeff( c, TT );
              T := DiagMat( [ T, TT ] );
              extension_map := UnionOfRows( extension_map, c );
          od;
      else
          extension_map := HomalgZeroMatrix( NrGenerators( Range( phi ) ), 0, K );
          T := HomalgZeroMatrix( 0, 0, K );
          for k in [ 1 .. l_var ] do
              c := CertainRows( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              TT := HomalgVoidMatrix( K );
              BasisOfColumnsCoeff( c, TT );
              T := DiagMat( [ T, TT ] );
              extension_map := UnionOfColumns( extension_map, c );
          od;
      fi;
      T := S * T;
      M := Source( var_s_morphism );
      T := GradedMap( T, DegreesOfGenerators( M )[1], M );
      Assert( 3, IsMonomorphism( T ) );
      SetIsMonomorphism( T, true );
      return [ PreCompose( T, var_s_morphism ), PreCompose( T, GradedMap( S * extension_map, M, N, S ) ) ];
    
end );

InstallGlobalFunction( _Functor_HomogeneousExteriorComplexToModule_OnGradedModules,    ### defines: HomogeneousExteriorComplexToModule (object part)
  function( ltate, M )
      local reg2, result, EmbeddingsOfHigherDegrees, jj, j, tate_morphism, extension_map, var_s_morphism, k;
      
      reg2 := HighestDegree( ltate );
      
      result := UnderlyingObject( SubmoduleGeneratedByHomogeneousPart( reg2, M ) );
      
#   each new step constructs a new StdM as pushout of 
#   extension_map*LeftPushoutMap  and  var_s_morphism.
#   These maps are created from the linearized Tate resolution.
#
#     StdM = new (+) old                                   Range( var_s_morphism )
#             /\                                                  /\
#             |                                                   |
#             |                                                   |
#             | LeftPushoutMap                                    | var_s_morphism
#             |                                                   |
#             |           extension_map                           |
#           new  <-------------------------------- Source( var_s_morphism ) = Source( extension_map )
      
      result := Pushout( TheZeroMorphism( Zero( result ), result ), TheZeroMorphism( Zero( result ), Zero( result ) ) );
      
      EmbeddingsOfHigherDegrees := rec( (reg2) := TheIdentityMorphism( result ) );
      
      for jj in [ 1 .. reg2 ] do
          j := reg2 - jj;
          
          # create the extension map from the tate-resolution
          # e.g. ( e_0, e_1, 3*e_0+2*e_1 ) leads to  /   1,   0,   3   \
          #                                          \   0,   1,   2   /
          tate_morphism := CertainMorphism( ltate, j );
          
          extension_map := ExtensionMapsFromExteriorComplex( tate_morphism, Source( LeftPushoutMap( result ) ) );
          
          var_s_morphism := extension_map[1];
          
          extension_map := extension_map[2];
          
          result := Pushout( var_s_morphism, extension_map * LeftPushoutMap( result ) );
          
          EmbeddingsOfHigherDegrees!.(j) := TheIdentityMorphism( result );
          for k in [ j + 1 .. reg2 ] do
              EmbeddingsOfHigherDegrees!.(k) := EmbeddingsOfHigherDegrees!.(k) * RightPushoutMap( result );
          od;
          
          ByASmallerPresentation( result );
          
      od;
      
      result!.EmbeddingsOfHigherDegrees := EmbeddingsOfHigherDegrees;
      
      return result;
      
end );

InstallGlobalFunction( _Functor_HomogeneousExteriorComplexToModule_OnGradedMaps,    ### defines: HomogeneousExteriorComplexToModule (morphism part)
  function( phi )
    Error( "not yet implemented" );
end );

InstallValue( Functor_HomogeneousExteriorComplexToModule_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "HomogeneousExteriorComplexToModule" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "HomogeneousExteriorComplexToModule" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex ] ] ],
                [ "2", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_HomogeneousExteriorComplexToModule_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_HomogeneousExteriorComplexToModule_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_HomogeneousExteriorComplexToModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_HomogeneousExteriorComplexToModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_HomogeneousExteriorComplexToModule_ForGradedModules );

##
## StandardModule
##
## (cf. Eisenbud, Floystad, Schreyer: Sheaf Cohomology and Free Resolutions over Exterior Algebras)

InstallGlobalFunction( _Functor_StandardModule_OnGradedModules,    ### defines: StandardModule (object part)
  function( M )
      local reg, tate, ltate, StdM;
      
      if IsBound( M!.StandardModule ) then
          return M!.StandardModule;
      fi;
      
      reg := Maximum( 0, CastelnuovoMumfordRegularity( M ) );
      
      #this is the trivial case, when the positive graded part already generates the standard module
#       if reg <=0 then
#           StdM := UnderlyingObject( SubmoduleGeneratedByHomogeneousPart( 0, M ) );
#           ByASmallerPresentation( StdM );
#           StdM!.EmbeddingsOfHigherDegrees := rec( 0 := TheIdentityMorphism( StdM ) );
#           return StdM;
#       fi;
      
      tate := TateResolution( M, 0, reg+1 );
      
      ltate:= MinimallyGeneratedHomogeneousSummand( tate );
      
      StdM := HomogeneousExteriorComplexToModule( ltate, M );
      
      StdM!.StandardModule := StdM;
      
      return StdM;
      
end );

##
InstallGlobalFunction( _Functor_StandardModule_OnGradedMaps, ### defines: StandardModule (morphism part)
  function( mor )
    
    Error( "Not yet implemented" );
    
end );

InstallValue( Functor_StandardModule_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "StandardModule" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "StandardModule" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_StandardModule_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_StandardModule_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_StandardModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_StandardModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_StandardModule_ForGradedModules );


##
## HomogeneousPartOverCoefficientsRing
##

InstallMethod( RepresentationOfMorphismOnHomogeneousParts,
        "for homalg ring elements",
        [ IsMapOfGradedModulesRep, IsInt, IsInt ],
        
  function( phi, m, n )
    local S, M, N, M_le_m, M_le_m_epi, N_le_n, N_le_n_epi, phi_le_m;
    
    if m > n then
        Error( "The first given degree needs to be larger then the second one" );
    fi;
    
    S := HomalgRing( phi );
    
    M := Source( phi );
    
    N := Range( phi );
    
    M_le_m := SubmoduleGeneratedByHomogeneousPart( m, M );
    
    M_le_m_epi := M_le_m!.map_having_subobject_as_its_image;
    
    N_le_n := SubmoduleGeneratedByHomogeneousPart( n, N );
    
    N_le_n_epi := N_le_n!.map_having_subobject_as_its_image;
    
    phi_le_m := PreCompose( M_le_m_epi, phi);
    
    return PostDivide( phi_le_m, N_le_n_epi );
    
end );

InstallGlobalFunction( _Functor_HomogeneousPartOverCoefficientsRing_OnGradedModules , ### defines: HomogeneousPartOverCoefficientsRing (object part)
        [ IsInt, IsGradedModuleOrGradedSubmoduleRep ],
        
  function( d, M )
    local S, k, N, gen, l, rel, result;
    
    S := HomalgRing( M );
    
    if not HasCoefficientsRing( S ) then
        TryNextMethod( );
    fi;
    
    k := CoefficientsRing( S );
    
    N := SubmoduleGeneratedByHomogeneousPart( d, M );
    
    gen := GeneratorsOfModule( N );
    
    gen := NewHomalgGenerators( MatrixOfGenerators( gen ), gen );
    
    gen!.ring := k;
    
    l := NrGenerators( gen );
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( M ) then
        rel := HomalgZeroMatrix( 0, l, k );
        rel := HomalgRelationsForLeftModule( rel );
    else
        rel := HomalgZeroMatrix( l, 0, k );
        rel := HomalgRelationsForRightModule( rel );
    fi;
    
    result := Presentation( gen, rel );
    
    result!.GradedRingOfAmbientGradedModule := S;
    
    result!.NaturalGeneralizedEmbedding := TheIdentityMorphism( result );
    
    return result;
    
end );


##
InstallGlobalFunction( _Functor_HomogeneousPartOverCoefficientsRing_OnGradedMaps, ### defines: HomogeneousPartOverCoefficientsRing (morphism part)
  function( d, mor )
    local S, k;
    
    S := HomalgRing( mor );
    
    if not HasCoefficientsRing( S ) then
        TryNextMethod( );
    fi;
    
    k := CoefficientsRing( S );
    
    return k * MatrixOfMap( RepresentationOfMorphismOnHomogeneousParts( mor, d, d ) );
    
end );

InstallValue( Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "HomogeneousPartOverCoefficientsRing" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "HomogeneousPartOverCoefficientsRing" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_HomogeneousPartOverCoefficientsRing_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_HomogeneousPartOverCoefficientsRing_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_MODULES.category.MorphismConstructor ]
                )
        );

Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules );

##
## HomogeneousPartOfDegreeZeroOverCoefficientsRing
##

InstallGlobalFunction( _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedModules , ### defines: HomogeneousPartOfDegreeZeroOverCoefficientsRing (object part)
        [ IsGradedModuleOrGradedSubmoduleRep ],
        
  function( M )
    
    return HomogeneousPartOverCoefficientsRing( 0, M );
    
end );


##
InstallGlobalFunction( _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedMaps, ### defines: HomogeneousPartOfDegreeZeroOverCoefficientsRing (morphism part)
  function( mor )
    
    return MatrixOfMap( HomogeneousPartOverCoefficientsRing( 0, mor ) );
    
end );

InstallValue( Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "HomogeneousPartOfDegreeZeroOverCoefficientsRing" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "HomogeneousPartOfDegreeZeroOverCoefficientsRing" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_MODULES.category.MorphismConstructor ]
                )
        );

Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules );

##
## Hom
##

ComposeFunctors( Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules, 1, Functor_GradedHom_ForGradedModules, "Hom", "Hom" );

####################################
#
# temporary
#
####################################

# ## works only for principal ideal domains
# InstallGlobalFunction( _UCT_Homology,
#   function( H, G )
#     local HG;
#     
#     HG := H * G + Tor( 1, Shift( H, -1 ), G );
#     
#     return ByASmallerPresentation( HG );
#     
# end );
# 
# ## works only for principal ideal domains
# InstallGlobalFunction( _UCT_Cohomology,
#   function( H, G )
#     local HG;
#     
#     HG := Hom( H, G ) + Ext( 1, Shift( H, -1 ), G );
#     
#     return ByASmallerPresentation( HG );
#     
# end );


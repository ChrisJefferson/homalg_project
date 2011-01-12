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
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    local S, zero, mat, deg, i, j;
    
    if HasIsZero( phi ) and IsZero( phi ) then
        return phi;
    fi;
    
    S := HomalgRing( phi );
    
    zero := Zero( S );
    
    mat := ShallowCopy( MatrixOfMap( phi ) );
    
    SetIsMutableMatrix( mat, true );
    
    deg := DegreesOfEntries( mat );
    
    if not ( deg <> [] and IsHomogeneousList( deg ) and IsHomogeneousList( deg[1] ) and IsInt( deg[1][1] ) ) then
      Error( "Multigraduations are not yet supported" );
    fi;
    
    for i in [ 1 .. Length( deg ) ] do
      for j in [ 1 .. Length( deg[1] ) ] do
        if deg[i][j]<>-1 then
          SetEntryOfHomalgMatrix( mat, i, j, zero );
        fi;
      od;
    od;
    
    SetIsMutableMatrix( mat, false );
    
    return GradedMap( mat, F_source, F_target );
    
end );

InstallValue( Functor_LinearPart_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "LinearPart" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "LinearPart" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_LinearPart_OnGradedModules ],
                [ "OnMorphisms", _Functor_LinearPart_OnGradedMaps ]
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
## MinimallyGeneratedHomogeneousSummand2
##

InstallGlobalFunction( _Functor_MinimallyGeneratedHomogeneousSummand2_OnGradedModules,    ### defines: MinimallyGeneratedHomogeneousSummand2 (object part)
  function( T )
  local i, M, deg, l, phi, T2, psi, result;
    
    for i in ObjectDegreesOfComplex( T ) do
        
        M := CertainObject( T, i );
        
        deg := DegreesOfGenerators( M );
        l := Filtered( [ 1 .. Length( deg ) ], a -> deg[a] <> i );
        phi := GradedMap( CertainGenerators( M, l ), "free", M );
        if l = [ 1 .. Length( deg ) ] then
            Assert( 1, IsEpimorphism( phi ) );
            SetIsEpimorphism( phi, true );
        fi;
        
        if not IsBound( T2 ) then
            T2 := HomalgCocomplex( Source( phi ), i );
        else
            Add( T2, Source( phi ) );
        fi;
        
        if not IsBound( psi ) then
            psi := HomalgChainMap( phi, T2, T, i );
        else
            Add( psi, phi );
        fi;
        
    od;
    
    result := Cokernel( psi );
    
    ByASmallerPresentation( result );
    
    result!.MinimallyGeneratedHomogeneousSummandChainMap := psi;
    
    return result;
    
end );

InstallGlobalFunction( _Functor_MinimallyGeneratedHomogeneousSummand2_OnGradedMaps,    ### defines: MinimallyGeneratedHomogeneousSummand2 (morphism part)
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    local psi_source, psi_target, C, D, i, c, d, Z, T;
    
    if not IsBound( F_source!.MinimallyGeneratedHomogeneousSummandChainMap ) or not IsBound( F_target!.MinimallyGeneratedHomogeneousSummandChainMap ) then
        Error( "This Complex is not output of MinimallyGeneratedHomogeneousSummand" );
    fi;
    
    psi_source := F_source!.MinimallyGeneratedHomogeneousSummandChainMap;
    psi_target := F_target!.MinimallyGeneratedHomogeneousSummandChainMap;

    C := Source( psi_source );
    D := Source( psi_target );
    for i in ObjectDegreesOfComplex( C ) do
        c := CertainObject( C, i );
        d := CertainObject( D, i );
        if not IsBound( Z ) then
            Z := HomalgChainMap( TheZeroMorphism( c, d ), C, D, i );
        else
            Add( Z, TheZeroMorphism( c, d ) );
        fi;
    od;

    T := HomalgChainMap( psi_source, HomalgComplex( Z ), HomalgComplex( phi ), 1 );
    Add( psi_target, T );
    
    Error( "test" );
    
end );
  

InstallValue( Functor_MinimallyGeneratedHomogeneousSummand2_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "MinimallyGeneratedHomogeneousSummand2" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "MinimallyGeneratedHomogeneousSummand2" ],
                [ "number_of_arguments", 1 ],
                [ "special", true ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex, [ IsHomalgChainMap, IsHomalgChainMap ] ] ] ],
                [ "OnObjects", _Functor_MinimallyGeneratedHomogeneousSummand2_OnGradedModules ],
                [ "OnMorphisms", _Functor_MinimallyGeneratedHomogeneousSummand2_OnGradedMaps ]
                )
        );

Functor_MinimallyGeneratedHomogeneousSummand2_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

Functor_MinimallyGeneratedHomogeneousSummand2_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( Functor_MinimallyGeneratedHomogeneousSummand2_ForGradedModules );

##
## HomogeneousExteriorComplexToModule
##

##
InstallMethod( ExtensionMapsFromExteriorComplex,
        "for linear complexes over the exterior algebra",
        [ IsMapOfGradedModulesRep, IsMapOfGradedModulesRep ],

  function( phi, psi )
      local N, E, S, K, l_var, left, map_E, map_S, t, F, var_s_morphism, k, matrix_of_extension, extension_map, c, extension_map2, T, T2, TT, Ti, TTi, M, rank, r, Z, R, g, h, result;
      
      N := Source( psi );
      
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
          if DegreesOfGenerators( Range( phi ) ) <> [ ] then
              F := FreeLeftModuleWithDegrees( NrGenerators( Source( phi ) ), S, DegreesOfGenerators( Range( phi ) )[1]-1 );
          else
              F := FreeLeftModuleWithDegrees( NrGenerators( Source( phi ) ), S, 0 );
          fi;
          var_s_morphism := - TensorProduct( map_S , F );
      else
          if DegreesOfGenerators( Range( phi ) ) <> [ ] then
              F := FreeRightModuleWithDegrees( NrGenerators( Source( phi ) ), S, DegreesOfGenerators( Range( phi ) )[1]-1 );
          else
              F := FreeRightModuleWithDegrees( NrGenerators( Source( phi ) ), S, 0 );
          fi;
          var_s_morphism := - TensorProduct( map_S , F );
      fi;
      matrix_of_extension := PostDivide( phi, TensorProduct( map_E, Range( phi ) ) );
      matrix_of_extension := K * MatrixOfMap( matrix_of_extension );
      if left then
          extension_map := HomalgZeroMatrix( 0, NrGenerators( Range( phi ) ), K );
          for k in [ 1 .. l_var ] do
              c := CertainColumns( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              extension_map := UnionOfRows( extension_map, c );
          od;
      else
          extension_map := HomalgZeroMatrix( NrGenerators( Range( phi ) ), 0, K );
          for k in [ 1 .. l_var ] do
              c := CertainRows( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              extension_map := UnionOfColumns( extension_map, c );
          od;
      fi;
      
      M := Source( var_s_morphism );
      
      # the algorithm would function without the following
      # simplification block (with corresponding changes
      # to _Functor_HomogeneousExteriorComplexToModule_OnGradedModules)
      #
      # The simplification works the following way:
      # extension_map is a matrix over the base field and we
      # do not want to use the (in this case rather slow)
      # ByASmallerPresentation to remove alle units. Instead
      # 1) we apply the gaussian algorithm to extension_map
      #    (both to rows and columns), which afterwards is
      #    an identity matrix (and possible zeros below and
      #    right of the identity).
      # 2) we create matrices T and T2, which will simplify
      #    the relations of the StandardModule. This is done
      #    similar to ByASmallerPresentation: With the identity
      #    matrix we can clear some columns and rows. In the
      #    transformation matrices we can leave out some rows/
      #    columns, because we know that the corresponding
      #    generators/relations are zero (especially important
      #    to remove superfluous generators with the help of T)
      ################################
      # begin simplification block
      ################################
      extension_map2 := extension_map;
      
      # 1)
      T := HomalgVoidMatrix( K );
      T2 := SyzygiesOfRows( extension_map2 );
      extension_map2 := BasisOfRowsCoeff( extension_map2, T );
      T := UnionOfRows( T, T2 );
      Ti := RightInverse( T );
      
      TT := HomalgVoidMatrix( K );
      T2 := SyzygiesOfColumns( extension_map2 );
      extension_map2 := BasisOfColumnsCoeff( extension_map2, TT );
      TT := UnionOfColumns( TT, T2 );
      TTi := LeftInverse( TT );
      
      rank := NrRows( extension_map2 );
      r := NrRows( extension_map ) - rank;
      c := NrColumns( extension_map ) - rank;
      Z := HomalgZeroMatrix( r, c, K );
      extension_map := DiagMat( [ extension_map2, Z ] );
      
      R := UnderlyingNonGradedRing( S );
      T := R* T;
      TT := R* TT;
      Ti := R * Ti;
      TTi := R * TTi;
      
      if left then
          AddANewPresentation( UnderlyingModule( M ), RelationsOfModule( M ) * Ti, Ti, T );
          AddANewPresentation( UnderlyingModule( N ), RelationsOfModule( N ) * TT, TT, TTi );
      else
          AddANewPresentation( UnderlyingModule( M ), RelationsOfModule( M ) * TT, TT, TTi );
          AddANewPresentation( UnderlyingModule( N ), RelationsOfModule( N ) * Ti, Ti, T );
      fi;
      
      # 2)
      g := NrGenerators( Range( var_s_morphism ) );
      if left then
          T := UnionOfRows( HomalgIdentityMatrix( g, R ), - CertainRows( MatrixOfMap( UnderlyingMorphism( var_s_morphism ) ), [ 1 .. rank ] ) );
          # that the next line does not exist is the trick: we do not need these generators
          # T := UnionOfColumns( T, UnionOfRows( HomalgZeroMatrix( g, rank, R ), HomalgIdentityMatrix( rank, R ) ) );
      else
          T := UnionOfColumns( HomalgIdentityMatrix( g, R ), - CertainColumns( MatrixOfMap( UnderlyingMorphism( var_s_morphism ) ), [ 1 .. rank ] ) );
      fi;
      if left then
          Ti := LeftInverse( T );
      else
          Ti := RightInverse( T );
      fi;
      
      h := NrRelations( Source( psi ) );
      if left then
           T2 := UnionOfColumns( UnionOfColumns( HomalgZeroMatrix( r, rank, S ), HomalgIdentityMatrix( r, S ) ), HomalgZeroMatrix( r, h, S ) );
           T2 := UnionOfRows( T2, UnionOfColumns( UnionOfColumns( CertainColumns( MatrixOfRelations( Source( psi ) ), [ 1 .. rank ] ), HomalgZeroMatrix( h, r, S ) ), HomalgIdentityMatrix( h, S ) ) );
      else
           T2 := UnionOfRows( UnionOfRows( HomalgZeroMatrix( rank, r, S ), HomalgIdentityMatrix( r, S ) ), HomalgZeroMatrix( h, r, S ) );
           T2 := UnionOfColumns( T2, UnionOfRows( UnionOfRows( CertainRows( MatrixOfRelations( Source( psi ) ), [ 1 .. rank ] ), HomalgZeroMatrix( r, h, S ) ), HomalgIdentityMatrix( h, S ) ) );
      fi;
      
      ################################
      # end simplification block  WW:=RightPresentationWithDegrees( wmat, [ 2, 0, 0, 2, 1, 1, 4 ], S );StandardModule(WW);
      ################################
      
      result := [ var_s_morphism, GradedMap( S * extension_map, M, N, S ), rank, T, Ti, T2 ];
      
      return result;
    
end );

InstallGlobalFunction( _Functor_HomogeneousExteriorComplexToModule_OnGradedModules,    ### defines: HomogeneousExteriorComplexToModule (object part)
  function( ltate, M )
      local reg2, result, EmbeddingsOfHigherDegrees, jj, j, tate_morphism, psi,extension_map, var_s_morphism, rank, T, Ti, T2, k;
      
      reg2 := HighestDegree( ltate );
      
      result := UnderlyingObject( SubmoduleGeneratedByHomogeneousPart( reg2, M ) );
      
#   each new step constructs a new StdM as pushout of 
#   extension_map*LeftPushoutMap  and  var_s_morphism.
#   These maps are created from a modified Tate resolution.
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
          # but the gaussian algorithm is applied to the latter matrix (both to rows an columns) for easier simplification
          tate_morphism := CertainMorphism( ltate, j );
          
          psi := LeftPushoutMap( result );
          
          extension_map := ExtensionMapsFromExteriorComplex( tate_morphism, psi );
          var_s_morphism := extension_map[1];
          rank := extension_map[3];
          T := extension_map[4];
          Ti := extension_map[5];
          T2 := extension_map[6];
          extension_map := extension_map[2];
          
          # this line computes the standard module
          result := Pushout( var_s_morphism, PreCompose( extension_map, psi ) );
          
          # use the trick explained in ExtensionMapsFromExteriorComplex to simplify the module
          if IsHomalgLeftObjectOrMorphismOfLeftObjects( result ) then
              Ti := DiagMat( [ Ti, HomalgIdentityMatrix( NrGenerators( result) - NrRows( T ), HomalgRing( T ) ) ] );
              T := DiagMat( [ T, HomalgIdentityMatrix( NrGenerators( result) - NrRows( T ), HomalgRing( T ) ) ] );
              T2 := DiagMat( [ T2, HomalgIdentityMatrix( NrRelations( result) - NrColumns( T2 ), HomalgRing( T2 ) ) ] );
              AddANewPresentation( UnderlyingModule( result ), HomalgRelationsForLeftModule( UnderlyingNonHomogeneousMatrix( T2 * MatrixOfRelations( result ) ) ) * T, T, Ti );
          else
              Ti := DiagMat( [ Ti, HomalgIdentityMatrix( NrGenerators( result) - NrColumns( T ), HomalgRing( T ) ) ] );
              T := DiagMat( [ T, HomalgIdentityMatrix( NrGenerators( result) - NrColumns( T ), HomalgRing( T ) ) ] );
              T2 := DiagMat( [ T2, HomalgIdentityMatrix( NrRelations( result) - NrRows( T2 ), HomalgRing( T2 ) ) ] );
              AddANewPresentation( UnderlyingModule( result ), HomalgRelationsForRightModule( UnderlyingNonHomogeneousMatrix( MatrixOfRelations( result ) * T2 ) ) * T, T, Ti );
          fi;
#           BasisOfModule( UnderlyingModule( result ) );
          
          # try to keep the information about higher modules
          EmbeddingsOfHigherDegrees!.(j) := TheIdentityMorphism( result );
          for k in [ j + 1 .. reg2 ] do
              EmbeddingsOfHigherDegrees!.(k) := PreCompose( EmbeddingsOfHigherDegrees!.(k), RightPushoutMap( result ) );
          od;
          
      od;
      
      result!.EmbeddingsOfHigherDegrees := EmbeddingsOfHigherDegrees;
      
      BasisOfModule( UnderlyingModule( result ) );
      
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
      
      ltate:= MinimallyGeneratedHomogeneousSummand2( tate );
      
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

##  <#GAPDoc Label="HomogeneousPartOverCoefficientsRing">
##  <ManSection>
##    <Oper Arg="d, M" Name="HomogeneousPartOverCoefficientsRing"/>
##    <Returns>a &homalg; module</Returns>
##    <Description>
##      The degree <M>d</M> homogeneous part of the graded <M>R</M>-module <A>M</A>
##      as a module over the coefficient ring or field of <M>R</M>.
##      <#Include Label="HomogeneousPartOverCoefficientsRing:example">
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
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
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    local S, k, d, mat;
    
    S := HomalgRing( phi );
    
    if not HasCoefficientsRing( S ) then
        TryNextMethod( );
    fi;
    
    k := CoefficientsRing( S );
    
    d := arg_before_pos[1];
    
    mat := k * MatrixOfMap( RepresentationOfMorphismOnHomogeneousParts( phi, d, d ) );
    
    return HomalgMap( mat, F_source, F_target );
    
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
                [ "OnMorphisms", _Functor_HomogeneousPartOverCoefficientsRing_OnGradedMaps ],
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
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    
    return HomogeneousPartOverCoefficientsRing( 0, phi );
    
end );

InstallValue( Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "HomogeneousPartOfDegreeZeroOverCoefficientsRing" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "HomogeneousPartOfDegreeZeroOverCoefficientsRing" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedModules ],
                [ "OnMorphisms", _Functor_HomogeneousPartOfDegreeZeroOverCoefficientsRing_OnGradedMaps ],
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


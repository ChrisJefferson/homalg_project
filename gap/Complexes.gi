#############################################################################
##
##  Complexes.gi                homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg procedures for complexes.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( DefectOfExactness,
        "for a homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep ],
        
  function( C )
    local display, display_string, on_less_generators, left, degrees, l,
          morphisms, T, H, i, S;
    
    if HasIsComplexForDefectOfExactness( C ) and IsComplexForDefectOfExactness( C ) then
        TryNextMethod( );
    fi;
    
    if IsBound( C!.DisplayHomology ) and C!.DisplayHomology = true then
        display := true;
    else
        display := false;
    fi;
    
    if IsBound( C!.StringBeforeDisplay ) and IsStringRep( C!.StringBeforeDisplay ) then
        display_string := C!.StringBeforeDisplay;
    else
        display_string := "";
    fi;
    
    if IsBound( C!.HomologyOnLessGenerators ) and C!.HomologyOnLessGenerators = true then
        on_less_generators := true;
    else
        on_less_generators := false;
    fi;
        
    if IsGradedObject( C ) then
        H := C;
    elif IsBound(C!.HomologyGradedObject) then
        H := C!.HomologyGradedObject;
    fi;
    
    if IsBound( H ) then
        if on_less_generators then
            OnLessGenerators( H );
        fi;
        
        if display then
            for i in ObjectsOfComplex( H ) do
                Print( display_string );
                Display( i );
            od;
        fi;
        
        return H;
    fi;
    
    if not IsComplex( C ) then
        Error( "the input is not a complex" );
    fi;
    
    left := IsHomalgLeftObjectOrMorphismOfLeftObjects( C );
    
    degrees := MorphismDegreesOfComplex( C );
    
    l := Length(degrees);
    
    morphisms := MorphismsOfComplex( C );
    
    if not IsBound( C!.SkipLowestDegreeHomology ) then
        T := Cokernel( morphisms[1] );
        H := HomalgComplex( T, degrees[1] - 1 );
    else
        if left then
            T := DefectOfExactness( morphisms[2], morphisms[1] );
        else
            T := DefectOfExactness( morphisms[1], morphisms[2] );
        fi;
        H := HomalgComplex( T, degrees[1] );
        morphisms := morphisms{[ 2 .. l ]};
        l := l - 1;
    fi;
    
    if on_less_generators then
        OnLessGenerators( T );
    fi;
    
    if display then
        Print( display_string );
        Display( T );
    fi;
    
    for i in [ 1 .. l - 1 ] do
        if left then
            S := DefectOfExactness( morphisms[i + 1], morphisms[i] );
        else
            S := DefectOfExactness( morphisms[i], morphisms[i + 1] );
        fi;
        Add( H, HomalgZeroMap( S, T ) );
        T := S;
        
        if on_less_generators then
            OnLessGenerators( T );
        fi;
        
        if display then
            Print( display_string );
            Display( T );
        fi;
    od;
    
    if not ( IsBound( C!.SkipHighestDegreeHomology ) and C!.SkipHighestDegreeHomology = true ) then
        S := Kernel( morphisms[l] );
        Add( H, HomalgZeroMap( S, T ) );
        
        if on_less_generators then
            OnLessGenerators( S );
        fi;
        
        if display then
            Print( display_string );
            Display( S );
        fi;
    fi;
    
    SetIsGradedObject( H, true );
    
    C!.HomologyGradedObject := H;
    
    return H;
    
end );

##
InstallMethod( DefectOfExactness,
        "for a homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep ],
        
  function( C )
    local display, display_string, on_less_generators, left, degrees, l,
          morphisms, S, H, i, T;
    
    if IsBound( C!.DisplayCohomology ) and C!.DisplayCohomology = true then
        display := true;
    else
        display := false;
    fi;
    
    if IsBound( C!.CohomologyOnLessGenerators ) and C!.CohomologyOnLessGenerators = true then
        on_less_generators := true;
    else
        on_less_generators := false;
    fi;
        
    if IsBound( C!.StringBeforeDisplay ) and IsStringRep( C!.StringBeforeDisplay ) then
        display_string := C!.StringBeforeDisplay;
    else
        display_string := "";
    fi;
    
    if IsGradedObject( C ) then
        H := C;
    elif IsBound(C!.CohomologyGradedObject) then
        H := C!.CohomologyGradedObject;
    fi;
    
    if IsBound( H ) then
        if on_less_generators then
            OnLessGenerators( H );
        fi;
        
        if display then
            for i in ObjectsOfComplex( H ) do
                Print( display_string );
                Display( i );
            od;
        fi;
        
        return H;
    fi;
    
    if not IsComplex( C ) then
        Error( "the input is not a cocomplex" );
    fi;
    
    left := IsHomalgLeftObjectOrMorphismOfLeftObjects( C );
    
    degrees := MorphismDegreesOfComplex( C );
    
    l := Length(degrees);
    
    morphisms := MorphismsOfComplex( C );
    
    if not IsBound( C!.SkipLowestDegreeCohomology ) then
        S := Kernel( morphisms[1] );
        H := HomalgCocomplex( S, degrees[1] );
    else
        if left then
            S := DefectOfExactness( morphisms[1], morphisms[2] );
        else
            S := DefectOfExactness( morphisms[2], morphisms[1] );
        fi;
        H := HomalgCocomplex( S, degrees[1] + 1 );
        morphisms := morphisms{[ 2 .. l ]};
        l := l - 1;
    fi;
    
    if on_less_generators then
        OnLessGenerators( S );
    fi;
    
    if display then
        Print( display_string );
        Display( S );
    fi;
    
    for i in [ 1 .. l - 1 ] do
        if left then
            T := DefectOfExactness( morphisms[i], morphisms[i + 1] );
        else
            T := DefectOfExactness( morphisms[i + 1], morphisms[i] );
        fi;
        Add( H, HomalgZeroMap( S, T ) );
        S := T;
        
        if on_less_generators then
            OnLessGenerators( S );
        fi;
        
        if display then
            Print( display_string );
            Display( S );
        fi;
    od;
    
    if not ( IsBound( C!.SkipHighestDegreeCohomology ) and C!.SkipHighestDegreeCohomology = true ) then
        T := Cokernel( morphisms[l] );
        Add( H, HomalgZeroMap( S, T ) );
        
        if on_less_generators then
            OnLessGenerators( T );
        fi;
        
        if display then
            Print( display_string );
            Display( T );
        fi;
    fi;
    
    SetIsGradedObject( H, true );
    
    C!.CohomologyGradedObject := H;
    
    return H;
    
end );

##
InstallMethod( Homology,			### defines: Homology (HomologyModules)
        "for a homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    if IsCocomplexOfFinitelyPresentedObjectsRep( C ) then
        Error( "this is a cocomplex: use \033[1mCohomology\033[0m instead\n" );
    fi;
    
    return DefectOfExactness( C );
    
end );

##
InstallMethod( Cohomology,			### defines: Cohomology (CohomologyModules)
        "for a homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    if IsComplexOfFinitelyPresentedObjectsRep( C ) then
        Error( "this is a complex: use \033[1mHomology\033[0m instead\n" );
    fi;
    
    return DefectOfExactness( C );
    
end );

## 0 <-- M <-(psi)- E <-(phi)- N <-- 0
InstallMethod( Resolution,	### defines: Resolution (generalizes ResolveShortExactSeq)
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsShortExactSequence, IsInt ],
        
  function( C, _q )
    local q, degrees, l, M, psi, E, phi, N, dM, dN, j, epsilonN, epsilonM,
          epsilon, dj, Pj, dE, d_psi, d_phi, horse_shoe, mu, epsilon_j;
    
    q := _q;
    
    degrees := ObjectDegreesOfComplex( C );
    
    l := Length( degrees );
    
    M := CertainObject( C, degrees[1] );
    psi := CertainMorphism( C, degrees[2] );
    E := CertainObject( C, degrees[2] );
    phi := CertainMorphism( C, degrees[3] );
    N := CertainObject( C, degrees[3] );
    
    dM := Resolution( M, q );
    dN := Resolution( N, q );
    
    if q < 1 then
        q := Maximum( List( [ dM, dN ], HighestDegreeInComplex ) );
        dM := Resolution( M, q );
        dN := Resolution( N, q );
    fi;
    
    j := 0;
    
    epsilonM := FreeHullEpi( M );
    epsilonN := FreeHullEpi( N );
    
    epsilonM := PostDivide( epsilonM, psi );
    epsilonN := PreCompose( epsilonN, phi );
    
    epsilon := StackMaps( epsilonN, epsilonM );
    
    SetIsEpimorphism( epsilon, true );
    
    dj := epsilon;
    
    Pj := Source( dj );
    
    dE := HomalgComplex( Pj );
    
    psi := DirectSumEpis( Pj )[2];
    phi := DirectSumEmbs( Pj )[1];
    
    d_psi := HomalgChainMap( psi, dE, dM );
    d_phi := HomalgChainMap( phi, dN, dE );
    
    horse_shoe := HomalgComplex( d_psi, degrees[2] );
    Add( horse_shoe, d_phi );
    
    while j < q do
        j := j + 1;
        
        mu := KernelEmb( dj );
        
        psi := CompleteImageSquare( mu, psi, SyzygiesModuleEmb( M, j ) );
        phi := CompleteImageSquare( SyzygiesModuleEmb( N, j ), phi, mu );
        
        epsilonM := SyzygiesModuleEpi( M, j );
        epsilonN := SyzygiesModuleEpi( N, j );
        
        epsilonM := PostDivide( epsilonM, psi );
        epsilonN := PreCompose( epsilonN, phi );
        
        epsilon_j := StackMaps( epsilonN, epsilonM );
        
        Pj := Source( epsilon_j );
        
        dj := PreCompose( epsilon_j, mu );
        
        if j = 1 then
            SetCokernelEpi( dj, epsilon );
        fi;
        
        Add( dE, dj );
        
        psi := DirectSumEpis( Pj )[2];
        phi := DirectSumEmbs( Pj )[1];
        
        Add( d_psi, psi );
        Add( d_phi, phi );
        
    od;
    
    SetIsAcyclic( dE, true );
    SetIsExactSequence( horse_shoe, true );
    
    return horse_shoe;
    
end );

InstallMethod( Resolution,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep ],
        
  function( C )
    local R, q;
    
    R := HomalgRing( C );
    
    if IsBound( C!.MaximumNumberOfResolutionSteps )
      and IsInt( C!.MaximumNumberOfResolutionSteps ) then
        q := C!.MaximumNumberOfResolutionSteps;
    elif IsBound( R!.MaximumNumberOfResolutionSteps )
      and IsInt( R!.MaximumNumberOfResolutionSteps ) then
        q := R!.MaximumNumberOfResolutionSteps;
    elif IsBound( HOMALG.MaximumNumberOfResolutionSteps )
      and IsInt( HOMALG.MaximumNumberOfResolutionSteps ) then
        q := HOMALG.MaximumNumberOfResolutionSteps;
    else
        q := 0;
    fi;
    
    return Resolution( C, q );
    
end );

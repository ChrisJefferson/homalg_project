#############################################################################
##
##  HomalgComplex.gi            homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg complexes.
##
#############################################################################

####################################
#
# representations:
#
####################################

# two new representations for the GAP-category IsHomalgComplex
# which are subrepresentations of the representation IsFinitelyPresentedObjectRep:
DeclareRepresentation( "IsComplexOfFinitelyPresentedObjectsRep",
        IsHomalgComplex and IsFinitelyPresentedObjectRep,
        [  ] );

DeclareRepresentation( "IsCocomplexOfFinitelyPresentedObjectsRep",
        IsHomalgComplex and IsFinitelyPresentedObjectRep,
        [  ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgComplexes",
        NewFamily( "TheFamilyOfHomalgComplexes" ) );

# four new types:
BindGlobal( "TheTypeHomalgComplexOfLeftObjects",
        NewType( TheFamilyOfHomalgComplexes,
                IsComplexOfFinitelyPresentedObjectsRep and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgComplexOfRightObjects",
        NewType( TheFamilyOfHomalgComplexes,
                IsComplexOfFinitelyPresentedObjectsRep and IsHomalgRightObjectOrMorphismOfRightObjects ) );

BindGlobal( "TheTypeHomalgCocomplexOfLeftObjects",
        NewType( TheFamilyOfHomalgComplexes,
                IsCocomplexOfFinitelyPresentedObjectsRep and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgCocomplexOfRightObjects",
        NewType( TheFamilyOfHomalgComplexes,
                IsCocomplexOfFinitelyPresentedObjectsRep and IsHomalgRightObjectOrMorphismOfRightObjects ) );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( PositionOfTheDefaultSetOfRelations,
        "for homalg maps",
        [ IsHomalgComplex ],
        
  function( M )
    
    return fail;
    
end );

##
InstallMethod( ObjectDegreesOfComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    return C!.degrees;
    
end );

##
InstallMethod( MorphismDegreesOfComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees, l;
    
    degrees := ObjectDegreesOfComplex( C );
    
    l := Length( degrees );
    
    if l = 1 then
        return [  ];
    elif IsComplexOfFinitelyPresentedObjectsRep( C ) then
        return degrees{[ 2 .. l ]};
    else
        return degrees{[ 1 .. l - 1 ]};
    fi;
    
end );

##
InstallMethod( CertainMorphism,
        "for homalg complexes",
        [ IsHomalgComplex, IsInt ],
        
  function( C, i )
    
    if IsBound( C!.(String( i )) ) and IsHomalgMorphism( C!.(String( i )) ) then
        return C!.(String( i ));
    fi;
    
    return fail;
    
end );

##
InstallMethod( CertainObject,
        "for homalg complexes",
        [ IsHomalgComplex, IsInt ],
        
  function( C, i )
    local degrees, l;
    
    if IsBound( C!.(String( i )) ) then
        if IsHomalgObject( C!.(String( i )) ) then
            return C!.(String( i ));
        else
            return Source( C!.(String( i )) );
        fi;
    fi;
    
    degrees := ObjectDegreesOfComplex( C );
    l := Length( degrees );
    
    if IsComplexOfFinitelyPresentedObjectsRep( C ) and degrees[1] = i then
        return Range( CertainMorphism( C, i + 1 ) );
    elif IsCocomplexOfFinitelyPresentedObjectsRep( C ) and degrees[l] = i then
        return Range( CertainMorphism( C, i - 1 ) );
    fi;
    
    return fail;
    
end );

##
InstallMethod( MorphismsOfComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees;
    
    degrees := MorphismDegreesOfComplex( C );
    
    if Length( degrees ) = 0 then
        return [  ];
    fi;
    
    return List( degrees, i -> CertainMorphism( C, i ) );
    
end );

##
InstallMethod( ObjectsOfComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local morphisms, l, modules;
    
    morphisms := MorphismsOfComplex( C );
    
    l := Length( morphisms );
    
    if l = 0 then
        return [ CertainObject( C, ObjectDegreesOfComplex( C )[1] ) ];
    elif IsComplexOfFinitelyPresentedObjectsRep( C ) then
        modules := List( morphisms, Range );
        Add( modules, Source( morphisms[l] ) );
    else
        modules := List( morphisms, Source );
        Add( modules, Range( morphisms[l] ) );
    fi;
    
    return modules;
    
end );

##
InstallMethod( LowestDegreeInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    return ObjectDegreesOfComplex( C )[1];
    
end );

##
InstallMethod( HighestDegreeInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees;
    
    degrees := ObjectDegreesOfComplex( C );
    
    return degrees[Length( degrees )];
    
end );

##
InstallMethod( LowestDegreeObjectInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    return CertainObject( C, LowestDegreeInComplex( C ) );
    
end );

##
InstallMethod( HighestDegreeObjectInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees;
    
    degrees := ObjectDegreesOfComplex( C );
    
    return CertainObject( C, HighestDegreeInComplex( C ) );
    
end );

##
InstallMethod( LowestDegreeMorphismInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees;
    
    degrees := MorphismDegreesOfComplex( C );
    
    return CertainMorphism( C, degrees[1] );
    
end );

##
InstallMethod( HighestDegreeMorphismInComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees;
    
    degrees := MorphismDegreesOfComplex( C );
    
    return CertainMorphism( C, degrees[Length( degrees )] );
    
end );

##
InstallMethod( HomalgRing,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    return HomalgRing( LowestDegreeObjectInComplex( C ) );
    
end );

##
InstallMethod( SupportOfComplex,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local degrees, l, modules;
    
    degrees := ObjectDegreesOfComplex( C );
    
    l := Length( degrees );
    
    modules := ObjectsOfComplex( C );
    
    return degrees{ Filtered( [ 1 .. l ], i -> not IsZero( modules[i] ) ) };
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep, IsMorphismOfFinitelyGeneratedModulesRep ],
        
  function( C, phi )
    local degrees, l, psi;
    
    if HasIsATwoSequence( C ) and IsATwoSequence( C ) then
        Error( "this complex is write-protected since IsATwoSequence = true\n" );
    fi;
    
    degrees := ObjectDegreesOfComplex( C );
    
    l := Length( degrees );
    
    if l = 1 then
        
        if IsHomalgMap( phi ) then
            if not IsIdenticalObj( CertainObject( C, degrees[1] ), Range( phi ) ) then
                Error( "the unique object in the complex and the target of the new map are not identical\n" );
            fi;
        else
            if CertainObject( C, degrees[1] ) <> Range( phi ) then
                Error( "the unique object in the complex and the target of the new chain map are not equal\n" );
            fi;
        fi;
        
        Unbind( C!.(String( degrees[1] )) );
        
        Add( degrees, degrees[1] + 1 );
        
        C!.(String( degrees[1] + 1 )) := phi;
        
    else
        
        l := degrees[l];
        
        if IsHomalgMap( phi ) then
            if not IsIdenticalObj( Source( CertainMorphism( C, l ) ), Range( phi ) ) then
                Error( "the source of the ", l, ". map in the complex (i.e. the highest one) and the target of the new one are not identical\n" );
            fi;
        else
            if Source( CertainMorphism( C, l ) ) <> Range( phi ) then
                Error( "the source of the ", l, ". chain map in the complex (i.e. the highest one) and the target of the new one are not equal\n" );
            fi;
        fi;
        
        Add( degrees, l + 1 );
        
        C!.(String( l + 1 )) := phi;
        
    fi;
    
    ConvertToRangeRep( degrees );
    
    if HasIsSequence( C ) and IsSequence( C ) and
       HasIsMorphism( phi ) and IsMorphism( phi ) then
        homalgResetFilters( C );
        SetIsSequence( C, true );
    else
        homalgResetFilters( C );
    fi;
    
    if Length( degrees ) = 3 then
        psi := LowestDegreeMorphismInComplex( C );
        if HasIsEpimorphism( psi ) and IsEpimorphism( psi ) and
           ( ( HasKernelEmb( psi ) and IsIdenticalObj( KernelEmb( psi ), phi ) ) or
             ( HasCokernelEpi( phi ) and IsIdenticalObj( CokernelEpi( phi ), psi ) ) ) then
            SetIsShortExactSequence( C, true );
        fi;
    fi;
    
    return C;
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep, IsMorphismOfFinitelyGeneratedModulesRep ],
        
  function( C, phi )
    local degrees, l, psi;
    
    degrees := ObjectDegreesOfComplex( C );
    
    l := Length( degrees );
    
    if l = 1 then
        
        if IsHomalgMap( phi ) then
            if not IsIdenticalObj( CertainObject( C, degrees[1] ), Source( phi ) ) then
                Error( "the unique object in the complex and the source of the new map are not identical\n" );
            fi;
        else
            if CertainObject( C, degrees[1] ) <> Source( phi ) then
                Error( "the unique object in the complex and the source of the new chain map are not equal\n" );
            fi;
        fi;
        
        Add( degrees, degrees[1] + 1 );
        
        C!.(String( degrees[1] )) := phi;
        
    else
        
        l := degrees[l - 1];
        
        if IsHomalgMap( phi ) then
            if not IsIdenticalObj( Range( CertainMorphism( C, l ) ), Source( phi ) ) then
                Error( "the target of the ", l, ". map in the complex (i.e. the highest one) and the source of the new one are not identical\n" );
            fi;
        else
            if Range( CertainMorphism( C, l ) ) <>  Source( phi ) then
                Error( "the target of the ", l, ". chain map in the complex (i.e. the highest one) and the source of the new one are not equal\n" );
            fi;
        fi;
        
        Add( degrees, l + 2 );
        
        C!.(String( l + 1 )) := phi;
        
    fi;
    
    ConvertToRangeRep( degrees );
    
    if HasIsSequence( C ) and IsSequence( C ) and
       HasIsMorphism( phi ) and IsMorphism( phi ) then
        homalgResetFilters( C );
        SetIsSequence( C, true );
    else
        homalgResetFilters( C );
    fi;
    
    if Length( degrees ) = 3 then
        psi := LowestDegreeMorphismInComplex( C );
        if HasIsMonomorphism( psi ) and IsMonomorphism( psi ) and
           ( ( HasCokernelEpi( psi ) and IsIdenticalObj( CokernelEpi( psi ), phi ) ) or
             ( HasKernelEmb( phi ) and IsIdenticalObj( KernelEmb( phi ), psi ) ) ) then
            SetIsShortExactSequence( C, true );
        fi;
    fi;
    
    return C;
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep, IsFinitelyPresentedModuleRep ],
        
  function( C, M )
    local T, grd, cpx, seq;
    
    T := HighestDegreeObjectInComplex( C );
    
    if HasIsGradedObject( C ) then
        grd := IsGradedObject( C );
    elif HasIsComplex( C ) then
        cpx := IsComplex( C );
    elif HasIsSequence( C ) then
        seq := IsSequence ( C );
    fi;
    
    Add( C, HomalgZeroMap( M, T ) );
    
    if IsBound( grd ) then
        SetIsGradedObject( C, grd );
    elif IsBound( cpx ) then
        SetIsComplex( C, cpx );
    elif IsBound( seq ) then
        SetIsSequence( C, seq );
    fi;
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep, IsFinitelyPresentedModuleRep ],
        
  function( C, M )
    local S, grd, cpx, seq;
    
    S := HighestDegreeObjectInComplex( C );
    
    if HasIsGradedObject( C ) then
        grd := IsGradedObject( C );
    elif HasIsComplex( C ) then
        cpx := IsComplex( C );
    elif HasIsSequence( C ) then
        seq := IsSequence ( C );
    fi;
    
    Add( C, HomalgZeroMap( S, M ) );
    
    if IsBound( grd ) then
        SetIsGradedObject( C, grd );
    elif IsBound( cpx ) then
        SetIsComplex( C, cpx );
    elif IsBound( seq ) then
        SetIsSequence( C, seq );
    fi;
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep, IsHomalgMatrix ],
        
  function( C, mat )
    local T;
    
    T := HighestDegreeObjectInComplex( C );
    
    Add( C, HomalgMap( mat, "free", T ) );
    
end );

##
InstallMethod( Add,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep, IsHomalgMatrix ],
        
  function( C, mat )
    local S;
    
    S := HighestDegreeObjectInComplex( C );
    
    Add( C, HomalgMap( mat, S, "free" ) );
    
end );

##
InstallMethod( Shift,
        "for homalg complexes",
        [ IsHomalgComplex, IsInt ],
        
  function( C, s )
    local d, Cd, Cs, m;
    
    d := LowestDegreeInComplex( C );
    
    Cd := LowestDegreeObjectInComplex( C );
    
    if IsComplexOfFinitelyPresentedObjectsRep( C ) then
        Cs := HomalgComplex( Cd, d - s );
    else
        Cs := HomalgCocomplex( Cd, d - s );
    fi;
    
    for m in MorphismsOfComplex( C ) do
        Add( Cs, m );
    od;
    
    if HasIsGradedObject( C ) and IsGradedObject( C ) then
        SetIsGradedObject( Cs, true );
    elif HasIsComplex( C ) and IsComplex( C ) then
        SetIsComplex( Cs, true );
    elif HasIsSequence( C ) and IsSequence( C ) then
        SetIsSequence( Cs, true );
    fi;
    
    return Cs;
    
end );

##
InstallMethod( \+,
        "for two homalg complexes",
        [ IsHomalgComplex and IsGradedObject, IsHomalgComplex and IsGradedObject ],
        
  function( C1, C2 )
    local cpx, d1, d2, d, Cd, Cs, i;
    
    if IsComplexOfFinitelyPresentedObjectsRep( C1 ) and IsComplexOfFinitelyPresentedObjectsRep( C2 ) then
        cpx := true;
    elif IsCocomplexOfFinitelyPresentedObjectsRep( C1 ) and IsCocomplexOfFinitelyPresentedObjectsRep( C2 ) then
        cpx := false;
    else
        Error( "first and second argument must either be both complexes or both cocomplexes\n" );
    fi;
    
    d1 := LowestDegreeInComplex( C1 );
    d2 := LowestDegreeInComplex( C2 );
    
    d := Minimum( d1, d2 );
    
    if d1 < d2 then
        Cd := LowestDegreeObjectInComplex( C1 );
    elif d2 < d1 then
        Cd := LowestDegreeObjectInComplex( C2 );
    else
        Cd := LowestDegreeObjectInComplex( C1 ) + LowestDegreeObjectInComplex( C2 );
    fi;
    
    if cpx then
        Cs := HomalgComplex( Cd, d );
    else
        Cs := HomalgCocomplex( Cd, d );
    fi;
    
    d1 := ObjectDegreesOfComplex( C1 );
    d2 := ObjectDegreesOfComplex( C2 );
    
    for i in [ d + 1 .. Maximum( List( [ C1, C2 ], HighestDegreeInComplex ) ) ] do
        if not i in d2 then
            Cd := CertainObject( C1, i );
        elif not i in d1 then
            Cd := CertainObject( C2, i );
        else
            Cd := CertainObject( C1, i ) + CertainObject( C2, i );
        fi;
        
        Add( Cs, Cd );
    od;
    
    SetIsGradedObject( Cs, true );
    
    return Cs;
    
end );

##
InstallMethod( CertainMorphismAsSubcomplex,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( C, i )
    local m, A;
    
    m := CertainMorphism( C, i );
    
    if m = fail then
        m := CertainMorphism( C, i + 1 );
        if m = fail then
            return fail;
        fi;
        m := CokernelEpi( m );
    fi;
    
    A := HomalgComplex( m, i );
    
    if HasIsZero( C ) and IsZero( C ) then
        SetIsZero( A, true );
    elif HasIsGradedObject( C ) and IsGradedObject( C ) then
        SetIsGradedObject( A, true );
    elif HasIsComplex( C ) and IsComplex( C ) then
        SetIsComplex( A, true );
    elif HasIsSequence( C ) and IsSequence( C ) then
        SetIsComplex( A, true );	## this is not a mistake
    fi;
    
    return A;
    
end );

##
InstallMethod( CertainMorphismAsSubcomplex,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( C, i )
    local m, A;
    
    m := CertainMorphism( C, i );
    
    if m = fail then
        return fail;
    fi;
    
    A := HomalgCocomplex( m, i );
    
    if HasIsZero( C ) and IsZero( C ) then
        SetIsZero( A, true );
    elif HasIsGradedObject( C ) and IsGradedObject( C ) then
        SetIsGradedObject( A, true );
    elif HasIsComplex( C ) and IsComplex( C ) then
        SetIsComplex( A, true );
    elif HasIsSequence( C ) and IsSequence( C ) then
        SetIsComplex( A, true );	## this is not a mistake
    fi;
    
    return A;
    
end );

##
InstallMethod( CertainTwoMorphismsAsSubcomplex,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( C, i )
    local m, A;
    
    m := CertainMorphism( C, i );
    
    if m = fail then
        return fail;
    fi;
    
    A := HomalgComplex( m, i );
    
    Add( A, CertainMorphism( C, i + 1 ) );
    
    if HasIsZero( C ) and IsZero( C ) then
        SetIsZero( A, true );
    elif HasIsGradedObject( C ) and IsGradedObject( C ) then
        SetIsGradedObject( A, true );
    elif HasIsComplex( C ) and IsComplex( C ) then
        SetIsComplex( A, true );
    elif HasIsSequence( C ) and IsSequence( C ) then
        SetIsSequence( A, true );
    fi;
    
    return A;
    
end );

##
InstallMethod( CertainTwoMorphismsAsSubcomplex,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( C, i )
    local m, A;
    
    m := CertainMorphism( C, i - 1 );
    
    if m = fail then
        return fail;
    fi;
    
    A := HomalgCocomplex( m, i - 1 );
    
    Add( A, CertainMorphism( C, i ) );
    
    if HasIsZero( C ) and IsZero( C ) then
        SetIsZero( A, true );
    elif HasIsGradedObject( C ) and IsGradedObject( C ) then
        SetIsGradedObject( A, true );
    elif HasIsComplex( C ) and IsComplex( C ) then
        SetIsComplex( A, true );
    elif HasIsSequence( C ) and IsSequence( C ) then
        SetIsSequence( A, true );
    fi;
    
    return A;
    
end );

##
InstallMethod( LongSequence,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsTriangle ],
        
  function( T )
    local mor, deg, C, j;
    
    mor := MorphismsOfComplex( T );
    
    deg := DegreesOfChainMap( mor[1] );
    
    C := HomalgComplex( CertainMorphism( mor[1], deg[1] ) );
    Add( C, CertainMorphism( mor[2], deg[1] ) );
    
    for j in deg{[ 2 .. Length( deg ) ]} do
        
        Add( C, CertainMorphism( mor[3], j ) );
        Add( C, CertainMorphism( mor[1], j ) );
        Add( C, CertainMorphism( mor[2], j ) );
        
    od;
    
    return C;
    
end );

##
InstallMethod( LongSequence,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and IsTriangle ],
        
  function( T )
    local mor, deg, C, j;
    
    mor := MorphismsOfComplex( T );
    
    deg := DegreesOfChainMap( mor[1] );
    
    C := HomalgCocomplex( CertainMorphism( mor[1], deg[1] ) );
    Add( C, CertainMorphism( mor[2], deg[1] ) );
    
    for j in deg{[ 2 .. Length( deg ) ]} do
        
        Add( C, CertainMorphism( mor[3], j - 1 ) );
        Add( C, CertainMorphism( mor[1], j ) );
        Add( C, CertainMorphism( mor[2], j ) );
        
    od;
    
    return C;
    
end );

##
InstallMethod( OnLessGenerators,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    List( ObjectsOfComplex( C ), OnLessGenerators );
    
    return C;
    
end );

##
InstallMethod( BasisOfModule,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    List( ObjectsOfComplex( C ), BasisOfModule );
    
    return C;
    
end );

##
InstallMethod( DecideZero,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    List( MorphismsOfComplex( C ), DecideZero );
    
    return C;
    
end );

##
InstallMethod( ByASmallerPresentation,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    
    if Length( ObjectDegreesOfComplex( C ) ) = 1 then
        List( ObjectsOfComplex( C ), ByASmallerPresentation );
    else
        List( MorphismsOfComplex( C ), ByASmallerPresentation );
    fi;
    
    return C;
    
end );

####################################
#
# global functions:
#
####################################

InstallMethod( homalgResetFilters,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( C )
    local property;
    
    if not IsBound( HOMALG.PropertiesOfComplexes ) then
        HOMALG.PropertiesOfComplexes :=
          [ IsZero,
            IsSequence,
            IsComplex,
            IsAcyclic,
            IsGradedObject,
            IsExactSequence,
            IsShortExactSequence,
            IsTriangle,
            IsExactTriangle,
            IsSplitShortExactSequence ];
    fi;
    
    for property in HOMALG.PropertiesOfComplexes do
        ResetFilterObj( C, property );
    od;
    
    if IsBound( C!.HomologyGradedObject ) then
        Unbind( C!.HomologyGradedObject );
    fi;
    
    if IsBound( C!.CohomologyGradedObject ) then
        Unbind( C!.CohomologyGradedObject );
    fi;
    
    if IsBound( C!.free_resolutions ) then
        Unbind( C!.free_resolutions );
    fi;
    
end );

####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( HomalgComplex,
  function( arg )
    local nargs, C, complex, degrees, object, obj_or_mor, left, type;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "empty input\n" );
    fi;
    
    C := rec( );
    
    if IsStringRep( arg[nargs] ) and ( arg[nargs] = "co" or arg[nargs] = "cocomplex" ) then
        complex := false;
    else
        complex := true;
    fi;
    
    if nargs > 1 and ( IsInt( arg[2] )
               or ( IsList( arg[2] ) and Length( arg[2] ) > 0 and ForAll( arg[2], IsInt ) ) ) then
        degrees := [ arg[2] ];
    elif complex and IsMorphismOfFinitelyGeneratedModulesRep( arg[1] ) then
        degrees := [ 1 ];
    else
        degrees := [ 0 ];
    fi;
    
    if IsHomalgRingOrFinitelyPresentedObjectRep( arg[1] ) then
        object := true;
        if IsHomalgRing( arg[1] ) then
            obj_or_mor := AsLeftModule( arg[1] );
        else
            obj_or_mor := arg[1];
        fi;
        C.degrees := degrees;
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( arg[1] );
    elif IsMorphismOfFinitelyGeneratedModulesRep( arg[1] ) then
        object := false;
        obj_or_mor := arg[1];
        if complex then
            C.degrees := [ degrees[1] - 1, degrees[1] ];
        else
            C.degrees := [ degrees[1], degrees[1] + 1 ];
        fi;
    else
        Error( "the first argument must be either a homalg object or a homalg morphism\n" );
    fi;
    
    left := IsHomalgLeftObjectOrMorphismOfLeftObjects( obj_or_mor );
    
    C.( String( degrees[1] ) ) := arg[1];
    
    if complex then
        if left then
            type := TheTypeHomalgComplexOfLeftObjects;
        else
            type := TheTypeHomalgComplexOfRightObjects;
        fi;
    else
        if left then
            type := TheTypeHomalgCocomplexOfLeftObjects;
        else
            type := TheTypeHomalgCocomplexOfRightObjects;
        fi;
    fi;
    
    ConvertToRangeRep( C.degrees );
    
    ## Objectify
    Objectify( type, C );
    
    if object then
        if degrees = [ 0 ] then
            SetIsAcyclic( C, true );
        fi;
        SetIsGradedObject( C, true );
    elif HasIsMorphism( arg[1] ) and IsMorphism( arg[1] ) then
        SetIsComplex( C, true );
    fi;
    
    return C;
    
end );

InstallGlobalFunction( HomalgCocomplex,
  function( arg )
    
    return CallFuncList( HomalgComplex, Concatenation( arg, [ "cocomplex" ] ) );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg complexes",
        [ IsHomalgComplex ],
        
  function( o )
    local cpx, first_attribute, degrees, l;
    
    cpx := IsComplexOfFinitelyPresentedObjectsRep( o );
    
    first_attribute := false;
    
    Print( "<A" );
    
    if HasIsZero( o ) then ## if this method applies and HasIsZero is set we already know that o is a non-zero homalg (co)complex
        Print( " non-zero" );
        first_attribute := true;
    fi;
    
    if HasIsAcyclic( o ) and IsAcyclic( o ) then
        if not first_attribute then
            Print( "n" );
        fi;
        if cpx then
            Print( " acyclic complex" );
        else
            Print( " acyclic cocomplex" );
        fi;
    elif HasIsExactTriangle( o ) and IsExactTriangle( o ) then
        if not first_attribute then
            Print( "n" );
        fi;
        if cpx then
            Print( " exact triangle" );
        else
            Print( " exact cotriangle" );
        fi;
    elif HasIsSplitShortExactSequence( o ) and IsSplitShortExactSequence( o ) then
        if cpx then
            Print( " split short exact sequence" );
        else
            Print( " split short exact cosequence" );
        fi;
    elif HasIsShortExactSequence( o ) and IsShortExactSequence( o ) then
        if cpx then
            Print( " short exact sequence" );
        else
            Print( " short exact cosequence" );
        fi;
    elif HasIsExactSequence( o ) and IsExactSequence( o ) then
        if not first_attribute then
            Print( "n" );
        fi;
        if cpx then
            Print( " exact sequence" );
        else
            Print( " exact cosequence" );
        fi;
    elif HasIsComplex( o ) then
        if IsComplex( o ) then
            if cpx then
                Print( " complex" );
            else
                Print( " cocomplex" );
            fi;
        else
            if cpx then
                Print( " non-complex" );
            else
                Print( " non-cocomplex" );
            fi;
        fi;
    elif HasIsSequence( o ) then
        if IsSequence( o ) then
            if cpx then
                Print( " sequence" );
            else
                Print( " cosequence" );
            fi;
        else
            if cpx then
                Print( " sequence of non-well-definded maps" );
            else
                Print( " cosequence of non-well-definded maps" );
            fi;
        fi;
    else
        if cpx then
            Print( " \"complex\"" );
        else
            Print( " \"cocomplex\"" );
        fi;
    fi;
    
    Print( " containing " );
    
    degrees := ObjectDegreesOfComplex( o );
    
    l := Length( degrees );
    
    if l = 1 then
        
        Print( "a single " );
        
        if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
            Print( "left" );
        else
            Print( "right" );
        fi;
        
        if IsHomalgModule( CertainObject( o, degrees[1] ) ) then
            Print( " module" );
        else
            if IsComplexOfFinitelyPresentedObjectsRep( CertainObject( o, degrees[1] ) ) then
                Print( " complex" );
            else
                Print( " cocomplex" );
            fi;
        fi;
        
        Print( " at degree ", degrees[1], ">" );
        
    else
        
        if l = 2 then
            Print( "a single morphism" );
        else
            Print( l - 1, " morphisms" );
        fi;
        
        Print( " of " );
        
        if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
            Print( "left" );
        else
            Print( "right" );
        fi;
        
        if IsHomalgModule( CertainObject( o, degrees[1] ) ) then
            Print( " modules" );
        else
            if IsComplexOfFinitelyPresentedObjectsRep( CertainObject( o, degrees[1] ) ) then
                Print( " complexes" );
            else
                Print( " cocomplexes" );
            fi;
        fi;
        
        if HasIsExactTriangle( o ) and IsExactTriangle( o ) then
            if cpx then
                Print( " at degrees ", [ degrees[2], degrees[3], degrees[4], degrees[2] ], ">" );
            else
                Print( " at degrees ", [ degrees[1], degrees[2], degrees[3], degrees[1] ], ">" );
            fi;
        else
            Print( " at degrees ", degrees, ">" );
        fi;
        
    fi;
    
end );

##
InstallMethod( ViewObj,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsGradedObject ],
        
  function( o )
    local l, degrees;
    
    Print( "<A graded homology object consisting of " );
    
    degrees := ObjectDegreesOfComplex( o );
    
    l := Length( degrees );
    
    if l = 1 then
        Print( "a single" );
    else
        Print( l );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
        Print( " left" );
    else
        Print( " right" );
    fi;
    
    if IsHomalgModule( CertainObject( o, degrees[1] ) ) then
        Print( " module" );
        if l > 1 then
            Print( "s" );
        fi;
    else
        if IsComplexOfFinitelyPresentedObjectsRep( CertainObject( o, degrees[1] ) ) then
            Print( " complex" );
        else
            Print( " cocomplex" );
        fi;
        if l > 1 then
            Print( "es" );
        fi;
    fi;
    
    Print( " at degree" );
    
    if l = 1 then
        Print( " ", degrees[1] );
    else
        Print( "s ", degrees );
    fi;
    
    Print( ">" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and IsGradedObject ],
        
  function( o )
    local l, degrees;
    
    Print( "<A graded cohomology object consisting of " );
    
    degrees := ObjectDegreesOfComplex( o );
    
    l := Length( degrees );
    
    if l = 1 then
        Print( "a single" );
    else
        Print( l );
    fi;
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
        Print( " left" );
    else
        Print( " right" );
    fi;
    
    if IsHomalgModule( CertainObject( o, degrees[1] ) ) then
        Print( " module" );
        if l > 1 then
            Print( "s" );
        fi;
    else
        if IsComplexOfFinitelyPresentedObjectsRep( CertainObject( o, degrees[1] ) ) then
            Print( " complex" );
        else
            Print( " cocomplex" );
        fi;
        if l > 1 then
            Print( "es" );
        fi;
    fi;
    
    Print( " at degree" );
    
    if l = 1 then
        Print( " ", degrees[1] );
    else
        Print( "s ", degrees );
    fi;
    
    Print( ">" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsZero ],
        
  function( o )
    
    Print( "<A zero " );
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
        Print( "left" );
    else
        Print( "right" );
    fi;
    
    Print( " complex>" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and IsZero ],
        
  function( o )
    
    Print( "<A zero " );
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
        Print( "left" );
    else
        Print( "right" );
    fi;
    
    Print( " cocomplex>" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep ],
        
  function( o )
    local i, degrees;
    
    degrees := ObjectDegreesOfComplex( o );
    
    Print( "-------------------------\n" );
    Print( "at homology degree: ", degrees[1], "\n" );
    Display( CertainObject( o, degrees[1] ) );
    
    for i in degrees{[ 2 .. Length( degrees ) ]} do
        Print( "------------^------------\n" );
        Display( CertainMorphism( o, i ) );
        Print( "------------^------------\n" );
        Print( "at homology degree: ", i, "\n" );
        Display( CertainObject( o, i ) );
    od;
    
    Print( "-------------------------\n" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep ],
        
  function( o )
    local i, degrees, l;
    
    degrees := ObjectDegreesOfComplex( o );
    
    l := Length( degrees );
    
    Print( "-------------------------\n" );
    
    for i in degrees{[ 1 .. l - 1 ]} do
        Print( "at cohomology degree: ", i, "\n" );
        Display( CertainObject( o, i ) );
        Print( "------------v------------\n" );
        Display( CertainMorphism( o, i ) );
        Print( "------------v------------\n" );
    od;
    
    Print( "at cohomology degree: ", degrees[l], "\n" );
    Display( CertainObject( o, degrees[l] ) );
    Print( "-------------------------\n" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsGradedObject ],
        
  function( o )
    local i;
    
    for i in ObjectDegreesOfComplex( o ) do
        Print( "-------------------------\n" );
        Print( "at homology degree: ", i, "\n" );
        Display( CertainObject( o, i ) );
    od;
    
    Print( "-------------------------\n" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and IsGradedObject ],
        
  function( o )
    local i;
    
    for i in ObjectDegreesOfComplex( o ) do
        Print( "---------------------------\n" );
        Print( "at cohomology degree: ", i, "\n" );
        Display( CertainObject( o, i ) );
    od;
    
    Print( "-------------------------\n" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsComplexOfFinitelyPresentedObjectsRep and IsZero ],
        
  function( o )
    
    Print( "0\n" );
    
end );

##
InstallMethod( Display,
        "for homalg complexes",
        [ IsCocomplexOfFinitelyPresentedObjectsRep and IsZero ],
        
  function( o )
    
    Print( "0\n" );
    
end );


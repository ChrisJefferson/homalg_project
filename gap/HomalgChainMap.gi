#############################################################################
##
##  HomalgChainMap.gi           homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg chain maps.
##
#############################################################################

####################################
#
# representations:
#
####################################

# two new representations for the GAP-category IsHomalgChainMap
# which are subrepresentations of the representation IsMorphismOfFinitelyGeneratedModulesRep:
DeclareRepresentation( "IsChainMapOfFinitelyPresentedObjectsRep",
        IsHomalgChainMap and IsMorphismOfFinitelyGeneratedModulesRep,
        [  ] );

DeclareRepresentation( "IsCochainMapOfFinitelyPresentedObjectsRep",
        IsHomalgChainMap and IsMorphismOfFinitelyGeneratedModulesRep,
        [  ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgChainMaps",
        NewFamily( "TheFamilyOfHomalgChainMaps" ) );

# eight new types:
BindGlobal( "TheTypeHomalgChainMapOfLeftObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsChainMapOfFinitelyPresentedObjectsRep and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgChainMapOfRightObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsChainMapOfFinitelyPresentedObjectsRep and IsHomalgRightObjectOrMorphismOfRightObjects ) );

BindGlobal( "TheTypeHomalgCochainMapOfLeftObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsCochainMapOfFinitelyPresentedObjectsRep and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgCochainMapOfRightObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsCochainMapOfFinitelyPresentedObjectsRep and IsHomalgRightObjectOrMorphismOfRightObjects ) );

BindGlobal( "TheTypeHomalgChainSelfMapOfLeftObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsChainMapOfFinitelyPresentedObjectsRep and IsHomalgChainSelfMap and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgChainSelfMapOfRightObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsChainMapOfFinitelyPresentedObjectsRep and IsHomalgChainSelfMap and IsHomalgRightObjectOrMorphismOfRightObjects ) );

BindGlobal( "TheTypeHomalgCochainSelfMapOfLeftObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsCochainMapOfFinitelyPresentedObjectsRep and IsHomalgChainSelfMap and IsHomalgLeftObjectOrMorphismOfLeftObjects ) );

BindGlobal( "TheTypeHomalgCochainSelfMapOfRightObjects",
        NewType( TheFamilyOfHomalgChainMaps,
                IsCochainMapOfFinitelyPresentedObjectsRep and IsHomalgChainSelfMap and IsHomalgRightObjectOrMorphismOfRightObjects ) );

####################################
#
# methods for properties:
#
####################################

##
InstallMethod( IsZero,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local morphisms;
    
    morphisms := MorphismsOfChainMap( cm );
    
    return ForAll( morphisms, IsZero );
    
end );

##
InstallMethod( IsMorphism,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local degrees, l, S, T;
    
    if not IsComplex( Source( cm ) ) then
        return false;
    elif not IsComplex( Range( cm ) ) then
        return false;
    fi;
    
    degrees := DegreesOfChainMap( cm );
    
    l := Length( degrees );
    
    degrees := degrees{[ 1 .. l - 1 ]};
    
    S := Source( cm );
    T := Range( cm );
    
    if l = 1 then
        if Length( ObjectDegreesOfComplex( S ) ) = 1 then
            return true;
        else
            Error( "not implemented for chain maps containing as single morphism\n" );
        fi;
    elif IsChainMapOfFinitelyPresentedObjectsRep( cm ) and IsHomalgLeftObjectOrMorphismOfLeftObjects( cm ) then
        return ForAll( degrees, i -> CertainMorphism( cm, i + 1 ) * CertainMorphism( T, i + 1 ) = CertainMorphism( S, i + 1 ) * CertainMorphism( cm, i ) );
    elif IsCochainMapOfFinitelyPresentedObjectsRep( cm ) and IsHomalgRightObjectOrMorphismOfRightObjects( cm ) then
        return ForAll( degrees, i -> CertainMorphism( T, i ) * CertainMorphism( cm, i ) = CertainMorphism( cm, i + 1 ) * CertainMorphism( S, i ) );
    elif IsChainMapOfFinitelyPresentedObjectsRep( cm ) and IsHomalgRightObjectOrMorphismOfRightObjects( cm ) then
        return ForAll( degrees, i -> CertainMorphism( T, i + 1 ) * CertainMorphism( cm, i + 1 ) = CertainMorphism( cm, i ) * CertainMorphism( S, i + 1 ) );
    else
        return ForAll( degrees, i -> CertainMorphism( cm, i ) * CertainMorphism( T, i ) = CertainMorphism( S, i ) * CertainMorphism( cm, i + 1 ) );
    fi;
    
end );

##
InstallMethod( IsMonomorphism,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return IsMorphism( cm ) and ForAll( MorphismsOfChainMap( cm ), IsMonomorphism );	## not true for split monomorphisms
    
end );

##
InstallMethod( IsEpimorphism,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return IsMorphism( cm ) and ForAll( MorphismsOfChainMap( cm ), IsEpimorphism );	## not true for split epimorphisms
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgRing,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return HomalgRing( Source( cm ) );
    
end );

##
InstallMethod( PositionOfTheDefaultSetOfRelations,
        "for homalg maps",
        [ IsHomalgChainMap ],
        
  function( M )
    
    return fail;
    
end );

##
InstallMethod( DegreesOfChainMap,		## this might differ from ObjectDegreesOfComplex( Source( cm ) ) when the chain map is not full
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return cm!.degrees;
    
end );

##
InstallMethod( ObjectDegreesOfComplex,		## this is not a mistake
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return ObjectDegreesOfComplex( Source( cm ) );
    
end );

##
InstallMethod( MorphismDegreesOfComplex,	## this is not a mistake
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return MorphismDegreesOfComplex( Source( cm ) );
    
end );

##
InstallMethod( CertainMorphism,
        "for homalg chain maps",
        [ IsHomalgChainMap, IsInt ],
        
  function( cm, i )
    
    if IsBound( cm!.(String( i )) ) and IsHomalgMorphism( cm!.(String( i )) ) then
        return cm!.(String( i ));
    fi;
    
    return fail;
    
end );

##
InstallMethod( MorphismsOfChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local degrees;
    
    degrees := DegreesOfChainMap( cm );
    
    return List( degrees, i -> CertainMorphism( cm, i ) );
    
end );

##
InstallMethod( LowestDegreeInChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return DegreesOfChainMap( cm )[1];
    
end );

##
InstallMethod( HighestDegreeInChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local degrees;
    
    degrees := DegreesOfChainMap( cm );
    
    return degrees[Length( degrees )];
    
end );

##
InstallMethod( LowestDegreeMorphismInChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return CertainMorphism( cm, LowestDegreeInChainMap( cm ) );
    
end );

##
InstallMethod( HighestDegreeMorphismInChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    
    return CertainMorphism( cm, HighestDegreeInChainMap( cm ) );
    
end );

##
InstallMethod( SupportOfChainMap,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local degrees, morphisms, l;
    
    degrees := DegreesOfChainMap( cm );
    morphisms := MorphismsOfChainMap( cm );
    
    l := Length( degrees );
    
    return degrees{ Filtered( [ 1 .. l ], i -> not IsZero( morphisms[i] ) ) };
    
end );

##
InstallMethod( Add,
        "for homalg chain maps",
        [ IsHomalgChainMap, IsMorphismOfFinitelyGeneratedModulesRep ],
        
  function( cm, phi )
    local d, degrees, l;
    
    if HasIsChainMapForPullback( cm ) and IsChainMapForPullback( cm ) then
        Error( "this chain map is write-protected since IsChainMapForPullback = true\n" );
    elif HasIsChainMapForPushout( cm ) and IsChainMapForPushout( cm ) then
        Error( "this chain map is write-protected since IsChainMapForPushout = true\n" );
    elif HasIsKernelSquare( cm ) and IsKernelSquare( cm ) then
        Error( "this chain map is write-protected since IsKernelSquare = true\n" );
    elif HasIsImageSquare( cm ) and IsImageSquare( cm ) then
        Error( "this chain map is write-protected since IsImageSquare = true\n" );
    elif HasIsLambekPairOfSquares( cm ) and IsLambekPairOfSquares( cm ) then
        Error( "this chain map is write-protected since IsLambekPairOfSquares = true\n" );
    fi;
    
    d := DegreeOfMorphism( cm );
    
    degrees := DegreesOfChainMap( cm );
    
    l := Length( degrees );
    
    l := degrees[l] + 1;
    
    if not l in ObjectDegreesOfComplex( cm ) then
        Error( "there is no module in the source complex with index ", l, "\n" );
    fi;
    
    if CertainObject( Source( cm ), l ) <> Source( phi ) then
        Error( "the ", l, ". module of the source complex in the chain map and the source of the new morphism are not the same object\n" );
    elif CertainObject( Range( cm ), l + d ) <> Range( phi ) then
        Error( "the ", l, ". module of the target complex in the chain map and the target of the new morphism are not the same object\n" );
    fi;
    
    Add( degrees, l );
    
    cm!.(String( l )) := phi;
    
    ConvertToRangeRep( cm!.degrees );
    
    homalgResetFilters( cm );
    
    return cm;
    
end );

##
InstallMethod( AreComparableMorphisms,
        "for homalg chain maps",
        [ IsHomalgChainMap, IsHomalgChainMap ],
        
  function( phi1, phi2 )
    
    return Source( phi1 ) = Source( phi2 ) and
           Range( phi1 ) = Range( phi2 ) and
           DegreeOfMorphism( phi1 ) = DegreeOfMorphism( phi2 );;
    
end );

##
InstallMethod( AreComposableMorphisms,
        "for homalg chain maps",
        [ IsHomalgChainMap and IsHomalgLeftObjectOrMorphismOfLeftObjects,
          IsHomalgChainMap and IsHomalgLeftObjectOrMorphismOfLeftObjects ],
        
  function( phi1, phi2 )
    
    return Range( phi1 ) = Source( phi2 );
    
end );

##
InstallMethod( AreComposableMorphisms,
        "for homalg chain maps",
        [ IsHomalgChainMap and IsHomalgRightObjectOrMorphismOfRightObjects,
          IsHomalgChainMap and IsHomalgRightObjectOrMorphismOfRightObjects ],
        
  function( phi2, phi1 )
    
    return Range( phi1 ) = Source( phi2 );
    
end );

##
InstallMethod( \=,
        "for two comparable homalg chain maps",
        [ IsHomalgChainMap, IsHomalgChainMap ],
        
  function( phi1, phi2 )
    local morphisms1, morphisms2;
    
    if not AreComparableMorphisms( phi1, phi2 ) then
        return false;
    fi;
    
    morphisms1 := MorphismsOfChainMap( phi1 );
    morphisms2 := MorphismsOfChainMap( phi2 );
    
    return ForAll( [ 1 .. Length( morphisms1 ) ], i -> morphisms1[i] = morphisms2[i] );
    
end );

##
InstallMethod( ZeroMutable,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    local degree, S, T, degrees, morphisms, zeta, i;
    
    degree := DegreeOfMorphism( phi );
    
    S := Source( phi );
    T := Range( phi );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms := MorphismsOfChainMap( phi );
    
    zeta := HomalgChainMap( 0 * morphisms[1], S, T, [ degrees[1], degree ] );
    
    for i in [ 2 .. Length( morphisms ) ] do
        Add( zeta, 0 * morphisms[i] );
    od;
    
    return zeta;
    
end );

##
InstallMethod( \*,
        "of two homalg chain maps",
        [ IsRingElement, IsHomalgChainMap ], 1001, ## it could otherwise run into the method ``PROD: negative integer * additive element with inverse'', value: 24
        
  function( a, phi )
    local degree, S, T, degrees, morphisms, psi, i;
    
    degree := DegreeOfMorphism( phi );
    
    S := Source( phi );
    T := Range( phi );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms := MorphismsOfChainMap( phi );
    
    psi := HomalgChainMap( a * morphisms[1], S, T, [ degrees[1], degree ] );
    
    for i in [ 2 .. Length( morphisms ) ] do
        Add( psi, a * morphisms[i] );
    od;
    
    if IsUnit( HomalgRing( phi ), a ) then
        if HasIsIsomorphism( phi ) and IsIsomorphism( phi ) then
            SetIsIsomorphism( psi, true );
        else
            if HasIsSplitMonomorphism( phi ) and IsSplitMonomorphism( phi ) then
                SetIsSplitMonomorphism( psi, true );
            elif HasIsMonomorphism( phi ) and IsMonomorphism( phi ) then
                SetIsMonomorphism( psi, true );
            fi;
            
            if HasIsSplitEpimorphism( phi ) and IsSplitEpimorphism( phi ) then
                SetIsSplitEpimorphism( psi, true );
            elif HasIsEpimorphism( phi ) and IsEpimorphism( phi ) then
                SetIsEpimorphism( psi, true );
            elif HasIsMorphism( phi ) and IsMorphism( phi ) then
                SetIsMorphism( psi, true );
            fi;
        fi;
    elif HasIsMorphism( phi ) and IsMorphism( phi ) then
        SetIsMorphism( psi, true );
    fi;
    
    return psi;
    
end );

##
InstallMethod( \+,
        "of two homalg chain maps",
        [ IsHomalgChainMap, IsHomalgChainMap ],
        
  function( phi1, phi2 )
    local degree, S, T, degrees, morphisms1, morphisms2, psi, i;
    
    if not AreComparableMorphisms( phi1, phi2 ) then
        return Error( "the two chain maps are not comparable" );
    fi;
    
    degree := DegreeOfMorphism( phi1 );
    
    S := Source( phi1 );
    T := Range( phi1 );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms1 := MorphismsOfChainMap( phi1 );
    morphisms2 := MorphismsOfChainMap( phi2 );
    
    psi := HomalgChainMap( morphisms1[1] + morphisms2[1], S, T, [ degrees[1], degree ] );
    
    for i in [ 2 .. Length( morphisms1 ) ] do
        Add( psi, morphisms1[i] + morphisms2[i] );
    od;
    
    if HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
       HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( psi, true );
    fi;
    
    return psi;
    
end );

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseMutable,
        "of homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    
    return MinusOne( HomalgRing( phi ) ) * phi;
    
end );

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseMutable,
        "of homalg chain maps",
        [ IsHomalgChainMap and IsZero ],
        
  function( phi )
    
    return phi;
    
end );

##
InstallMethod( \-,
        "of two homalg chain maps",
        [ IsHomalgChainMap, IsHomalgChainMap ],
        
  function( phi1, phi2 )
    local degree, S, T, degrees, morphisms1, morphisms2, psi, i;
    
    if not AreComparableMorphisms( phi1, phi2 ) then
        return Error( "the two chain maps are not comparable" );
    fi;
    
    degree := DegreeOfMorphism( phi1 );
    
    S := Source( phi1 );
    T := Range( phi1 );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms1 := MorphismsOfChainMap( phi1 );
    morphisms2 := MorphismsOfChainMap( phi2 );
    
    psi := HomalgChainMap( morphisms1[1] - morphisms2[1], S, T, [ degrees[1], degree ] );
    
    for i in [ 2 .. Length( morphisms1 ) ] do
        Add( psi, morphisms1[i] - morphisms2[i] );
    od;
    
    if HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
       HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( psi, true );
    fi;
    
    return psi;
    
end );

##
InstallMethod( \*,
        "of two homalg chain maps",
        [ IsHomalgChainMap and IsHomalgLeftObjectOrMorphismOfLeftObjects,
          IsHomalgChainMap and IsHomalgLeftObjectOrMorphismOfLeftObjects ],
        
  function( phi1, phi2 )
    local degree1, degree2, S, T, degrees, morphisms1, morphisms2, psi, i;
    
    
    if not AreComposableMorphisms( phi1, phi2 ) then
        Error( "the two chain maps are not composable, since the target of the left one and the source of right one are not equal\n" );
    fi;
    
    degree1 := DegreeOfMorphism( phi1 );
    degree2 := DegreeOfMorphism( phi2 );
    
    S := Source( phi1 );
    T := Range( phi2 );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms1 := MorphismsOfChainMap( phi1 );
    morphisms2 := MorphismsOfChainMap( phi2 );
    
    psi := HomalgChainMap( morphisms1[1] * morphisms2[1], S, T, [ degrees[1], degree1 + degree2 ] );
    
    for i in [ 2 .. Length( morphisms1 ) ] do
        Add( psi, morphisms1[i] * morphisms2[i] );
    od;
    
    if HasIsMonomorphism( phi1 ) and IsMonomorphism( phi1 ) and
       HasIsMonomorphism( phi2 ) and IsMonomorphism( phi2 ) then
        SetIsMonomorphism( psi, true );
    fi;
    
    ## cannot use elif here:
    if HasIsEpimorphism( phi1 ) and IsEpimorphism( phi1 ) and
       HasIsEpimorphism( phi2 ) and IsEpimorphism( phi2 ) then
        SetIsEpimorphism( psi, true );
    elif HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
      HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( psi, true );
    fi;
    
    return psi;
    
end );

##
InstallMethod( \*,
        "of two homalg chain maps",
        [ IsHomalgChainMap and IsHomalgRightObjectOrMorphismOfRightObjects,
          IsHomalgChainMap and IsHomalgRightObjectOrMorphismOfRightObjects ],
        
  function( phi2, phi1 )
    local degree1, degree2, S, T, degrees, morphisms1, morphisms2, psi, i;
    
    
    if not AreComposableMorphisms( phi2, phi1 ) then
        Error( "the two chain maps are not composable, since the target of the left one and the source of right one are not equal\n" );
    fi;
    
    degree1 := DegreeOfMorphism( phi1 );
    degree2 := DegreeOfMorphism( phi2 );
    
    S := Source( phi1 );
    T := Range( phi2 );
    
    degrees := ObjectDegreesOfComplex( S );
    
    morphisms1 := MorphismsOfChainMap( phi1 );
    morphisms2 := MorphismsOfChainMap( phi2 );
    
    psi := HomalgChainMap( morphisms2[1] * morphisms1[1], S, T, [ degrees[1], degree1 + degree2 ] );
    
    for i in [ 2 .. Length( morphisms1 ) ] do
        Add( psi, morphisms2[i] * morphisms1[i] );
    od;
    
    if HasIsMonomorphism( phi1 ) and IsMonomorphism( phi1 ) and
       HasIsMonomorphism( phi2 ) and IsMonomorphism( phi2 ) then
        SetIsMonomorphism( psi, true );
    fi;
    
    ## cannot use elif here:
    if HasIsEpimorphism( phi1 ) and IsEpimorphism( phi1 ) and
       HasIsEpimorphism( phi2 ) and IsEpimorphism( phi2 ) then
        SetIsEpimorphism( psi, true );
    elif HasIsMorphism( phi1 ) and IsMorphism( phi1 ) and
      HasIsMorphism( phi2 ) and IsMorphism( phi2 ) then
        SetIsMorphism( psi, true );
    fi;
    
    return psi;
    
end );

##
InstallMethod( OnLessGenerators,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    
    OnLessGenerators( Source( phi ) );
    OnLessGenerators( Range( phi ) );
    
    return phi;
    
end );

##
InstallMethod( BasisOfModule,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    
    BasisOfModule( Source( phi ) );
    BasisOfModule( Range( phi ) );
    
    return phi;
    
end );

##
InstallMethod( DecideZero,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    
    DecideZero( Source( phi ) );
    DecideZero( Range( phi ) );
    
    List( MorphismsOfChainMap( phi ), DecideZero );
    
    return phi;
    
end );

##
InstallMethod( ByASmallerPresentation,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( phi )
    
    ByASmallerPresentation( Source( phi ) );
    ByASmallerPresentation( Range( phi ) );
    
    List( MorphismsOfChainMap( phi ), DecideZero );
    
    return phi;
    
end );

##
InstallMethod( CertainMorphismAsKernelSquare,
        "for homalg chain maps",
        [ IsHomalgChainMap, IsInt ],
        
  function( cm, i )
    local degree, phi, S, T, sub;
    
    degree := DegreeOfMorphism( cm );
    
    phi := CertainMorphism( cm, i );
    
    S := CertainMorphismAsSubcomplex( Source( cm ), i );
    T := CertainMorphismAsSubcomplex( Range( cm ), i );
    
    sub := HomalgChainMap( phi, S, T, [ i, degree ] );
    
    if HasIsMorphism( cm ) and IsMorphism( cm ) then
        SetIsMorphism( sub, true );
    fi;
    
    SetIsKernelSquare( sub, true );
    
    return sub;
    
end );

##
InstallMethod( CertainMorphismAsImageSquare,
        "for homalg chain maps",
        [ IsChainMapOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( cm, i )
    local degree, phi, S, T, sub;
    
    degree := DegreeOfMorphism( cm );
    
    phi := CertainMorphism( cm, i );
    
    S := CertainMorphismAsSubcomplex( Source( cm ), i + 1 );
    T := CertainMorphismAsSubcomplex( Range( cm ), i + 1 );
    
    sub := HomalgChainMap( phi, S, T, [ i, degree ] );
    
    if HasIsMorphism( cm ) and IsMorphism( cm ) then
        SetIsMorphism( sub, true );
    fi;
    
    SetIsImageSquare( sub, true );
    
    return sub;
    
end );

##
InstallMethod( CertainMorphismAsImageSquare,
        "for homalg chain maps",
        [ IsCochainMapOfFinitelyPresentedObjectsRep, IsInt ],
        
  function( cm, i )
    local degree, phi, S, T, sub;
    
    degree := DegreeOfMorphism( cm );
    
    phi := CertainMorphism( cm, i );
    
    S := CertainMorphismAsSubcomplex( Source( cm ), i - 1 );
    T := CertainMorphismAsSubcomplex( Range( cm ), i - 1 );
    
    sub := HomalgChainMap( phi, S, T, [ i, degree ] );
    
    if HasIsMorphism( cm ) and IsMorphism( cm ) then
        SetIsMorphism( sub, true );
    fi;
    
    SetIsImageSquare( sub, true );
    
    return sub;
    
end );

##
InstallMethod( CertainMorphismAsLambekPairOfSquares,
        "for homalg chain maps",
        [ IsHomalgChainMap, IsInt ],
        
  function( cm, i )
    local degree, phi, S, T, sub;
    
    degree := DegreeOfMorphism( cm );
    
    phi := CertainMorphism( cm, i );
    
    S := CertainTwoMorphismsAsSubcomplex( Source( cm ), i );
    T := CertainTwoMorphismsAsSubcomplex( Range( cm ), i );
    
    sub := HomalgChainMap( phi, S, T, [ i, degree ] );
    
    if HasIsMorphism( cm ) and IsMorphism( cm ) then
        SetIsMorphism( sub, true );
    fi;
    
    SetIsLambekPairOfSquares( sub, true );
    
    return sub;
    
end );

####################################
#
# global functions:
#
####################################

##
InstallMethod( homalgResetFilters,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( cm )
    local property;
    
    if not IsBound( HOMALG.PropertiesOfChainMaps ) then
        HOMALG.PropertiesOfChainMaps :=
          [ IsZero,
            IsMorphism,
            IsGradedMorphism,
            IsSplitMonomorphism,
            IsMonomorphism,
            IsSplitEpimorphism,
            IsEpimorphism,
            IsIsomorphism,
            IsQuasiIsomorphism,
            IsImageSquare,
            IsKernelSquare,
            IsLambekPairOfSquares ];
    fi;
    
    for property in HOMALG.PropertiesOfChainMaps do
        ResetFilterObj( cm, property );
    od;
    
end );

####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( HomalgChainMap,
  function( arg )
    local nargs, morphism, left, source, target, degrees, degree,
          chainmap, type, cm;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "empty input\n" );
    fi;
    
    if nargs > 0 and IsMorphismOfFinitelyGeneratedModulesRep( arg[1] ) then
        left := IsHomalgLeftObjectOrMorphismOfLeftObjects( arg[1] );
    else
        Error( "the first argument must be a morphism" );
    fi;
    
    morphism := arg[1];
    
    if nargs > 1 and IsHomalgComplex( arg[2] ) then
        if not IsBound( left ) then
            left := IsHomalgLeftObjectOrMorphismOfLeftObjects( arg[2] );
        fi;
        source := arg[2];
    fi;
    
    if nargs > 2 and IsHomalgComplex( arg[3] ) then
        if ( IsHomalgRightObjectOrMorphismOfRightObjects( arg[3] ) and left ) or
           ( IsHomalgLeftObjectOrMorphismOfLeftObjects( arg[3] ) and not left ) then
            Error( "the two complexes must either be both left or both right complexes\n" );
        fi;
        target := arg[3];
    else
        target := source;
    fi;
    
    if IsInt( arg[nargs] ) then
        degrees := [ arg[nargs] ];
        degree := 0;
    elif IsList( arg[nargs] ) and Length( arg[nargs] ) = 2 and ForAll( arg[nargs], IsInt ) then
        degrees := [ arg[nargs][1] ];
        degree := arg[nargs][2];
    else
        degrees := [ ObjectDegreesOfComplex( source )[1] ];
        degree := 0;
    fi;
    
    if IsHomalgMap( morphism ) then
        if not IsIdenticalObj( Source( morphism ), CertainObject( source, degrees[1] ) ) then
            Error( "the map and the source complex do not match\n" );
        elif not IsIdenticalObj( Range( morphism ), CertainObject( target, degrees[1] + degree ) ) then
            Error( "the map and the target complex do not match\n" );
        fi;
    else
        if Source( morphism ) <> CertainObject( source, degrees[1] ) then
            Error( "the chain map and the source complex do not match\n" );
        elif Range( morphism ) <> CertainObject( target, degrees[1] ) then
            Error( "the chain map and the target complex do not match\n" );
        fi;
    fi;
    
    ConvertToRangeRep( degrees );
    
    cm := rec( degrees := degrees );
    
    cm.(String( degrees[1] )) := morphism;
    
    if IsComplexOfFinitelyPresentedObjectsRep( source ) and
       IsComplexOfFinitelyPresentedObjectsRep( target ) then
        chainmap := true;
    elif IsCocomplexOfFinitelyPresentedObjectsRep( source ) and
      IsCocomplexOfFinitelyPresentedObjectsRep( target ) then
        chainmap := false;
    else
        Error( "source and target must either be both complexes or both cocomplexes\n" );
    fi;
    
    if source = target then
        if chainmap then
            if left then
                type := TheTypeHomalgChainSelfMapOfLeftObjects;
            else
                type := TheTypeHomalgChainSelfMapOfRightObjects;
            fi;
        else
            if left then
                type := TheTypeHomalgCochainSelfMapOfLeftObjects;
            else
                type := TheTypeHomalgCochainSelfMapOfRightObjects;
            fi;
        fi;
    else
        if chainmap then
            if left then
                type := TheTypeHomalgChainMapOfLeftObjects;
            else
                type := TheTypeHomalgChainMapOfRightObjects;
            fi;
        else
            if left then
                type := TheTypeHomalgCochainMapOfLeftObjects;
            else
                type := TheTypeHomalgCochainMapOfRightObjects;
            fi;
        fi;
    fi;
    
    ## Objectify
    ObjectifyWithAttributes(
            cm, type,
            Source, source,
            Range, target,
            DegreeOfMorphism, degree
            );
    
    return cm;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg chain maps",
        [ IsHomalgChainMap ],
        
  function( o )
    local degrees, l;
    
    Print( "<A" );
    
    if HasIsZero( o ) then
        if IsZero ( o ) then
            Print( " zero" );
        else
            Print( " non-zero" );
        fi;
    fi;
    
    if HasIsMorphism( o ) then
        if IsMorphism( o ) then
            if IsChainMapOfFinitelyPresentedObjectsRep( o ) then
                Print( " chain map" );
            else
                Print( " cochain map" );
            fi;
        else
            if IsChainMapOfFinitelyPresentedObjectsRep( o ) then
                Print( " non-chain map" );
            else
                Print( " non-cochain map" );
            fi;
        fi;
    else
        if IsChainMapOfFinitelyPresentedObjectsRep( o ) then
            Print( " \"chain map\"" );
        else
            Print( " \"cochain map\"" );
        fi;
    fi;
    
    if HasIsGradedMorphism( o ) and IsGradedMorphism( o ) then
        Print( " of graded objects" );
    fi;
    
    if HasDegreeOfMorphism( o ) and DegreeOfMorphism( o ) <> 0 then
        Print( " of degree ", DegreeOfMorphism( o ) );
    fi;
    
    Print( " containing " );
    
    degrees := DegreesOfChainMap( o );
    
    l := Length( degrees );
    
    if l = 1 then
        
        Print( "a single " );
        
        if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
            Print( "left" );
        else
            Print( "right" );
        fi;
        
        Print( " morphism at degree ", degrees[1], ">" );
        
    else
        
        Print( l, " morphisms" );
        
        Print( " of " );
        
        if IsHomalgLeftObjectOrMorphismOfLeftObjects( o ) then
            Print( "left" );
        else
            Print( "right" );
        fi;
        
        Print( " modules at degrees ", degrees, ">" );
        
    fi;
    
end );

##
InstallMethod( Display,
        "for homalg chain maps",
        [ IsChainMapOfFinitelyPresentedObjectsRep ],
        
  function( o )
    local i;
    
    for i in DegreesOfChainMap( o ) do
        Print( "-------------------------\n" );
        Print( "at homology degree: ", i, "\n" );
        Display( CertainMorphism( o, i ) );
    od;
    
    Print( "-------------------------\n" );
    
end );

##
InstallMethod( Display,
        "for homalg chain maps",
        [ IsCochainMapOfFinitelyPresentedObjectsRep ],
        
  function( o )
    local i;
    
    for i in DegreesOfChainMap( o ) do
        Print( "---------------------------\n" );
        Print( "at cohomology degree: ", i, "\n" );
        Display( CertainMorphism( o, i ) );
    od;
    
    Print( "-------------------------\n" );
    
end );


#############################################################################
##
##  HomalgRing.gi               homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg rings.
##
#############################################################################

####################################
#
# representations:
#
####################################

# two new representations for the GAP-category IsHomalgRing
# which are subrepresentations of IsHomalgRingOrFinitelyPresentedModuleRep:

##  <#GAPDoc Label="IsHomalgInternalRingRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="R" Name="IsHomalgInternalRingRep"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The internal representation of &homalg; rings. <Br/><Br/>
##      (It is a subrepresentation of the &GAP; representation <Br/>
##      <C>IsHomalgRingOrFinitelyPresentedModuleRep</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgInternalRingRep",
        IsHomalgRing and IsHomalgRingOrFinitelyPresentedModuleRep,
        [ "ring", "homalgTable" ] );

##  <#GAPDoc Label="IsHomalgExternalRingRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="R" Name="IsHomalgExternalRingRep"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The external representation of &homalg; rings. <Br/><Br/>
##      (It is a subrepresentation of the &GAP; representation <Br/>
##      <C>IsHomalgRingOrFinitelyPresentedModuleRep</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgExternalRingRep",
        IsHomalgRing and IsHomalgRingOrFinitelyPresentedModuleRep,
        [ "ring", "homalgTable" ] );

##  <#GAPDoc Label="IsHomalgExternalRingElementRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="r" Name="IsHomalgExternalRingElementRep"/>
##    <Returns>true or false</Returns>
##    <Description>
##      The representation of elements of external &homalg; rings. <P/>
##      (It is a representation of the &GAP; category <Ref Filt="IsHomalgRingElement"/>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgExternalRingElementRep",
        IshomalgExternalObjectRep and IsHomalgRingElement,
        [ "pointer", "cas" ] );

# a new subrepresentation of the representation IsContainerForWeakPointersRep:
DeclareRepresentation( "IsContainerForWeakPointersOnHomalgExternalRingsRep",
        IsContainerForWeakPointersRep,
        [ "weak_pointers", "streams", "counter", "deleted" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgRings",
        NewFamily( "TheFamilyOfHomalgRings" ) );

# two new types:
BindGlobal( "TheTypeHomalgInternalRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgInternalRingRep ) );

BindGlobal( "TheTypeHomalgExternalRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalRingRep ) );

# a new family:
BindGlobal( "TheFamilyOfHomalgRingElements",
        NewFamily( "TheFamilyOfHomalgRingElements" ) );

# two new types:
BindGlobal( "TheTypeHomalgExternalRingElement",
        NewType( TheFamilyOfHomalgRingElements,
                IsHomalgExternalRingElementRep ) );

BindGlobal( "TheTypeHomalgExternalRingElementWithIOStream",
        NewType( TheFamilyOfHomalgRingElements,
                IshomalgExternalObjectWithIOStreamRep and IsHomalgExternalRingElementRep ) );

# a new family:
BindGlobal( "TheFamilyOfContainersForWeakPointersOnHomalgExternalRings",
        NewFamily( "TheFamilyOfContainersForWeakPointersOnHomalgExternalRings" ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnHomalgExternalRings",
        NewType( TheFamilyOfContainersForWeakPointersOnHomalgExternalRings,
                IsContainerForWeakPointersOnHomalgExternalRingsRep ) );

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( Zero,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( R )
    
    return Zero( R!.ring );
    
end );

##
InstallMethod( One,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( R )
    
    return One( R!.ring );
    
end );

##
InstallMethod( MinusOne,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( R )
    
    return -One( R!.ring );
    
end );

##
InstallMethod( ZeroMutable,
        "for homalg rings",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return Zero( HomalgRing( r ) );
    
end );

##
InstallMethod( OneMutable,
        "for homalg rings",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return One( HomalgRing( r ) );
    
end );

##
InstallMethod( MinusOneMutable,
        "for homalg rings",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return MinusOne( HomalgRing( r ) );
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgRing,
        "for external homalg ring elements",
        [ IsHomalgRing ],
        
  function( R )
    
    return R;
    
end );

##
InstallMethod( HomalgRing,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return fail;
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfPolynomialRing ],
        
  function( R )
    
    return IndeterminatesOfPolynomialRing( R );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfExteriorRing ],
        
  function( R )
    
    return IndeterminatesOfExteriorRing( R );
    
end );

InstallMethod( Indeterminate,
        "for homalg rings",
        [ IsHomalgRing, IsPosInt ],
        
  function( R, i )
    
    return Indeterminates( R )[i];
    
end );

##
InstallMethod( PositionOfTheDefaultSetOfRelations,	## provided to avoid branching in the code and always returns fail
        "for ring elements",
        [ IsRingElement ],
        
  function( r )
    
    return fail;
    
end );

##
InstallMethod( \=,
        "for homalg external objects",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( r1, r2 )
    
    return IsZero( r1 - r2 );
    
end );

##
InstallMethod( RingName,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local RP, c, v, r;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.RingName) then
        if IsFunction( RP!.RingName ) then
            return RP!.RingName( R );
        else
            return RP!.RingName;
        fi;
    elif HasName( R ) then
        return Name( R );
    elif HasCharacteristic( R ) then
        
        c := Characteristic( R );
        
        if HasIndeterminatesOfPolynomialRing( R ) then
            v := IndeterminatesOfPolynomialRing( R );
            if ForAll( v, HasName ) then
                v := List( v, Name );
            elif Length( v ) = 1 then
                v := [ "x" ];
            else
                v := List( [ 1 .. Length( v ) ], i -> Flat( [ "x", String( i ) ] ) );
            fi;
            v := JoinStringsWithSeparator( v );
            if IsPrime( c ) then
                return Flat( [ "GF(", String( c ), ")[", v, "]" ] );
            elif c = 0 then
                r := CoefficientsRing( R );
                if HasIsIntegersForHomalg( r ) and IsIntegersForHomalg( r ) then
                    return Flat( [ "Z[", v, "]" ] );
                elif HasIsFieldForHomalg( r ) and IsFieldForHomalg( r ) then
                    return Flat( [ "Q[", v, "]" ] );
                fi;
            fi;
        elif c = 0 then
            if HasIsIntegersForHomalg( R ) and IsIntegersForHomalg( R ) then
                return "Z";
            else
                return "Q";
            fi;
        elif IsPrime( c ) then
            return Flat( [ "GF(", String( c ), ")" ] );
        else
            return Flat( [ "Z/", String( c ), "Z" ] );
        fi;
        
    fi;
    
    return "couldn't find a way to display";
        
end );

##
InstallMethod( RingName,
        "for homalg rings",
        [ IsHomalgRing and HasRingRelations ],
        
  function( R )
    local ring_rel, l, name;
    
    ring_rel := RingRelations( R );
    ring_rel := MatrixOfRelations( ring_rel );
    ring_rel := EntriesOfHomalgMatrix( ring_rel );
    
    l := Length( ring_rel );
    
    if ring_rel = [ ] then
        TryNextMethod( );
    elif IsHomalgExternalRingRep( R ) then
        ring_rel := Concatenation( Flat( List( ring_rel{[ 1 .. l - 1 ]}, a -> Concatenation( " ", Name( a ), "," ) ) ), Concatenation( " ", Name( ring_rel[l] ) ) );
    else
        ring_rel := Concatenation( Flat( List( ring_rel{[ 1 .. l - 1 ]}, a -> Concatenation( " ", String( a ), "," ) ) ), Concatenation( " ", String( ring_rel[l] ) ) );
    fi;
    
    name := RingName( AmbientRing( R ) );
    
    return Flat( [ name, "/(", ring_rel, " )" ] );
    
end );

##
InstallMethod( homalgRingStatistics,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    
    return R!.statistics;
    
end );

##
InstallMethod( IncreaseRingStatistics,
        "for homalg rings",
        [ IsHomalgRing, IsString ],
        
  function( R, s )
    
    R!.statistics.(s) := R!.statistics.(s) + 1;
    
end );

##
InstallOtherMethod( AsList,
        "for external homalg ring elements",
        [ IsHomalgInternalRingRep ],
        
  function( r )
    
    return AsList( r!.ring );
    
end );

##
InstallMethod( homalgSetName,
        "for homalg rings",
        [ IsHomalgRingElement, IsString ],
        
  function( r, name )
    
    SetName( r, name );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsHomalgRing, IsList ],
        
  function( S, R, var )
    local d;
    
    d := Length( var );
    
    SetCoefficientsRing( S, R );
    
    if HasIsFieldForHomalg( R ) and IsFieldForHomalg( R ) then
        SetCharacteristic( S, Characteristic( R ) );
    fi;
    
    SetIsCommutative( S, true );
    
    SetIndeterminatesOfPolynomialRing( S, var );
    
    if HasGlobalDimension( R ) then
        SetGlobalDimension( S, d + GlobalDimension( R ) );
    fi;
    
    if HasKrullDimension( R ) then
        SetKrullDimension( S, d + KrullDimension( R ) );
    fi;
    
    SetGeneralLinearRank( S, 1 );	## Quillen-Suslin Theorem (see [McCRob, 11.5.5]
    
    if d = 1 then			## [McCRob, 11.5.7]
        SetElementaryRank( S, 1 );
    elif d > 2 then
        SetElementaryRank( S, 2 );
    fi;
    
    SetIsIntegralDomain( S, true );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsWeylRing, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, der )
    local r, var, d;
    
    r := CoefficientsRing( R );
    
    var := IndeterminatesOfPolynomialRing( R );
    
    d := Length( var );
    
    SetCoefficientsRing( S, r );
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, false );
    
    SetIndeterminateCoordinatesOfRingOfDerivations( S, var );
    
    SetIndeterminateDerivationsOfRingOfDerivations( S, der );
    
    if HasGlobalDimension( r ) then
        SetGlobalDimension( S, d + GlobalDimension( r ) );
    fi;
    
    if HasIsFieldForHomalg( r ) and IsFieldForHomalg( r ) and Characteristic( S ) = 0 then
        SetGeneralLinearRank( S, 2 );	## [Stafford78, McCRob, 11.2.15(i)]
        SetIsSimpleRing( S, true );
    fi;
    
    if HasIsIntegralDomain( r ) and IsIntegralDomain( r ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsExteriorRing, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, anti )
    local r, d, comm, T;
    
    r := CoefficientsRing( R );
    
    d := Length( anti );
    
    SetCoefficientsRing( S, r );
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, d = 0 );
    
    SetIsAnticommutative( S, true );
    
    SetIsIntegralDomain( S, d = 0 );
    
    comm := [ ];
    
    if HasBaseRing( R ) then
        T := BaseRing( R );
        if HasIndeterminatesOfPolynomialRing( T ) then
            comm := IndeterminatesOfPolynomialRing( T );
        fi;
    fi;
    
    SetIndeterminateAntiCommutingVariablesOfExteriorRing( S, anti );
    
    SetIndeterminatesOfExteriorRing( S, Concatenation( comm, anti ) );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsResidueClassRingOfTheIntegers, IsInt ],
        
  function( R, c )
    local RP, powers;
    
    RP := homalgTable( R );
    
    SetCharacteristic( R, c );
    
    if c = 0 then
        SetIsIntegersForHomalg( R, true );
        SetContainsAField( R, false );
        SetKrullDimension( R, 1 );	## FIXME: it is not set automatically although an immediate method is installed
    elif IsPrime( c ) then
        SetIsFieldForHomalg( R, true );
        SetRingProperties( R, c );
    else
        SetIsSemiLocalRing( R, true );
        SetIsIntegralDomain( R, false );
        powers := List( Collected( FactorsInt( c ) ), a -> a[2] );
        if Set( powers ) = [ 1 ] then
            SetIsSemiSimpleRing( R, true );
        else
            SetIsRegular( R, false );
            if Length( powers ) = 1 then
                SetIsLocalRing( R, true );
            fi;
        fi;
        SetKrullDimension( R, 0 );
    fi;
    
    if HasIsIntegralDomain( R ) and IsIntegralDomain( R ) then
        if IsBound( RP!.RowRankOfMatrixOverDomain ) then
            RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
        fi;
        
        if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
            RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
        fi;
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsFieldForHomalg, IsInt ],
        
  function( R, c )
    local RP;
    
    RP := homalgTable( R );
    
    SetCharacteristic( R, c );
    
    if IsBound( RP!.RowRankOfMatrixOverDomain ) then
        RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
    fi;
    
    if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
        RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

HOMALG.ContainerForWeakPointersOnHomalgExternalRings :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnHomalgExternalRings, [ "streams", [ ] ] );

##
InstallGlobalFunction( CreateHomalgRing,
  function( arg )
    local nargs, r, statistics, homalg_ring, table, properties,
          ar, type, ring_element_constructor, c, el,
          container, weak_pointers, l, deleted, streams;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "expecting a ring as the first argument\n" );
    fi;
    
    r := arg[1];
    
    statistics := rec(
                      BasisOfRowModule := 0,
                      BasisOfColumnModule := 0,
                      BasisOfRowsCoeff := 0,
                      BasisOfColumnsCoeff := 0,
                      DecideZeroRows := 0,
                      DecideZeroColumns := 0,
                      DecideZeroRowsEffectively := 0,
                      DecideZeroColumnsEffectively := 0,
                      SyzygiesGeneratorsOfRows := 0,
                      SyzygiesGeneratorsOfColumns := 0
                      );
    
    homalg_ring := rec( ring := r, statistics := statistics );
    
    if nargs > 1 and IshomalgTable( arg[nargs] ) then
        table := arg[nargs];
    else
        table := CreateHomalgTable( r );
    fi;
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if IsFilter( ar ) then
            Add( properties, ar );
        elif not IsBound( type ) and IsType( ar ) then
            type := ar;
        elif not IsBound( ring_element_constructor ) and IsFunction( ar ) then
            ring_element_constructor := ar;
        fi;
    od;
    
    if not IsBound( type ) then
        if IsSemiringWithOneAndZero( r ) then
            type := TheTypeHomalgInternalRing;
        else
            type := TheTypeHomalgExternalRing;
        fi;
    fi;
    
    ## Objectify:
    ObjectifyWithAttributes(
            homalg_ring, type,
            homalgTable, table );
    
    if properties <> [ ] then
        for ar in properties do
            Setter( ar )( homalg_ring, true );
        od;
    fi;
    
    if IsBound( HOMALG.RingCounter ) then
        HOMALG.RingCounter := HOMALG.RingCounter + 1;
    else
        HOMALG.RingCounter := 1;
    fi;
    
    ## this has to be done before we call
    ## ring_element_constructor below
    homalg_ring!.creation_number := HOMALG.RingCounter;
    
    ## do not invoke SetRingProperties here, since I might be
    ## the first step of creating a residue class ring!
    
    ## add distinguished ring elements like 0 and 1
    ## (sometimes also -1) to the homalg table:
    if IsBound( ring_element_constructor ) then
        
        for c in NamesOfComponents( table ) do
            if IsRingElement( table!.( c ) ) then
                table!.( c ) := ring_element_constructor( table!.( c ), homalg_ring );
            fi;
        od;
        
        ## set the attribute
        SetRingElementConstructor( homalg_ring, ring_element_constructor );
        
    fi;
    
    homalg_ring!.AsLeftModule := HomalgFreeLeftModule( 1, homalg_ring );
    homalg_ring!.AsRightModule := HomalgFreeRightModule( 1, homalg_ring );
    
    homalg_ring!.AsLeftModule!.distinguished := true;
    homalg_ring!.AsRightModule!.distinguished := true;
    
    homalg_ring!.ZeroLeftModule := HomalgZeroLeftModule( homalg_ring );
    homalg_ring!.ZeroRightModule := HomalgZeroRightModule( homalg_ring );
    
    homalg_ring!.ZeroLeftModule!.distinguished := true;
    homalg_ring!.ZeroRightModule!.distinguished := true;
    
    if IsHomalgExternalRingRep( homalg_ring ) then
        
        container := HOMALG.ContainerForWeakPointersOnHomalgExternalRings;
        
        weak_pointers := container!.weak_pointers;
        
        l := container!.counter;
        
        deleted := Filtered( [ 1 .. l ], i -> not IsBoundElmWPObj( weak_pointers, i ) );
        
        container!.deleted := deleted;
        
        l := l + 1;
        
        container!.counter := l;
        
        SetElmWPObj( weak_pointers, l, homalg_ring );
        
        streams := container!.streams;
        
        if not homalgExternalCASystemPID( homalg_ring ) in List( streams, s -> s.pid ) then
            Add( streams, homalgStream( homalg_ring ) );
        fi;
        
    fi;
    
    if IsBound( HOMALG.ByASmallerPresentation ) and HOMALG.ByASmallerPresentation = true then
        homalg_ring!.ByASmallerPresentation := true;
    fi;
    
    ## e.g. needed to construct residue class rings
    homalg_ring!.ConstructorArguments := arg;
    
    return homalg_ring;
    
end );

##  <#GAPDoc Label="HomalgRingOfIntegers">
##  <ManSection>
##    <Func Arg="" Name="HomalgRingOfIntegers" Label="constructor for the integers"/>
##    <Returns>the ring of integers <M>&ZZ;</M> for &homalg;</Returns>
##    <Func Arg="c" Name="HomalgRingOfIntegers" Label="constructor for the residue class rings of the integers"/>
##    <Returns>a &homalg; ring</Returns>
##    <Description>
##      The no-argument form returns the ring of integers <M>&ZZ;</M> for &homalg;. <P/>
##      The one-argument form accepts an integer <A>c</A> and returns
##      the ring <M>&ZZ; / c </M> for &homalg;:
##      <List>
##        <Item><A>c</A><M> = 0</M> defaults to <M>&ZZ;</M></Item>
##        <Item>if <A>c</A> is a prime power then the package &GaussForHomalg; is loaded (if it fails to load an error is issued)</Item>
##        <Item>otherwise, the residue class ring constructor <C>/</C>
##          (&see; <Ref Oper="\/" Label="constructor for residue class rings" Style="Number"/>) is invoked</Item>
##      </List>
##      The operation <C>SetRingProperties</C> is automatically invoked to set the ring properties. <P/>
##      If for some reason you don't want to use the &GaussForHomalg; package (maybe because you didn't install it), then use<P/>
##      <C>HomalgRingOfIntegers</C>( ) <C>/</C> <A>c</A>; <P/>
##      but note that the computations will then be considerably slower.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallGlobalFunction( HomalgRingOfIntegers,
  function( arg )
    local nargs, R, c, rel;
    
    nargs := Length( arg );
    
    if nargs = 0 or arg[1] = 0 then
        c := 0;
        R := CreateHomalgRing( Integers );
    elif IsInt( arg[1] ) then
        c := arg[1];
        if Length( Collected( FactorsInt( c ) ) ) = 1 then
            if LoadPackage( "GaussForHomalg" ) <> true then
                Error( "the package GaussForHomalg failed to load\n" );
            fi;
            if IsPrime( c ) then
                R := CreateHomalgRing( GF( c ) );
            else
                R := CreateHomalgRing( ZmodnZ( c ) );
            fi;
        else
            R := HomalgRingOfIntegers( );
            rel := HomalgRelationsForLeftModule( [ c ], R );
            return R / rel;
        fi;
    else
        Error( "the first argument must be an integer\n" );
    fi;
    
    SetIsResidueClassRingOfTheIntegers( R, true );
    
    SetRingProperties( R, c );
    
    return R;
    
end );

##  <#GAPDoc Label="HomalgFieldOfRationals">
##  <ManSection>
##    <Func Arg="" Name="HomalgFieldOfRationals" Label="constructor for the field of rationals"/>
##    <Returns>a &homalg; ring</Returns>
##    <Description>
##      The package &GaussForHomalg; is loaded and the field of rationals <M>&QQ;</M> is returned.
##      If &GaussForHomalg; fails to load an error is issued. <P/>
##      The operation <C>SetRingProperties</C> is automatically invoked to set the ring properties.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallGlobalFunction( HomalgFieldOfRationals,
  function( arg )
    local R;
    
    if LoadPackage( "GaussForHomalg" ) <> true then
        Error( "the package GaussForHomalg failed to load\n" );
    fi;
    
    R := CreateHomalgRing( Rationals );
    
    SetIsFieldForHomalg( R, true );
    
    SetRingProperties( R, 0 );
    
    return R;
    
end );

##  <#GAPDoc Label="ResidueClassRing">
##  <ManSection>
##    <Oper Arg="R, ring_rel" Name="\/" Label="constructor for residue class rings"/>
##    <Returns>a &homalg; ring</Returns>
##    <Description>
##      This is the &homalg; constructor for residue class rings <A>R</A> <M>/</M> <A>ring_rel</A>, where
##      <A>R</A> is a &homalg; ring and <A>ring_rel</A> might be:
##      <List>
##        <Item>a set of left resp. right relations on one generator</Item>
##        <Item>a list of ring elements of <A>R</A></Item>
##        <Item>a ring element of <A>R</A></Item>
##      </List>
##      In the first case the relations should generate the ideal of relations
##      as left resp. right ideal generators. If <A>ring_rel</A> is not a set
##      of relations, a left set of relations is constructed. <P/>
##      The operation <C>SetRingProperties</C> is automatically invoked to set the ring properties.
##      <Example><![CDATA[
##  gap> ZZ := HomalgRingOfIntegers( );
##  <A homalg internal ring>
##  gap> Display( ZZ );
##  Z
##  gap> Z256 := ZZ / 2^8;
##  <A homalg internal ring>
##  gap> Display( Z256 );
##  Z/( 256 )
##  gap> Z2 := Z256 / 6;
##  <A homalg internal ring>
##  gap> Display( Z2 );
##  Z/( 2 )
##  ]]></Example>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallMethod( \/,
        "for homalg rings",
        [ IsHomalgRing, IsHomalgRelations ],
        
  function( R, ring_rel )
    local S, mat, rel, left, rel_old, mat_old, left_old, c;
    
    S := CallFuncList( CreateHomalgRing, R!.ConstructorArguments );
    
    mat := MatrixOfRelations( ring_rel );
    
    mat := mat * S;
    
    if IsHomalgRelationsOfLeftModule( ring_rel ) then
        rel := HomalgRelationsForLeftModule( mat );
        left := true;
    else
        rel := HomalgRelationsForRightModule( mat );
        left := false;
    fi;
    
    ## merge the new relations with the relations of the ambient ring
    if HasRingRelations( R ) then
        SetAmbientRing( S, AmbientRing( R ) );
        rel_old := RingRelations( R );
        mat_old := MatrixOfRelations( rel_old );
        mat_old := mat_old * S;
        if IsHomalgRelationsOfLeftModule( rel_old ) then
            rel_old := HomalgRelationsForLeftModule( mat_old );
            left_old := true;
        else
            rel_old := HomalgRelationsForRightModule( mat_old );
            left_old := false;
        fi;
        if left <> left_old then
            Error( "the relations of the ambient ring and the given relations must both be either left or right relations\n" );
        fi;
        rel := BasisOfModule( UnionOfRelations( rel_old, rel ) );
    else
        SetAmbientRing( S, R );
    fi;
    
    SetRingRelations( S, rel );
    
    ## residue class rings of the integers
    if HasIsResidueClassRingOfTheIntegers( R ) and
       IsResidueClassRingOfTheIntegers( R ) then
        SetIsResidueClassRingOfTheIntegers( S, true );
        c := RingRelations( S );
        c := MatrixOfRelations( c );
        c := EntriesOfHomalgMatrix( c );
        if Length( c ) = 1 then
            c := c[1];
            if IsHomalgExternalRingElementRep( c ) and
               IsInt( homalgPointer( c ) ) then
                c := homalgPointer( c );
            fi;
        fi;
        if IsInt( c ) then
            SetRingProperties( S, c );
        fi;
    fi;
    
    return S;
    
end );

##
InstallMethod( \/,
        "for homalg rings",
        [ IsHomalgRing, IsList ],
        
  function( R, ring_rel )
    
    if not ForAll( ring_rel, IsRingElement ) then
        TryNextMethod( );
    fi;
    
    return R / HomalgRelationsForLeftModule( HomalgMatrix( ring_rel, R ) );
    
end );

##
InstallMethod( \/,
        "for homalg rings",
        [ IsHomalgRing, IsRingElement ],
        
  function( R, ring_rel )
    
    return R / [ ring_rel ];
    
end );

##
InstallMethod( \*,
        "for homalg rings",
        [ IsHomalgExternalRingRep, IsString ],
        
  function( R, indets )
    
    return PolynomialRing( R, SplitString( indets, "," ) );
    
end );

##
InstallMethod( AssociatedRingOfDerivations,
        "for homalg rings",
        [ IsHomalgRing and IsCommutative, IsList ],
        
  function( S, der )
    local A;
    
    if IsBound(S!.RingOfDerivations) then
        return S!.RingOfDerivations;
    fi;
    
    A := RingOfDerivations( S, der );
    
    S!.RingOfDerivations := A;
    
    return A;
    
end );

##
InstallMethod( AssociatedRingOfDerivations,
        "for homalg rings",
        [ IsHomalgRing and IsCommutative ],
        
  function( S )
    
    if IsBound(S!.RingOfDerivations) then
        return S!.RingOfDerivations;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ExteriorRing,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, anti )
    
    if HasBaseRing( S ) then
        return ExteriorRing( S, BaseRing( S ), anti );
    else
        return ExteriorRing( S, CoefficientsRing( S ), anti );
    fi;
    
end );

##
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, anti )
    local A;
    
    if IsBound(S!.KoszulDualRing) then
        return S!.KoszulDualRing;
    fi;
    
    A := ExteriorRing( S, anti );
    
    ## thanks GAP4
    A!.KoszulDualRing := S;
    S!.KoszulDualRing := A;
    
    return A;
    
end );

##
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( S )
    
    if IsBound(S!.KoszulDualRing) then
        return S!.KoszulDualRing;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallGlobalFunction( HomalgExternalRingElement,
  function( arg )
    local nargs, el, pointer, ring, cas, ar, properties, r;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "empty input\n" );
    fi;
    
    if IsHomalgExternalRingElementRep( arg[1] ) then
        
        el := arg[1];
        pointer := homalgPointer( el );
        
        ## rebuild an external ring element if a ring is provided as a second argument
        if nargs > 1 and IsHomalgRing( arg[2] ) then
            ring := arg[2];
            cas := homalgExternalCASystem( ring );
            ar := [ pointer, cas, ring ];
            properties := KnownTruePropertiesOfObject( el );
            Append( ar, List( properties, ValueGlobal ) );
            return CallFuncList( HomalgExternalRingElement, ar );
        fi;
        
        ## otherwise simply return it
        return el;
        
    fi;
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if not IsBound( cas ) and IsString( ar ) then
            cas := ar;
        elif not IsBound( ring ) and IsHomalgExternalRingRep( ar ) then
            ring := ar;
            cas := homalgExternalCASystem( ring );
        elif IsFilter( ar ) then
            Add( properties, ar );
        else
            Error( "this argument (now assigned to ar) should be in { IsString, IsHomalgExternalRingRep, IsFilter }\n" );
        fi;
    od;
    
    pointer := arg[1];
    
    if IsBound( ring ) then
        
        if IsFunction( pointer ) then
            pointer := pointer( ring );
        fi;
        
        r := rec( pointer := pointer, cas := cas, ring := ring );
        
        ## Objectify:
        Objectify( TheTypeHomalgExternalRingElementWithIOStream, r );
    else
        r := rec( pointer := pointer, cas := cas );
        
        ## Objectify:
        Objectify( TheTypeHomalgExternalRingElement, r );
    fi;
    
    if properties <> [ ] then
        for ar in properties do
            Setter( ar )( r, true );
        od;
    fi;
    
    return r;
    
end );

##
InstallGlobalFunction( StringToElementStringList,
  function( arg )
    
    return SplitString( arg[1], ",", "[ ]\n" );
    
end );

##
InstallGlobalFunction( _CreateHomalgRingToTestProperties,
  function( arg )
    local homalg_ring, type;
    
    homalg_ring := rec( );
    
    type := TheTypeHomalgInternalRing;
    
    ## Objectify:
    CallFuncList( ObjectifyWithAttributes, Concatenation([ homalg_ring, type ], arg ) );
    
    return homalg_ring;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( o )
    
    Print( "<A homalg internal ring>" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg rings",
        [ IsHomalgExternalRingRep ],
        
  function( o )
    
    Print( "<A homalg external ring residing in the CAS " );
    Print( homalgExternalCASystem( o ), ">" );
    
end );

##
InstallMethod( Display,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( o )
    
    Print( RingName( o ), "\n" );
    
end );

##
InstallMethod( DisplayRing,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( o )
    
    Display( o );
    
end );

##
InstallMethod( Name,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( o )
    local pointer;
    
    pointer := homalgPointer( o );
    
    if not IsFunction( pointer ) then
        
        homalgSetName( o, pointer );
        
        return Name( o );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ViewObj,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( o )
    
    Print( Name( o ) );	## this sets the attribute Name and the view method is never triggered again (as long as Name is set)
    
end );

##
InstallMethod( ViewObj,
        "for containers of weak pointers on homalg external rings",
        [ IsContainerForWeakPointersOnHomalgExternalRingsRep ],
        
  function( o )
    local del;
    
    del := Length( o!.deleted );
    
    Print( "<A container of weak pointers on homalg external rings: active = ", o!.counter - del, ", deleted = ", del, ">" );
    
end );

##
InstallMethod( Display,
        "for containers of weak pointers on homalg external rings",
        [ IsContainerForWeakPointersOnHomalgExternalRingsRep ],
        
  function( o )
    local weak_pointers;
    
    weak_pointers := o!.weak_pointers;
    
    Print( List( [ 1 .. LengthWPObj( weak_pointers ) ], function( i ) if IsBoundElmWPObj( weak_pointers, i ) then return i; else return 0; fi; end ), "\n" );
    
end );


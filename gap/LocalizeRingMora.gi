##  <#GAPDoc Label="LocalizePolynomialRingAtZeroWithMora">
##  <ManSection>
##    <Oper Arg="R" Name="LocalizePolynomialRingAtZeroWithMora" Label= "constructor for homalg localized rings using Mora's algorithm"/>
##    <Returns>a local ring</Returns>
##    <Description>
##      This method localizes the ring <A>R</A> at zero and this localized ring is returned. The ring table uses Mora's algorithm as implemented &Singular; for low level computations.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallMethod( LocalizePolynomialRingAtZeroWithMora,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing ],
  function( R )
    local var, Rloc, S, v, RP, c, n_gens, gens;

    if LoadPackage( "RingsForHomalg" ) <> true then
        Error( "the package RingsForHomalg failed to load\n" );
    fi;

    RP := CreateHomalgTableForLocalizedRingsWithMora( R );
    
    Rloc := LocalizePolynomialRingAtZero( R );
    
    var := IndeterminatesOfPolynomialRing( R );
    
    S := CreateHomalgRing( Rloc, [ TheTypeHomalgLocalRing, TheTypeHomalgLocalMatrix ], HomalgLocalRingElement, RP );
    
    ## for the view method: <A homalg local matrix>
    S!.description := "local";
    
    S!.AssociatedGlobalRing := R;
    
    S!.AssociatedComputationRing := Rloc;
    
    SetIsLocalRing( S, true );
    
    n_gens := Length( var );
    
    gens := Rloc * HomalgMatrix( var, n_gens, 1, R );
    
    SetGeneratorsOfMaximalLeftIdeal( S, gens );
    
    gens := Rloc * HomalgMatrix( var, 1, n_gens, R );
    
    SetGeneratorsOfMaximalRightIdeal( S, gens );
    
#if IsBound(S!.asserts) then
      S!.asserts.BasisOfRowsCoeff := function( arg ) return true; end;
      S!.asserts.BasisOfColumnsCoeff := function( arg ) return true; end;
      S!.asserts.DecideZeroRowsEffectively := function( arg ) return true; end;
      S!.asserts.DecideZeroColumnsEffectively := function( arg ) return true; end;
#    fi;
    
    return S;
    
end );

##
InstallMethod( CreateHomalgTableForLocalizedRingsWithMora,
        "for Singular rings",
        [ IsHomalgRing and IsCommutative and IsFreePolynomialRing ],
        
  function( globalR )
    local globalRP, RP, RP_General, RP_Basic, RP_specific, component;
    
    globalRP := homalgTable( globalR );
    
    RP := ShallowCopy( CommonHomalgTableForLocalizedRingsTools );
    
    RP_General := ShallowCopy( CommonHomalgTableForLocalizedRings );
    
    RP_Basic := ShallowCopy( CommonHomalgTableForLocalizedRingsBasic );
    
    RP_specific := rec (
                        Zero := globalRP!.Zero,

                        One := globalRP!.One,

                        MinusOne := globalRP!.MinusOne,
                        
                        );
    
    for component in NamesOfComponents( RP_General ) do
        RP.(component) := RP_General.(component);
    od;
    
    for component in NamesOfComponents( RP_Basic ) do
        RP.(component) := RP_Basic.(component);
    od;
    
    for component in NamesOfComponents( RP_specific ) do
        RP.(component) := RP_specific.(component);
    od;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );


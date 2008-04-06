#############################################################################
##
##  MapleHomalgInvolutive.gi  RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the rings provided by the Maple package Involutive
##  accessed via the Maple implementation of homalg.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for homalg rings provided by the maple package Involutive",
        [ IsHomalgExternalRingObjectInMapleRep
          and IsCommutative ],
        
  function( arg )
    local RP, RP_default, RP_BestBasis, RP_specific, component;
    
    RP := ShallowCopy( CommonHomalgTableForMapleHomalgTools );
    
    RP_default := ShallowCopy( CommonHomalgTableForMapleHomalgDefault );
    
    RP_BestBasis := ShallowCopy( CommonHomalgTableForMapleHomalgBestBasis );
    
    RP_specific :=
          rec(
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (HomalgTable gives no default value)
               
               RingName :=
                 function( R )
                   local c, v, r;
                     
                     c := Characteristic( R );
                     
                     if HasIndeterminatesOfPolynomialRing( R ) then
                         v := IndeterminatesOfPolynomialRing( R );
                         if ForAll( v, HasName ) then
                             v := List( v, Name );
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
                       return "Z";
                     elif IsPrime( c ) then
                       return Flat( [ "GF(", String( c ), ")" ] );
                     else
                       return Flat( [ "Z/", String( c ), "Z" ] );
                     fi;
		     return "couldn't find a way to display";
		     
                 end,
               
          );
    
    for component in NamesOfComponents( RP_default ) do
        RP.(component) := RP_default.(component);
    od;
    
    for component in NamesOfComponents( RP_specific ) do
        RP.(component) := RP_specific.(component);
    od;
    
    Objectify( HomalgTableType, RP );
    
    return RP;
    
end );

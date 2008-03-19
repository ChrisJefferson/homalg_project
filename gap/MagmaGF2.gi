#############################################################################
##
##  MagmaGF2.gd               RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the field GF(2) in MAGMA.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
               "for finite Sage field GF(2) with 2 Elements",
               [ IsHomalgExternalObjectRep and IsHomalgExternalObjectWithIOStream and IsSageGF2 ],

  function( arg )
    local RP, RP_BestBasis, RP_specific, component;
    
    RP := ShallowCopy( CommonHomalgTableForSageTools );
    
    RP_BestBasis := ShallowCopy( CommonHomalgTableForSageBestBasis );
    
    RP_specific :=
          rec(
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (HomalgTable gives no default value)
               
               RingName := "GF(2)",
               
               ## Must be defined if other functions are not defined
               
               TriangularBasisOfRows :=
                 function( arg )
                   local M, R, nargs, N, U, rank_of_N;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   N := HomalgMatrix( "void", NrRows( M ), NrColumns( M ), R );
                   
                   if HasIsDiagonalMatrix( M ) and IsDiagonalMatrix( M ) then
                       SetIsDiagonalMatrix( N, true );
                   else
                       SetIsUpperTriangularMatrix( N, true );
                   fi;
                   
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not TriangularBasisOfRows( M, "" )
                       # assign U:
                       U := arg[2];
                       SetNrRows( U, NrRows( M ) );
                       SetNrColumns( U, NrRows( M ) );
                       SetIsInvertibleMatrix( U, true );
                       
                       ## compute N and U:
                       rank_of_N := Int( HomalgSendBlocking( [ N, U, " := EchelonForm(", M, "); Rank(", N, ")" ], "need_output" ) );
                   else
                       ## compute N only:
                       rank_of_N := Int( HomalgSendBlocking( [ N, " := EchelonForm(", M, "); Rank(", N, ")" ], "need_output" ) );
                   fi;
                   
                   SetRowRankOfMatrix( N, rank_of_N );
                   
                   return N;
                   
                 end
               
          );
    
    for component in NamesOfComponents( RP_BestBasis ) do
        RP.(component) := RP_BestBasis.(component);
    od;
    
    for component in NamesOfComponents( RP_specific ) do
        RP.(component) := RP_specific.(component);
    od;
    
    Objectify( HomalgTableType, RP );
    
    return RP;
    
end );

#############################################################################
##
##  Fields.gi                   homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  A field
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for the integers",
        [ IsField ],
        
  function( arg )
    local RP;
    
    RP := rec( 
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (homalgTable gives no default value)
               RingName := "Field",
               
               ## Must be defined if other functions are not defined
                   
               TriangularBasisOfRows :=
                 function( arg )
                   local M, R, nargs, N, H;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   if nargs > 1 then
                       ## compute N and U:
                       N := SemiEchelonMatTransformation( Eval( M ) );
                   else
                       ## compute N only:
                       N := SemiEchelonMat( Eval( M ) );
                   fi;
                   
                   # assign U:
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not TriangularBasisOfRows( M, "" )
                       SetEval( arg[2], Concatenation( N.coeffs, N.relations ) );
                       ResetFilterObj( arg[2], IsVoidMatrix );
                       SetNrRows( arg[2], NrRows( M ) );
                       SetNrColumns( arg[2], NrRows( M ) );
                       SetIsInvertibleMatrix( arg[2], true );
                   fi;
                   
                   if N.vectors = [ ] then
                       H := HomalgZeroMatrix( 0, Length( N.heads ), R );
                   else
                       H := HomalgMatrix( N.vectors, R );
                   fi;
                   
                   SetNrColumns( H, NrColumns( M ) );
                   SetRowRankOfMatrix( H, NrRows( H ) );
                   
                   if HasIsDiagonalMatrix( M ) and IsDiagonalMatrix( M ) then
                       SetIsDiagonalMatrix( H, true );   
                   else
                       SetIsUpperTriangularMatrix( H, true );
                   fi;
                   
                   return H;
                   
                 end
                 
          );
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );

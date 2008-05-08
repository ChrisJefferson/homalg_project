#############################################################################
##
##  SingularDefault.gd        RingsForHomalg package          Simon Goertzen
##
##  Copyright 2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the rings provided by Singular.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForSingularDefault,

  rec(               
  
    DecideZeroRows :=
    function( A, B )
      local R, N;
    
      R := HomalgRing( A );
      N := HomalgVoidMatrix( NrRows( A ), NrColumns( A ), R );
      homalgSendBlocking( [ "matrix ", N, " = reduce(", A, B, ")" ], "need_command" );
      ResetFilterObj( N, IsVoidMatrix );
      return N;
    
    end,
    
    SyzygiesGeneratorsOfRows :=
    function( arg )
      local M, R, N;
      M := arg[1];
      R := HomalgRing( M );
      N := HomalgVoidMatrix(  R );
      if Length( arg ) > 1 and IsHomalgMatrix( arg[2] ) then
        homalgSendBlocking( [ "matrix ", N, " = syz(", UnionOfRows( M, arg[2] ), ")" ], "need_command" );
	N := CertainColumns( N, [1.. NrRows( M )] );
      else
        homalgSendBlocking( [ "matrix ", N, " = syz(", M, ")" ], "need_command" );
      fi;
      SetNrColumns( N, NrRows( M ) );
      ResetFilterObj( N, IsVoidMatrix );
      return N;
    
    end,
    
    BasisOfRowModule :=
    function( M )
      local R, N;
      R := HomalgRing( M );
      N := HomalgVoidMatrix( "unknown_number_of_rows", NrColumns( M ), R );
      homalgSendBlocking( [ "matrix ", N, " = std(", M, ")" ], "need_command" );
      ResetFilterObj( N, IsVoidMatrix );
      return N;
    end,
  )
);

#############################################################################
##
##  LocalizeRingBasic.gi     LocalizeRingBasic package       Mohamed Barakat
##                                                    Markus Lange-Hegermann
##
##  Copyright 2009, Mohamed Barakat, Universität des Saarlandes
##           Markus Lange-Hegermann, RWTH-Aachen University
##
##  Implementation stuff for LocalizeRingForHomalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForLocalizedRingsBasic,
        
        rec(
               ## Must only then be provided by the RingPackage in case the default
               ## "service" function does not match the Ring
               
               BasisOfRowModule :=
                 function( M )
                   local R, N;
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( "unknown_number_of_rows", NrColumns( M ), R );
                   
                   homalgSendBlocking( [ "matrix ", N, " = BasisOfRowModule(", M, ")" ], "need_command", HOMALG_IO.Pictograms.BasisOfModule );
                   
                   return N;
                   
                 end,
               
               BasisOfColumnModule :=
                 function( M )
                   local R, N;
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( NrRows( M ), "unknown_number_of_columns", R );
                   
                   homalgSendBlocking( [ "matrix ", N, " = BasisOfColumnModule(", M, ")" ], "need_command", HOMALG_IO.Pictograms.BasisOfModule );
                   
                   return N;
                   
                 end,
               
               BasisOfRowsCoeff :=
                 function( M, T )
                   local R, N;
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( "unknown_number_of_rows", NrColumns( M ), R );
                   
                   homalgSendBlocking( [ "l=BasisOfRowsCoeff(", M, "); matrix ", N, " = l[1]; matrix ", T, " = l[2]" ], "need_command", HOMALG_IO.Pictograms.BasisCoeff );
                   
                   return N;
                   
                 end,
               
               BasisOfColumnsCoeff :=
                 function( M, T )
                   local R, N;
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( NrRows( M ), "unknown_number_of_columns", R );
                   
                   homalgSendBlocking( [ "l=BasisOfColumnsCoeff(", M, "); matrix ", N, " = l[1]; matrix ", T, " = l[2]" ], "need_command", HOMALG_IO.Pictograms.BasisCoeff );
                   
                   return N;
                   
                 end,
               
               DecideZeroRows :=
                 function( A, B )
                   local R, N;
                   
                   R := HomalgRing( A );
                   
                   N := HomalgVoidMatrix( NrRows( A ), NrColumns( A ), R );
                   
                   homalgSendBlocking( [ "matrix ", N, " = DecideZeroRows(", A, B, ")" ], "need_command", HOMALG_IO.Pictograms.DecideZero );
                   
                   return N;
                   
                 end,
               
               DecideZeroColumns :=
                 function( A, B )
                   local R, N;
                   
                   R := HomalgRing( A );
                   
                   N := HomalgVoidMatrix( NrRows( A ), NrColumns( A ), R );
                   
                   homalgSendBlocking( [ "matrix ", N, " = DecideZeroColumns(", A, B, ")" ], "need_command", HOMALG_IO.Pictograms.DecideZero );
                   
                   return N;
                   
                 end,
               
               DecideZeroRowsEffectively :=
                 function( A, B, T )
                   local R, N;
                   
                   R := HomalgRing( A );
                   
                   N := HomalgVoidMatrix( NrRows( A ), NrColumns( A ), R );
                   
                   homalgSendBlocking( [ "l=DecideZeroRowsEffectively(", A, B, "); matrix ", N, " = l[1]; matrix ", T, " = l[2]" ], "need_command", HOMALG_IO.Pictograms.DecideZeroEffectively );
                   
                   return N;
                   
                 end,
               
               DecideZeroColumnsEffectively :=
                 function( A, B, T )
                   local R, N;
                   
                   R := HomalgRing( A );
                   
                   N := HomalgVoidMatrix( NrRows( A ), NrColumns( A ), R );
                   
                   homalgSendBlocking( [ "l=DecideZeroColumnsEffectively(", A, B, "); matrix ", N, " = l[1]; matrix ", T, " = l[2]" ], "need_command", HOMALG_IO.Pictograms.DecideZeroEffectively );
                   
                   return N;
                   
                 end,
               
               SyzygiesGeneratorsOfRows :=
                 function( arg )
                   local M, R, N, M2;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( "unknown_number_of_rows", NrRows( M ), R );
                   
                   if Length( arg ) > 1 and IsHomalgMatrix( arg[2] ) then
                       
                       M2 := arg[2];
                       
                       homalgSendBlocking( [ "matrix ", N, " = SyzygiesGeneratorsOfRows2(", M, M2, ")" ], "need_command", HOMALG_IO.Pictograms.SyzygiesGenerators );
                       
                   else
                       
                       homalgSendBlocking( [ "matrix ", N, " = SyzygiesGeneratorsOfRows(", M, ")" ], "need_command", HOMALG_IO.Pictograms.SyzygiesGenerators );
                       
                   fi;
                   
                   return N;
                   
                 end,
               
               SyzygiesGeneratorsOfColumns :=
                 function( arg )
                   local M, R, N, M2;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   N := HomalgVoidMatrix( NrColumns( M ), "unknown_number_of_columns", R );
                   
                   if Length( arg ) > 1 and IsHomalgMatrix( arg[2] ) then
                       
                       M2 := arg[2];
                       
                       homalgSendBlocking( [ "matrix ", N, " = SyzygiesGeneratorsOfColumns2(", M, M2, ")" ], "need_command", HOMALG_IO.Pictograms.SyzygiesGenerators );
                       
                   else
                       
                       homalgSendBlocking( [ "matrix ", N, " = SyzygiesGeneratorsOfColumns(", M, ")" ], "need_command", HOMALG_IO.Pictograms.SyzygiesGenerators );
                       
                   fi;
                   
                   return N;
                   
                 end,
               
        )
 );

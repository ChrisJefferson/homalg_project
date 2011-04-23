#############################################################################
##
##  SingularTools.gi                             GradedRingForHomalg package
##
##  Copyright 2009-2011, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH-Aachen University
##
##  Implementations for the rings provided by Singular.
##
#############################################################################

####################################
#
# global variables:
#
####################################

##
SingularMacros.Deg := "\n\
ring r;\n\
if ( deg(0,(1,1,1)) > 0 ) // this is a workaround for a bug in the 64 bit versions of Singular 3-0-4\n\
{ proc Deg (pol,weights)\n\
  {\n\
    if ( pol == 0 )\n\
    {\n\
      return(deg(0));\n\
    }\n\
    return(deg(pol,weights));\n\
  }\n\
}\n\
else\n\
{ proc Deg (pol,weights)\n\
  {\n\
    return(deg(pol,weights));\n\
  }\n\
}\n\
kill r;\n\n";

##
SingularMacros.MultiDeg := "\n\
proc MultiDeg (pol,weights)\n\
{\n\
  int mul=size(weights);\n\
  intmat m[1][mul];\n\
  for (int i=1; i<=mul; i++)\n\
  {\n\
    m[1,i]=Deg(pol,weights[i]);\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.DegreesOfEntries := "\n\
proc DegreesOfEntries (matrix M)\n\
{\n\
  intmat m[ncols(M)][nrows(M)];\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      m[i,j] = deg(M[j,i]);\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.WeightedDegreesOfEntries := "\n\
proc WeightedDegreesOfEntries (matrix M, weights)\n\
{\n\
  intmat m[ncols(M)][nrows(M)];\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      m[i,j] = Deg(M[j,i],weights);\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";
    
##
SingularMacros.NonTrivialDegreePerRow := "\n\
proc NonTrivialDegreePerRow (matrix M)\n\
{\n\
  int b = 1;\n\
  intmat m[1][ncols(M)];\n\
  int d = deg(0);\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      if ( deg(M[j,i]) <> d ) { m[1,i] = deg(M[j,i]); break; }\n\
    }\n\
    if ( b && i > 1 ) { if ( m[1,i] <> m[1,i-1] ) { b = 0; } } // Singular is strange\n\
  }\n\
  if ( b ) { return(m[1,1]); } else { return(m); }\n\
}\n\n";

##
SingularMacros.NonTrivialWeightedDegreePerRow := "\n\
proc NonTrivialWeightedDegreePerRow (matrix M, weights)\n\
{\n\
  int b = 1;\n\
  intmat m[1][ncols(M)];\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      if ( M[j,i] <> 0 ) { m[1,i] = Deg(M[j,i],weights); break; }\n\
    }\n\
    if ( b && i > 1 ) { if ( m[1,i] <> m[1,i-1] ) { b = 0; } } // Singular is strange\n\
  }\n\
  if ( b ) { return(m[1,1]); } else { return(m); }\n\
}\n\n";

##
SingularMacros.NonTrivialDegreePerRowWithColPosition := "\n\
proc NonTrivialDegreePerRowWithColPosition(matrix M)\n\
{\n\
  intmat m[2][ncols(M)];\n\
  int d = deg(0);\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      if ( deg(M[j,i]) <> d ) { m[1,i] = deg(M[j,i]); m[2,i] = j; break; }\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.NonTrivialWeightedDegreePerRowWithColPosition := "\n\
proc NonTrivialWeightedDegreePerRowWithColPosition(matrix M, weights)\n\
{\n\
  intmat m[2][ncols(M)];\n\
  for (int i=1; i<=ncols(M); i++)\n\
  {\n\
    for (int j=1; j<=nrows(M); j++)\n\
    {\n\
      if ( M[j,i] <> 0 ) { m[1,i] = Deg(M[j,i],weights); m[2,i] = j; break; }\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.NonTrivialDegreePerColumn := "\n\
proc NonTrivialDegreePerColumn (matrix M)\n\
{\n\
  int b = 1;\n\
  intmat m[1][nrows(M)];\n\
  int d = deg(0);\n\
  for (int j=1; j<=nrows(M); j++)\n\
  {\n\
    for (int i=1; i<=ncols(M); i++)\n\
    {\n\
      if ( deg(M[j,i]) <> d ) { m[1,j] = deg(M[j,i]); break; }\n\
    }\n\
    if ( b && j > 1 ) { if ( m[1,j] <> m[1,j-1] ) { b = 0; } } // Singular is strange\n\
  }\n\
  if ( b ) { return(m[1,1]); } else { return(m); }\n\
}\n\n";

##
SingularMacros.NonTrivialWeightedDegreePerColumn := "\n\
proc NonTrivialWeightedDegreePerColumn (matrix M, weights)\n\
{\n\
  int b = 1;\n\
  intmat m[1][nrows(M)];\n\
  for (int j=1; j<=nrows(M); j++)\n\
  {\n\
    for (int i=1; i<=ncols(M); i++)\n\
    {\n\
      if ( M[j,i] <> 0 ) { m[1,j] = Deg(M[j,i],weights); break; }\n\
    }\n\
    if ( b && j > 1 ) { if ( m[1,j] <> m[1,j-1] ) { b = 0; } } // Singular is strange\n\
  }\n\
  if ( b ) { return(m[1,1]); } else { return(m); }\n\
}\n\n";

##
SingularMacros.NonTrivialDegreePerColumnWithRowPosition := "\n\
proc NonTrivialDegreePerColumnWithRowPosition (matrix M)\n\
{\n\
  intmat m[2][nrows(M)];\n\
  int d = deg(0);\n\
  for (int j=1; j<=nrows(M); j++)\n\
  {\n\
    for (int i=1; i<=ncols(M); i++)\n\
    {\n\
      if ( deg(M[j,i]) <> d ) { m[1,j] = deg(M[j,i]); m[2,j] = i; break; }\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.NonTrivialWeightedDegreePerColumnWithRowPosition := "\n\
proc NonTrivialWeightedDegreePerColumnWithRowPosition (matrix M, weights)\n\
{\n\
  intmat m[2][nrows(M)];\n\
  for (int j=1; j<=nrows(M); j++)\n\
  {\n\
    for (int i=1; i<=ncols(M); i++)\n\
    {\n\
      if ( M[j,i] <> 0 ) { m[1,j] = Deg(M[j,i],weights); m[2,j] = i; break; }\n\
    }\n\
  }\n\
  return(m);\n\
}\n\n";

##
SingularMacros.Diff := "\n\
proc Diff (matrix m, matrix n) // following the Macaulay2 convention \n\
{\n\
  int f = nrows(m);\n\
  int p = ncols(m);\n\
  int g = nrows(n);\n\
  int q = ncols(n);\n\
  matrix h[f*g][p*q]=0;\n\
  for (int i=1; i<=f; i=i+1)\n\
    {\n\
    for (int j=1; j<=g; j=j+1)\n\
      {\n\
      for (int k=1; k<=p; k=k+1)\n\
        {\n\
        for (int l=1; l<=q; l=l+1)\n\
          {\n\
            h[g*(i-1)+j,q*(k-1)+l] = diff( ideal(m[i,k]), ideal(n[j,l]) )[1,1];\n\
          }\n\
        }\n\
      }\n\
    }\n\
  return(h)\n\
}\n\n";

##
InstallValue( GradedRingTableForSingularTools,
        
        rec(
               DegreeOfRingElement :=
                 function( r, R )
                   
                   return Int( homalgSendBlocking( [ "deg( ", r, " )" ], "need_output", HOMALG_IO.Pictograms.DegreeOfRingElement ) );
                   
                 end,
               
               WeightedDegreeOfRingElement :=
                 function( r, weights, R )
                   
                   return Int( homalgSendBlocking( [ "deg( ", r, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.DegreeOfRingElement ) );
                   
                 end,
               
               MultiWeightedDegreeOfRingElement :=
                 function( r, weights, R )
                   local externally_stored_weights;
                   
                   externally_stored_weights := MatrixOfWeightsOfIndeterminates( R );
                   
                   return StringToIntList( homalgSendBlocking( [ "MultiDeg(", r, externally_stored_weights, ")" ], "need_output", HOMALG_IO.Pictograms.DegreeOfRingElement ) );
                   
                 end,
               
               DegreesOfEntries :=
                 function( M )
                   local list_string, L;
                   
                   list_string := homalgSendBlocking( [ "DegreesOfEntries( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.DegreesOfEntries );
                   
                   L :=  StringToIntList( list_string );
                   
                   return ListToListList( L, NrRows( M ), NrColumns( M ) );
                   
                 end,
               
               WeightedDegreesOfEntries :=
                 function( M, weights )
                   local list_string, L;
                   
                     list_string := homalgSendBlocking( [ "WeightedDegreesOfEntries(", M, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.DegreesOfEntries );
                     
                     L :=  StringToIntList( list_string );
                     
                     return ListToListList( L, NrRows( M ), NrColumns( M ) );
                     
                 end,
               
               NonTrivialDegreePerRow :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerRow( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerRow );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrRows( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               NonTrivialWeightedDegreePerRow :=
                 function( M, weights )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialWeightedDegreePerRow(", M, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerRow );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrRows( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               NonTrivialDegreePerRowWithColPosition :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerRowWithColPosition( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerRow );
                   
                   L := StringToIntList( L );
                   
                   return ListToListList( L, 2, NrRows( M ) );
                   
                 end,
               
               NonTrivialWeightedDegreePerRowWithColPosition :=
                 function( M, weights )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialWeightedDegreePerRowWithColPosition(", M, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerRow );
                   
                   L := StringToIntList( L );
                   
                   return ListToListList( L, 2, NrRows( M ) );
                   
                 end,
               
               NonTrivialDegreePerColumn :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerColumn( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerColumn );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrColumns( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               NonTrivialWeightedDegreePerColumn :=
                 function( M, weights )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialWeightedDegreePerColumn(", M, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerColumn );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrColumns( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               NonTrivialDegreePerColumnWithRowPosition :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerColumnWithRowPosition( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerColumn );
                   
                   L := StringToIntList( L );
                   
                   return ListToListList( L, 2, NrColumns( M ) );
                   
                 end,
               
               NonTrivialWeightedDegreePerColumnWithRowPosition :=
                 function( M, weights )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialWeightedDegreePerColumnWithRowPosition(", M, ",intvec(", weights, "))" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerColumn );
                   
                   L := StringToIntList( L );
                   
                   return ListToListList( L, 2, NrColumns( M ) );
                   
                 end,
               
               MonomialMatrix :=
                 function( i, vars, R )
                   
                   return homalgSendBlocking( [ "matrix(ideal(", vars, ")^", i, ")" ], [ "matrix" ], R, HOMALG_IO.Pictograms.MonomialMatrix );
                   
                 end,
               
               Diff :=
                 function( D, N )
                   
                   return homalgSendBlocking( [ "Diff(", D, N, ")" ], [ "matrix" ], HOMALG_IO.Pictograms.Diff );
                   
                 end,
               
        )
 );

## enrich the global homalg table for Singular:
AddToAhomalgTable( CommonHomalgTableForSingularTools, GradedRingTableForSingularTools );

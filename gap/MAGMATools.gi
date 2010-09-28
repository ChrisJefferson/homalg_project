#############################################################################
##
##  MAGMATools.gi               Graded package              Mohamed Barakat
##
##  Copyright 2008-2009, Mohamed Barakat, Universität des Saarlandes
##
##  Implementations for the rings provided by MAGMA.
##
#############################################################################

####################################
#
# global variables:
#
####################################

##
MAGMAMacros.NonTrivialDegreePerRow := "\n\
NonTrivialDegreePerRow := function(M)\n\
  X:= [ Degree(m[Depth(m)]) where m:= M[i] : i in [1..Nrows(M)] ];\n\
  if exists{ x : x in X | x ne X[1] } then\n\
    return X;\n\
  else\n\
    return X[1];\n\
  end if;\n\
end function;\n\n";

##
MAGMAMacros.NonTrivialDegreePerRowWithColPosition := "\n\
NonTrivialDegreePerRowWithColPosition := function(M)\n\
  X:= [];\n\
  Y:= [];\n\
  for i in [1..Nrows(M)] do\n\
    d:= Depth(M[i]);\n\
    Append(~X, Degree(M[i,d]));\n\
    Append(~Y, d);\n\
  end for;\n\
  return X cat Y;\n\
end function;\n\n";

##
MAGMAMacros.NonTrivialDegreePerColumn := "\n\
NonTrivialDegreePerColumn := function(M)\n\
  X:= [];\n\
  m:= Nrows(M);\n\
  for j in [1..Ncols(M)] do\n\
    i:= rep{ i: i in [1..m] | not IsZero(M[i,j]) };\n\
    Append(~X, Degree(M[i,j]));\n\
  end for;\n\
  if exists{ x : x in X | x ne X[1] } then\n\
    return X;\n\
  else\n\
    return X[1];\n\
  end if;\n\
end function;\n\n";

##
MAGMAMacros.NonTrivialDegreePerColumnWithRowPosition := "\n\
NonTrivialDegreePerColumnWithRowPosition := function(M)\n\
  X:= [];\n\
  Y:= [];\n\
  m:= Nrows(M);\n\
  for j in [1..Ncols(M)] do\n\
    i:= rep{ i: i in [1..m] | not IsZero(M[i,j]) };\n\
    Append(~X, Degree(M[i,j]));\n\
    Append(~Y, i);\n\
  end for;\n\
  return X cat Y;\n\
end function;\n\n";

##
InstallValue( GradedRingTableForMAGMATools,
        
        rec(
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
               
               NonTrivialDegreePerRowWithColPosition :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerRowWithColPosition( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerRow );
                   
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
               
               NonTrivialDegreePerColumnWithRowPosition :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "NonTrivialDegreePerColumnWithRowPosition( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.NonTrivialDegreePerColumn );
                   
                   L := StringToIntList( L );
                   
                   return ListToListList( L, 2, NrColumns( M ) );
                   
                 end,
               
               MonomialMatrix :=
                 function( i, vars, R )
                   
                   return homalgSendBlocking( [ "Matrix(1,MonomialsOfDegree(", R, i, ",{", R, ".i : i in [ 1 .. Rank(", R, ")]} diff {", vars, "}))" ], "break_lists", HOMALG_IO.Pictograms.MonomialMatrix );
                   
                 end,
               
        )
 );

## enrich the global homalg table for MAGMA:
AddToAhomalgTable( CommonHomalgTableForMAGMATools, GradedRingTableForMAGMATools );

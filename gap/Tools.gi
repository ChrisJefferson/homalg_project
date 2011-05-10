#############################################################################
##
##  Tools.gi                                     GradedRingForHomalg package
##
##  Copyright 2009-2011, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH-Aachen University
##
##  Implementations for tools for (homogeneous) matrices.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( DegreeOfRingElementFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList ],
        
  function( R, weights )
    local RP, set_weights, weight;
    
    RP := homalgTable( R );
    
    set_weights := Set( weights );
    
    if set_weights = [ 1 ] then
        
        if IsBound(RP!.DegreeOfRingElement) then
            return r -> RP!.DegreeOfRingElement( r, R );
        fi;
        
    elif Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if weight <> 0 and IsBound(RP!.DegreeOfRingElement) then
            return r -> weight * RP!.DegreeOfRingElement( r, R );
        fi;
        
    elif Length( set_weights ) = 2 and 0 in set_weights and
      ForAll( set_weights, a -> a in Rationals ) then
        
        weight := Filtered( set_weights, a -> a <> 0 )[1];
        
        weights := List( weights, a -> AbsInt( SignInt( a ) ) );
        
        if IsBound(RP!.WeightedDegreeOfRingElement) then
            return r -> weight * RP!.WeightedDegreeOfRingElement( r, weights, R );
        fi;
        
    else
        
        if weights = [ ] then
            if IsBound(RP!.MultiWeightedDegreeOfRingElement) then
                return r -> RP!.MultiWeightedDegreeOfRingElement( r, [ 1 ], R );
            fi;
        elif IsList( weights[1] ) then
            if IsBound(RP!.MultiWeightedDegreeOfRingElement) then
                return r -> RP!.MultiWeightedDegreeOfRingElement( r, weights, R );
            fi;
        else
            if IsBound(RP!.WeightedDegreeOfRingElement) then
                return r -> RP!.WeightedDegreeOfRingElement( r, weights, R );
            fi;
        fi;
        
    fi;
    
    ## there is no fallback method
    
    TryNextMethod( );
    
end );

##
InstallMethod( DegreesOfEntriesFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList ],
        
  function( R, weights )
    local RP, set_weights, weight;
    
    RP := homalgTable( R );
    
    set_weights := Set( weights );
    
    if Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if IsBound(RP!.DegreesOfEntries) then
            return C -> weight * RP!.DegreesOfEntries( C );
        fi;
        
    else
        
        if weights = [ ] then
            if IsBound(RP!.MultiWeightedDegreesOfEntries) then
                return C -> RP!.MultiWeightedDegreesOfEntries( C, [ 1 ] );
            fi;
        elif IsList( weights[1] ) then
            if IsBound(RP!.MultiWeightedDegreesOfEntries) then
                return C -> RP!.MultiWeightedDegreesOfEntries( C, weights );
            fi;
        elif IsBound(RP!.WeightedDegreesOfEntries) then
            return C -> RP!.WeightedDegreesOfEntries( C, weights );
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    return
      function( C )
        local e;
        
        e := EntriesOfHomalgMatrix( C );
        
        e := List( e, DegreeOfRingElementFunction( R, weights ) );
        
        return ListToListList( e, NrRows( C ), NrColumns( C ) );
        
    end;
    
end );

##
InstallMethod( NonTrivialDegreePerRowFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList, IsObject, IsObject ],
        
  function( R, weights, deg0, deg1 )
    local RP, set_weights, weight;
    
    RP := homalgTable( R );
    
    set_weights := Set( weights );
    
    if Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if IsBound(RP!.NonTrivialDegreePerRow) then
            return C -> weight * RP!.NonTrivialDegreePerRow( C );
        fi;
        
    else
        
        if weights = [ ] then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                return C -> RP!.NonTrivialMultiWeightedDegreePerRow( C, [ 1 ] );
            fi;
        elif IsList( weights[1] ) then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                return C -> RP!.NonTrivialMultiWeightedDegreePerRow( C, weights );
            fi;
        elif IsBound(RP!.NonTrivialWeightedDegreePerRow) then
            return C -> RP!.NonTrivialWeightedDegreePerRow( C, weights );
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    return
      C -> List(
              DegreesOfEntriesFunction( R, weights )( C ),
              function( r )
                local c;
                
                c := First( r, a -> not a = deg0 );
                if c = fail then
                    return deg1;
                else
                    return c;
                fi;
            end );
    
end );

##
InstallMethod( NonTrivialDegreePerRowWithColDegreesFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList, IsObject, IsList ],
        
  function( R, weights, deg0, col_degrees )
    local RP, d, f, set_weights, weight;
    
    RP := homalgTable( R );
    
    d := Set( col_degrees );
    
    f := e ->
         function( i )
           local c;
           
           c := e[2][i];
           if c = fail or c <= 0 then
               return col_degrees[1];
           else
               return e[1][i] + col_degrees[c];
           fi;
       end;
    
    set_weights := Set( weights );
    
    if Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if Length( d ) = 1 then
            if IsBound(RP!.NonTrivialDegreePerRow) then
                return C -> weight * RP!.NonTrivialDegreePerRow( C ) + d[1];
            fi;
        else
            if IsBound( RP!.NonTrivialDegreePerRowWithColPosition ) then
                return
                  function( C )
                    local e;
                    e := RP!.NonTrivialDegreePerRowWithColPosition( C );
                    e := [ weight * e[1], e[2] ];	## e might be immutable
                    return List( [ 1 .. NrRows( C ) ], f( e ) );
                end;
            fi;
        fi;
        
    else
        
        if Length( d ) = 1 then
            if weights = [ ] then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                    return C -> RP!.NonTrivialMultiWeightedDegreePerRow( C, [ 1 ] ) + d[1];
                fi;
            elif IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                    return C -> RP!.NonTrivialMultiWeightedDegreePerRow( C, weights ) + d[1];
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerRow) then
                return C -> RP!.NonTrivialWeightedDegreePerRow( C, weights ) + d[1];
            fi;
        else
            if weights = [ ] then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition) then
                    return
                      function( C )
                        local e;
                        e := RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition( C, [ 1 ] );
                        return List( [ 1 .. NrRows( C ) ], f );
                    end;
                fi;
            elif IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition) then
                    return
                      function( C )
                        local e;
                        e := RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition( C, weights );
                        return List( [ 1 .. NrRows( C ) ], f( e ) );
                    end;
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerRowWithColPosition) then
                return
                  function( C )
                    local e;
                    e := RP!.NonTrivialWeightedDegreePerRowWithColPosition( C, weights );
                    return List( [ 1 .. NrRows( C ) ], f( e ) );
                end;
            fi;
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    return
      C -> List(
              DegreesOfEntriesFunction( R, weights )( C ),
              function( r )
                local c;
                
                c := PositionProperty( r, a -> not a = deg0 );
                if c = fail then
                    return col_degrees[1];
                else
                    return r[c] + col_degrees[c];
                fi;
            end );
    
end );

##
InstallMethod( NonTrivialDegreePerColumnFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList, IsObject, IsObject ],
        
  function( R, weights, deg0, deg1 )
    local RP, set_weights, weight;
    
    RP := homalgTable( R );
    
    set_weights := Set( weights );
    
    if Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if IsBound(RP!.NonTrivialDegreePerColumn) then
            return C -> weight * RP!.NonTrivialDegreePerColumn( C );
        fi;
        
    else
        
        if weights = [ ] then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                return C -> RP!.NonTrivialMultiWeightedDegreePerColumn( C, [ 1 ] );
            fi;
        elif IsList( weights[1] ) then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                return C -> RP!.NonTrivialMultiWeightedDegreePerColumn( C, weights );
            fi;
        elif IsBound(RP!.NonTrivialWeightedDegreePerColumn) then
            return C -> RP!.NonTrivialWeightedDegreePerColumn( C, weights );
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    return
      C -> List(
              TransposedMat( DegreesOfEntriesFunction( R, weights )( C ) ),
              function( c )
                local r;
                
                r := First( c, a -> not a = deg0 );
                if r = fail then
                    return deg1;
                else
                    return r;
                fi;
            end );
    
end );

##
InstallMethod( NonTrivialDegreePerColumnWithRowDegreesFunction,
        "for homalg rings",
        [ IsHomalgRing, IsList, IsObject, IsList ],
        
  function( R, weights, deg0, row_degrees )
    local RP, d, f, set_weights, weight;
    
    RP := homalgTable( R );
    
    d := Set( row_degrees );
    
    f := e ->
         function( j )
           local r;
           
           r := e[2][j];
           if r = fail or r <= 0 then
               return row_degrees[1];
           else
               return e[1][j] + row_degrees[r];
           fi;
       end;
    
    set_weights := Set( weights );
    
    if Length( set_weights ) = 1 and set_weights[1] in Rationals then
        
        weight := set_weights[1];
        
        if Length( d ) = 1 then
            if IsBound(RP!.NonTrivialDegreePerColumn) then
                return C -> weight * RP!.NonTrivialDegreePerColumn( C ) + d[1];
            fi;
        else
            if IsBound( RP!.NonTrivialDegreePerColumnWithRowPosition ) then
                return
                  function( C )
                    local e;
                    e := RP!.NonTrivialDegreePerColumnWithRowPosition( C );
                    e := [ weight * e[1], e[2] ];	## e might be immutable
                    return List( [ 1 .. NrColumns( C ) ], f( e ) );
                end;
            fi;
        fi;
        
    else
    
        if Length( d ) = 1 then
            if weights = [ ] then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                    return C -> RP!.NonTrivialMultiWeightedDegreePerColumn( C, [ 1 ] ) + d[1];
                fi;
            elif IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                    return C -> RP!.NonTrivialMultiWeightedDegreePerColumn( C, weights ) + d[1];
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerColumn) then
                return C -> RP!.NonTrivialWeightedDegreePerColumn( C, weights ) + d[1];
            fi;
        else
            if weights = [ ] then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition) then
                    return
                      function( C )
                        local e;
                        e := RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition( C, [ 1 ] );
                        return List( [ 1 .. NrColumns( C ) ], f );
                    end;
                fi;
            elif IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition) then
                    return
                      function( C )
                        local e;
                        e := RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition( C, weights );
                        return List( [ 1 .. NrColumns( C ) ], f( e ) );
                    end;
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerColumnWithRowPosition) then
                return
                  function( C )
                    local e;
                    e := RP!.NonTrivialWeightedDegreePerColumnWithRowPosition( C, weights );
                    return List( [ 1 .. NrColumns( C ) ], f( e ) );
                end;
            fi;
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    return
      C -> List(
              TransposedMat( DegreesOfEntriesFunction( R, weights )( C ) ),
              function( c )
                local r;
                
                r := PositionProperty( c, a -> not a = deg0 );
                if r = fail then
                    return row_degrees[1];
                else
                    return c[r] + row_degrees[r];
                fi;
            end );
    
end );

##
InstallMethod( MonomialMatrixWeighted,
        "for homalg rings",
        [ IsInt, IsHomalgRing, IsList ],
        
  function( d, R, weights )
    local dd, set_weights, RP, vars, mon;
    
    RP := homalgTable( R );
    
    if not Length( weights ) = Length( Indeterminates( R ) ) then
        Error( "there must be as many weights as indeterminates\n" );
    fi;
    
    set_weights := Set( weights );
    
    if set_weights = [1] or set_weights = [0,1] then
        dd := d;
    elif set_weights = [-1] or set_weights = [-1,0] then
        dd := -d;
    else
        Error( "Only weights -1, 0 or 1 are accepted. The weights -1 and 1 must not appear at once." );
    fi;
    
    if dd < 0 then
        return HomalgZeroMatrix( 0, 1, R );
    fi;
    
    if 0 in set_weights and dd=0 then
        Error( "This method can not possible to construct a finite matrix of degree 0 for a ring having an indeterminate of degree 0" );
    fi;
    
    vars := Indeterminates( R );

    if HasIsExteriorRing( R ) and IsExteriorRing( R ) and dd > Length( vars ) then
        return HomalgZeroMatrix( 0, 1, R );
    fi;
    
    if not ( set_weights = [ 1 ] or set_weights = [ -1 ] ) then
        
        ## the variables of weight 1 or -1
        vars := vars{Filtered( [ 1 .. Length( weights ) ], p -> weights[p] <> 0 )};
        
    fi;
    
    if IsBound(RP!.MonomialMatrix) then
        mon := RP!.MonomialMatrix( dd, vars, R );        ## the external object
        mon := HomalgMatrix( mon, R );
        SetNrColumns( mon, 1 );
        if d = 0 then
            IsOne( mon );
        fi;
        
        return mon;
    fi;
    
    if IsHomalgExternalRingRep( R ) then
        Error( "could not find a procedure called MonomialMatrix in the homalgTable of the external ring\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( LinearSyzygiesGeneratorsOfRows,
        "for matrices over graded rings",
        [ IsMatrixOverGradedRing ],
        
  function( M )
    local R, RP, t, C;
    
    if IsBound(M!.LinearSyzygiesGeneratorsOfRows) then
        return M!.LinearSyzygiesGeneratorsOfRows;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "LinearSyzygiesGeneratorsOfRows", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.LinearSyzygiesGeneratorsOfRows) then
        
        C := RP!.LinearSyzygiesGeneratorsOfRows( M );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );	## most of the computer algebra systems cannot handle degenerated matrices
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.LinearSyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfRows", NrRows( C ) );
        
        IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfRows" );
        
        return C;
        
    elif IsBound(RP!.LinearSyzygiesGeneratorsOfColumns) then
        
        C := Involution( RP!.LinearSyzygiesGeneratorsOfColumns( Involution( M ) ) );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );	## most of the computer algebra systems cannot handle degenerated matrices
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.LinearSyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfRows", NrRows( C ) );
        
        DecreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfRows" );
        
        IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfColumns" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    ## add the fallback and delete TryNextMethod( )
    TryNextMethod( );
    
    if IsZero( C ) then
        
        C := HomalgZeroMatrix( 0, NrRows( M ), R );
        
    fi;
    
    M!.LinearSyzygiesGeneratorsOfRows := C;
    
    ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfRows", NrRows( C ) );
    
    IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfRows" );
    
    return C;
    
end );

##
InstallMethod( LinearSyzygiesGeneratorsOfColumns,
        "for matrices over graded rings",
        [ IsMatrixOverGradedRing ],
        
  function( M )
    local R, RP, t, C;
    
    if IsBound(M!.LinearSyzygiesGeneratorsOfColumns) then
        return M!.LinearSyzygiesGeneratorsOfColumns;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "LinearSyzygiesGeneratorsOfColumns", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.LinearSyzygiesGeneratorsOfColumns) then
        
        C := RP!.LinearSyzygiesGeneratorsOfColumns( M );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.LinearSyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfColumns" );
        
        return C;
        
    elif IsBound(RP!.LinearSyzygiesGeneratorsOfRows) then
        
        C := Involution( RP!.LinearSyzygiesGeneratorsOfRows( Involution( M ) ) );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.LinearSyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        DecreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfColumns" );
        
        IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfRows" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    ## add the fallback and delete TryNextMethod( )
    TryNextMethod( );
    
    if IsZero( C ) then
        
        C := HomalgZeroMatrix( NrColumns( M ), 0, R );
        
    fi;
    
    M!.LinearSyzygiesGeneratorsOfColumns := C;
    
    ColoredInfoForService( t, "LinearSyzygiesGeneratorsOfColumns", NrColumns( C ) );
    
    IncreaseRingStatistics( R, "LinearSyzygiesGeneratorsOfColumns" );
    
    return C;
    
end );

##
InstallMethod( MonomialMatrixWeighted,
        "for homalg rings",
        [ IsList, IsHomalgRing, IsList ],
        
  function( d, R, weights )
    local l, mon, w;
    
    if not Length( weights ) = Length( Indeterminates( R ) ) then
        Error( "there must be as many weights as indeterminates\n" );
    fi;
    
    l := Length( d );
    
    w := ListOfDegreesOfMultiGradedRing( l, R, weights );
    
    mon := List( [ 1 .. l ] , i -> MonomialMatrixWeighted( d[i], R, w[i] ) );
    
    return Iterated( mon, KroneckerMat );
    
end );

##
InstallMethod( RandomMatrixBetweenGradedFreeLeftModulesWeighted,
        "for homalg rings",
        [ IsList, IsList, IsHomalgRing, IsList ],
        
  function( degreesS, degreesT, R, weights )
    local RP, r, c, rand, i, j, mon;
    
    RP := homalgTable( R );
    
    r := Length( degreesS );
    c := Length( degreesT );
    
    if degreesT = [ ] then
        return HomalgZeroMatrix( 0, c, R );
    elif degreesS = [ ] then
        return HomalgZeroMatrix( r, 0, R );
    fi;
    
    if IsBound(RP!.RandomMatrix) then
        rand := RP!.RandomMatrix( R, degreesT, degreesS, weights );      ## the external object
        rand := HomalgMatrix( rand, r, c, R );
        return rand;
    fi;
    
    #=====# begin of the core procedure #=====#
    
    rand := [ 1 .. r * c ];
    
    for i in [ 1 .. r ] do
        for j in [ 1 .. c ] do
            mon := MonomialMatrixWeighted( degreesS[i] - degreesT[j], R, weights );
            mon := ( R * HomalgMatrix( RandomMat( 1, NrRows( mon ) ), HOMALG_MATRICES.ZZ ) ) * mon;
            mon := GetEntryOfHomalgMatrix( mon, 1, 1 );
            rand[ ( i - 1 ) * c + j ] := mon;
        od;
    od;
    
    return HomalgMatrix( rand, r, c, R );
    
end );

##
InstallMethod( RandomMatrixBetweenGradedFreeRightModulesWeighted,
        "for homalg rings",
        [ IsList, IsList, IsHomalgRing, IsList ],
        
  function( degreesT, degreesS, R, weights )
    local RP, r, c, rand, i, j, mon;
    
    RP := homalgTable( R );
    
    r := Length( degreesT );
    c := Length( degreesS );
    
    if degreesT = [ ] then
        return HomalgZeroMatrix( 0, c, R );
    elif degreesS = [ ] then
        return HomalgZeroMatrix( r, 0, R );
    fi;
    
    if IsBound(RP!.RandomMatrix) then
        rand := RP!.RandomMatrix( R, degreesT, degreesS, weights );      ## the external object
        rand := HomalgMatrix( rand, r, c, R );
        return rand;
    fi;
    
    #=====# begin of the core procedure #=====#
    
    rand := [ 1 .. r * c ];
    
    for i in [ 1 .. r ] do
        for j in [ 1 .. c ] do
            mon := MonomialMatrixWeighted( degreesS[j] - degreesT[i], R, weights );
            mon := ( R * HomalgMatrix( RandomMat( 1, NrRows( mon ) ), HOMALG_MATRICES.ZZ ) ) * mon;
            mon := GetEntryOfHomalgMatrix( mon, 1, 1 );
            rand[ ( i - 1 ) * c + j ] := mon;
        od;
    od;
    
    return HomalgMatrix( rand, r, c, R );
    
end );

##  <#GAPDoc Label="Diff">
##  <ManSection>
##    <Oper Arg="D, N" Name="Diff"/>
##    <Returns>a &homalg; matrix</Returns>
##    <Description>
##      If <A>D</A> is a <M>f \times p</M>-matrix and <A>N</A> is a <M>g \times q</M>-matrix then
##      <M>H=Diff(</M><A>D</A>,<A>N</A><M>)</M> is an <M>fg \times pq</M>-matrix whose entry
##      <M>H[g*(i-1)+j,q*(k-1)+l]</M> is the result of differentiating <A>N</A><M>[j,l]</M>
##      by the differential operator corresponding to <A>D</A><M>[i,k]</M>. (Here we follow
##      the Macaulay2 convention.)
##      <Example><![CDATA[
##  gap> S := HomalgFieldOfRationalsInDefaultCAS( ) * "a,b,c" * "x,y,z";;
##  gap> D := HomalgMatrix( "[ \
##  > x,2*y,   \
##  > y,a-b^2, \
##  > z,y-b    \
##  > ]", 3, 2, S );;
##  <A 3 x 2 matrix over an external ring>
##  gap> N := HomalgMatrix( "[ \
##  > x^2-a*y^3,x^3-z^2*y,x*y-b,x*z-c, \
##  > x,        x*y,      a-b,  x*a*b  \
##  > ]", 2, 4, S );;
##  <A 2 by 4 matrix over an external ring>
##  gap> H := Diff( D, N );
##  <A 6 x 8 matrix over an external ring>
##   gap> Display( H );
##   2*x,     3*x^2, y,z,  -6*a*y^2,-2*z^2,2*x,0,  
##   1,       y,     0,a*b,0,       2*x,   0,  0,  
##   -3*a*y^2,-z^2,  x,0,  -y^3,    0,     0,  0,  
##   0,       x,     0,0,  0,       0,     1,  b*x,
##   0,       -2*y*z,0,x,  -3*a*y^2,-z^2,  x+1,0,  
##   0,       0,     0,0,  0,       x,     1,  -a*x
##  ]]></Example>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallMethod( Diff,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( D, N )
    local R, RP, diff;
    
    R := HomalgRing( D );
    
    if not IsIdenticalObj( R, HomalgRing( N ) ) then
        Error( "the two matrices must be defined over identically the same ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.Diff) then
        diff := RP!.Diff( D, N );	## the external object
        diff := HomalgMatrix( diff, NrRows( D ) * NrRows( N ), NrColumns( D ) * NrColumns( N ), R );
        return diff;
    fi;
    
    if not IsHomalgInternalRingRep( R ) then
        Error( "could not find a procedure called Diff ",
               "in the homalgTable of the non-internal ring\n" );
    fi;
    
    TryNextMethod( );
    
end );


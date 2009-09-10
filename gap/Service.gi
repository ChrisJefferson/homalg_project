#############################################################################
##
##  Service.gi                  homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg service procedures.
##
#############################################################################

####################################
#
# functions:
#
####################################

InstallGlobalFunction( ColoredInfoForService,
  function( arg )
    local nargs, l, color, s;
    
    nargs := Length( arg );
    
    l := arg[2];
    
    if l{[1]} = "T" then
        l := 4;
        color := HOMALG.color_BOT;
    elif l{[1]} = "B" then
        l := 3;
        color := HOMALG.color_BOB;
    elif l{[1 .. 8]} = "ReducedB" then
        l := 3;
        color := HOMALG.color_BOB;
    elif l{[1]} = "D" then
        l := 2;
        color := HOMALG.color_BOD;
    elif l{[1]} = "S" then
        l := 2;
        color := HOMALG.color_BOH;
    elif l{[1 .. 8]} = "ReducedS" then
        l := 2;
        color := HOMALG.color_BOH;
    fi;
    
    if arg[1] = "busy" then
        
        s := Concatenation( HOMALG.color_busy, "BUSY>\033[0m ", color );
        
        s := Concatenation( s, arg[2], "\033[0m \033[7m", color );
        
        Append( s, Concatenation( List( arg{[3..nargs]}, function( a ) if IsStringRep( a ) then return a; else return String( a ); fi; end ) ) );
        
        s := Concatenation( s, "\033[0m " );
        
        if l < 4 then
            Info( InfoHomalgBasicOperations, l , "" );
        fi;
        
        Info( InfoHomalgBasicOperations, l, s );
    
    else
        
        s := Concatenation( HOMALG.color_done, "<DONE\033[0m ", color );
        
        s := Concatenation( s, arg[2], "\033[0m \033[7m", color );
        
        Append( s, Concatenation( List( arg{[3..nargs]}, function( a ) if IsStringRep( a ) then return a; else return String( a ); fi; end ) ) );
        
        s := Concatenation( s, "\033[0m ", "	in ", homalgTotalRuntimes( arg[1] ) );
        
        Info( InfoHomalgBasicOperations, l, s );
    
        if l < 4 then
            Info( InfoHomalgBasicOperations, l , "" );
        fi;
        
    fi;
    
end );

####################################
#
# methods for operations:
#
####################################

################################################################
##
## CAUTION: !!!
##
## the following procedures never take ring relations into
## account; the user should call the following higher level
## procedures instead:
## . BasisOfRows/Columns
## . DecideZero
## . SyzygiesOfRows/Columns
## . ReducedSyzygiesOfRows/Columns
##
################################################################

##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, B;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    ColoredInfoForService( "busy", "TriangularBasisOfRows", NrRows( M ), " x ", NrColumns( M ) );
    
    t := homalgTotalRuntimes( );
    
    if IsBound(RP!.TriangularBasisOfRows) then
        
        B := RP!.TriangularBasisOfRows( M );
        
        ColoredInfoForService( t, "TriangularBasisOfRows", Length( NonZeroRows( B ) ) );
        
        return B;
        
    elif IsBound(RP!.TriangularBasisOfColumns) then
        
        B := Involution( RP!.TriangularBasisOfColumns( Involution( M ) ) );
        
        ColoredInfoForService( t, "TriangularBasisOfRows", Length( NonZeroRows( B ) ) );
        
        return B;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( TriangularBasisOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R, RP, t, TI, B;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    ColoredInfoForService( "busy", "TriangularBasisOfRows (M,T)", NrRows( M ), " x ", NrColumns( M ) );
    
    t := homalgTotalRuntimes( );
    
    if IsBound(RP!.TriangularBasisOfRows) then
        
        B := RP!.TriangularBasisOfRows( M, T );
        
        ColoredInfoForService( t, "TriangularBasisOfRows (M,T)", Length( NonZeroRows( B ) ) );
        
        return B;
        
    elif IsBound(RP!.TriangularBasisOfColumns) then
        
        TI := HomalgVoidMatrix( R );
        
        B := Involution( RP!.TriangularBasisOfColumns( Involution( M ), TI ) );
        
        ColoredInfoForService( t, "TriangularBasisOfRows (M,T)", Length( NonZeroRows( B ) ) );
        
        SetPreEval( T, Involution( TI ) ); ResetFilterObj( T, IsVoidMatrix );
        
        return B;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, B;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.TriangularBasisOfColumns) then
        
        t := homalgTotalRuntimes( );
        
        ColoredInfoForService( "busy", "TriangularBasisOfColumns", NrRows( M ), " x ", NrColumns( M ) );
        
        B := RP!.TriangularBasisOfColumns( M );
        
        ColoredInfoForService( t, "TriangularBasisOfColumns", Length( NonZeroColumns( B ) ) );
        
        return B;
        
    fi;
    
    B := Involution( TriangularBasisOfRows( Involution( M ) ) );
    
    return B;
    
end );

##
InstallMethod( TriangularBasisOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R, RP, t, TI, B;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.TriangularBasisOfColumns) then
        
        t := homalgTotalRuntimes( );
        
        ColoredInfoForService( "busy", "TriangularBasisOfColumns (M,T)", NrRows( M ), " x ", NrColumns( M ) );
        
        B := RP!.TriangularBasisOfColumns( M, T );
        
        ColoredInfoForService( t, "TriangularBasisOfColumns (M,T)", Length( NonZeroColumns( B ) ) );
        
        return B;
        
    fi;
    
    TI := HomalgVoidMatrix( R );
    
    B := Involution( TriangularBasisOfRows( Involution( M ), TI ) );
    
    SetPreEval( T, Involution( TI ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return B;
    
end );

#### could become lazy

##
InstallMethod( BasisOfRowModule,		### defines: BasisOfRowModule (BasisOfModule (low-level))
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, nr, MI, B, nz;
    
    if IsBound(M!.BasisOfRowModule) then
        return M!.BasisOfRowModule;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrColumns( M );
    
    ColoredInfoForService( "busy", "BasisOfRowModule", NrRows( M ), " x ", nr );
    
    if IsBound(RP!.BasisOfRowModule) then
        
        B := RP!.BasisOfRowModule( M );
        
        if HasRowRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        M!.BasisOfRowModule := B;
        
        ColoredInfoForService( t, "BasisOfRowModule", NrRows( B ) );
        
        IncreaseRingStatistics( R, "BasisOfRowModule" );
        
        return B;
        
    elif IsBound(RP!.BasisOfColumnModule) then
        
        MI := Involution( M );
        
        B := RP!.BasisOfColumnModule( MI );
        
        if HasColumnRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        MI!.BasisOfColumnModule := B;
        
        B := Involution( B );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        M!.BasisOfRowModule := B;
        
        ColoredInfoForService( t, "BasisOfRowModule", NrRows( B ) );
        
        DecreaseRingStatistics( R, "BasisOfRowModule" );
        
        IncreaseRingStatistics( R, "BasisOfColumnModule" );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    B := TriangularBasisOfRows( M );
    
    nz := Length( NonZeroRows( B ) );
    
    if nz = 0 then
        B := HomalgZeroMatrix( 0, NrColumns( B ), R );
    else
        B := CertainRows( B, [ 1 .. nz ] );
    fi;
    
    SetIsBasisOfRowsMatrix( B, true );
    
    M!.BasisOfRowModule := B;
    
    ColoredInfoForService( t, "BasisOfRowModule", NrRows( B ) );
    
    IncreaseRingStatistics( R, "BasisOfRowModule" );
    
    return B;
    
end );

##
InstallMethod( BasisOfColumnModule,		### defines: BasisOfColumnModule (BasisOfModule (low-level))
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, nr, MI, B, nz;
    
    if IsBound(M!.BasisOfColumnModule) then
        return M!.BasisOfColumnModule;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrRows( M );
    
    ColoredInfoForService( "busy", "BasisOfColumnModule", nr, " x ", NrColumns( M ) );
    
    if IsBound(RP!.BasisOfColumnModule) then
        
        B := RP!.BasisOfColumnModule( M );
        
        if HasColumnRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        M!.BasisOfColumnModule := B;
        
        ColoredInfoForService( t, "BasisOfColumnModule", NrColumns( B ) );
        
        IncreaseRingStatistics( R, "BasisOfColumnModule" );
        
        return B;
        
    elif IsBound(RP!.BasisOfRowModule) then
        
        MI := Involution( M );
        
        B := RP!.BasisOfRowModule( MI );
        
        if HasRowRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        MI!.BasisOfRowModule := B;
        
        B := Involution( B );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        M!.BasisOfColumnModule := B;
        
        ColoredInfoForService( t, "BasisOfColumnModule", NrColumns( B ) );
        
        DecreaseRingStatistics( R, "BasisOfColumnModule" );
        
        IncreaseRingStatistics( R, "BasisOfRowModule" );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    B := TriangularBasisOfColumns( M );
    
    nz := Length( NonZeroColumns( B ) );
    
    if nz = 0 then
        B := HomalgZeroMatrix( NrRows( B ), 0, R );
    else
        B := CertainColumns( B, [ 1 .. nz ] );
    fi;
    
    SetIsBasisOfColumnsMatrix( B, true );
    
    M!.BasisOfColumnModule := B;
    
    ColoredInfoForService( t, "BasisOfColumnModule", NrColumns( B ) );
    
    IncreaseRingStatistics( R, "BasisOfColumnModule" );
    
    return B;
    
end );

##
InstallMethod( DecideZeroRows,			### defines: DecideZeroRows (Reduce)
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( A, B )
    local R, RP, t, l, m, n, id, zz, M, C;
    
    R := HomalgRing( B );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    l := NrRows( A );
    m := NrColumns( A );
    
    ColoredInfoForService( "busy", "DecideZeroRows", "( ", l, " + ", NrRows( B ), " ) x ", m );
    
    if IsBound(RP!.DecideZeroRows) then
        
        C := RP!.DecideZeroRows( A, B );
        
        SetNrRows( C, l ); SetNrColumns( C, m );
        
        ColoredInfoForService( t, "DecideZeroRows" );
        
        IncreaseRingStatistics( R, "DecideZeroRows" );
        
        return C;
        
    elif IsBound(RP!.DecideZeroColumns) then
        
        C := RP!.DecideZeroColumns( Involution( A ), Involution( B ) );
        
        SetNrRows( C, m ); SetNrColumns( C, l );
        
        C := Involution( C );
        
        ColoredInfoForService( t, "DecideZeroRows" );
        
        DecreaseRingStatistics( R, "DecideZeroRows" );
        
        IncreaseRingStatistics( R, "DecideZeroColumns" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    n := NrRows( B );
    
    if HasIsIdentityMatrix( A ) and IsIdentityMatrix( A ) then ## save as much new definitions as possible
        id := A;
    else
        id := HomalgIdentityMatrix( l, R );
    fi;
    
    zz := HomalgZeroMatrix( n, l, R );
    
    M := UnionOfRows( UnionOfColumns( id, A ), UnionOfColumns( zz, B ) );
    
    M := TriangularBasisOfRows( M );
    
    C := CertainRows( CertainColumns( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    ColoredInfoForService( t, "DecideZeroRows" );
    
    IncreaseRingStatistics( R, "DecideZeroRows" );
    
    return C;
    
end );

##
InstallMethod( DecideZeroColumns,		### defines: DecideZeroColumns (Reduce)
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( A, B )
    local R, RP, t, l, m, n, id, zz, M, C;
    
    R := HomalgRing( B );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    l := NrColumns( A );
    m := NrRows( A );
    
    ColoredInfoForService( "busy", "DecideZeroColumns", m, " x ( ", l, " + ", NrColumns( B ), " )" );
    
    if IsBound(RP!.DecideZeroColumns) then
        
        C := RP!.DecideZeroColumns( A, B );
        
        SetNrRows( C, m ); SetNrColumns( C, l );
        
        ColoredInfoForService( t, "DecideZeroColumns" );
        
        IncreaseRingStatistics( R, "DecideZeroColumns" );
        
        return C;
        
    elif IsBound(RP!.DecideZeroRows) then
        
        C := RP!.DecideZeroRows( Involution( A ), Involution( B ) );
        
        SetNrRows( C, l ); SetNrColumns( C, m );
        
        C := Involution( C );
        
        ColoredInfoForService( t, "DecideZeroColumns" );
        
        DecreaseRingStatistics( R, "DecideZeroColumns" );
        
        IncreaseRingStatistics( R, "DecideZeroRows" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    n := NrColumns( B );
    
    if HasIsIdentityMatrix( A ) and IsIdentityMatrix( A ) then ## save as much new definitions as possible
        id := A;
    else
        id := HomalgIdentityMatrix( l, R );
    fi;
    
    zz := HomalgZeroMatrix( l, n, R );
    
    M := UnionOfColumns( UnionOfRows( id, A ), UnionOfRows( zz, B ) );
    
    M := TriangularBasisOfColumns( M );
    
    C := CertainColumns( CertainRows( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    ColoredInfoForService( t, "DecideZeroColumns" );
    
    IncreaseRingStatistics( R, "DecideZeroColumns" );
    
    return C;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, C, B, nz;
    
    if IsBound(M!.SyzygiesGeneratorsOfRows) then
        return M!.SyzygiesGeneratorsOfRows;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "SyzygiesGeneratorsOfRows", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.SyzygiesGeneratorsOfRows) then
        
        C := RP!.SyzygiesGeneratorsOfRows( M );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsLeftRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.SyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        return C;
        
    elif IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        
        C := Involution( RP!.SyzygiesGeneratorsOfColumns( Involution( M ) ) );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsLeftRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.SyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
        
        DecreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    C := HomalgVoidMatrix( R );
    
    B := TriangularBasisOfRows( M, C );
    
    nz := Length( NonZeroRows( B ) );
    
    C := CertainRows( C, [ nz + 1 .. NrRows( C ) ] );
    
    if IsZero( C ) then
        
        ## the procedure we are in now is the one of the ambient ring
        ## which does not take ring relations into account
        if not HasRingRelations( R ) then
            SetIsLeftRegularMatrix( M, true );
        fi;
        
        C := HomalgZeroMatrix( 0, NrRows( M ), R );
        
    fi;
    
    M!.SyzygiesGeneratorsOfRows := C;
    
    ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
    
    IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
    
    return C;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,	### defines: SyzygiesGeneratorsOfRows (SyzygiesGenerators)
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP, t, M, C, nz;
    
    R := HomalgRing( M1 );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "SyzygiesGeneratorsOfRows", "( ", NrRows( M1 ), " + ", NrRows( M2 ), " ) x ", NrColumns( M1 ) );
    
    if IsBound(RP!.SyzygiesGeneratorsOfRows) then
        
        C := RP!.SyzygiesGeneratorsOfRows( M1, M2 );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( 0, NrRows( M1 ), R );
            
        else
            
            SetNrColumns( C, NrRows( M1 ) );
            
        fi;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        return C;
        
    elif IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        
        C := Involution( RP!.SyzygiesGeneratorsOfColumns( Involution( M1 ), Involution( M2 ) ) );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( 0, NrRows( M1 ), R );
            
        else
            
            SetNrColumns( C, NrRows( M1 ) );
            
        fi;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
        
        DecreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    M := UnionOfRows( M1, M2 );
    
    C := HomalgVoidMatrix( R );
    
    M := TriangularBasisOfRows( M, C );
    
    nz := Length( NonZeroRows( M ) );
    
    C := CertainColumns( CertainRows( C, [ nz + 1 .. NrRows( C ) ] ), [ 1 .. NrRows( M1 ) ] );
    
    if IsZero( C ) then
        
        C := HomalgZeroMatrix( 0, NrRows( M1 ), R );
        
    fi;
    
    ColoredInfoForService( t, "SyzygiesGeneratorsOfRows", NrRows( C ) );
    
    IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
    
    return C;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, C, B, nz;
    
    if IsBound(M!.SyzygiesGeneratorsOfColumns) then
        return M!.SyzygiesGeneratorsOfColumns;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "SyzygiesGeneratorsOfColumns", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        
        C := RP!.SyzygiesGeneratorsOfColumns( M );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsRightRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.SyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        return C;
        
    elif IsBound(RP!.SyzygiesGeneratorsOfRows) then
        
        C := Involution( RP!.SyzygiesGeneratorsOfRows( Involution( M ) ) );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsRightRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.SyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        DecreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    C := HomalgVoidMatrix( R );
    
    B := TriangularBasisOfColumns( M, C );
    
    nz := Length( NonZeroColumns( B ) );
    
    C := CertainColumns( C, [ nz + 1 .. NrColumns( C ) ] );
    
    if IsZero( C ) then
        
        ## the procedure we are in now is the one of the ambient ring
        ## which does not take ring relations into account
        if not HasRingRelations( R ) then
            SetIsRightRegularMatrix( M, true );
        fi;
        
        C := HomalgZeroMatrix( NrColumns( M ), 0, R );
        
    fi;
    
    M!.SyzygiesGeneratorsOfColumns := C;
    
    ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
    
    IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
    
    return C;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,	### defines: SyzygiesGeneratorsOfColumns (SyzygiesGenerators)
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP, t, M, C, nz;
    
    R := HomalgRing( M1 );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "SyzygiesGeneratorsOfColumns", NrRows( M1 ), " x ( ", NrColumns( M1 ), " + ", NrColumns( M2 ), " )" );
    
    if IsBound(RP!.SyzygiesGeneratorsOfColumns) then
        
        C := RP!.SyzygiesGeneratorsOfColumns( M1, M2 );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( NrColumns( M1 ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M1 ) );
            
        fi;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        return C;
        
    elif IsBound(RP!.SyzygiesGeneratorsOfRows) then
        
        C := Involution( RP!.SyzygiesGeneratorsOfRows( Involution( M1 ), Involution( M2 ) ) );
        
        if IsZero( C ) then
            
            C := HomalgZeroMatrix( NrColumns( M1 ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M1 ) );
            
        fi;
        
        ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        DecreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
        
        IncreaseRingStatistics( R, "SyzygiesGeneratorsOfRows" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    M := UnionOfColumns( M1, M2 );
    
    C := HomalgVoidMatrix( R );
    
    M := TriangularBasisOfColumns( M, C );
    
    nz := Length( NonZeroColumns( M ) );
    
    C := CertainRows( CertainColumns( C, [ nz + 1 .. NrColumns( C ) ] ), [ 1 .. NrColumns( M1 ) ] );
    
    if IsZero( C ) then
        
        C := HomalgZeroMatrix( NrColumns( M1 ), 0, R );
        
    fi;
    
    ColoredInfoForService( t, "SyzygiesGeneratorsOfColumns", NrColumns( C ) );
    
    IncreaseRingStatistics( R, "SyzygiesGeneratorsOfColumns" );
    
    return C;
    
end );

#### Reduced:

##
InstallMethod( ReducedBasisOfRowModule,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, nr, MI, B, S, unit_pos;
    
    if IsBound(M!.ReducedBasisOfRowModule) then
        return M!.ReducedBasisOfRowModule;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrColumns( M );
    
    ColoredInfoForService( "busy", "ReducedBasisOfRowModule", NrRows( M ), " x ", nr );
    
    if IsBound(RP!.ReducedBasisOfRowModule) then
        
        B := RP!.ReducedBasisOfRowModule( M );
        
        if HasRowRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsReducedBasisOfRowsMatrix( B, true );
        
        M!.ReducedBasisOfRowModule := B;
        
        ColoredInfoForService( t, "ReducedBasisOfRowModule", NrRows( B ) );
        
        IncreaseRingStatistics( R, "ReducedBasisOfRowModule" );
        
        return B;
        
    elif IsBound(RP!.ReducedBasisOfColumnModule) then
        
        MI := Involution( M );
        
        B := RP!.ReducedBasisOfColumnModule( MI );
        
        if HasColumnRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsReducedBasisOfColumnsMatrix( B, true );
        
        MI!.ReducedBasisOfColumnModule := B;
        
        B := Involution( B );
        
        SetIsReducedBasisOfRowsMatrix( B, true );
        
        M!.ReducedBasisOfRowModule := B;
        
        ColoredInfoForService( t, "ReducedBasisOfRowModule", NrRows( B ) );
        
        DecreaseRingStatistics( R, "ReducedBasisOfRowModule" );
        
        IncreaseRingStatistics( R, "ReducedBasisOfColumnModule" );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    B := M;
    
    ## iterate the syzygy trick
    while true do
        S := SyzygiesGeneratorsOfRows( B );
        
        unit_pos := GetColumnIndependentUnitPositions( S );
        unit_pos := List( unit_pos, a -> a[2] );
        
        if NrRows( S ) = 0 or unit_pos = [ ] then
            break;
        fi;
        
        B := CertainRows( B, Filtered( [ 1 .. NrRows( B ) ], j -> not j in unit_pos ) );
    od;
    
    SetIsReducedBasisOfRowsMatrix( B, true );
    
    M!.ReducedBasisOfRowModule := B;
    
    ColoredInfoForService( t, "ReducedBasisOfRowModule", NrRows( B ) );
    
    DecreaseRingStatistics( R, "ReducedBasisOfRowModule" );
    
    return B;
    
end );

##
InstallMethod( ReducedBasisOfColumnModule,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, nr, MI, B, S, unit_pos;
    
    if IsBound(M!.ReducedBasisOfColumnModule) then
        return M!.ReducedBasisOfColumnModule;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrRows( M );
    
    ColoredInfoForService( "busy", "ReducedBasisOfColumnModule", nr, " x ", NrColumns( M ) );
    
    if IsBound(RP!.ReducedBasisOfColumnModule) then
        
        B := RP!.ReducedBasisOfColumnModule( M );
        
        if HasColumnRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsReducedBasisOfColumnsMatrix( B, true );
        
        M!.ReducedBasisOfColumnModule := B;
        
        ColoredInfoForService( t, "ReducedBasisOfColumnModule", NrColumns( B ) );
        
        IncreaseRingStatistics( R, "ReducedBasisOfColumnModule" );
        
        return B;
        
    elif IsBound(RP!.ReducedBasisOfRowModule) then
        
        MI := Involution( M );
        
        B := RP!.ReducedBasisOfRowModule( MI );
        
        if HasRowRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsReducedBasisOfRowsMatrix( B, true );
        
        MI!.ReducedBasisOfRowModule := B;
        
        B := Involution( B );
        
        SetIsReducedBasisOfColumnsMatrix( B, true );
        
        M!.ReducedBasisOfColumnModule := B;
        
        ColoredInfoForService( t, "ReducedBasisOfColumnModule", NrColumns( B ) );
        
        DecreaseRingStatistics( R, "ReducedBasisOfColumnModule" );
        
        IncreaseRingStatistics( R, "ReducedBasisOfRowModule" );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    B := M;
    
    ## iterate the syzygy trick
    while true do
        S := SyzygiesGeneratorsOfColumns( B );
        
        unit_pos := GetRowIndependentUnitPositions( S );
        unit_pos := List( unit_pos, a -> a[2] );
        
        if NrColumns( S ) = 0 or unit_pos = [ ] then
            break;
        fi;
        
        B := CertainColumns( B, Filtered( [ 1 .. NrColumns( B ) ], j -> not j in unit_pos ) );
    od;
    
    SetIsReducedBasisOfColumnsMatrix( B, true );
    
    M!.ReducedBasisOfColumnModule := B;
    
    ColoredInfoForService( t, "ReducedBasisOfColumnModule", NrColumns( B ) );
    
    DecreaseRingStatistics( R, "ReducedBasisOfColumnModule" );
    
    return B;
    
end );

##
InstallMethod( ReducedSyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, C, B, nz;
    
    if IsBound(M!.ReducedSyzygiesGeneratorsOfRows) then
        return M!.ReducedSyzygiesGeneratorsOfRows;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "ReducedSyzygiesGeneratorsOfRows", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.ReducedSyzygiesGeneratorsOfRows) then
        
        C := RP!.ReducedSyzygiesGeneratorsOfRows( M );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsLeftRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.ReducedSyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfRows", NrRows( C ) );
        
        IncreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfRows" );
        
        return C;
        
    elif IsBound(RP!.ReducedSyzygiesGeneratorsOfColumns) then
        
        C := Involution( RP!.ReducedSyzygiesGeneratorsOfColumns( Involution( M ) ) );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsLeftRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( 0, NrRows( M ), R );
            
        else
            
            SetNrColumns( C, NrRows( M ) );
            
        fi;
        
        M!.ReducedSyzygiesGeneratorsOfRows := C;
        
        ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfRows", NrRows( C ) );
        
        DecreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfRows" );
        
        IncreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfColumns" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    C := SyzygiesGeneratorsOfRows( M );
    
    C := ReducedBasisOfRowModule( C );	## a priori computing a basis of C causes obsolete computations, at least in general
    
    M!.ReducedSyzygiesGeneratorsOfRows := C;
    
    ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfRows", NrRows( C ) );
    
    DecreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfRows" );
    
    return C;
    
end );

##
InstallMethod( ReducedSyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, t, C, B, nz;
    
    if IsBound(M!.ReducedSyzygiesGeneratorsOfColumns) then
        return M!.ReducedSyzygiesGeneratorsOfColumns;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "ReducedSyzygiesGeneratorsOfColumns", NrRows( M ), " x ", NrColumns( M ) );
    
    if IsBound(RP!.ReducedSyzygiesGeneratorsOfColumns) then
        
        C := RP!.ReducedSyzygiesGeneratorsOfColumns( M );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsRightRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.ReducedSyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        IncreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfColumns" );
        
        return C;
        
    elif IsBound(RP!.ReducedSyzygiesGeneratorsOfRows) then
        
        C := Involution( RP!.ReducedSyzygiesGeneratorsOfRows( Involution( M ) ) );
        
        if IsZero( C ) then
            
            ## the procedure we are in now is the one of the ambient ring
            ## which does not take ring relations into account
            if not HasRingRelations( R ) then
                SetIsRightRegularMatrix( M, true );
            fi;
            
            C := HomalgZeroMatrix( NrColumns( M ), 0, R );
            
        else
            
            SetNrRows( C, NrColumns( M ) );
            
        fi;
        
        M!.ReducedSyzygiesGeneratorsOfColumns := C;
        
        ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfColumns", NrColumns( C ) );
        
        DecreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfColumns" );
        
        IncreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfRows" );
        
        return C;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    C := SyzygiesGeneratorsOfColumns( M );
    
    C := ReducedBasisOfColumnModule( C );	## a priori computing a basis of C causes obsolete computations, at least in general
    
    M!.ReducedSyzygiesGeneratorsOfColumns := C;
    
    ColoredInfoForService( t, "ReducedSyzygiesGeneratorsOfColumns", NrColumns( C ) );
    
    DecreaseRingStatistics( R, "ReducedSyzygiesGeneratorsOfColumns" );
    
    return C;
    
end );

#### Effectively:

##
InstallMethod( BasisOfRowsCoeff,		### defines: BasisOfRowsCoeff (BasisCoeff)
        "for a homalg matrix",
        [ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R, RP, t, nr, TI, MI, B, TT, nz;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrColumns( M );
    
    ColoredInfoForService( "busy", "BasisOfRowsCoeff", NrRows( M ), " x ", nr );
    
    if IsBound(RP!.BasisOfRowsCoeff) then
        
        B := RP!.BasisOfRowsCoeff( M, T ); ResetFilterObj( T, IsVoidMatrix );
        
        if HasRowRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        M!.BasisOfRowModule := B;
        
        ColoredInfoForService( t, "BasisOfRowsCoeff", nr );
        
        IncreaseRingStatistics( R, "BasisOfRowsCoeff" );
        
        nr := NrRows( B );
        
        SetNrRows( T, nr );
        
        ## check assertion
        Assert( 4, B = T * M );
        
        return B;
        
    elif IsBound(RP!.BasisOfColumnsCoeff) then
        
        TI := HomalgVoidMatrix( R );
        
        MI := Involution( M );
        
        B := RP!.BasisOfColumnsCoeff( MI, TI ); ResetFilterObj( TI, IsVoidMatrix );
        
        if HasColumnRankOfMatrix( B ) then
            SetRowRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        MI!.BasisOfColumnModule := B;
        
        B := Involution( B );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        M!.BasisOfRowModule := B;
        
        ColoredInfoForService( t, "BasisOfRowsCoeff", nr );
        
        DecreaseRingStatistics( R, "BasisOfRowsCoeff" );
        
        IncreaseRingStatistics( R, "BasisOfColumnsCoeff" );
        
        SetEvalInvolution( T, TI ); ResetFilterObj( T, IsVoidMatrix );
        
        nr := NrRows( B );
        
        SetNrRows( T, nr );
        
        SetNrColumns( TI, nr );
        
        ## check assertion
        Assert( 4, B = T * M );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    TT := HomalgVoidMatrix( R );
    
    B := TriangularBasisOfRows( M, TT );
    
    nz := Length( NonZeroRows( B ) );
    
    if nz = 0 then
        B := HomalgZeroMatrix( 0, NrColumns( B ), R );
    else
        B := CertainRows( B, [ 1 .. nz ] );
    fi;
    
    ## B = T * M;
    SetPreEval( T, CertainRows( TT, [ 1 .. nz ] ) ); ResetFilterObj( T, IsVoidMatrix );
    
    ColoredInfoForService( t, "BasisOfRowsCoeff", NrRows( B ) );
    
    IncreaseRingStatistics( R, "BasisOfRowsCoeff" );
    
    ## check assertion
    Assert( 4, B = T * M );
    
    return B;
    
end );

##
InstallMethod( BasisOfColumnsCoeff,		### defines: BasisOfColumnsCoeff (BasisCoeff)
        "for a homalg matrix",
        [ IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R, RP, t, nr, TI, MI, B, TT, nz;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    nr := NrRows( M );
    
    ColoredInfoForService( "busy", "BasisOfColumnsCoeff", nr, " x ", NrColumns( M ) );
    
    if IsBound(RP!.BasisOfColumnsCoeff) then
        
        B := RP!.BasisOfColumnsCoeff( M, T ); ResetFilterObj( T, IsVoidMatrix );
        
        if HasColumnRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, ColumnRankOfMatrix( B ) );
        fi;
        
        SetNrRows( B, nr );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        M!.BasisOfColumnModule := B;
        
        ColoredInfoForService( t, "BasisOfColumnsCoeff", nr );
        
        IncreaseRingStatistics( R, "BasisOfColumnsCoeff" );
        
        nr := NrColumns( B );
        
        SetNrColumns( T, nr );
        
        ## check assertion
        Assert( 4, B = M * T );
        
        return B;
        
    elif IsBound(RP!.BasisOfRowsCoeff) then
        
        TI := HomalgVoidMatrix( R );
        
        MI := Involution( M );
        
        B := RP!.BasisOfRowsCoeff( MI, TI ); ResetFilterObj( TI, IsVoidMatrix );
        
        if HasRowRankOfMatrix( B ) then
            SetColumnRankOfMatrix( M, RowRankOfMatrix( B ) );
        fi;
        
        SetNrColumns( B, nr );
        
        SetIsBasisOfRowsMatrix( B, true );
        
        MI!.BasisOfRowModule := B;
        
        B := Involution( B );
        
        SetIsBasisOfColumnsMatrix( B, true );
        
        M!.BasisOfColumnModule := B;
        
        ColoredInfoForService( t, "BasisOfColumnsCoeff", nr );
        
        DecreaseRingStatistics( R, "BasisOfColumnsCoeff" );
        
        IncreaseRingStatistics( R, "BasisOfRowsCoeff" );
        
        SetEvalInvolution( T, TI ); ResetFilterObj( T, IsVoidMatrix );
        
        nr := NrColumns( B );
        
        SetNrColumns( T, nr );
        
        SetNrRows( TI, nr );
        
        ## check assertion
        Assert( 4, B = M * T );
        
        return B;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    TT := HomalgVoidMatrix( R );
    
    B := TriangularBasisOfColumns( M, TT );
    
    nz := Length( NonZeroColumns( B ) );
    
    if nz = 0 then
        B := HomalgZeroMatrix( NrRows( B ), 0, R );
    else
        B := CertainColumns( B, [ 1 .. nz ] );
    fi;
    
    SetPreEval( T, CertainColumns( TT, [ 1 .. nz ] ) ); ResetFilterObj( T, IsVoidMatrix );
    
    ColoredInfoForService( t, "BasisOfColumnsCoeff", NrColumns( B ) );
    
    IncreaseRingStatistics( R, "BasisOfColumnsCoeff" );
    
    ## check assertion
    Assert( 4, B = M * T );
    
    return B;
    
end );

##
InstallMethod( DecideZeroRowsEffectively,	### defines: DecideZeroRowsEffectively (ReduceCoeff)
        "for a homalg matrix",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( A, B, T )
    local R, RP, t, TI, l, m, n, id, zz, M, TT, MM;
    
    SetNrRows( T, NrRows( A ) );
    SetNrColumns( T, NrRows( B ) );
    
    R := HomalgRing( B );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "DecideZeroRowsEffectively", "( ", NrRows( A ), " + ", NrRows( B ), " ) x ", NrColumns( A ) );
    
    if IsBound(RP!.DecideZeroRowsEffectively) then
        
        M := RP!.DecideZeroRowsEffectively( A, B, T ); ResetFilterObj( T, IsVoidMatrix );
        
        ColoredInfoForService( t, "DecideZeroRowsEffectively" );
        
        IncreaseRingStatistics( R, "DecideZeroRowsEffectively" );
        
        ## check assertion
        Assert( 4, M = A + T * B );
        
        return M;
        
    elif IsBound(RP!.DecideZeroColumnsEffectively) then
        
        TI := HomalgVoidMatrix( R );
        
        M := Involution( RP!.DecideZeroColumnsEffectively( Involution( A ), Involution( B ), TI ) );
        
        SetEvalInvolution( T, TI ); ResetFilterObj( T, IsVoidMatrix ); ResetFilterObj( TI, IsVoidMatrix );
        
        ColoredInfoForService( t, "DecideZeroRowsEffectively" );
        
        DecreaseRingStatistics( R, "DecideZeroRowsEffectively" );
        
        IncreaseRingStatistics( R, "DecideZeroColumnsEffectively" );
        
        ## check assertion
        Assert( 4, M = A + T * B );
        
        return M;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    l := NrRows( A );
    m := NrColumns( A );
    
    n := NrRows( B );
    
    if HasIsIdentityMatrix( A ) and IsIdentityMatrix( A ) then ## save as much new definitions as possible
        id := A;
    else
        id := HomalgIdentityMatrix( l, R );
    fi;
    
    zz := HomalgZeroMatrix( n, l, R );
    
    M := UnionOfRows( UnionOfColumns( id, A ), UnionOfColumns( zz, B ) );
    
    TT := HomalgVoidMatrix( R );
    
    M := TriangularBasisOfRows( M, TT );
    
    M := CertainRows( CertainColumns( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    TT := CertainColumns( CertainRows( TT, [ 1 .. l ] ), [ l + 1 .. l + n ] );
    
    SetPreEval( T, TT ); ResetFilterObj( T, IsVoidMatrix );
    
    ColoredInfoForService( t, "DecideZeroRowsEffectively" );
    
    IncreaseRingStatistics( R, "DecideZeroRowsEffectively" );
    
    ## check assertion
    Assert( 4, M = A + T * B );
    
    return M;
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,	### defines: DecideZeroColumnsEffectively (ReduceCoeff)
        "for a homalg matrix",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( A, B, T )
    local R, RP, t, TI, l, m, n, id, zz, M, TT;
    
    SetNrColumns( T, NrColumns( A ) );
    SetNrRows( T, NrColumns( B ) );
    
    R := HomalgRing( B );
    
    RP := homalgTable( R );
    
    t := homalgTotalRuntimes( );
    
    ColoredInfoForService( "busy", "DecideZeroColumnsEffectively", NrRows( A ), " x ( ", NrColumns( A ), " + ", NrColumns( B ), " )" );
    
    if IsBound(RP!.DecideZeroColumnsEffectively) then
        
        M := RP!.DecideZeroColumnsEffectively( A, B, T ); ResetFilterObj( T, IsVoidMatrix );
        
        ColoredInfoForService( t, "DecideZeroColumnsEffectively" );
        
        IncreaseRingStatistics( R, "DecideZeroColumnsEffectively" );
        
        ## check assertion
        Assert( 4, M = A + B * T );
        
        return M;
        
    elif IsBound(RP!.DecideZeroRowsEffectively) then
        
        TI := HomalgVoidMatrix( R );
        
        M := Involution( RP!.DecideZeroRowsEffectively( Involution( A ), Involution( B ), TI ) );
        
        SetEvalInvolution( T, TI ); ResetFilterObj( T, IsVoidMatrix ); ResetFilterObj( TI, IsVoidMatrix );
        
        ColoredInfoForService( t, "DecideZeroColumnsEffectively" );
        
        DecreaseRingStatistics( R, "DecideZeroColumnEffectively" );
        
        IncreaseRingStatistics( R, "DecideZeroRowsEffectively" );
        
        ## check assertion
        Assert( 4, M = A + B * T );
        
        return M;
        
    fi;
    
    #=====# begin of the core procedure #=====#
    
    l := NrColumns( A );
    m := NrRows( A );
    
    n := NrColumns( B );
    
    if HasIsIdentityMatrix( A ) and IsIdentityMatrix( A ) then ## save as much new definitions as possible
        id := A;
    else
        id := HomalgIdentityMatrix( l, R );
    fi;
    
    zz := HomalgZeroMatrix( l, n, R );
    
    M := UnionOfColumns( UnionOfRows( id, A ), UnionOfRows( zz, B ) );
    
    TT := HomalgVoidMatrix( R );
    
    M := TriangularBasisOfColumns( M, TT );
    
    M := CertainColumns( CertainRows( M, [ l + 1 .. l + m ] ), [ 1 .. l ] );
    
    TT := CertainRows( CertainColumns( TT, [ 1 .. l ] ), [ l + 1 .. l + n ] );
    
    SetPreEval( T, TT ); ResetFilterObj( T, IsVoidMatrix );
    
    ColoredInfoForService( t, "DecideZeroColumnsEffectively" );
    
    IncreaseRingStatistics( R, "DecideZeroColumnsEffectively" );
    
    ## check assertion
    Assert( 4, M = A + B * T );
    
    return M;
    
end );


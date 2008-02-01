#############################################################################
##
##  Basic.gi                    homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg basic procedures.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( BasisOfRowsCoeff,
        "for a homalg matrix",
	[ IsMatrixForHomalg ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfRowsCoeff) then
        return RP!.BasisOfRowsCoeff( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return BasisOfRows( AddRhs( M ) );
    
end );

##
InstallMethod( BasisOfColumnsCoeff,
        "for a homalg matrix",
	[ IsMatrixForHomalg ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfColumnsCoeff) then
        return RP!.BasisOfColumnsCoeff( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return BasisOfColumns( AddBts( M ) );
    
end );

##
InstallMethod( EffectivelyDecideZeroRows,
        "for a homalg matrix",
	[ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, RP, zz, A_zz;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroRows) then
        return RP!.EffectivelyDecideZeroRows( A, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    zz := MatrixForHomalg( "zero", NrRows( A ), NrRows( B ), R );
    
    A_zz := AddRhs( A, zz );
    
    return DecideZeroRows( A_zz, AddRhs( B ) );
    
end );

##
InstallMethod( EffectivelyDecideZeroColumns,
        "for a homalg matrix",
	[ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, RP, zz, A_zz;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroColumns) then
        return RP!.EffectivelyDecideZeroColumns( A, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    zz := MatrixForHomalg( "zero", NrColumns( B ), NrColumns( A ), R );
    
    A_zz := AddBts( A, zz );
    
    return DecideZeroColumns( A_zz, AddBts( B ) );
    
end );

##
InstallMethod( SyzygiesBasisOfRows,
        "for homalg matrices",
	[ IsMatrixForHomalg ],
        
  function( M )
    local R, RP, S;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfRows) then
        return RP!.SyzygiesBasisOfRows( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfRows( M, [ ] );
    
    return BasisOfRows( S );
    
end );

##
InstallMethod( SyzygiesBasisOfRows,
        "for homalg matrices",
	[ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( M1, M2 )
    local R, RP, S;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfRows) then
        return RP!.SyzygiesBasisOfRows( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfRows( M1, M2 );
    
    return BasisOfRows( S );
    
end );

##
InstallMethod( SyzygiesBasisOfColumns,
        "for homalg matrices",
	[ IsMatrixForHomalg ],
        
  function( M )
    local R, RP, S;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfColumns) then
        return RP!.SyzygiesBasisOfColumns( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfColumns( M, [ ] );
    
    return BasisOfColumns( S );
    
end );

##
InstallMethod( SyzygiesBasisOfColumns,
        "for homalg matrices",
	[ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( M1, M2 )
    local R, RP, S;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfColumns) then
        return RP!.SyzygiesBasisOfColumns( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfColumns( M1, M2 );
    
    return BasisOfColumns( S );
    
end );


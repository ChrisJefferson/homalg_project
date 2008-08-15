#############################################################################
##
##  LIMAT.gi                    LIMAT subpackage             Mohamed Barakat
##
##         LIMAT = Logical Implications for homalg MATrices
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for the LIMAT subpackage.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( LIMAT,
        rec(
            color := "\033[4;30;46m" )
        );

##
InstallValue( LogicalImplicationsForHomalgMatrices,
        [ ## logical implications for matrices
          
          [ IsEmptyMatrix,
            "implies", IsZero ],
          
          [ IsEmptyMatrix,
            "implies", IsSubidentityMatrix ],
          
          [ IsZero,
            "implies", IsReducedModuloRingRelations ],
          
          ## follows from the rest, but this gives a direct way
          [ IsZero,
            "implies", IsDiagonalMatrix ],
          
          [ IsZero,
            "implies", IsUpperStairCaseMatrix ],
          
          [ IsZero,
            "implies", IsLowerStairCaseMatrix ],
          
          [ IsZero,
            "implies", IsStrictUpperTriangularMatrix ],
          
          [ IsZero,
            "implies", IsStrictLowerTriangularMatrix ],
          
          [ IsIdentityMatrix,
            "implies", IsPermutationMatrix ],
          
          ## follows from the rest, but this gives a direct way
          [ IsIdentityMatrix,
            "implies", IsDiagonalMatrix ],
          
          [ IsIdentityMatrix,
            "implies", IsUpperStairCaseMatrix ],
          
          [ IsIdentityMatrix,
            "implies", IsLowerStairCaseMatrix ],
          
          [ IsSubidentityMatrix, "and", IsInvertibleMatrix,
            "imply", IsPermutationMatrix ],
          
          [ IsPermutationMatrix,
            "implies", IsInvertibleMatrix ],
          
          [ IsPermutationMatrix,
            "implies", IsSubidentityMatrix ],
          
          ## a split injective morphism (of free modules) is injective
          [ IsRightInvertibleMatrix,
            "implies", IsLeftRegularMatrix ],
          
          [ IsLeftInvertibleMatrix,
            "implies", IsRightRegularMatrix ],
          
          ## an isomorphism is split injective
          [ IsInvertibleMatrix,
            "implies", IsRightInvertibleMatrix ],
          
          ## an isomorphism is split surjective
          [ IsInvertibleMatrix,
            "implies", IsLeftInvertibleMatrix ],
          
          ## a split surjective and split injective morphism (of free modules) is an isomorphism
          [ IsLeftInvertibleMatrix, "and", IsRightInvertibleMatrix,
            "imply", IsInvertibleMatrix ],
          
          [ IsDiagonalMatrix,
            "implies", IsUpperTriangularMatrix ],
          
          [ IsDiagonalMatrix,
            "implies", IsLowerTriangularMatrix ],
          
          [ IsStrictUpperTriangularMatrix,
            "implies", IsUpperTriangularMatrix ],
          
          [ IsStrictLowerTriangularMatrix,
            "implies", IsLowerTriangularMatrix ],
          
          [ IsUpperStairCaseMatrix,
            "implies", IsUpperTriangularMatrix ],
          
          [ IsLowerStairCaseMatrix,
            "implies", IsLowerTriangularMatrix ],
          
          [ IsUpperTriangularMatrix,
            "implies", IsTriangularMatrix ],
          
          [ IsLowerTriangularMatrix,
            "implies", IsTriangularMatrix ],
          
          [ IsUpperTriangularMatrix, "and", IsLowerTriangularMatrix,
            "imply", IsDiagonalMatrix ],
          
          ] );

##
InstallValue( LogicalImplicationsForHomalgMatricesOverSpecialRings,
        [ ## logical implications for matrices over special rings
          
          ] );

####################################
#
# logical implications methods:
#
####################################

InstallLogicalImplicationsForHomalg( LogicalImplicationsForHomalgMatrices, IsHomalgMatrix );

InstallLogicalImplicationsForHomalg( LogicalImplicationsForHomalgMatricesOverSpecialRings, IsHomalgMatrix, IsHomalgRing );

####################################
#
# immediate methods for properties:
#
####################################

##
InstallImmediateMethod( IsEmptyMatrix,
        IsHomalgMatrix and HasNrRows and HasNrColumns, 0,
        
  function( M )
    
    if NrRows( M ) = 0 or NrColumns( M ) = 0 then
        return true;
    else
        return false;
    fi;
    
end );

##
InstallImmediateMethod( IsIdentityMatrix,
        IsHomalgMatrix and HasNrRows and HasNrColumns, 0,
        
  function( M )
    
    if NrRows( M ) <> NrColumns( M ) then
        return false;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZero,
        IsHomalgMatrix and HasZeroRows and HasNrRows, 0,
        
  function( M )
    
    return Length( ZeroRows( M ) ) = NrRows( M );
    
end );

##
InstallImmediateMethod( IsZero,
        IsHomalgMatrix and HasZeroColumns and HasNrColumns, 0,
        
  function( M )
    
    return Length( ZeroColumns( M ) ) = NrColumns( M );
    
end );

##
InstallImmediateMethod( IsReducedModuloRingRelations,
        IsHomalgMatrix, 0,
        
  function( M )
    
    if not HasRingRelations( HomalgRing( M ) ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsRightInvertibleMatrix,
        IsHomalgMatrix and IsSubidentityMatrix, 0,
        
  function( M )
    
    return NrRows( M ) <= NrColumns( M );
    
end );

##
InstallImmediateMethod( IsRightInvertibleMatrix,
        IsHomalgMatrix and HasNrRows, 0,
        
  function( M )
    
    if NrRows( M ) = 0 then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLeftInvertibleMatrix,
        IsHomalgMatrix and IsSubidentityMatrix, 0,
        
  function( M )
    
    return NrColumns( M ) <= NrRows( M );
    
end );

##
InstallImmediateMethod( IsLeftInvertibleMatrix,
        IsHomalgMatrix and HasNrColumns, 0,
        
  function( M )
    
    if NrColumns( M ) = 0 then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsUpperStairCaseMatrix,
        IsHomalgMatrix and HasNrRows, 0,
        
  function( M )
    
    if NrRows( M ) = 1 then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLowerStairCaseMatrix,
        IsHomalgMatrix and HasNrColumns, 0,
        
  function( M )
    
    if NrColumns( M ) = 1 then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasEvalDiagMat, 0,
        
  function( M )
    local e;
    
    e := EvalDiagMat( M );
    
    if ForAll( e, HasIsDiagonalMatrix ) then
        return ForAll( List( e, HasIsDiagonalMatrix ), a -> a = true );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasEvalUnionOfRows, 0,
        
  function( M )
    local A, B;
    
    A := EvalUnionOfRows( M )[1];
    B := EvalUnionOfRows( M )[2];
    
    if HasIsDiagonalMatrix( A ) and IsDiagonalMatrix( A )
       and HasIsZero( B ) and IsZero( B ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasEvalUnionOfColumns, 0,
        
  function( M )
    local A, B;
    
    A := EvalUnionOfColumns( M )[1];
    B := EvalUnionOfColumns( M )[2];
    
    if HasIsDiagonalMatrix( A ) and IsDiagonalMatrix( A )
       and HasIsZero( B ) and IsZero( B ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

####################################
#
# immediate methods for attributes:
#
####################################

##
InstallImmediateMethod( RowRankOfMatrix,
        IsHomalgMatrix and IsIdentityMatrix and HasNrRows, 0,
        
  function( M )
    
    return NrRows( M );
        
end );

##
InstallImmediateMethod( ColumnRankOfMatrix,
        IsHomalgMatrix and IsIdentityMatrix and HasNrColumns, 0,
        
  function( M )
    
    return NrColumns( M );
        
end );

##
InstallImmediateMethod( RowRankOfMatrix,
        IsHomalgMatrix and IsZero, 0,
        
  function( M )
    
    return 0;
        
end );

##
InstallImmediateMethod( ColumnRankOfMatrix,
        IsHomalgMatrix and IsZero, 0,
        
  function( M )
    
    return 0;
        
end );

##
InstallImmediateMethod( ZeroRows,
        IsHomalgMatrix and IsIdentityMatrix and IsReducedModuloRingRelations, 0,
        
  function( M )
    
    return [ ];
        
end );

##
InstallImmediateMethod( ZeroRows,
        IsHomalgMatrix and IsZero and HasNrRows, 0,
        
  function( M )
    
    return [ 1 .. NrRows( M ) ];
        
end );

##
InstallImmediateMethod( ZeroRows,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasZeroColumns( EvalInvolution( M ) ) then
        return ZeroColumns( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( ZeroColumns,
        IsHomalgMatrix and IsIdentityMatrix and IsReducedModuloRingRelations, 0,
        
  function( M )
    
    return [ ];
        
end );

##
InstallImmediateMethod( ZeroColumns,
        IsHomalgMatrix and IsZero and HasNrColumns, 0,
        
  function( M )
    
    return [ 1 .. NrColumns( M ) ];
        
end );

##
InstallImmediateMethod( ZeroColumns,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasZeroRows( EvalInvolution( M ) ) then
        return ZeroRows( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( NonZeroRows,
        IsHomalgMatrix and IsIdentityMatrix and IsReducedModuloRingRelations and HasNrRows, 0,
        
  function( M )
    
    return [ 1 .. NrRows( M ) ];
        
end );

##
InstallImmediateMethod( NonZeroRows,
        IsHomalgMatrix and IsZero, 0,
        
  function( M )
    
    return [ ];
        
end );

##
InstallImmediateMethod( NonZeroColumns,
        IsHomalgMatrix and IsIdentityMatrix and IsReducedModuloRingRelations and HasNrColumns, 0,
        
  function( M )
    
    return [ 1 .. NrColumns( M ) ];
        
end );

##
InstallImmediateMethod( NonZeroColumns,
        IsHomalgMatrix and IsZero, 0,
        
  function( M )
    
    return [ ];
        
end );

##
InstallImmediateMethod( PositionOfFirstNonZeroEntryPerRow,
        IsHomalgMatrix and IsIdentityMatrix and IsReducedModuloRingRelations and HasNrRows, 0,
        
  function( M )
    
    if not ( HasIsZero( M ) and IsZero( M ) ) then
        return [ 1 .. NrRows( M ) ];
    fi;
    
    TryNextMethod( );
        
end );

####################################
#
# methods for attributes:
#
####################################

#-----------------------------------
# RowRankOfMatrix
#-----------------------------------

##
InstallMethod( RowRankOfMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local RP, B;
    
    RP := homalgTable( HomalgRing( M ) );
    
    if IsBound( RP!.RowRankOfMatrix ) then
        
        return RP!.RowRankOfMatrix( M );
        
    elif IsBound( RP!.TriangularBasisOfRows ) then
        
        B := RP!.TriangularBasisOfRows( M );
        
        if HasRowRankOfMatrix( B ) then
            return RowRankOfMatrix( B );
        fi;
	
    else
        
        BasisOfRowModule( M );
        
        if HasRowRankOfMatrix( M ) then
            return RowRankOfMatrix( M );
        fi;
	
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# ColumnRankOfMatrix
#-----------------------------------

##
InstallMethod( ColumnRankOfMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local RP, B, N;
    
    RP := homalgTable( HomalgRing( M ) );
    
    if IsBound( RP!.ColumnRankOfMatrix ) then
        
        return RP!.ColumnRankOfMatrix( M );
        
    elif IsBound( RP!.RowRankOfMatrix ) then
        
        return RP!.RowRankOfMatrix( Involution( M ) );	## in most cases Involution is obsolete
        
    elif IsBound( RP!.TriangularBasisOfColumns ) then
        
        B := RP!.TriangularBasisOfColumns( M );
        
        if HasColumnRankOfMatrix( B ) then
            return ColumnRankOfMatrix( B );
        fi;
        
    elif IsBound( RP!.TriangularBasisOfRows ) then
        
        N := Involution( M );
        
        B := RP!.TriangularBasisOfRows( N );
        
        if HasRowRankOfMatrix( B ) then
            return RowRankOfMatrix( B );
        fi;
	
    else
        
        BasisOfColumnModule( M );
        
        if HasColumnRankOfMatrix( M ) then
            return ColumnRankOfMatrix( M );
        fi;
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# ZeroColumns
#-----------------------------------

##
InstallMethod( ZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalInvolution ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "ZeroColumns( Involution( M ) ) = ZeroRows( M )", "\033[0m" );
    
    return ZeroRows( EvalInvolution( M ) );
    
end );

####################################
#
# methods for operations:
#
####################################

#-----------------------------------
# \=
#-----------------------------------

##
InstallMethod( \=,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix and IsZero ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsZero(Matrix) = IsZero(Matrix)", "\033[0m" );
    
    return AreComparableMatrices( M1, M2 );
    
end );

##
InstallMethod( \=,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsIdentityMatrix = IsIdentityMatrix", "\033[0m" );
    
    return AreComparableMatrices( M1, M2 );
    
end );

#-----------------------------------
# Involution
#-----------------------------------

##
InstallMethod( Involution,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "Involution( IsZero(Matrix) )", "\033[0m" );
    
    return HomalgZeroMatrix( NrColumns( M ), NrRows( M ), HomalgRing( M ) );
    
end );

##
InstallMethod( Involution,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "Involution( IsIdentityMatrix )", "\033[0m" );
    
    return M;
    
end );

#-----------------------------------
# CertainRows
#-----------------------------------

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList ], 10001,
        
  function( M, plist )
    
    if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
        Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
    fi;
    
    if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
        return M;
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# CertainColumns
#-----------------------------------

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList ], 10001,
        
  function( M, plist )
    
    if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
        Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
    fi;
    
    if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
        return M;
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# UnionOfRows
#-----------------------------------

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not stackable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsEmptyMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfRows( IsHomalgMatrix, IsEmptyMatrix )", "\033[0m" );
    
    return A;
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsEmptyMatrix, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfRows( IsEmptyMatrix, IsHomalgMatrix )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsEmptyMatrix, IsHomalgMatrix and IsEmptyMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfRows( IsEmptyMatrix, IsEmptyMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( A ) + NrRows( B ), NrColumns( A ), HomalgRing( A ) );
    
end );

#-----------------------------------
# UnionOfColumns
#-----------------------------------

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not augmentable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsEmptyMatrix, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfColumns( IsEmptyMatrix, IsHomalgMatrix )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsEmptyMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfColumns( IsHomalgMatrix, IsEmptyMatrix )", "\033[0m" );
    
    return A;
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsEmptyMatrix, IsHomalgMatrix and IsEmptyMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "UnionOfColumns( IsEmptyMatrix, IsEmptyMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( A ), NrColumns( A ) + NrColumns( B ), HomalgRing( A ) );
    
end );

#-----------------------------------
# DiagMat
#-----------------------------------

##
InstallMethod( DiagMat,
        "of homalg matrices",
        [ IsHomogeneousList ], 10001,
        
  function( l )
    local R;
    
    if l = [ ] then
        Error( "recieved an empty list\n" );
    fi;
    
    if not ForAll( l, IsHomalgMatrix ) then
        Error( "at least one of the matrices in the list is not a homalg matrix\n" );
    fi;
    
    if Length( l ) = 1 then
        return l[1];
    fi;
    
    R := HomalgRing( l[1] );
    
    if not ForAll( l{[ 2 .. Length( l ) ]}, a -> IsIdenticalObj( HomalgRing( a ), R ) ) then
        Error( "the matrices are not defined over identically the same ring\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DiagMat,
        "of homalg matrices",
        [ IsHomogeneousList ], 2,
        
  function( l )
    local R;
    
    if ForAll( l, HasIsIdentityMatrix and IsIdentityMatrix ) then
        
        R := HomalgRing( l[1] );
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DiagMat( [ identity matrices ] )", "\033[0m" );
        
        return HomalgIdentityMatrix( Sum( List( l, NrRows ) ), Sum( List( l, NrColumns ) ), R );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DiagMat,
        "of homalg matrices",
        [ IsHomogeneousList ], 2,
        
  function( l )
    local R;
    
    if ForAll( l, HasIsZero and IsZero ) then
        
        R := HomalgRing( l[1] );
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DiagMat( [ zero matrices ] )", "\033[0m" );
        
        return HomalgZeroMatrix( Sum( List( l, NrRows ) ), Sum( List( l, NrColumns ) ), R );
        
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# KroneckerMat
#-----------------------------------

##
InstallMethod( KroneckerMat,
        "of homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( KroneckerMat,
        "of homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "KroneckerMat( IsIdentityMatrix, IsHomalgMatrix )", "\033[0m" );
    
    return DiagMat( ListWithIdenticalEntries( NrRows( A ), B ) );
    
end );

##
InstallMethod( KroneckerMat,
        "of homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ], 1001,	## FIXME: this must be ranked higer the "KroneckerMat( IsIdentityMatrix, IsHomalgMatrix )", why?
        
  function( A, B )
    local R;
    
    R := HomalgRing( A );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "KroneckerMat( IsZero(Matrix), IsHomalgMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( A ) * NrRows( B ), NrColumns( A ) * NrColumns( B ), R );
    
end );

##
InstallMethod( KroneckerMat,
        "of homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix ],
        
  function( A, B )
    local R;
    
    R := HomalgRing( A );
    
    if ( HasNrRows( B ) and NrRows( B ) = 1 )
       or ( HasNrRows( B ) and NrRows( B ) = 1 ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "KroneckerMat( IsHomalgMatrix, (1) )", "\033[0m" );
        
        return A;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( KroneckerMat,
        "of homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( A, B )
    local R;
    
    R := HomalgRing( A );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "KroneckerMat( IsHomalgMatrix, IsZero(Matrix) )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( A ) * NrRows( B ), NrColumns( A ) * NrColumns( B ), R );
    
end );

#-----------------------------------
# MulMat
#-----------------------------------

##
InstallMethod( \*,
        "of homalg matrices",
        [ IshomalgExternalObjectWithIOStreamRep and IsHomalgExternalRingElementRep, IsHomalgMatrix ], 10001,
        
  function( a, A )
    
    if not IsIdenticalObj( HomalgRing( a ), HomalgRing( A ) ) then
        Error( "the ring element and the matrix are not defined over identically the same ring\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \*,
        "of homalg matrices with ring elements",
        [ IsRingElement and IsZero, IsHomalgMatrix ],
        
  function( a, A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsZero * IsHomalgMatrix", "\033[0m" );
    
    return 0 * A;
    
end );

##
InstallMethod( \*,
        "of homalg matrices with ring elements",
        [ IsRingElement and IsOne, IsHomalgMatrix ],
        
  function( a, A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsOne * IsHomalgMatrix", "\033[0m" );
    
    return A;
    
end );

##
InstallMethod( \*,
        "of homalg matrices",
        [ IsRingElement, IsHomalgMatrix and IsZero ],
        
  function( a, A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsRingElement * IsZero(Matrix)", "\033[0m" );
    
    return A;
    
end );

#-----------------------------------
# AddMat
#-----------------------------------

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsZero(Matrix) + IsHomalgMatrix", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ) );
    
    return B;
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsHomalgMatrix + IsZero(Matrix)", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ) );
    
    return A;
    
end );

#-----------------------------------
# AdditiveInverseMutable
#-----------------------------------

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseMutable,
        "of homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "-IsZero(Matrix)", "\033[0m" );
    
    return A;
    
end );

#-----------------------------------
# SubMat
#-----------------------------------

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not subtractable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not subtractable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 1000,
        
  function( A, B )
    
    if IsIdenticalObj( A, B ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "M - M", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ) );
        
        return 0 * A;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsZero(Matrix) - IsHomalgMatrix", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ) );
    
    return -B;
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsHomalgMatrix - IsZero(Matrix)", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ) );
    
    return A;
    
end );

#-----------------------------------
# Compose
#-----------------------------------

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsIdentityMatrix * IsHomalgMatrix", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ), " x ", NrColumns( B ) );
    
    return B;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsHomalgMatrix * IsIdentityMatrix", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ), " x ", NrColumns( B ) );
    
    return A;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsZero(Matrix) * IsHomalgMatrix", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ), " x ", NrColumns( B ) );
    
    if NrRows( B ) = NrColumns( B ) then
        return A;
    else
        return HomalgZeroMatrix( NrRows( A ), NrColumns( B ), HomalgRing( A ) );
    fi;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "IsHomalgMatrix * IsZero(Matrix)", "\033[0m", "	", NrRows( A ), " x ", NrColumns( A ), " x ", NrColumns( B ) );
    
    if NrRows( A ) = NrColumns( A ) then
        return B;
    else
        return HomalgZeroMatrix( NrRows( A ), NrColumns( B ), HomalgRing( B ) );
    fi;
    
end );

#-----------------------------------
# RightDivide
#-----------------------------------

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( B, A )
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the first and the second matrix must have the same number of columns\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix ],
        
  function( B, A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightDivide( IsHomalgMatrix, IsIdentityMatrix )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( B, A )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightDivide( IsZero(Matrix), IsHomalgMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( B ), NrRows( A ), HomalgRing( B ) );
    
end );

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgRelationsOfLeftModule ], 10001,
        
  function( B, A, L )
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the first and the second matrix must have the same number of columns\n" );
    fi;
    
    if NrColumns( A ) <> NrGenerators( L ) then
        Error( "the number of columns of the first matrix and the number of generators of the last argment do not coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix, IsHomalgRelationsOfLeftModule ],
        
  function( B, A, L )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightDivide( IsHomalgMatrix, IsIdentityMatrix, IsHomalgRelations )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( RightDivide,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix, IsHomalgRelationsOfLeftModule ],
        
  function( B, A, L )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightDivide( IsZero(Matrix), IsHomalgMatrix, IsHomalgRelations )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( B ), NrRows( A ), HomalgRing( B ) );
    
end );

#-----------------------------------
# LeftDivide
#-----------------------------------

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the first and the second matrix must have the same number of rows\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftDivide( IsIdentityMatrix, IsHomalgMatrix )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( A, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftDivide( IsHomalgMatrix, IsZero(Matrix) )", "\033[0m" );
    
    return HomalgZeroMatrix( NrColumns( A ), NrColumns( B ), HomalgRing( B ) );
    
end );

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsHomalgRelationsOfRightModule ], 10001,
        
  function( A, B, L )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the first and the second matrix must have the same number of rows\n" );
    fi;
    
    if NrRows( A ) <> NrGenerators( L ) then
        Error( "the number of rows of the first matrix and the number of generators of the last argment do not coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix, IsHomalgRelationsOfRightModule ],
        
  function( A, B, L )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftDivide( IsIdentityMatrix, IsHomalgMatrix, IsHomalgRelations )", "\033[0m" );
    
    return B;
    
end );

##
InstallMethod( LeftDivide,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero, IsHomalgRelationsOfRightModule ],
        
  function( A, B, L )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftDivide( IsHomalgMatrix, IsZero(Matrix), IsHomalgRelations )", "\033[0m" );
    
    return HomalgZeroMatrix( NrColumns( A ), NrColumns( B ), HomalgRing( B ) );
    
end );

#-----------------------------------
# LeftInverse
#-----------------------------------

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix ], 10001,
        
  function( M )
    
    if NrRows( M ) < NrColumns( M ) then
        Error( "the number of rows ", NrRows( M ), " is smaller than the number of columns ", NrColumns( M ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftInverse( IsIdentityMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsSubidentityMatrix ],
        
  function( M )
    local C;
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftInverse( IsSubidentityMatrix )", "\033[0m" );
    
    C := Involution( M );
    
    SetEvalRightInverse( M, C );
    
    return C;
    
end );

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    if NrColumns( M ) = 0 then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "LeftInverse( ? x 0 -- IsZero(Matrix) )", "\033[0m" );
        
        return HomalgZeroMatrix( 0, NrRows( M ), HomalgRing( M ) );
        
    else
        Error( "a zero matrix with positive number of columns has no left inverse!\n" );
    fi;
    
end );

#-----------------------------------
# RightInverse
#-----------------------------------

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix ], 10001,
        
  function( M )
    
    if NrColumns( M ) < NrRows( M ) then
        Error( "the number of columns ", NrColumns( M ), " is smaller than the number of rows ", NrRows( M ), "\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightInverse( IsIdentityMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsSubidentityMatrix ],
        
  function( M )
    local C;
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightInverse( IsSubidentityMatrix )", "\033[0m" );
    
    C := Involution( M );
    
    SetEvalLeftInverse( M, C );
    
    return C;
    
end );

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    if NrRows( M ) = 0 then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RightInverse( 0 x ? -- IsZero(Matrix) )", "\033[0m" );
        
        return HomalgZeroMatrix( NrColumns( M ), 0, HomalgRing( M ) );
        
    else
        Error( "a zero matrix with positive number of rows has no left inverse!\n" );
    fi;
    
end );

#-----------------------------------
# RowRankOfMatrix
#-----------------------------------

##
InstallMethod( RowRankOfMatrix,			 	## FIXME: make an extra InstallImmediateMethod when NonZeroRows( M ) is set
        [ IsHomalgMatrix and IsUpperStairCaseMatrix ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if not ( HasIsIntegralDomain( R ) and IsIntegralDomain( R ) ) then
        TryNextMethod( );
    fi;
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "RowRankOfMatrix( IsTriangularMatrix over domain )", "\033[0m" );
    
    return Length( NonZeroRows( M ) );
    
end );

#-----------------------------------
# ColumnRankOfMatrix
#-----------------------------------

##
InstallMethod( ColumnRankOfMatrix,			## FIXME: make an extra InstallImmediateMethod when NonZeroColumns( M ) is set
        [ IsHomalgMatrix and IsLowerStairCaseMatrix ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if not ( HasIsIntegralDomain( R ) and IsIntegralDomain( R ) ) then
        TryNextMethod( );
    fi;
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "ColumnRankOfMatrix( IsTriangularMatrix over domain )", "\033[0m" );
    
    return Length( NonZeroColumns( M ) );
    
end );

#-----------------------------------
# BasisOfRowModule
#-----------------------------------

##
InstallMethod( BasisOfRowModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsBasisOfRowsMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowModule( IsBasisOfRowsMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( BasisOfRowModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowModule( IsIdentityMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( BasisOfRowModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowModule( IsZero(Matrix) )", "\033[0m" );
    
    return HomalgZeroMatrix( 0, NrColumns( M ), HomalgRing( M ) );
    
end );

#-----------------------------------
# BasisOfColumnModule
#-----------------------------------

##
InstallMethod( BasisOfColumnModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsBasisOfColumnsMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnModule( IsBasisOfColumnsMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( BasisOfColumnModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnModule( IsIdentityMatrix )", "\033[0m" );
    
    return M;
    
end );

##
InstallMethod( BasisOfColumnModule,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnModule( IsZero(Matrix) )", "\033[0m" );
    
    return HomalgZeroMatrix( NrRows( M ), 0, HomalgRing( M ) );
    
end );

#-----------------------------------
# BasisOfRowsCoeff
#-----------------------------------

##
InstallMethod( BasisOfRowsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsBasisOfRowsMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowsCoeff( IsBasisOfRowsMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( NrRows( M ), R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return M;
    
end );

##
InstallMethod( BasisOfRowsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowsCoeff( IsIdentityMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( NrRows( M ), R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return M;
    
end );

##
InstallMethod( BasisOfRowsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfRowsCoeff( IsZero(Matrix), T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( 0, R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return HomalgZeroMatrix( 0, NrColumns( M ), R );
    
end );

#-----------------------------------
# BasisOfColumnsCoeff
#-----------------------------------

##
InstallMethod( BasisOfColumnsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsBasisOfColumnsMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnsCoeff( IsBasisOfColumnsMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( NrColumns( M ), R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return M;
    
end );

##
InstallMethod( BasisOfColumnsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnsCoeff( IsIdentityMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( NrColumns( M ), R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return M;
    
end );

##
InstallMethod( BasisOfColumnsCoeff,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix and IsVoidMatrix ],
        
  function( M, T )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "BasisOfColumnsCoeff( IsZero(Matrix), T )", "\033[0m" );
    
    SetPreEval( T, HomalgIdentityMatrix( 0, R ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return HomalgZeroMatrix( NrRows( M ), 0, R );
    
end );

#-----------------------------------
# DecideZeroRows
#-----------------------------------

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( L, B )
    
    if not IsIdenticalObj( HomalgRing( L ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrColumns( L ) <> NrColumns( B ) then
        Error( "the number of columns of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( L, B )
    
    if IsIdenticalObj( L, B ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRows( M, M )", "\033[0m" );
        
        return 0 * L;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsLeftInvertibleMatrix ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRows( IsHomalgMatrix, IsLeftInvertibleMatrix )", "\033[0m" );
    
    return 0 * L;
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRows( IsHomalgMatrix, IsZero(Matrix) )", "\033[0m" );
    
    return L;
    
end );

##
InstallMethod( DecideZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRows( IsZero(Matrix), IsHomalgMatrix )", "\033[0m" );
    
    return L;
    
end );

#-----------------------------------
# DecideZeroColumns
#-----------------------------------

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( L, B )
    
    if not IsIdenticalObj( HomalgRing( L ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( L ) <> NrRows( B ) then
        Error( "the number of rows of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( L, B )
    
    if IsIdenticalObj( L, B ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumns( M, M )", "\033[0m" );
        
        return 0 * L;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsRightInvertibleMatrix ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumns( IsHomalgMatrix, IsRightInvertibleMatrix )", "\033[0m" );
    
    return 0 * L;
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumns( IsHomalgMatrix, IsZero(Matrix) )", "\033[0m" );
    
    return L;
    
end );

##
InstallMethod( DecideZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( L, B )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumns( IsZero(Matrix), IsHomalgMatrix )", "\033[0m" );
    
    return L;
    
end );

#-----------------------------------
# DecideZeroRowsEffectively
#-----------------------------------

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsVoidMatrix ], 10001,
        
  function( A, B, T )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the number of columns of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    if IsIdenticalObj( A, B ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRowsEffectively( M, M, T )", "\033[0m" );
        
        SetPreEval( T, HomalgIdentityMatrix( NrRows( A ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
        
        return 0 * A;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and HasItsLeftInverse, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRowsEffectively( IsHomalgMatrix, HasItsLeftInverse, T )", "\033[0m" );
    
    ## 0 = A + T * B
    SetPreEval( T, -A * ItsLeftInverse( B ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return 0 * A;
    
end );

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRowsEffectively( IsHomalgMatrix, IsIdentityMatrix, T )", "\033[0m" );
    
    ## 0 = A + T * Id
    SetPreEval( T, -A ); ResetFilterObj( T, IsVoidMatrix );
    
    return 0 * A;
    
end );

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRowsEffectively( IsHomalgMatrix, IsZero(Matrix), T )", "\033[0m" );
    
    SetPreEval( T, HomalgZeroMatrix( NrRows( A ), NrRows( B ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return A;
    
end );

##
InstallMethod( DecideZeroRowsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroRowsEffectively( IsZero(Matrix), IsHomalgMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgZeroMatrix( NrRows( A ), NrRows( B ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return A;
    
end );

#-----------------------------------
# DecideZeroColumnsEffectively
#-----------------------------------

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsVoidMatrix ], 10001,
        
  function( A, B, T )
    
    if not IsIdenticalObj( HomalgRing( A ), HomalgRing( B ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the number of rows of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    if IsIdenticalObj( A, B ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumnsEffectively( M, M, T )", "\033[0m" );
        
        SetPreEval( T, HomalgIdentityMatrix( NrColumns( A ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
        
        return 0 * A;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and HasItsRightInverse, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumnsEffectively( IsHomalgMatrix, HasItsRightInverse, T )", "\033[0m" );
    
    ## 0 = A + B * T
    SetPreEval( T, ItsRightInverse( B ) * -A ); ResetFilterObj( T, IsVoidMatrix );
    
    return 0 * A;
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsIdentityMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumnsEffectively( IsHomalgMatrix, IsIdentityMatrix, T )", "\033[0m" );
    
    ## 0 = A + Id * T
    SetPreEval( T, -A ); ResetFilterObj( T, IsVoidMatrix );
    
    return 0 * A;
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumnsEffectively( IsHomalgMatrix, IsZero(Matrix), T )", "\033[0m" );
    
    SetPreEval( T, HomalgZeroMatrix( NrColumns( B ), NrColumns( A ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return A;
    
end );

##
InstallMethod( DecideZeroColumnsEffectively,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix, IsVoidMatrix ],
        
  function( A, B, T )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "DecideZeroColumnsEffectively( IsZero(Matrix), IsHomalgMatrix, T )", "\033[0m" );
    
    SetPreEval( T, HomalgZeroMatrix( NrColumns( B ), NrColumns( A ), HomalgRing( A ) ) ); ResetFilterObj( T, IsVoidMatrix );
    
    return A;
    
end );

#-----------------------------------
# SyzygiesGeneratorsOfRows
#-----------------------------------

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( M1, M2 )
    
    if not IsIdenticalObj( HomalgRing( M1 ), HomalgRing( M2 ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrColumns( M1 ) <> NrColumns( M2 ) then
        Error( "the number of columns of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    if IsIdenticalObj( M1, M2 ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows( M, M )", "\033[0m" );
        
        return HomalgIdentityMatrix( NrRows( M1 ), HomalgRing( M1 ) );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix and IsLeftRegularMatrix ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows( IsLeftRegularMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( 0, NrRows( M ), HomalgRing( M ) );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows(IsIdentityMatrix,IsHomalgMatrix)", "\033[0m" );
    
    return M2;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows(IsHomalgMatrix,IsZero(Matrix))", "\033[0m" );
    
    return SyzygiesGeneratorsOfRows( M1 );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows( IsZero(Matrix) )", "\033[0m" );
    
    return HomalgIdentityMatrix( NrRows( M ), HomalgRing( M ) );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfRows,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfRows(IsZero(Matrix),IsHomalgMatrix)", "\033[0m" );
    
    return HomalgIdentityMatrix( NrRows( M1 ), HomalgRing( M1 ) );
    
end );

#-----------------------------------
# SyzygiesGeneratorsOfColumns
#-----------------------------------

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ], 10001,
        
  function( M1, M2 )
    
    if not IsIdenticalObj( HomalgRing( M1 ), HomalgRing( M2 ) ) then
        Error( "the two matrices are not defined over identically the same ring\n" );
    fi;
    
    if NrRows( M1 ) <> NrRows( M2 ) then
        Error( "the number of rows of the two matrices must coincide\n" );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    if IsIdenticalObj( M1, M2 ) then
        
        Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns( M, M )", "\033[0m" );
        
        return HomalgIdentityMatrix( NrColumns( M1 ), HomalgRing( M1 ) );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and IsRightRegularMatrix ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns( IsRightRegularMatrix )", "\033[0m" );
    
    return HomalgZeroMatrix( NrColumns( M ), 0, HomalgRing( M ) );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and IsIdentityMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns(IsIdentityMatrix,IsHomalgMatrix)", "\033[0m" );
    
    return M2;
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and IsZero ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns(IsHomalgMatrix,IsZero(Matrix))", "\033[0m" );
    
    return SyzygiesGeneratorsOfColumns( M1 );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns( IsZero(Matrix) )", "\033[0m" );
    
    return HomalgIdentityMatrix( NrColumns( M ), HomalgRing( M ) );
    
end );

##
InstallMethod( SyzygiesGeneratorsOfColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsHomalgMatrix ],
        
  function( M1, M2 )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "SyzygiesGeneratorsOfColumns(IsZero(Matrix),IsHomalgMatrix)", "\033[0m" );
    
    return HomalgIdentityMatrix( NrColumns( M1 ), HomalgRing( M1 ) );
    
end );

#-----------------------------------
# GetUnitPosition
#-----------------------------------

##
InstallMethod( GetUnitPosition,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero ],
        
  function( M )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "GetUnitPosition( IsZero(Matrix) )", "\033[0m" );
    
    return fail;
    
end );

#-----------------------------------
# GetColumnIndependentUnitPositions
#-----------------------------------

##
InstallMethod( GetColumnIndependentUnitPositions,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsList ],
        
  function( M, pos_list )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "GetColumnIndependentUnitPositions( IsZero(Matrix) )", "\033[0m" );
    
    return [ ];
    
end );

#-----------------------------------
# GetRowIndependentUnitPositions
#-----------------------------------

##
InstallMethod( GetRowIndependentUnitPositions,
        "for homalg matrices",
        [ IsHomalgMatrix and IsZero, IsList ],
        
  function( M, pos_list )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "GetRowIndependentUnitPositions( IsZero(Matrix) )", "\033[0m" );
    
    return [ ];
    
end );

#-----------------------------------
# GetCleanRowsPositions
#-----------------------------------

##
InstallMethod( GetCleanRowsPositions,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList and IsEmpty ],
        
  function( M, pos_list )
    
    Info( InfoLIMAT, 2, LIMAT.color, "\033[01mLIMAT\033[0m ", LIMAT.color, "GetCleanRowsPositions( IsHomalgMatrix, IsEmpty(List) )", "\033[0m" );
    
    return [ ];
    
end );


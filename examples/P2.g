LoadPackage( "Sheaves" );

S := HomalgFieldOfRationalsInDefaultCAS( ) * "x0,x1,x2";

A := KoszulDualRing( S, "e0,e1,e2" );

## the residue class field (i.e. S modulo the maximal homogeneous ideal)
k := HomalgMatrix( Indeterminates( S ), Length( Indeterminates( S ) ), 1, S );

k := LeftPresentationWithWeights( k );

## the sheaf supported on a point
p := HomalgMatrix( Indeterminates( S ){[ 1 .. Length( Indeterminates( S ) ) ]}, 1, Length( Indeterminates( S ) ) - 1, S );

p := RightPresentationWithWeights( p );

## the sheaf supported on a line
l := HomalgMatrix( Indeterminates( S ){[ 1 .. Length( Indeterminates( S ) ) ]}, 1, Length( Indeterminates( S ) ) - 2, S );

l := RightPresentationWithWeights( l );

## the twisted line bundle O(a)
O := a -> S^a;

## the cotangent bundle
cotangent := SyzygiesModule( 2, k );

## the canonical bundle
omega := S^(-2-1);

## from [ Decker, Eisenbud ]
M := HomalgMatrix( "[ x0^2, x1^2 ]", 1, 2, S );

M := RightPresentationWithWeights( M );

m := SubmoduleGeneratedByHomogeneousPart( CastelnuovoMumfordRegularity( M ), M );

N := HomalgMatrix( "[ x0^2, x1^2, x2^2 ]", 1, 3, S );

N := RightPresentationWithWeights( N );

N2 := SubmoduleGeneratedByHomogeneousPart( 2, M );


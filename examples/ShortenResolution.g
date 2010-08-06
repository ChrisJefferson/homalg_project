LoadPackage( "RingsForHomalg" );

Qt := HomalgFieldOfRationalsInSingular( ) * "t";

A1 := RingOfDerivations( Qt, "Dt" );

M := HomalgMatrix( "[ \
t^2, \
t * Dt + 2 \
]", 2, 1, A1 );

LoadPackage( "homalg" );

M := LeftPresentation( M );

P := ShortenResolution( M );

Assert( 0, IsIdenticalObj( Cokernel( PresentationMorphism( M ) ), M ) );

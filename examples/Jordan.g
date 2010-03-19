LoadPackage( "RingsForHomalg" );

LoadPackage( "homalg" );

Qx := HomalgFieldOfRationalsInSingular() * "x";

V := HomalgMatrix( "[ \
x, 1, 0, \
0, x, 1, \
0, 0, x \
]", 3, 3, Qx );

V := LeftPresentation( V );

L := HomalgMatrix( "[ x^3 ]", 1, 1, Qx );

L := LeftPresentation( L );

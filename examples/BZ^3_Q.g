LoadPackage( "RingsForHomalg" );

ZX := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,a,X,Y,A";

rel := HomalgMatrix( "[ x*X-1, y*Y-1, a*A-1 ]", 3, 1, ZX );
rel := HomalgRelationsForLeftModule( rel );

ZZ3 := ZX / rel;

zz := HomalgMatrix( "[ x - 1, y - 1, a - 1 ]", 3, 1, ZZ3 );

ZZ := LeftPresentation( zz );

ext := rec( );

ext.0 := Ext( 0, ZZ, ZZ );
ext.1 := Ext( 1, ZZ, ZZ );
ext.2 := Ext( 2, ZZ, ZZ );
ext.3 := Ext( 3, ZZ, ZZ );
ext.4 := Ext( 4, ZZ, ZZ );
ext.5 := Ext( 5, ZZ, ZZ );
ext.6 := Ext( 6, ZZ, ZZ );


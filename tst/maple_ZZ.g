LoadPackage( "homalg" );
LoadPackage( "RingsForHomalg" );
HOMALG_RINGS.color_display := true;
ZZ := HomalgRingOfIntegersInMaple( );
Display( ZZ );
wmat := HomalgMatrix( imat, ZZ );
W := LeftPresentation( wmat );

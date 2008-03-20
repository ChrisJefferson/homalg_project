LoadPackage( "homalg" );
LoadPackage( "RingsForHomalg" );
HOMALG_RINGS.color_display := true;
ZZ := RingForHomalgInPIRMaple9( "[]" );
Display(ZZ);
wmat := HomalgMatrixInMaple( " \
[ [ 262, -33, 75, -40 ], \
  [ 682, -86, 196, -104 ], \
  [ 1186, -151, 341, -180 ], \
  [ -1932, 248, -556, 292 ], \
  [ 1018, -127, 293, -156 ] ] \
", ZZ );
wrel := HomalgRelationsForLeftModule( wmat );
W := Presentation( wrel );

LoadPackage( "homalg" );
LoadPackage( "RingsForHomalg" );
HOMALG_RINGS.color_display := true;
#SetInfoLevel( InfoRingsForHomalg, 7 );
Qxyz := RingForHomalgInInvolutiveMaple9( "[x,y,z]" );
Display(Qxyz);
wmat := HomalgMatrixInMaple( " \
[ [x*z, z*y, z^2, 0, 0, y], \
  [0, 0, 0, z^2*y-z^2, z^3, x*z], \
  [0, 0, 0, z*y^2-z*y, z^2*y, x*y], \
  [0, 0, 0, x*z*y-x*z, x*z^2, x^2], \
  [x^2*z, x*z*y, x*z^2, 0, 0, x*y], \
  [-x*y, -y^2, -z*y, x^2*y-y-x^2+1, x^2*z-z, 0], \
  [x^2*y-x^2, x*y^2-x*y, x*z*y-x*z, -y^3+2*y^2-y, -z*y^2+z*y, 0], \
  [0, 0, 0, z*y-z, z^2, x^3-y^2] ] \
", Qxyz );
wrel := HomalgRelationsForLeftModule( wmat );
W := Presentation( wrel );
BasisOfModule( W );
BasisOfModule( W );
rsyz:=SyzygiesGenerators( W );
Display(rsyz);

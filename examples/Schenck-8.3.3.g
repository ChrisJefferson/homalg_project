##  <#GAPDoc Label="Schenck-8.3.3">
##  <Subsection Label="Schenck-8.3.3">
##  <Heading>Schenck-8.3.3</Heading>
##  This is Exercise 8.3.3 in <Cite Key="Sch"/>.
##  <Example><![CDATA[
##  gap> Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";;
##  gap> mat := HomalgMatrix( "[ x*y*z, x*y^2, x^2*z, x^2*y, x^3 ]", 1, 5, Qxyz );
##  <A homalg external 1 by 5 matrix>
##  gap> M := RightPresentationWithDegrees( mat );
##  <A graded cyclic right module on a cyclic generator satisfying 5 relations>
##  gap> Mr := Resolution( M );
##  <A right acyclic complex containing 3 morphisms of right modules at degrees
##  [ 0 .. 3 ]>
##  gap> betti := BettiDiagram( Mr );
##  <A Betti diagram of <A right acyclic complex containing
##  3 morphisms of right modules at degrees [ 0 .. 3 ]>>
##  gap> Display( betti );
##   total:  1 5 6 2
##  ----------------
##       0:  1 . . .
##       1:  . . . .
##       2:  . 5 6 2
##  ----------------
##  degree:  0 1 2 3
##  ]]></Example>
##  </Subsection>
##  <#/GAPDoc>

LoadPackage( "RingsForHomalg" );

LoadPackage( "Modules" );

Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";

mat := HomalgMatrix( "[ x*y*z, x*y^2, x^2*z, x^2*y, x^3 ]", 1, 5, Qxyz );

M := RightPresentationWithDegrees( mat );

Mr := Resolution( M );

betti := BettiDiagram( Mr );


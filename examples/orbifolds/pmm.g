M:=[[1,2,5],[1,4,5],[2,3,4],[3,5,6],[4,5,7],[5,6,9],[5,7,8],[5,8,9]];
G1:=Group((1,2));
G2:=Group((3,4));
V:=Group((1,2),(3,4));
Isotropy:=rec(1:=V,2:=G1,3:=V,4:=G2,6:=G2,7:=V,8:=G1,9:=V);
mult:=[];

ot:=OrbifoldTriangulation(M,Isotropy,mult);
ss:=SimplicialSet(ot,4);

#up to 4 works: [ 0 ], [ 0, 0 ], [ 2, 2, 2 ] (?)
M:=[[1,2,4],[1,4,9],[2,3,5],[2,4,5],[3,5,6],[3,6,7],[4,5,7],[4,6,7],[4,6,9],[5,6,8],[5,7,8],[6,8,9]];
G:=Group((1,2));
Isotropy:=rec(1:=G,2:=G,3:=G,7:=G,8:=G,9:=G);
mult:=[];
dim := 4;

#4 works, [0],[0],[2],[2]

#cohomology over GF(2):
# GF(2)^(1 x 1)
# GF(2)^(1 x 2)
# GF(2)^(1 x 2)
# GF(2)^(1 x 2)
# GF(2)^(1 x 2)
# GF(2)^(1 x 2)

#cohomology over Z/4Z: seems to be wrong!
# Z/4Z^(1 x 1)
# Z/4Z^(1 x 1)
# Z/4Z/< ZmodnZObj(2,4) > + Z/4Z^(1 x 1)
# Z/4Z/< ZmodnZObj(2,4) >

#cohomology over Z/8Z: seems to be wrong!
# Z/8Z^(1 x 1)
# Z/8Z^(1 x 1)
# Z/8Z/< ZmodnZObj(2,8) > + Z/8Z^(1 x 1)
# Z/8Z/< ZmodnZObj(2,8) >

#cohomology over Z: Z, Z, Z/2Z, Z/2Z, ...
#  homology over Z: Z, Z + Z/2Z, Z/2Z, Z/2Z, ... (probably Z/2Z all the way)

# Ext:
# H^q(C,G) = Hom(H_q(C),G) + Ext_Z^1(H_(q-1)(C),G)
# 
#
#
#


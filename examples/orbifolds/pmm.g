# pmm (p2mm)

# http://en.wikipedia.org/wiki/Wallpaper_group#Group_pmm

M := [ [1,2,5], [1,4,5], [2,3,5], [3,5,6], [4,5,7], [5,6,9], [5,7,8], [5,8,9] ];
G1 := Group( (1,2) );
G2 := Group( (3,4) );
V := Group( (1,2), (3,4) );
Isotropy := rec( 1 := V, 2 := G1, 3 := V, 4 := G2, 6 := G2, 7 := V, 8 := G1, 9 := V );
mult := [];

dim := 3;

#matrix sizes:
# [ 8, 92, 512, 3022, 19904 ]
#factors:
# [ 11.5, 5.56522, 5.90234, 6.58637 ]

#cohomology over Z:
#----------------------------------------------->>>>  Z^(1 x 1)
#----------------------------------------------->>>>  0
#----------------------------------------------->>>>  Z/< 2 > + Z/< 2 > + Z/< 2 > + Z/< 2 >

#cohomology over GF(2):
# 1: 8 x 92 matrix with rank 7 and kernel dimension 1. Time: 0.000 sec.
# 2: 92 x 512 matrix with rank 81 and kernel dimension 11. Time: 0.004 sec.
# 3: 512 x 3022 matrix with rank 423 and kernel dimension 89. Time: 0.096 sec.
# 4: 3022 x 19904 matrix with rank 2587 and kernel dimension 435. Time: 3.488 sec.
# 5: 19904 x 136420 matrix with rank 17301 and kernel dimension 2603. Time: 136.721 sec.
# Cohomology dimension at degree 0:  GF(2)^(1 x 1)
# Cohomology dimension at degree 1:  GF(2)^(1 x 4)
# Cohomology dimension at degree 2:  GF(2)^(1 x 8)
# Cohomology dimension at degree 3:  GF(2)^(1 x 12)
# Cohomology dimension at degree 4:  GF(2)^(1 x 16)

#cohomology over Z/4Z:
#----------------------------------------------->>>>  Z/4Z^(1 x 1)
#----------------------------------------------->>>>  Z/4Z/< ZmodnZObj(2,4) >^(1 x 4)
#----------------------------------------------->>>>  Z/4Z/< ZmodnZObj(2,4) >^(1 x 8)
#----------------------------------------------->>>>  Z/4Z/< ZmodnZObj(2,4) >^(1 x 12)

#Z
#0
#  4
#  4
#  8
#  8
#

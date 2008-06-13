M := [ [1,2,4], [1,2,6], [1,4,6], [2,3,4], [2,3,6], [3,4,5], [3,5,6], [4,5,7], [4,6,7], [5,6,7] ];
C6 := Group( (1,2,3,4,5,6) );
C3 := Group( (1,3,5)(2,4,6) );
C2 := Group( (1,4)(2,5)(3,6) );
Isotropy := rec( 1 := C6, 3 := C2, 7 := C3 );
mult:=[
[ [2], [1,2], [1,2,4], [1,2,6], x -> x * (1,2,3,4,5,6) ],
[ [2], [1,2], [1,2,6], [1,2,4], x -> x * (1,6,5,4,3,2) ],
[ [5], [5,7], [4,5,7], [5,6,7], x -> x * (1,3,5)(2,4,6) ],
[ [5], [5,7], [5,6,7], [4,5,7], x -> x * (1,5,3)(2,6,4) ],
];

dim := 3;

#matrix sizes:
# [ 10, 130, 1303, 17679, 272467 ]
#factor:
# [ 13, 10.0231, 13.5679, 15.4119 ]

########## p = 2 ##########
#cohomology over GF(2):
#----------------------------------------------->>>>  GF(2)^(1 x 1)
#----------------------------------------------->>>>  GF(2)^(1 x 1)
#----------------------------------------------->>>>  GF(2)^(1 x 2)

#cohomology over Z/4Z:
#------------------------------------->>>>  Z/4Z^(1 x 1)
#------------------------------------->>>>  Z/4Z/< ZmodnZObj(2,4) > 
#------------------------------------->>>>  Z/4Z/< ZmodnZObj(2,4) > + Z/4Z^(1 x 1)
 

########## p = 3 ##########
#cohomology over GF(3):
#----------------------------------------------->>>>  GF(3)^(1 x 1)
#----------------------------------------------->>>>  GF(3)^(1 x 1)
#----------------------------------------------->>>>  GF(3)^(1 x 2)

#cohomology over Z/9Z:
#------------------------------------->>>>  Z/9Z^(1 x 1)
#------------------------------------->>>>  Z/9Z/< ZmodnZObj(3,9) > 
#------------------------------------->>>>  Z/9Z/< ZmodnZObj(3,9) > + Z/9Z^(1 x 1)


########## p = 5 ##########
#cohomology over GF(5):
#----------------------------------------------->>>>  GF(5)^(1 x 1)
#----------------------------------------------->>>>  0
#----------------------------------------------->>>>  GF(5)^(1 x 1)

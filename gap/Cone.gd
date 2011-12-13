#############################################################################
##
##  Cone.gd         ConvexForHomalg package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Cones for ConvexForHomalg.
##
#############################################################################

DeclareCategory( "IsHomalgCone",
                 IsConvexObject );


################################
##
## Basic Properties
##
################################

DeclareProperty( "IsPointedCone",
                 IsHomalgCone );

DeclareProperty( "IsSmooth",
                 IsHomalgCone );

DeclareProperty( "IsRegular",
                 IsHomalgCone );

################################
##
## Attributes
##
################################

DeclareAttribute( "RayGenerators",
                  IsHomalgCone );

DeclareAttribute( "DualCone",
                  IsHomalgCone );

################################
##
## Constructors
##
################################


DeclareOperation( "HomalgCone",
                  [ IsHomalgCone ] );

DeclareOperation( "HomalgCone",
                  [ IsList ] );

DeclareOperation( "HomalgCone",
                  [ IsInt ] );



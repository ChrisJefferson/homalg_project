#############################################################################
##
##  Fan.gd         ConvexForHomalg package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Fans for ConvexForHomalg.
##
#############################################################################

DeclareCategory( "IsHomalgFan",
                 IsConvexObject );

####################################
##
## Attributes
##
####################################

DeclareAttribute( "Rays",
                  IsHomalgFan );

DeclareAttribute( "RayGenerators",
                  IsHomalgFan );

DeclareAttribute( "RaysInMaximalCones",
                  IsHomalgFan );

DeclareAttribute( "MaximalCones",
                  IsHomalgFan );

####################################
##
## Properties
##
####################################

DeclareProperty( "IsComplete",
                 IsHomalgFan );

DeclareProperty( "IsPointed",
                 IsHomalgFan );

DeclareProperty( "IsSmooth",
                 IsHomalgFan );

DeclareProperty( "IsRegularFan",
                 IsHomalgFan );

DeclareProperty( "IsSimplicial",
                 IsHomalgFan );

####################################
##
## Methods
##
####################################

DeclareOperation( "\*",
                 [ IsHomalgFan, IsHomalgFan ] );

####################################
##
## Constructors
##
####################################

DeclareOperation( "HomalgFan",
                 [ IsHomalgFan ] );

DeclareOperation( "HomalgFan",
                 [ IsInt ] );

DeclareOperation( "HomalgFan",
                 [ IsList ] );

DeclareOperation( "HomalgFan",
                 [ IsList, IsList ] );
#############################################################################
##
##  ExternalSystem.gd          ConvexForHomalg package      Sebastian Gutsche
##
##  Copyright 2011-2012 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declares Methods for an external CAS
##
#############################################################################


####################################
#
# Cone Methods
#
####################################


DeclareOperation( "EXT_CREATE_CONE_BY_RAYS",
        [ IsList ] );
        
DeclareOperation( "EXT_CREATE_DUAL_CONE_OF_CONE",
        [ IsHomalgCone and IsExternalConvexObjectRep ] );

DeclareOperation( "EXT_IS_POINTED_CONE",
        [ IsHomalgCone and IsExternalConvexObjectRep ] );

####################################
#
# Recover Methods
#
####################################
        
DeclareOperation( "EXT_GENERATING_RAYS_OF_CONE",
        [ IsHomalgCone and IsExternalConvexObjectRep ] );
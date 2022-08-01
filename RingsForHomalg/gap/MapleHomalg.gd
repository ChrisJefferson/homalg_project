#############################################################################
##
##  MapleHomalg.gd            RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for the external computer algebra system Maple.
##
#############################################################################

####################################
#
# global variables:
#
####################################

DeclareGlobalVariable( "HOMALG_IO_Maple" );

DeclareGlobalVariable( "MapleMacros" );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "_MapleHomalg_SetRing" );

DeclareGlobalFunction( "_Maple_multiple_delete" );

DeclareGlobalFunction( "InitializeMapleMacros" );

# constructor methods:

DeclareGlobalFunction( "RingForHomalgInMapleUsingPIR" );

DeclareGlobalFunction( "RingForHomalgInMapleUsingInvolutive" );

DeclareGlobalFunction( "RingForHomalgInMapleUsingJanet" );

DeclareGlobalFunction( "RingForHomalgInMapleUsingJanetOre" );

DeclareGlobalFunction( "RingForHomalgInMapleUsingOreModules" );

DeclareGlobalFunction( "HomalgRingOfIntegersInMaple" );

DeclareGlobalFunction( "HomalgFieldOfRationalsInMaple" );

DeclareGlobalFunction( "MapleHomalgOptions" );

# basic operations:


####################################
#
# representations:
#
####################################

# a new subrepresentation of the representation IshomalgExternalRingObjectRep:
DeclareRepresentation( "IsHomalgExternalRingObjectInMapleRep",
        IshomalgExternalRingObjectRep,
        [  ] );

# five new subrepresentations of the representation IsHomalgExternalRingObjectInMapleRep:
DeclareRepresentation( "IsHomalgExternalRingObjectInMapleUsingPIRRep",
        IsHomalgExternalRingObjectInMapleRep,
        [  ] );

DeclareRepresentation( "IsHomalgExternalRingObjectInMapleUsingInvolutiveRep",
        IsHomalgExternalRingObjectInMapleRep,
        [  ] );

DeclareRepresentation( "IsHomalgExternalRingObjectInMapleUsingJanetRep",
        IsHomalgExternalRingObjectInMapleRep,
        [  ] );

DeclareRepresentation( "IsHomalgExternalRingObjectInMapleUsingJanetOreRep",
        IsHomalgExternalRingObjectInMapleRep,
        [  ] );

DeclareRepresentation( "IsHomalgExternalRingObjectInMapleUsingOreModulesRep",
        IsHomalgExternalRingObjectInMapleRep,
        [  ] );

# a new subrepresentation of the representation IsHomalgExternalRingRep:
DeclareRepresentation( "IsHomalgExternalRingInMapleRep",
        IsHomalgExternalRingRep,
        [  ] );

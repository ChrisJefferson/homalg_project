#############################################################################
##
##  LITorSubvar.gi     ToricVarieties       Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Logical implications for toric subvarieties.
##
#############################################################################

#############################
##
## True methods
##
#############################

##
InstallTrueMethod( IsWholeVariety, IsOpen and IsClosed );

##
InstallTrueMethod( IsOpen, IsWholeVariety );

##
InstallTrueMethod( IsClosed, IsWholeVariety );

#############################################################################
##
##  HomalgToCAS.gd            IO_ForHomalg package           Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff to use the fantastic GAP4 I/O package of Max.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "homalgFlush" );

DeclareGlobalFunction( "_SetElmWPObj_ForHomalg" );

DeclareGlobalFunction( "homalgCreateStringForExternalCASystem" );

DeclareGlobalFunction( "homalgSendBlocking" ); ## this name was implicitly suggested by Max Neunhöffer ;)

DeclareGlobalFunction( "homalgDisplay" );

DeclareGlobalFunction( "StringToInt" );

DeclareGlobalFunction( "StringToIntList" );

DeclareGlobalFunction( "StringToDoubleIntList" );


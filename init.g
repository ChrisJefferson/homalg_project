#############################################################################
##
##  init.g                    RingsForHomalg package            Mohamed Barakat
##                                                           Simon G�rtzen
##                                                           Max Neunh�ffer
##                                                           Daniel Robertz
##
##  Copyright 2007-2008 Lehrstuhl B f�r Mathematik, RWTH Aachen
##
##  Reading the declaration part of the RingsForHomalg package.
##
#############################################################################

ReadPackage( "RingsForHomalg", "gap/RingsForHomalg.gd" );

ReadPackage( "RingsForHomalg", "gap/IO.gd" );

## GAP
ReadPackage( "RingsForHomalg", "gap/GAPHomalgTools.gd" );
ReadPackage( "RingsForHomalg", "gap/GAPHomalgDefault.gd" );
ReadPackage( "RingsForHomalg", "gap/GAPHomalgBestBasis.gd" );

ReadPackage( "RingsForHomalg", "gap/GAPHomalgPIR.gd" );
#ReadPackage( "RingsForHomalg", "gap/GAPHomalgInvolutive.gd" );

## Sage
ReadPackage( "RingsForHomalg", "gap/SageTools.gd" );
ReadPackage( "RingsForHomalg", "gap/SageDefault.gd" );
ReadPackage( "RingsForHomalg", "gap/SageBestBasis.gd" );

ReadPackage( "RingsForHomalg", "gap/SageIntegers.gd" );
ReadPackage( "RingsForHomalg", "gap/SageGF2.gd" );

## Maple (using the Maple implementation of homalg)
ReadPackage( "RingsForHomalg", "gap/MapleHomalgTools.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgDefault.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgBestBasis.gd" );

ReadPackage( "RingsForHomalg", "gap/MapleHomalgPIR.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgInvolutive.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgJanet.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgJanetOre.gd" );
ReadPackage( "RingsForHomalg", "gap/MapleHomalgOreModules.gd" );

## MAGMA
ReadPackage( "RingsForHomalg", "gap/MagmaTools.gd" );
ReadPackage( "RingsForHomalg", "gap/MagmaDefault.gd" );
ReadPackage( "RingsForHomalg", "gap/MagmaBestBasis.gd" );

ReadPackage( "RingsForHomalg", "gap/MagmaIntegers.gd" );
ReadPackage( "RingsForHomalg", "gap/MagmaGF2.gd" );

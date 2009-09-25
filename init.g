#############################################################################
##
##  init.g                homalg package                    Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Reading the declaration part of the homalg package.
##
#############################################################################

ReadPackage( "homalg", "gap/homalg.gd" );

## rings
ReadPackage( "homalg", "gap/homalgTable.gd" );
ReadPackage( "homalg", "gap/HomalgRing.gd" );
ReadPackage( "homalg", "gap/HomalgRingMap.gd" );

## matrices
ReadPackage( "homalg", "gap/HomalgMatrix.gd" );

## relations/generators
ReadPackage( "homalg", "gap/HomalgRelations.gd" );
ReadPackage( "homalg", "gap/SetsOfRelations.gd" );
ReadPackage( "homalg", "gap/HomalgGenerators.gd" );
ReadPackage( "homalg", "gap/SetsOfGenerators.gd" );

## modules
ReadPackage( "homalg", "gap/HomalgModule.gd" );

## morphisms
ReadPackage( "homalg", "gap/HomalgMap.gd" );

## filtrations
ReadPackage( "homalg", "gap/HomalgFiltration.gd" );

## complexes
ReadPackage( "homalg", "gap/HomalgComplex.gd" );

## chain maps
ReadPackage( "homalg", "gap/HomalgChainMap.gd" );

## bicomplexes
ReadPackage( "homalg", "gap/HomalgBicomplex.gd" );

## bigraded objects
ReadPackage( "homalg", "gap/HomalgBigradedObject.gd" );

## spectral sequences
ReadPackage( "homalg", "gap/HomalgSpectralSequence.gd" );

## functors
ReadPackage( "homalg", "gap/HomalgFunctor.gd" );

## diagrams
ReadPackage( "homalg", "gap/HomalgDiagram.gd" );

## tools/service/basic
ReadPackage( "homalg", "gap/Tools.gd" );
ReadPackage( "homalg", "gap/Service.gd" );
ReadPackage( "homalg", "gap/Basic.gd" );

## main
ReadPackage( "homalg", "gap/Modules.gd" );

ReadPackage( "homalg", "gap/Maps.gd" );

ReadPackage( "homalg", "gap/Complexes.gd" );

ReadPackage( "homalg", "gap/ChainMaps.gd" );

ReadPackage( "homalg", "gap/SpectralSequences.gd" );

ReadPackage( "homalg", "gap/Filtrations.gd" );

ReadPackage( "homalg", "gap/ToolFunctors.gd" );
ReadPackage( "homalg", "gap/BasicFunctors.gd" );
ReadPackage( "homalg", "gap/OtherFunctors.gd" );

## LogicForHomalg subpackages
ReadPackage( "homalg", "gap/LIRNG.gd" );
ReadPackage( "homalg", "gap/LIMAP.gd" );
ReadPackage( "homalg", "gap/LIMAT.gd" );
ReadPackage( "homalg", "gap/COLEM.gd" );
ReadPackage( "homalg", "gap/LIMOD.gd" );
ReadPackage( "homalg", "gap/LIMOR.gd" );
ReadPackage( "homalg", "gap/LICPX.gd" );

## the subpackage ResidueClassRingForHomalg
ReadPackage( "homalg", "gap/ResidueClassRingForHomalg.gd" );
ReadPackage( "homalg", "gap/ResidueClassRing.gd" );
ReadPackage( "homalg", "gap/ResidueClassRingBasic.gd" );
ReadPackage( "homalg", "gap/ResidueClassRingTools.gd" );

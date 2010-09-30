##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

## we need the homalg book loaded
LoadPackage( "homalg" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/Modules.bib" );
WriteBibXMLextFile( "doc/ModulesBib.xml", bib );

list := [
         "../gap/HomalgRingMap.gd",
         "../gap/HomalgRingMap.gi",
         "../gap/HomalgRelations.gd",
         "../gap/HomalgRelations.gi",
         "../gap/HomalgGenerators.gd",
         "../gap/HomalgGenerators.gi",
         "../gap/HomalgModule.gd",
         "../gap/HomalgModule.gi",
         "../gap/HomalgSubmodule.gd",
         "../gap/HomalgSubmodule.gi",
         "../gap/HomalgMap.gd",
         "../gap/HomalgMap.gi",
         "../gap/Modules.gi",
         "../gap/LIMAP.gi",
         "../gap/BasicFunctors.gi",
         "../examples/RHom_Z.g",
         "../examples/LTensorProduct_Z.g",
         "../examples/ExtExt.g",
         "../examples/Purity.g",
         "../examples/TorExt_Grothendieck.g",
         "../examples/TorExt.g",
         "../examples/Hom(Hom(-,Z128),Z16)_On_Seq.g",
         "../examples/Saturate.g",
         "../gap/Tools.gi",
         ];

MakeGAPDocDoc( "doc", "ModulesForHomalg", list, "ModulesForHomalg" );

GAPDocManualLab( "Modules" );

quit;

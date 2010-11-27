##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/LocalizeRingForHomalg.bib" );
WriteBibXMLextFile( "doc/LocalizeRingForHomalgBib.xml", bib );

list := [
         "../gap/LocalizeRing.gd",
         "../gap/LocalizeRing.gi",
         "../gap/LocalizeRingBasic.gd",
         "../gap/LocalizeRingBasic.gi",
         "../gap/LocalizeRingMora.gd",
         "../gap/LocalizeRingMora.gi",
         "../examples/Hom\(Hom\(-\,Z128\)\,Z16\)_On_Seq.g",
         "../examples/QuickstartZ.g",
         "../examples/ResidueClass.g",
         "../examples/EasyPoly.g",
         "../examples/Intersection.g",
         ];

PrintTo( "VERSION", PackageInfo( "LocalizeRingForHomalg" )[1].Version );

MakeGAPDocDoc( "doc", "LocalizeRingForHomalg", list, "LocalizeRingForHomalg" );

GAPDocManualLab("LocalizeRingForHomalg");

quit;

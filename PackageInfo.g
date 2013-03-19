


SetPackageInfo( rec(

PackageName := "4ti2Interface",

Subtitle := "Special methods and knowledge propagation tools",

Version := Maximum( [
  "2013.03.19", ## Sebas' version
] ),

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

ArchiveURL := Concatenation( "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/4ti2Interface/4ti2Interface-", ~.Version ),

ArchiveFormats := ".tar.gz",



Persons := [
  rec(
    LastName      := "Gutsche",
    FirstNames    := "Sebastian",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "sebastian.gutsche@rwth-aachen.de",
    WWWHome       := "http://wwwb.math.rwth-aachen.de/~gutsche/",
    PostalAddress := Concatenation( [
                       "Sebastian Gutsche\n",
                       "Lehrstuhl B fuer Mathematik, RWTH Aachen\n",
                       "Templergraben 64\n",
                       "52062 Aachen\n",
                       "Germany" ] ),
    Place         := "Aachen",
    Institution   := "RWTH Aachen University"
  ),
  
],

Status := "dev",


#README_URL := 
#  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/4ti2Interface/README.4ti2Interface",
#PackageInfoURL := 
#  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/4ti2Interface/PackageInfo.g",

#AbstractHTML := 
#  "The <span class=\"pkgname\">4ti2Interface</span> package provides GAP extensions for the homalg project",
PackageWWWHome := "http://homalg.math.rwth-aachen.de/index.php/core-packages/matricesforhomalg",
PackageDoc := rec(
  BookName  := "4ti2Interface",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "An interface to 4ti2.",
  Autoload  := false
),


Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.0" ], [ "AutoDoc", ">=2012.07.29" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := []
                      
),

AvailabilityTest := function()
    return true;
  end,

Autoload := false,


Keywords := [  ]

));



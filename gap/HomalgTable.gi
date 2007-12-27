#############################################################################
##
##  HomalgTable.gi          homalg package                   Mohamed Barakat
##
##  Copyright 2007 Lehrstuhl B f�r Mathematik, RWTH Aachen
##
##  Implementation stuff for rings.
##
#############################################################################

####################################
#
# representations:
#
####################################

# a new representation for the category IsHomalgTable:
DeclareRepresentation( "IsHomalgTableRep",
        IsHomalgTable,
        [ "ring" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "HomalgTableFamily",
        NewFamily( "HomalgTableFamily" ));

# a new type:
BindGlobal( "HomalgTableType",
        NewType( HomalgTableFamily,
                IsHomalgTableRep ));

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for rings",
        [ IsSemiringWithOneAndZero ],
        
  function ( arg )
    local RP;
    
    RP := rec( ring := arg[1] );
    
    Objectify( HomalgTableType, RP );
    
    return RP;
    
end );

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( BasisOfModule,
        "for homalg tables",
        [ IsHomalgTableRep ],
        
  function( RP )
    
    return BasisOfModule;
    
end );

##
InstallMethod( CertainRows,
        "for homalg tables",
        [ IsHomalgTableRep ],
        
  function( RP )
    
    return CertainRows;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for a homalg ring package conversion table",
        [ IsHomalgTableRep ],
        
  function( o )
    
    Print("<A homalg ring package conversion table>");
    
end );


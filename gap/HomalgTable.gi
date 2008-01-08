#############################################################################
##
##  HomalgTable.gi          homalg package                   Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B f�r Mathematik, RWTH Aachen
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
# methods for attributes:
#
####################################

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
    
    RP := rec( );
    
    Objectify( HomalgTableType, RP );
    
    return RP;
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsMatrixForHomalg, IsList ],
        
  function( M, plist )
    
    return Eval( M ){plist};
    
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

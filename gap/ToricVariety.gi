#############################################################################
##
##  ToricVariety.gi         ToricVarietiesForHomalg package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  The Category of toric Varieties
##
#############################################################################

#################################
##
## Representations
##
#################################

DeclareRepresentation( "IsSheafRep",
                       IsToricVariety and IsAttributeStoringRep,
                       [ "Sheaf" ]
                      );

DeclareRepresentation( "IsCombinatoricalRep",
                       IsToricVariety and IsAttributeStoringRep,
                       [ "ConvexObject" ]
                      );

DeclareRepresentation( "IsFanRep",
                       IsCombinatoricalRep,
                       []
                      );

##################################
##
## Family and Type
##
##################################

BindGlobal( "TheFamilyOfToricVarietes",
        NewFamily( "TheFamilyOfToricVarietes" , IsToricVariety ) );

BindGlobal( "TheTypeFanToricVariety",
        NewType( TheFamilyOfToricVarietes,
                 IsFanRep ) );

##################################
##
## Properties
##
##################################

##
InstallMethod( IsAffine,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    local conv;
    
    conv := UnderlyingConvexObject( vari );
    
    if Length( MaximalCones( conv ) ) = 1 then
        
        return true;
        
    fi;
    
    return false;
    
end );


##################################
##
## Methods
##
##################################

##
InstallMethod( UnderlyingConvexObject,
               " getter for convex object",
               [ IsToricVariety ],
               
  function( var )
    
    if IsBound( var!.ConvexObject ) then
        
        return var!.ConvexObject;
        
    else
        
        Error( " no combinatorical object." );
        
    fi;
    
end );

##
InstallMethod( UnderlyingSheaf,
               " getter for the sheaf",
               [ IsToricVariety ],
               
  function( var )
    
    if IsBound( var!.Sheaf ) then
        
        return var!.Sheaf;
        
    else
        
        Error( " no sheaf." );
        
    fi;
    
end );

##################################
##
## Constructors
##
##################################

##
InstallMethod( ToricVariety,
               " for homalg fans",
               [ IsHomalgFan ],
               
  function( fan )
    local var;
    
    var := rec(
                ConvexObject := fan
               );
    
    ObjectifyWithAttributes( 
                             var, TheTypeFanToricVariety
                            );
    
    return var;
    
end );

#################################
##
## Display
##
#################################

##
InstallMethod( ViewObj,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( var )
    
    Print( "<A" );
    
    if HasIsAffine( var ) then
        
        if IsAffine( var ) then
            
            Print( " affine");
            
        fi;
        
    fi;
    
    Print( " toric variety" );
    
    Print( ">" );
    
end );

##
InstallMethod( Display,
               " for toric varieties",
               [ IsToricVariety ],
               
  function( var )
    
    Print( "A" );
    
    if HasIsAffine( var ) then
        
        if IsAffine( var ) then
            
            Print( " affine");
            
        fi;
        
    fi;
    
    Print( " toric variety" );
    
    Print( "." );
    
end );

#############################################################################
##
##  Fan.gi         ConvexForHomalg package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Fans for ConvexForHomalg.
##
#############################################################################

####################################
##
## Reps
##
####################################

DeclareRepresentation( "IsExternalFanRep",
                       IsHomalgFan and IsExternalConvexObjectRep,
                       [ ]
                      );

DeclareRepresentation( "IsPolymakeFanRep",
                       IsExternalFanRep,
                       [ ]
                      );

####################################
##
## Types and Families
##
####################################


BindGlobal( "TheFamilyOfFans",
        NewFamily( "TheFamilyOfFans" , IsHomalgFan ) );

BindGlobal( "TheTypeExternalFan",
        NewType( TheFamilyOfFans,
                 IsHomalgFan and IsExternalFanRep ) );

BindGlobal( "TheTypePolymakeFan",
        NewType( TheFamilyOfFans,
                 IsPolymakeFanRep ) );

####################################
##
## Attributes
##
####################################

##
InstallMethod( Rays,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_RAYS_OF_FAN( fan );
    
end );

##
InstallMethod( RaysInMaximalCones,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_RAYS_IN_MAXCONES_OF_FAN( fan );
    
end );

##
InstallMethod( MaximalCones,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    local raylist, rays, conelist, i, lis, j;
    
    raylist := RaysInMaximalCones( fan );
    
    rays := Rays( fan );
    
    conelist := [ ];
    
    for i in [ 1..Length( raylist ) ] do
        
        lis := [ ];
        
        for j in [ 1 .. Length( raylist[ i ] ) ] do
            
            if raylist[ i ][ j ] = 1 then
                
                lis := Concatenation( lis, [ rays[ j ] ] );
                
            fi;
            
        od;
        
        conelist := Concatenation( conelist, [ lis ] );
        
    od;
    
    return conelist;
    
    TryNextMethod();
    
end );

##
InstallMethod( Dimension,
               " for external fans. ",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_DIM_OF_FAN( fan );
    
end );

##
InstallMethod( ContainingSpaceDimension,
               " for external fans. ",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_AMBIENT_DIM_OF_FAN( fan );
    
end );

####################################
##
## Properties
##
####################################

##
InstallMethod( IsComplete,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_IS_COMPLETE_FAN( fan );
    
end );

##
InstallMethod( IsPointed,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_IS_POINTED_FAN( fan );
    
end );

##
InstallMethod( IsSmooth,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_IS_SMOOTH_FAN( fan );
    
end );

##
InstallMethod( IsRegular,
               " for external fans.",
               [ IsExternalFanRep ],
               
  function( fan )
    
    return EXT_IS_REGULAR_FAN( fan );
    
end );

##
InstallMethod( IsFullDimensional,
               "for homalg cones.",
               [ IsExternalFanRep ],
  function( fan )
    
    return EXT_IS_FULL_DIMENSIONAL_FAN( fan );
    
end );

####################################
##
## Constructors
##
####################################

##
InstallMethod( HomalgFan,
               " for homalg fans",
               [ IsHomalgFan ],
               
  IdFunc
  
);

##
InstallMethod( HomalgFan,
               " for homalg fans",
               [ IsInt ],
               
  function( point )
    
    point := rec(
                  WeakPointerToExternalObject := point 
             );
    
    ObjectifyWithAttributes(
                             point, TheTypePolymakeFan
                            );
    
    return point;
    
end );

##
InstallMethod( HomalgFan,
               " for lists of HomalgCones",
               [ IsList ],
               
  function( cones )
    local point;
    
    if Length( cones ) = 0 then
        
        Error( " fan has to have the trivial cone." );
        
    fi;
    
    if IsHomalgCone( cones[ 1 ] ) then
        
        cones := List( cones, RayGenerators );
        
    fi;
    
    point := rec( 
        WeakPointerToExternalObject := EXT_FAN_BY_CONES( cones )
        );
    
    ObjectifyWithAttributes(
        point, TheTypePolymakeFan
        );
    
    return point;
    
end );

InstallMethod( HomalgFan,
               " for rays and cones.",
               [ IsList, IsList ],
               
  function( rays, cones )
    local point;
    
    if Length( cones ) = 0 or Length( rays ) = 0 then
        
        Error( " fan has to have the trivial cone." );
        
    fi;
    
    point := rec( 
        WeakPointerToExternalObject := EXT_FAN_BY_RAYS_AND_CONES( rays, cones )
        );
    
    ObjectifyWithAttributes(
        point, TheTypePolymakeFan
        );
    
    return point;
    
end );

####################################
##
## Display Methods
##
####################################

##
InstallMethod( ViewObj,
               "for homalg fans",
               [ IsHomalgFan ],
               
  function( fan )
    local str;
    
    Print( "<A" );
    
    if HasIsComplete( fan ) then
        
        if IsComplete( fan ) then
            
            Print( " complete" );
            
        fi;
    
    fi;
    
    if HasIsPointed( fan ) then
        
        if IsPointed( fan ) then
            
            Print( " pointed" );
            
        fi;
    
    fi;
      
    if HasIsSmooth( fan ) then
        
        if IsSmooth( fan ) then
            
            Print( " smooth" );
            
        fi;
    
    fi;
    
    Print( " fan" );
    
    if HasRays( fan ) then
        
        Print( " with ", String( Length( Rays( fan ) ) )," rays" );
        
    fi;
    
    Print( ">" );
    
end );

##
InstallMethod( Display,
               "for homalg polytopes",
               [ IsHomalgFan ],
               
  function( fan )
    local str;
    
    Print( "A" );
    
    if HasIsComplete( fan ) then
        
        if IsComplete( fan ) then
            
            Print( " complete" );
            
        fi;
    
    fi;
    
    Print( " fan" );
    
    if HasRays( fan ) then
        
        Print( " with ", String( Length( Rays( fan ) ) )," rays" );
        
    fi;
    
    Print( ".\n" );
    
end );

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

##
InstallMethod( IsProjective,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    
    
    if not IsComplete( vari ) then
        
        return false;
        
    fi;
    
    return IsRegular( UnderlyingConvexObject( vari ) );
    
end );

##
InstallMethod( IsSmooth,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    
    return IsSmooth( UnderlyingConvexObject( vari ) );
    
end );

##
InstallMethod( IsComplete,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    
    return IsComplete( UnderlyingConvexObject( vari ) );
    
end );

##
InstallMethod( HasTorusfactor,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    local ret;
    
    ret := IsFullDimensional( UnderlyingConvexObject( vari ) );
    
    if ret then
        
        SetDimensionOfTorusfactor( vari, 0 );
        
    fi;
    
    return not ret;
    
end );

##
InstallMethod( ClassGroup,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    local dims, rays, M, grou;
    
    dims := Dimension( vari );
    
    rays := Rays( UnderlyingConvexObject( vari ) );
    
    M := HomalgMatrix( Flat( rays ), Length( rays ), dims, HOMALG_MATRICES.ZZ );
    
    M := Involution( M );
    
    M := HomalgMap( M, "free", "free" );
    
    return Cokernel( M );
    
end );

##
InstallMethod( PicardGroup,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    
    if IsAffine( vari ) then
        
        return 0 * HOMALG_MATRICES.ZZ;
        
    fi;
    
    if IsSmooth( vari ) then
        
        return ClassGroup( vari );
    fi;
    
    if not HasTorusfactor( vari ) then
        
        if IsSimplicial( vari ) then
            
            return Rank( ClassGroup( vari ) ) * HOMALG_MATRICES.ZZ;
            
        fi;
        
    fi;
    
    TryNextMethod();
    
end );

##################################
##
## Attributes
##
##################################

##
InstallMethod( Dimension,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    
    return AmbientSpaceDimension( UnderlyingConvexObject( vari ) );
    
end );

##
InstallMethod( DimensionOfTorusfactor,
               "for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    local dim, cdim;
    
    if not HasTorusfactor( vari ) then
        
        return 0;
    fi;
    
    dim := Dimension( UnderlyingConvexObject( vari ) );
    
    cdim := Dimension( vari );
    
    return cdim - dim;
    
end );

##
InstallMethod( AffineOpenCovering,
               " for convex varieties",
               [ IsFanRep ],
               
  function( vari )
    local cones;
    
    cones := MaximalCones( UnderlyingConvexObject( vari ) );
    
    return List( cones, ToricVariety );
    
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

##
InstallMethod( CoordinateRingOfTorus,
               " for affine convex varieties",
               [ IsFanRep, IsList ],
               
  function( vari, vars )
    local n, ring, i, rels;
    
    if HasCoordinateRingOfTorus( vari ) then
        
        return CoordinateRingOfTorus( vari );
        
    fi;
    
    n := AmbientSpaceDimension( UnderlyingConvexObject( vari ) );
    
    if ( not Length( vars ) = 2 * n ) and ( not Length( vars ) = n ) then
        
        Error( "incorrect number of indets." );
        
    fi;
    
    if Length( vars ) = n then
        
        vars := List( vars, i -> [ i, JoinStringsWithSeparator( [i,"1"], "" ) ] );
        
        vars := List( vars, i -> JoinStringsWithSeparator( i, "," ) );
        
    fi;
    
    vars := JoinStringsWithSeparator( vars );
    
    ring := HomalgFieldOfRationalsInDefaultCAS() * vars;
    
    vars := Indeterminates( ring );
    
    rels := [ 1..n ];
    
    for i in [ 1 .. n ] do
        
        rels[ i ] := vars[ 2*i - 1 ] * vars[ 2*i ] - 1;
        
    od;
    
    ring := ring / rels;
    
    SetCoordinateRingOfTorus( vari, ring );
    
    return ring;
    
end );

##
InstallMethod( \*,
               "for toric varieties",
               [ IsCombinatoricalRep, IsCombinatoricalRep ],
               
  function( var1, var2 )
    
    return ToricVariety( UnderlyingConvexObject( var1 ) * UnderlyingConvexObject( var2 ) );
    
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
    
    if not IsPointed( fan ) then
        
        Error( " input fan must only contain strictly convex cones." );
        
    fi;
    
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
            
            Print( "n affine");
            
        fi;
        
    fi;
    
    if HasIsSmooth( var ) then
        
        if IsSmooth( var ) then
            
            Print( " smooth");
            
        fi;
        
    fi;
    
    if HasIsProjective( var ) then
        
        if IsProjective( var ) then
            
            Print( " projective");
            
        fi;
        
    fi;
    
    if HasIsComplete( var ) then
        
        if IsComplete( var ) then
            
            Print( " complete");
            
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
            
            Print( "n affine");
            
        fi;
        
    fi;
    
    if HasIsSmooth( var ) then
        
        if IsSmooth( var ) then
            
            Print( " smooth");
            
        fi;
        
    fi;
    
    if HasIsProjective( var ) then
        
        if IsProjective( var ) then
            
            Print( " projective");
            
        fi;
        
    fi;
    
    if HasIsComplete( var ) then
        
        if IsComplete( var ) then
            
            Print( " complete");
            
        fi;
        
    fi;
    
    Print( " toric variety" );
    
    Print( "." );
    
end );

#############################################################################
##
##  AffineToricVariety.gi     ToricVarietiesForHomalg package       Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  The Category of affine toric Varieties
##
#############################################################################

#################################
##
## Representations
##
#################################

DeclareRepresentation( "IsAffineSheafRep",
                       IsAffineToricVariety and IsSheafRep,
                       [ "Sheaf" ]
                      );

DeclareRepresentation( "IsAffineCombinatoricalRep",
                       IsAffineToricVariety and IsCombinatoricalRep,
                       [ ]
                      );

DeclareRepresentation( "IsConeRep",
                       IsAffineCombinatoricalRep and IsFanRep,
                       []
                      );

##################################
##
## Family and Type
##
##################################

BindGlobal( "TheTypeConeToricVariety",
        NewType( TheFamilyOfToricVarietes,
                 IsConeRep ) );

##################################
##
## Properties
##
##################################

##
InstallMethod( IsSmooth,
               " for convex varieties",
               [ IsConeRep ],
               
  function( vari )
    
    return IsSmooth( UnderlyingConvexObject( vari ) );
    
end );

##################################
##
## Attributes
##
##################################

##
InstallMethod( PicardGroup,
               " for affine conxev varieties",
               [ IsConeRep ],
               
  function( vari )
    
    return 0 * HOMALG_MATRICES.ZZ;
    
end );

##################################
##
## Methods
##
##################################

##
InstallMethod( FanToConeRep,
               " for affine varieties",
               [ IsFanRep ],
               
  function( vari )
    local rays, cone;
    
    if not IsAffine( vari ) then
        
        Error( " variety is not affine." );
        
    fi;
    
    rays := UnderlyingConvexObject( vari );
    
    rays := Rays( rays );
    
    cone := HomalgCone( rays );
    
    vari!.ConvexObject := cone;
    
    ChangeTypeObj( TheTypeConeToricVariety, vari );
    
    SetIsAffine( vari, true );
    
    SetIsProjective( vari, false );
    
    SetIsComplete( vari, false );
    
    return vari;
    
end );

##################################
##
## Constructors
##
##################################

##
InstallMethod( ToricVariety,
               " for cones",
               [ IsHomalgCone ],
               
  function( cone )
    local vari;
    
    vari := rec(
                ConvexObject := cone 
               );
    
    ObjectifyWithAttributes(
                            vari, TheTypeConeToricVariety
                            );
    
    SetIsAffine( vari, true );
    
    SetIsProjective( vari, false );
    
    SetIsComplete( vari, false );
    
    SetAffineOpenCovering( vari, vari );
    
##    SetIsNormal( vari, true );
    
    return vari;
    
end );


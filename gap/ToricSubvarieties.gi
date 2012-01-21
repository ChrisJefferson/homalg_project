#############################################################################
##
##  ToricSubarieties.gi         ToricVarieties package         Sebastian Gutsche
##
##  Copyright 2011 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  The Category of toric Varieties
##
#############################################################################

DeclareRepresentation( "IsCombinatoricalSubRep",
                       IsToricSubvariety and IsAttributeStoringRep,
                       [ UnderlyingToricVariety, AmbientToricVariety ]
                      );

DeclareRepresentation( "IsFanSubRep",
                       IsCombinatoricalSubRep,
                       [ ]
                      );

##################################
##
## Family and Type
##
##################################


BindGlobal( "TheTypeFanToricSubariety",
        NewType( TheFamilyOfToricVarietes,
                 IsFanSubRep ) );

##
TORIC_VARIETIES!.prop_and_attr_shared_by_vars_and_subvars := [
                "IsNormalVariety",
                "IsAffine",
                "IsProjective",
                "IsSmooth",
                "IsComplete",
                "HasTorusfactor",
                "AffineOpenCovering",
                "CoxRing",
                "ClassGroup",
                "PicardGroup",
                "DivisorGroup",
                "MapFromCharacterToPrincipalDivisor",
                "Dimension",
                "DimensionOfTorusfactor",
                "CoordinateRingOfTorus",
                "IsProductOf",
                "CharacterGrid",
                "PrimeDivisors",
                "IrrelevantIdeal",
                "FanOfVariety",
                "PolytopeOfVariety",
                "ConeOfVariety"
                                                             ];


##################################
##
## Constructors
##
##################################

##
InstallTrueMethod( IsOpen and IsClosed, IsWholeVariety );

##
InstallTrueMethod( IsWholeVariety, IsOpen );

##
InstallTrueMethod( IsWholeVariety, IsClosed );

##
InstallMethod( ClosureOfTorusOrbitOfCone,
               " for homalg cone",
               [ IsFanRep, IsHomalgCone ],
               
  function( vari, cone )
    local newfan;
    
    newfan := StarFan( cone, FanOfVariety( vari ) );
    
    newfan := ToricVariety( newfan );
    
    newfan := ToricSubvariety( newfan, vari );
    
    SetIsClosed( newfan, true );
    
    SetIsOpen( newfan, false );
    
    return newfan;
    
end );

InstallMethod( ToricSubvariety,
               " for 2 toric varieties",
               [ IsToricVariety, IsToricVariety ],
               
  function( vari, ambvari )
    local suvari;
    
    suvari := rec( );
    
    ObjectifyWithAttributes(
                            suvari, TheTypeFanToricSubariety,
                            UnderlyingToricVariety, vari,
                            AmbientToricVariety, ambvari
    );
    
    return suvari;
    
end );







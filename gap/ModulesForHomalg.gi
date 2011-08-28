#############################################################################
##
##  ModulesForHomalg.gi         Modules package              Mohamed Barakat
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Implementation stuff for ModulesForHomalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( HOMALG_MODULES,
        rec(
            category := rec(
                            description := "f.p. modules and their maps over computable rings",
                            short_description := "_for_fp_modules",
                            MorphismConstructor := HomalgMap,
                            TryPostDivideWithoutAids := true, # see homalg/ToolFunctors.gi
                            InternalHom := Hom,
                            InternalExt := Ext,
                            ),
            
            ByASmallerPresentationDoesNotDecideZero := false,
            
            Intersect_uses_ReducedBasisOfModule := true,
            
            variable_for_Hilbert_polynomial := Indeterminate( Rationals, "s" ),
            
            DimensionOfZeroModules := -1,
            
           )
);


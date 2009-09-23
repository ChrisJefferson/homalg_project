#############################################################################
##
##  LocalRing.gd    LocalizeRingForHomalg package            Mohamed Barakat
##                                                    Markus Lange-Hegermann
##
##  Copyright 2009, Mohamed Barakat, Universität des Saarlandes
##           Markus Lange-Hegermann, RWTH-Aachen University
##
##  Declarations of procedures for localized rings.
##
#############################################################################

####################################
#
# attributes:
#
####################################

##  <#GAPDoc Label="GeneratorsOfMaximalLeftIdeal">
##  <ManSection>
##    <Attr Arg="R" Name="GeneratorsOfMaximalLeftIdeal"/>
##    <Returns>a &homalg; matrix</Returns>
##    <Description>
##      The &homalg; matrix is a 1-column matrix containing the generators of the maximal ideal considered as a left ideal.
##   </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "GeneratorsOfMaximalLeftIdeal",
        IsHomalgRing );

##  <#GAPDoc Label="GeneratorsOfMaximalRightIdeal">
##  <ManSection>
##    <Attr Arg="R" Name="GeneratorsOfMaximalRightIdeal"/>
##    <Returns>a &homalg; matrix</Returns>
##    <Description>
##      The &homalg; matrix is a 1-column matrix containing the generators of the maximal ideal considered as a right ideal.
##   </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "GeneratorsOfMaximalRightIdeal",
        IsHomalgRing );

####################################
#
# global functions and operations:
#
####################################

# constructor methods:

DeclareOperation( "CreateHomalgTableForLocalizedRings",
        [ IsHomalgRing ] );

DeclareOperation( "CreateHomalgTableForLocalizedRingsWithMora",
        [ IsHomalgRing ] );

DeclareGlobalFunction( "CreateHomalgLocalizedRing" );

DeclareOperation( "LocalizeAt",
        [ IsHomalgRing, IsList ] );

DeclareOperation( "LocalizeAt",
        [ IsHomalgRing ] );

DeclareGlobalFunction( "HomalgLocalRingElement" );

DeclareOperation( "BlindlyCopyMatrixPropertiesToLocalMatrix",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

# basic operations:

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgRing ] );

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgRingElement ] );

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgMatrix ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgRing ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgRingElement ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgMatrix ] );

DeclareOperation( "Numerator",
        [ IsHomalgRingElement ] );

DeclareOperation( "Denominator",
        [ IsHomalgRingElement ] );

DeclareOperation( "Numerator",
        [ IsHomalgMatrix ] );

DeclareOperation( "Denominator",
        [ IsHomalgMatrix ] );

DeclareOperation( "HomalgLocalMatrix",
        [ IsHomalgMatrix, IsRingElement, IsHomalgRing ] );

DeclareOperation( "HomalgLocalMatrix",
        [ IsHomalgMatrix, IsHomalgRing ] );

DeclareOperation( "Cancel",
        [ IsRingElement, IsRingElement ] );

DeclareOperation( "/",
        [ IsHomalgMatrix, IsHomalgRing ] );

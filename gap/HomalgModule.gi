#############################################################################
##
##  HomalgModule.gi             homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg modules.
##
#############################################################################

####################################
#
# representations:
#
####################################

# a new representation for the category IsHomalgModule:
DeclareRepresentation( "IsFinitelyPresentedModuleRep",
        IsHomalgModule,
        [ "SetsOfGenerators", "SetsOfRelations" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgModules",
        NewFamily( "TheFamilyOfHomalgModules" ) );

# two new types:
BindGlobal( "TheTypeHomalgLeftModuleFinitelyPresented",
        NewType( TheFamilyOfHomalgModules,
                IsFinitelyPresentedModuleRep and IsLeftModule ) );

BindGlobal( "TheTypeHomalgRightModuleFinitelyPresented",
        NewType( TheFamilyOfHomalgModules,
                IsFinitelyPresentedModuleRep and IsRightModule ) );

####################################
#
# global variables:
#
####################################

InstallValue( SimpleLogicalImplicationsForHomalgModules,
        [ ## IsTorsionFreeModule:
          
          [ IsZeroModule,
            "implies", IsFreeModule ],
          
          [ IsFreeModule,
            "implies", IsStablyFreeModule ],
          
          [ IsStablyFreeModule,
            "implies", IsProjectiveModule ],
          
          [ IsProjectiveModule,
            "implies", IsReflexiveModule ],
          
          [ IsReflexiveModule,
            "implies", IsTorsionFreeModule ],
          
          ## IsTorsionModule:
          
          [ IsZeroModule,
            "implies", IsHolonomicModule ],
          
          [ IsHolonomicModule,
            "implies", IsTorsionModule ],
          
          [ IsHolonomicModule,
            "implies", IsArtinianModule ],
          
          ## IsCyclicModule:
          
          [ IsZeroModule,
            "implies", IsCyclicModule ],
          
          ## IsZeroModule:
          
          [ IsTorsionModule, "and", IsTorsionFreeModule,
            "imply", IsZeroModule ]
          
          ] );

####################################
#
# logical implications methods:
#
####################################

#LogicalImplicationsForHomalg( SimpleLogicalImplicationsForHomalgModules );

## FIXME: find a way to activate the above line and to delete the following
for property in SimpleLogicalImplicationsForHomalgModules do;
    
    if Length( property ) = 3 then
        
        ## a => b:
        InstallTrueMethod( property[3],
                IsHomalgModule and property[1] );
        
        ## not b => not a:
        InstallImmediateMethod( property[1],
                IsHomalgModule and Tester( property[3] ), 0, ## NOTE: don't drop the Tester here!
                
          function( M )
            if Tester( property[3] )( M ) and not property[3]( M ) then  ## FIXME: find a way to get rid of Tester here
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
    elif Length( property ) = 5 then
        
        ## a and b => c:
        InstallTrueMethod( property[5],
                IsHomalgModule and property[1] and property[3] );
        
        ## b and not c => not a:
        InstallImmediateMethod( property[1],
                IsHomalgModule and Tester( property[3] ) and Tester( property[5] ), 0, ## NOTE: don't drop the Testers here!
                
          function( M )
            if Tester( property[3] )( M ) and Tester( property[5] )( M )  ## FIXME: find a way to get rid of the Testers here
               and property[3]( M ) and not property[5]( M ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
        ## a and not c => not b:
        InstallImmediateMethod( property[3],
                IsHomalgModule and Tester( property[1] ) and Tester( property[5] ), 0, ## NOTE: don't drop the Testers here!
                
          function( M )
            if Tester( property[1] )( M ) and Tester( property[5] )( M ) ## FIXME: find a way to get rid of the Testers here
               and property[1]( M ) and not property[5]( M ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
    fi;
    
od;

####################################
#
# immediate methods for properties:
#
####################################

## strictly less relations than generators => not IsTorsionModule
InstallImmediateMethod( IsTorsionModule,
        IsFinitelyPresentedModuleRep, 0,
        
  function( M )
    local l, b, i, rel, mat;
    
    l := SetsOfRelations( M )!.ListOfPositionsOfKnownSetsOfRelations;
    
    b := false;
    
    for i in [ 1.. Length( l ) ] do;
        
        rel := SetsOfRelations( M )!.(i);
        
        if not IsString( rel ) then
            mat := MatrixOfRelations( rel );
     
            if HasNrRows( mat ) and HasNrColumns( mat )
              and NrColumns( mat ) > NrRows( mat ) then
                b := true;
                break;
            fi;
        fi;
        
    od;
    
    if b then
        return false;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsFreeModule,
        IsFinitelyPresentedModuleRep, 0,
        
  function( M )
    
    if NrRelations( M ) = 0 then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( RankOfModule,
        IsFinitelyPresentedModuleRep and IsFreeModule, 0,
        
  function( M )
    
    if NrRelations( M ) = 0 then
        return NrGenerators( M );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsTorsionModule,
        IsFinitelyPresentedModuleRep and HasRankOfModule, 0,
        
  function( M )
    
    return RankOfModule( M ) = 0;
    
end );

####################################
#
# methods for properties:
#
####################################

##
InstallMethod( IsZeroModule,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    return NonZeroGenerators( M ) = [ ];
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgRing,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsLeftModule ],
        
  function( M )
    
    return LeftActingDomain( M );
    
end );

##
InstallMethod( HomalgRing,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsRightModule ],
        
  function( M )
    
    return RightActingDomain( M );
    
end );

##
InstallMethod( SetsOfGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    if IsBound(M!.SetsOfGenerators) then
        return M!.SetsOfGenerators;
    fi;
    
    return fail;
    
end );

##
InstallMethod( SetsOfRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    if IsBound(M!.SetsOfRelations) then
        return M!.SetsOfRelations;
    fi;
    
    return fail;
    
end );

##
InstallMethod( PositionOfTheDefaultSetOfRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    if IsBound(M!.PositionOfTheDefaultSetOfRelations) then
        return M!.PositionOfTheDefaultSetOfRelations;
    fi;
    
    return fail;
    
end );

##
InstallMethod( GeneratorsOfModule,		### defines: GeneratorsOfModule (GeneratorsOfPresentation)
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    if IsBound(SetsOfGenerators(M)!.(PositionOfTheDefaultSetOfGenerators( M ))) then
        return SetsOfGenerators(M)!.(PositionOfTheDefaultSetOfGenerators( M ));
    fi;
    
    return fail;
    
end );

##
InstallMethod( GeneratorsOfModule,		### defines: GeneratorsOfModule (GeneratorsOfPresentation)
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
        
  function( M, pos )
    
    if IsBound(SetsOfGenerators(M)!.(pos)) then
        return SetsOfGenerators(M)!.(pos);
    fi;
    
    return fail;
    
end );

##
InstallMethod( RelationsOfModule,		### defines: RelationsOfModule (NormalizeInput)
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    if IsBound(SetsOfRelations(M)!.(PositionOfTheDefaultSetOfRelations( M ))) then;
        return SetsOfRelations(M)!.(PositionOfTheDefaultSetOfRelations( M ));
    fi;
    
    return fail;
    
end );

##
InstallMethod( RelationsOfModule,		### defines: RelationsOfModule (NormalizeInput)
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
        
  function( M, pos )
    
    if IsBound(SetsOfRelations(M)!.(pos)) then;
        return SetsOfRelations(M)!.(pos);
    fi;
    
    return fail;
    
end );

InstallMethod( RelationsOfHullModule,		### defines: RelationsOfHullModule
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local gen;
    
    gen := GeneratorsOfModule( M );
    
    if gen <> fail then;
        return RelationsOfHullModule( gen );
    fi;
    
    return fail;
    
end );

##
InstallMethod( RelationsOfHullModule,		### defines: RelationsOfHullModule
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
        
  function( M, pos )
    local gen;
    
    gen := GeneratorsOfModule( M, pos );
    
    if gen <> fail then;
        return RelationsOfHullModule( gen );
    fi;
    
    return fail;
    
end );

##
InstallMethod( MatrixOfGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
  function( M )
    
    return MatrixOfGenerators( GeneratorsOfModule( M ) );
    
end );

##
InstallMethod( MatrixOfGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
  function( M, pos )
    local gen;
    
    gen := GeneratorsOfModule( M, pos );
    
    if IsHomalgGenerators( gen ) then
        return MatrixOfGenerators( gen );
    fi;
    
    return fail;
    
end );

##
InstallMethod( MatrixOfRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    return MatrixOfRelations( RelationsOfModule( M ) );
    
end );

##
InstallMethod( MatrixOfRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
        
  function( M, pos )
    local rel;
    
    rel := RelationsOfModule( M, pos );
    
    if IsHomalgRelations( rel ) then
        return MatrixOfRelations( rel );
    fi;
    
    return fail;
    
end );

##
InstallMethod( NrGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
  function( M )
    
    return NrGenerators( GeneratorsOfModule( M ) );
    
end );

##
InstallMethod( NrGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
  function( M, pos )
    local gen;
    
    gen := GeneratorsOfModule( M, pos );
    
    if IsHomalgGenerators( gen ) then
        return NrGenerators( gen );
    fi;
    
    return fail;
    
end );

##
InstallMethod( NrRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local rel;
    
    rel := RelationsOfModule( M );
    
    if IsHomalgRelations( rel ) then
        return NrRelations( rel );
    fi;
    
    return fail;
    
end );

##
InstallMethod( NrRelations,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt ],
        
  function( M, pos )
    local rel;
    
    rel := RelationsOfModule( M, pos );
    
    if IsHomalgRelations( rel ) then
        return NrRelations( rel );
    fi;
    
    return fail;
    
end );

##
InstallMethod( TransitionMatrix,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsPosInt, IsPosInt ],
        
  function( M, pos1, pos2 )
    local pres_a, pres_b, sets_of_generators, tr, sign, i, j;
    
    if IsLeftModule( M ) then
        pres_a := pos2;
        pres_b := pos1;
    else
        pres_a := pos1;
        pres_b := pos2;
    fi;
    
    sets_of_generators := M!.SetsOfGenerators;
    
    if not IsBound( sets_of_generators!.( pres_a ) ) then
        
        Error( "the module given by the first argument has no ", pres_a, ". set of generators\n" );
        
    elif not IsBound( sets_of_generators!.( pres_b ) ) then
        
        Error( "the module given by the first argument has no ", pres_b, ". set of generators\n" );
        
    elif pres_a = pres_b then
        
        return HomalgIdentityMatrix( NrGenerators( sets_of_generators!.( pres_a ) ), HomalgRing( M ) );
        
    else
        
        ## starting with the identity is no waste of performance since the subpackage LIMAT is active:
        tr := HomalgIdentityMatrix(  NrGenerators( sets_of_generators!.( pres_a ) ), HomalgRing( M ) );
        
        sign := SignInt( pres_b - pres_a );
        
        i := pres_a;
        
        if IsLeftModule( M ) then
            
            while AbsInt( pres_b - i ) > 0 do
                for j in pres_b - sign * [ 0 .. AbsInt( pres_b - i ) - 1 ]  do
                    if IsBound( M!.TransitionMatrices.( String( [ j, i ] ) ) ) then
                        tr := M!.TransitionMatrices.( String( [ j, i ] ) ) * tr;
                        i := j;
                        break;
                    fi;
                od;
            od;
            
        else
            
            while AbsInt( pres_b - i ) > 0 do
                for j in pres_b - sign * [ 0 .. AbsInt( pres_b - i ) - 1 ]  do
                    if IsBound( M!.TransitionMatrices.( String( [ i, j ] ) ) ) then
                        tr := tr * M!.TransitionMatrices.( String( [ i, j ] ) );
                        i := j;
                        break;
                    fi;
                od;
            od;
            
        fi;
        
        return tr;
        
    fi;
    
end );

##
InstallMethod( AddANewPresentation,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( M, gen )
    local rels, gens, d, l, id, tr, itr;
    
    if not ( IsLeftModule( M ) and IsHomalgGeneratorsOfLeftModule( gen ) )
       and not ( IsRightModule( M ) and IsHomalgGeneratorsOfRightModule( gen ) ) then
        Error( "the module and the new set of generators must either be both left or both right\n" );
    fi;
    
    rels := SetsOfRelations( M );
    gens := SetsOfGenerators( M );
    
    d := PositionOfTheDefaultSetOfRelations( M );
    
    l := PositionOfLastStoredSetOfRelations( rels );
    
    ## define the (l+1)st set of generators:
    gens!.(l+1) := gen;
    
    ## adjust the list of positions:
    gens!.ListOfPositionsOfKnownSetsOfGenerators[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    ## define the (l+1)st set of relations:
    if IsBound( rels!.(d) ) then
        rels!.(l+1) := rels!.(d);
    fi;
    
    ## adjust the list of positions:
    rels!.ListOfPositionsOfKnownSetsOfRelations[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    id := HomalgIdentityMatrix( NrGenerators( M ), HomalgRing( M ) );
    
    ## no need to distinguish between left and right modules here:
    M!.TransitionMatrices.( String( [ d, l+1 ] ) ) := id;
    M!.TransitionMatrices.( String( [ l+1, d ] ) ) := id;
    
    if d <> l then
        
        ## starting with the identity is no waste of performance since the subpackage LIMAT is active:
        tr := id; itr := id;
        
        if IsHomalgGeneratorsOfLeftModule( gen ) then
            
            tr := tr * TransitionMatrix( M, d, l );
            itr :=  TransitionMatrix( M, l, d ) * itr;
            
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := itr;
            
        else
            
            tr := TransitionMatrix( M, l, d ) * tr;
            itr :=  itr * TransitionMatrix( M, d, l );
            
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := itr;
            
        fi;
        
    fi;
    
    ## adjust the default position:
    M!.PositionOfTheDefaultSetOfRelations := l+1;
    
    if NrGenerators( gen ) = 0 then
        SetIsZeroModule( M, true );
    fi;
    
    return M;
    
end );

##
InstallMethod( AddANewPresentation,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsHomalgRelationsOfFinitelyPresentedModuleRep ],
        
  function( M, rel )
    local rels, lpos, d, gens, l, id, tr, itr;
    
    if not ( IsLeftModule( M ) and IsHomalgRelationsOfLeftModule( rel ) )
       and not ( IsRightModule( M ) and IsHomalgRelationsOfRightModule( rel ) ) then
        Error( "the module and the new set of relations must either be both left or both right\n" );
    fi;
    
    rels := SetsOfRelations( M );
    
    lpos := rels!.ListOfPositionsOfKnownSetsOfRelations;
    
    ## don't add an old set of relations, but let it be the default set of relations instead:
    for d in lpos do
        if IsIdenticalObj( rel, rels!.(d) ) then
            M!.PositionOfTheDefaultSetOfRelations := d;
            return M;
        fi;
    od;
    
    for d in lpos do
        if MatrixOfRelations( rel ) = MatrixOfRelations( rels!.(d) ) then
            M!.PositionOfTheDefaultSetOfRelations := d;
            return M;
        fi;
    od;
    
    gens := SetsOfGenerators( M );
    
    d := PositionOfTheDefaultSetOfRelations( M );
    
    l := PositionOfLastStoredSetOfRelations( rels );
    
    ## define the (l+1)st set of generators:
    gens!.(l+1) := gens!.(d);
    
    ## adjust the list of positions:
    gens!.ListOfPositionsOfKnownSetsOfGenerators[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    ## define the (l+1)st set of relations:
    rels!.(l+1) := rel;
    
    ## adjust the list of positions:
    lpos[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    id := HomalgIdentityMatrix( NrGenerators( M ), HomalgRing( M ) );
    
    ## no need to distinguish between left and right modules here:
    M!.TransitionMatrices.( String( [ d, l+1 ] ) ) := id;
    M!.TransitionMatrices.( String( [ l+1, d ] ) ) := id;
    
    if d <> l then
        
        ## starting with the identity is no waste of performance since the subpackage LIMAT is active:
        tr := id; itr := id;
        
        if IsHomalgRelationsOfLeftModule( rel ) then
            
            tr := tr * TransitionMatrix( M, d, l );
            itr :=  TransitionMatrix( M, l, d ) * itr;
            
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := itr;
            
        else
            
            tr := TransitionMatrix( M, l, d ) * tr;
            itr :=  itr * TransitionMatrix( M, d, l );
            
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := itr;
            
        fi;
        
    fi;
    
    ## adjust the default position:
    M!.PositionOfTheDefaultSetOfRelations := l+1;
    
    if NrRelations( rel ) = 0 then
        SetIsFreeModule( M, true );
    fi;
    
    return M;
    
end );

##
InstallMethod( AddANewPresentation,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep, IsHomalgRelationsOfFinitelyPresentedModuleRep, IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M, rel, T, TI )
    local rels, gens, d, l, gen, tr, itr;
    
    if not ( IsLeftModule( M ) and IsHomalgRelationsOfLeftModule( rel ) )
       and not ( IsRightModule( M ) and IsHomalgRelationsOfRightModule( rel ) ) then
        Error( "the module and the new set of relations must either be both left or both right\n" );
    fi;
    
    rels := SetsOfRelations( M );
    gens := SetsOfGenerators( M );
    
    d := PositionOfTheDefaultSetOfRelations( M );
    
    l := PositionOfLastStoredSetOfRelations( rels );
    
    gen := TI * GeneratorsOfModule( M );
    
    ## define the (l+1)st set of generators:
    gens!.(l+1) := gen;
    
    ## adjust the list of positions:
    gens!.ListOfPositionsOfKnownSetsOfGenerators[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    ## define the (l+1)st set of relations:
    rels!.(l+1) := rel;
    
    ## adjust the list of positions:
    rels!.ListOfPositionsOfKnownSetsOfRelations[l+1] := l+1;	## the list is allowed to contain holes (sparse list)
    
    if IsHomalgRelationsOfLeftModule( rel ) then
        M!.TransitionMatrices.( String( [ d, l+1 ] ) ) := T;
        M!.TransitionMatrices.( String( [ l+1, d ] ) ) := TI;
    else
        M!.TransitionMatrices.( String( [ l+1, d ] ) ) := T;
        M!.TransitionMatrices.( String( [ d, l+1 ] ) ) := TI;
    fi;
    
    if d <> l then
        
        tr := TI; itr := T;
        
        if IsHomalgRelationsOfLeftModule( rel ) then
            
            tr := tr * TransitionMatrix( M, d, l );
            itr :=  TransitionMatrix( M, l, d ) * itr;
            
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := itr;
            
        else
            
            tr := TransitionMatrix( M, l, d ) * tr;
            itr :=  itr * TransitionMatrix( M, d, l );
            
            M!.TransitionMatrices.( String( [ l, l+1 ] ) ) := tr;
            M!.TransitionMatrices.( String( [ l+1, l ] ) ) := itr;
            
        fi;
        
    fi;
    
    ## adjust the default position:
    M!.PositionOfTheDefaultSetOfRelations := l+1;
    
    if NrGenerators( gen ) = 0 then
        SetIsZeroModule( M, true );
    fi;
    
    if NrRelations( rel ) = 0 then
        SetIsFreeModule( M, true );
    fi;
    
    return M;

end );

##
InstallMethod( BasisOfModule,			### CAUTION: has the side effect of possibly affecting the module M
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local rel, bas, mat, diag, zero, rk;
    
    rel := RelationsOfModule( M );
    
    if not ( HasCanBeUsedToDecideZeroEffectively( rel ) and CanBeUsedToDecideZeroEffectively( rel ) ) then
        bas := BasisOfModule( rel );		## CAUTION: might have a side effect on rel
        
        AddANewPresentation( M, bas );		## this might set CanBeUsedToDecideZeroEffectively( rel ) to true
    else
        bas := rel;
    fi;
    
    if not HasRankOfModule( M ) then
       mat := MatrixOfRelations( rel );
       if HasIsDiagonalMatrix( mat ) and IsDiagonalMatrix( mat ) then
           diag := DiagonalEntries( mat );
           zero := Zero( HomalgRing( M ) );
           rk := Length( Filtered( diag, d -> d = zero ) ) + NrGenerators( M ) - Length( diag );
           SetRankOfModule( M, rk );
       elif HasIsInjectivePresentation( bas ) and IsInjectivePresentation( bas ) then
           rk := NrGenerators( M ) - NrRelations( M );
           SetRankOfModule( M, rk );
       fi;
    fi;
    
    return RelationsOfModule( M );
    
end );

##
InstallMethod( DecideZero,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local gen, red;
    
    gen := GeneratorsOfModule( M );
    
    if HasIsReduced( gen ) and IsReduced( gen ) then
        return gen;
    fi;
    
    red := DecideZero( gen );
    
    if MatrixOfGenerators( gen ) = MatrixOfGenerators( red ) then
        return gen;
    fi;
    
    AddANewPresentation( M, red );
    
    return red;
    
end );

##
InstallMethod( DecideZero,
        "for homalg modules",
        [ IsHomalgMatrix, IsFinitelyPresentedModuleRep ],
        
  function( mat, M )
    local rel;
    
    rel := RelationsOfModule( M );
    
    return DecideZero( mat, rel );
    
end );

##
InstallMethod( DecideZeroEffectively,
        "for homalg modules",
        [ IsHomalgMatrix, IsFinitelyPresentedModuleRep ],
        
  function( mat, M )
    local rel;
    
    rel := RelationsOfModule( M );
    
    return DecideZeroEffectively( mat, rel );
    
end );

##
InstallMethod( UnionOfRelations,
        "for homalg modules",
        [ IsHomalgMatrix, IsFinitelyPresentedModuleRep ],
        
  function( mat, M )
    
    return UnionOfRelations( mat, RelationsOfModule( M ) );
    
end );

##
InstallMethod( SyzygiesGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    return SyzygiesGenerators( RelationsOfModule( M ) );
    
end );

##
InstallMethod( SyzygiesGenerators,
        "for homalg modules",
        [ IsHomalgMatrix, IsFinitelyPresentedModuleRep ],
        
  function( mat, M )
    
    return SyzygiesGenerators( mat, RelationsOfModule( M ) );
    
end );

##
InstallMethod( NonZeroGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    
    return NonZeroGenerators( BasisOfModule( RelationsOfModule( M ) ) );
    
end );

##
InstallMethod( GetRidOfObsoleteGenerators,	### defines: GetRidOfObsoleteGenerators (BetterPresentation) (incomplete)
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local bl, rel, diagonal, upper, lower, id, T, TI;
    
    bl := NonZeroGenerators( M );
    
    if Length( bl ) <> NrGenerators( M ) then
        
        rel := MatrixOfRelations( M );
        
        if HasIsDiagonalMatrix( rel ) then
            if IsDiagonalMatrix( rel ) then
                diagonal := true;
            else
                diagonal := false;
            fi;
        else
            diagonal := fail;
        fi;
        
        if HasIsUpperTriangularMatrix( rel ) then
            if IsUpperTriangularMatrix( rel ) then
                upper := true;
            else
                upper := false;
            fi;
        else
            upper := fail;
        fi;
        
        if HasIsLowerTriangularMatrix( rel ) then
            if IsLowerTriangularMatrix( rel ) then
                lower := true;
            else
                lower := false;
            fi;
        else
            lower := fail;
        fi;
        
        id := HomalgIdentityMatrix( NrGenerators( M ), HomalgRing( M ) );
        
        if IsLeftModule( M ) then
            rel := CertainColumns( rel, bl );
            rel := CertainRows( rel, NonZeroRows( rel ) );
            if diagonal <> fail and diagonal then
                SetIsDiagonalMatrix( rel, true );
            fi;
            rel := HomalgRelationsForLeftModule( rel );
            T := CertainColumns( id, bl );
            TI := CertainRows( id, bl );
        else
            rel := CertainRows( rel, bl );
            rel := CertainColumns( rel, NonZeroColumns( rel ) );
            if diagonal <> fail and diagonal then
                SetIsDiagonalMatrix( rel, true );
            fi;
            rel := HomalgRelationsForRightModule( rel );
            T := CertainRows( id, bl );
            TI := CertainColumns( id, bl );
        fi;
        
        AddANewPresentation( M, rel, T, TI );
        
    fi;
    
    return M;
    
end );

##
InstallMethod( BetterGenerators,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsLeftModule ],
        
  function( M )
    local R, rel_old, rel, V, VI;
    
    R := HomalgRing( M );
    
    rel_old := MatrixOfRelations( M );
    
    V := HomalgMatrix( R );
    VI := HomalgMatrix( R );
    
    rel := SimplerEquivalentMatrix( rel_old, V, VI, "", "" );
    
    if rel_old = rel then
        return GetRidOfObsoleteGenerators( M );
    fi;
    
    rel := HomalgRelationsForLeftModule( rel );
    
    AddANewPresentation( M, rel, V, VI );
    
    return GetRidOfObsoleteGenerators( M );
    
end );

##
InstallMethod( BetterGenerators,
        "for homalg modules",
	[ IsFinitelyPresentedModuleRep and IsRightModule ],
        
  function( M )
    local R, rel_old, rel, U, UI;
    
    R := HomalgRing( M );
    
    rel_old := MatrixOfRelations( M );
    
    U := HomalgMatrix( R );
    UI := HomalgMatrix( R );
    
    rel := SimplerEquivalentMatrix( rel_old, U, UI, "", "", "" );
    
    if rel_old = rel then
        return GetRidOfObsoleteGenerators( M );
    fi;
    
    rel := HomalgRelationsForRightModule( rel );
    
    AddANewPresentation( M, rel, U, UI );
    
    return GetRidOfObsoleteGenerators( M );
    
end );

##
InstallMethod( ElementaryDivisors,
        "for homalg modules",
	[ IsFinitelyPresentedModuleRep ],
        
  function( M )
    local rel, b, R, RP, e, zero, one;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ElementaryDivisors) and HasRankOfModule( M ) then
        e := RP!.ElementaryDivisors( MatrixOfRelations( M ) );
        if IsString( e ) then
            e := StringToElementStringList( e );
            e := List( e, a -> HomalgExternalRingElement( a, homalgExternalCASystem( R ), R ) );
        fi;
        
        ## since the computer algebra systems have different
        ## conventions for elementary divisors, we fix our own here:
        zero := Zero( R );
        one := One( R );
        
        e := Filtered( e, x -> x <> one and x <> zero );
        
        Append( e, ListWithIdenticalEntries( RankOfModule( M ), zero ) );
        
        return e;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ElementaryDivisors,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsZeroModule ],
        
  function( M )
    
    return [ ];
    
end );

##
InstallMethod( ElementaryDivisors,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsFreeModule ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    return ListWithIdenticalEntries( NrGenerators( M ), Zero( R ) );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

##
InstallMethod( Presentation,
        "constructor",
        [ IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfLeftModule ],
        
  function( rel )
    local R, is_zero_module, gens, rels, M;
    
    R := HomalgRing( rel );
    
    is_zero_module := false;
    
    if NrGenerators( rel ) = 0 then ## since one doesn't specify generators here giving no relations defines the zero module
        gens := CreateSetsOfGeneratorsForLeftModule( [ ], R );
        is_zero_module := true;
    else
        gens := CreateSetsOfGeneratorsForLeftModule(
                        HomalgIdentityMatrix( NrGenerators( rel ), R ), rel );
    fi;
    
    rels := CreateSetsOfRelationsForLeftModule( rel );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( Presentation,
        "constructor",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfLeftModule, IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfLeftModule ],
        
  function( gen, rel )
    local R, is_zero_module, gens, rels, M;
    
    if NrGenerators( gen ) <> NrGenerators( rel ) then
        Error( "the first argument is a set of ", NrGenerators( gen ), " generator(s) while the second argument is a set of relations for ", NrGenerators( rel ), " generators\n" );
    fi;
    
    R := HomalgRing( rel );
    
    is_zero_module := false;
    
    gens := CreateSetsOfGeneratorsForLeftModule( gen );
    
    if NrGenerators( rel ) = 0 then
        is_zero_module := true;
    fi;
    
    rels := CreateSetsOfRelationsForLeftModule( rel );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( Presentation,
        "constructor",
        [ IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfRightModule ],
        
  function( rel )
    local R, is_zero_module, gens, rels, M;
    
    R := HomalgRing( rel );
    
    is_zero_module := false;
    
    if NrGenerators( rel ) = 0 then ## since one doesn't specify generators here giving no relations defines the zero module
        gens := CreateSetsOfGeneratorsForRightModule( [ ], R );
        is_zero_module := true;
    else
        gens := CreateSetsOfGeneratorsForRightModule(
                        HomalgIdentityMatrix( NrGenerators( rel ), R ), rel );
    fi;
    
    rels := CreateSetsOfRelationsForRightModule( rel );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( Presentation,
        "constructor",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfRightModule, IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfRightModule ],
        
  function( gen, rel )
    local R, is_zero_module, gens, rels, M;
    
    if NrGenerators( gen ) <> NrGenerators( rel ) then
        Error( "the first argument is a set of ", NrGenerators( gen ), " generator(s) while the second argument is a set of relations for ", NrGenerators( rel ), " generators\n" );
    fi;
    
    R := HomalgRing( rel );
    
    is_zero_module := false;
    
    gens := CreateSetsOfGeneratorsForRightModule( gen );
    
    if NrGenerators( rel ) = 0 then
        is_zero_module := true;
    fi;
    
    rels := CreateSetsOfRelationsForRightModule( rel );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( LeftPresentation,
        "constructor",
        [ IsList, IsHomalgRing ],
        
  function( rel, R )
    local gens, rels, M, is_zero_module;
    
    is_zero_module := false;
    
    if Length( rel ) = 0 then ## since one doesn't specify generators here giving no relations defines the zero module
        gens := CreateSetsOfGeneratorsForLeftModule( [ ], R );
        is_zero_module := true;
    elif IsList( rel[1] ) then ## FIXME: to be replaced with something to distinguish lists of rings elements from elements that are theirself lists
        gens := CreateSetsOfGeneratorsForLeftModule(
                        HomalgIdentityMatrix( Length( rel[1] ), R ), rel );  ## FIXME: Length( rel[1] )
    else ## only one generator
        gens := CreateSetsOfGeneratorsForLeftModule(
                        HomalgIdentityMatrix( 1, R ), rel );
    fi;
    
    rels := CreateSetsOfRelationsForLeftModule( rel, R );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgLeftModuleFinitelyPresented,
                LeftActingDomain, R,
                GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( LeftPresentation,
        "constructor",
        [ IsList, IsList, IsHomalgRing ],
        
  function( gen, rel, R )
    local gens, rels, M;
    
    gens := CreateSetsOfGeneratorsForLeftModule( gen, R );
    
    if rel = [ ] and gen <> [ ] then
        rels := CreateSetsOfRelationsForLeftModule( "unknown relations", R );
    else
        rels := CreateSetsOfRelationsForLeftModule( rel, R );
    fi;
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    ObjectifyWithAttributes(
            M, TheTypeHomalgLeftModuleFinitelyPresented,
            LeftActingDomain, R,
            GeneratorsOfLeftOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );

##
InstallMethod( LeftPresentation,
        "constructor",
        [ IsHomalgMatrix ],
        
  function( mat )
    
    return Presentation( HomalgRelationsForLeftModule( mat ) );
    
end );

##
InstallMethod( RightPresentation,
        "constructor",
        [ IsList, IsHomalgRing ],
        
  function( rel, R )
    local gens, rels, M, is_zero_module;
    
    is_zero_module := false;
    
    if Length( rel ) = 0 then ## since one doesn't specify generators here giving no relations defines the zero module
        gens := CreateSetsOfGeneratorsForRightModule( [ ], R );
        is_zero_module := true;
    elif IsList( rel[1] ) then ## FIXME: to be replaced with something to distinguish lists of rings elements from elements that are theirself lists
        gens := CreateSetsOfGeneratorsForRightModule(
                        HomalgIdentityMatrix( Length( rel ), R ), rel ); ## FIXME: Length( rel )
    else ## only one generator
        gens := CreateSetsOfGeneratorsForRightModule(
                        HomalgIdentityMatrix( 1, R ), rel );
    fi;
    
    rels := CreateSetsOfRelationsForRightModule( rel, R );
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    if is_zero_module then
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1,
                IsZeroModule, true );
    else
        ObjectifyWithAttributes(
                M, TheTypeHomalgRightModuleFinitelyPresented,
                RightActingDomain, R,
                GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    fi;
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );
  
##
InstallMethod( RightPresentation,
        "constructor",
        [ IsList, IsList, IsHomalgRing ],
        
  function( gen, rel, R )
    local gens, rels, M;
    
    gens := CreateSetsOfGeneratorsForRightModule( gen, R );
    
    if rel = [ ] and gen <> [ ] then
        rels := CreateSetsOfRelationsForRightModule( "unknown relations", R );
    else
        rels := CreateSetsOfRelationsForRightModule( rel, R );
    fi;
    
    M := rec( SetsOfGenerators := gens,
              SetsOfRelations := rels,
              TransitionMatrices := rec( ),
              PositionOfTheDefaultSetOfRelations := 1 );
    
    ## Objectify:
    ObjectifyWithAttributes(
            M, TheTypeHomalgRightModuleFinitelyPresented,
            RightActingDomain, R,
            GeneratorsOfRightOperatorAdditiveGroup, M!.SetsOfGenerators!.1 );
    
#    SetParent( gens, M );
#    SetParent( rels, M );
    
    return M;
    
end );

##
InstallMethod( RightPresentation,
        "constructor",
        [ IsHomalgMatrix ],
        
  function( mat )
    
    return Presentation( HomalgRelationsForRightModule( mat ) );
    
end );

##
InstallMethod( HomalgFreeLeftModule,
        "constructor",
        [ IsInt, IsHomalgRing ],
        
  function( rank, ring )
    
    return LeftPresentation( HomalgZeroMatrix( 0, rank, ring ) );
    
end );

##
InstallMethod( HomalgFreeRightModule,
        "constructor",
        [ IsInt, IsHomalgRing ],
        
  function( rank, ring )
    
    return RightPresentation( HomalgZeroMatrix( rank, 0, ring ) );
    
end );

##
InstallMethod( HomalgZeroLeftModule,
        "constructor",
        [ IsHomalgRing ],
        
  function( ring )
    
    return HomalgFreeLeftModule( 0, ring );
    
end );

##
InstallMethod( HomalgZeroRightModule,
        "constructor",
        [ IsHomalgRing ],
        
  function( ring )
    
    return HomalgFreeRightModule( 0, ring );
    
end );

##
InstallGlobalFunction( GetGenerators,
  function( arg )
    local nargs, M, pos, g, gen, mat, proc, l;
    
    nargs := Length( arg );
    
    if nargs > 0 and IsFinitelyPresentedModuleRep( arg[1] ) then
        
        M := arg[1];
        
        if nargs > 2 and IsPosInt( arg[3] ) then
            pos := arg[3];
        else
            pos := PositionOfTheDefaultSetOfGenerators( M );
        fi;
        
        gen := GeneratorsOfModule( M, pos );
        
    elif nargs > 0 and IsHomalgGeneratorsOfFinitelyGeneratedModuleRep( arg[1] ) then
        
        gen := arg[1];
        
    else
        
        Error( "the first argument must be a homalg module or a set of generators of a homalg module\n" );
        
    fi;
    
    g := [ 1 .. NrGenerators( gen ) ];
    
    if nargs > 1 then
        if IsPosInt( arg[2] ) then
            g := [ arg[2] ];
        elif IsHomogeneousList( arg[2] ) and ForAll( arg[2], IsPosInt ) then
            g := arg[2];
        fi;
    fi;
    
    mat := MatrixOfGenerators( gen );
    
    if IsHomalgGeneratorsOfLeftModule( gen ) then
        g := List( g, a -> CertainRows( mat, [ a ] ) );
    else
        g := List( g, a -> CertainColumns( mat, [ a ] ) );
    fi;
    
    if HasProcedureToReadjustGenerators( gen ) then
        proc := ProcedureToReadjustGenerators( gen );
        l := Length( proc );
        g := List( g, a -> CallFuncList( proc[1], Concatenation( [ a ], proc{[ 2 .. l ]} ) ) );
    fi;
    
    if nargs > 1 and IsPosInt( arg[2] ) then
        return g[1];
    fi;
    
    return g;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsLeftModule ],
        
  function( M )
    local num_gen, num_rel, gen_string, rel_string;
    
    num_gen := NrGenerators( M );
    
    if num_gen = 1 then
        gen_string := " generator";
    else
        gen_string := " generators";
    fi;
    if RelationsOfModule( M ) = "unknown relations" then
        num_rel := "unknown";
        rel_string := " relations for ";
    else
        num_rel := NrRelations( M );
        if num_rel = 0 then
            num_rel := "";
            rel_string := "no relations for ";
        elif num_rel = 1 then
            rel_string := " relation for ";
        else
            rel_string := " relations for ";
        fi;
    fi;
    
    Print( "<A left module presented by ", num_rel, rel_string, num_gen, gen_string, ">" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsRightModule ],
        
  function( M )
    local num_gen, num_rel, gen_string, rel_string;
    
    num_gen := NrGenerators( M );
    if num_gen = 1 then
        gen_string := " generator and ";
    else
        gen_string := " generators and ";
    fi;
    if RelationsOfModule( M ) = "unknown relations" then
        num_rel := "unknown";
        rel_string := " relations";
    else
        num_rel := NrRelations( M );
        if num_rel = 0 then
            num_rel := "";
            rel_string := "no relations";
        elif num_rel = 1 then
            rel_string := " relation";
        else
            rel_string := " relations";
        fi;
    fi;
    Print( "<A right module on ", num_gen, gen_string, num_rel, rel_string, ">" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsFreeModule ], 1001,
        
  function( M )
    local r, rk;
    
    Print( "<A free " );
    
    if IsLeftModule( M ) then
        Print( "left " );
    else
        Print( "right " );
    fi;
    
    Print( "module" );
    
    r := NrGenerators( M );
    
    if HasRankOfModule( M ) then
        rk := RankOfModule( M );
        Print( " of rank ", rk, " on " );
        if r = rk then
            if r = 1 then
                Print( "a free generator" );
            else
                Print( "free generators" );
            fi;
        else ## => r > 1
            Print( r, " non-free generators" );
        fi;
    fi;
    
    Print( ">" );
    
end );
    
##
InstallMethod( ViewObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsZeroModule ], 1001,
        
  function( M )
    
    if IsLeftModule( M ) then
        Print( "<The zero left module>" ); ## FIXME: the zero module should be universal
    else
        Print( "<The zero right module>" ); ## FIXME: the zero module should be universal
    fi;
    
end );
    
##
InstallMethod( PrintObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsLeftModule ],
        
  function( M )
    
    Print( "LeftPresentation( " );
    if HasIsZeroModule( M ) and IsZeroModule( M ) then
        Print( "[ ], ", LeftActingDomain( M ) ); ## no generators, empty relations, ring
    else
        Print( GeneratorsOfModule( M ), ", " );
        if RelationsOfModule( M ) = "unknown relations" then
            Print( "[ ], " ); ## empty relations
        else
            Print( RelationsOfModule( M ), ", " );
        fi;
        Print( LeftActingDomain( M ), " " );
    fi;
    Print( ")" );
    
end );

##
InstallMethod( PrintObj,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsRightModule ],
        
  function( M )
    
    Print( "RightPresentation( " );
    if HasIsZeroModule( M ) and IsZeroModule( M ) then
        Print( "[ ], ", RightActingDomain( M ) ); ## no generators, empty relations, ring
    else
        Print( GeneratorsOfModule( M ), ", " );
        if RelationsOfModule( M ) = "unknown relations" then
            Print( "[ ], " ); ## empty relations
        else
            Print( RelationsOfModule( M ), ", " );
        fi;
        Print( RightActingDomain( M ), " " );
    fi;
    Print( ")" );
    
end );

##
InstallMethod( Display,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsLeftModule ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    R := RingName( R );
    
    Print( "Cokernel of the map:\n", R, "^(1x\033[01m", NrRelations( M ), "\033[0m) --> ", R, "^(1x\033[01m", NrGenerators( M ), "\033[0m), with matrix\n\n" );
    Display( MatrixOfRelations( M ) );
    
end );

##
InstallMethod( Display,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsRightModule ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    R := RingName( R );
    
    Print( "Cokernel of the map:\n", R, "^(\033[01m", NrRelations( M ), "\033[0mx1) --> ", R, "^(\033[01m", NrGenerators( M ), "\033[0mx1), with matrix\n\n" );
    Display( MatrixOfRelations( M ) );
    
end );

##
InstallMethod( Display,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep ], 1001,
        
  function( M )
    local rel, R, RP, name, zero, one, diag, display, rk, get_string;
    
    rel := MatrixOfRelations( M );
    
    if not ( HasElementaryDivisors( M ) and HasRankOfModule( M ) ) ## this should have no side effect on M
       and not IsDiagonalMatrix( rel ) then
        TryNextMethod( );
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    name := RingName( R );
    
    zero := Zero( R );
    one := One( R );
    
    if HasElementaryDivisors( M ) then
        diag := ElementaryDivisors( M );
    else
        diag := DiagonalEntries( rel );
        rk := Length( Filtered( diag, d -> d = zero ) ) + NrGenerators( M ) - Length( diag );
        SetRankOfModule( M, rk );
    fi;
    
    diag := Filtered( diag, x  -> x <> zero and x <> one );
    
    rk := RankOfModule( M );
    
    if IsHomalgExternalRingElementRep( zero ) then
        get_string := homalgPointer;
    else
        get_string := String;
    fi;
    
    if diag <> [ ] then
        display := List( diag, x -> [ name, "/< \033[01m", get_string( x ), "\033[0m > + " ] );
        display := Concatenation( display );
        display := Concatenation( display );
    else
        display := "";
    fi;
    
    if rk <> 0 then
        if IsLeftModule ( M ) then
            Print( display, name, "^(1 x", " \033[01m", rk, "\033[0m)\n" );
        else
            Print( display, name, "^(\033[01m", rk, "\033[0m x 1)\n" );
        fi;
    else
        Print( display{ [ 1 .. Length( display ) - 2 ] }, "\n" );
    fi;
    
end );

##
InstallMethod( Display,
        "for homalg modules",
        [ IsFinitelyPresentedModuleRep and IsZeroModule ], 1001,
        
  function( M )
    
    Print( 0, "\n" );
    
end );


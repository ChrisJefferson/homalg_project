#############################################################################
##
##  HomalgGenerators.gi         homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for a set of generators.
##
#############################################################################

####################################
#
# representations:
#
####################################

# a new representation for the category IsHomalgGenerators:
DeclareRepresentation( "IsHomalgGeneratorsOfFinitelyGeneratedModuleRep",
        IsHomalgGenerators,
        [ "generators", "relations_of_hullmodule" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgGenerators",
        NewFamily( "TheFamilyOfHomalgGenerators" ) );

# two new types:
BindGlobal( "TheTypeHomalgGeneratorsOfLeftModule",
        NewType(  TheFamilyOfHomalgGenerators,
                IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfLeftModule ) );

BindGlobal( "TheTypeHomalgGeneratorsOfRightModule",
        NewType(  TheFamilyOfHomalgGenerators,
                IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfRightModule ) );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( MatrixOfGenerators,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen )
    
    return gen!.generators;
    
end );

##
InstallMethod( HomalgRing,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen )
    
    return HomalgRing( MatrixOfGenerators( gen ) );
    
end );

##
InstallMethod( RelationsOfHullModule,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen )
    
    return gen!.relations_of_hullmodule;
    
end );

##
InstallMethod( MatrixOfRelations,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen )
    
    return MatrixOfRelations( RelationsOfHullModule( gen ) );
    
end );

##
InstallMethod( NrGenerators,			### defines: NrGenerators (NumberOfGenerators)
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfLeftModule ],
        
  function( gen )
    
    return NrRows( MatrixOfGenerators( gen ) );
    
end );

##
InstallMethod( NrGenerators,			### defines: NrGenerators (NumberOfGenerators)
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfRightModule ],
        
  function( gen )
    
    return NrColumns( MatrixOfGenerators( gen ) );
    
end );

##
InstallMethod( NewHomalgGenerators,
        "for sets of generators of homalg modules",
        [ IsHomalgMatrix, IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( mat, gen )
    local generators, relations_of_hullmodule, gen_new;
    
    generators := gen!.generators;
    relations_of_hullmodule := gen!.relations_of_hullmodule;
    
    if IsHomalgGeneratorsOfLeftModule( gen ) then
        gen_new := HomalgGeneratorsForLeftModule( mat, relations_of_hullmodule );
    else
        gen_new := HomalgGeneratorsForRightModule( mat, relations_of_hullmodule );
    fi;
    
    if HasProcedureToReadjustGenerators( gen ) then
        SetProcedureToReadjustGenerators( gen_new, ProcedureToReadjustGenerators( gen ) );
    fi;
    
    if HasProcedureToNormalizeGenerators( gen ) then
        SetProcedureToNormalizeGenerators( gen_new, ProcedureToNormalizeGenerators( gen ) );
    fi;
    
    return gen_new;
    
end );

##
InstallMethod( UnionOfRelations,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep, IsHomalgRelationsOfFinitelyPresentedModuleRep ],
        
  function( gen, rel )
    local gen_new, hull;
    
    gen_new := MatrixOfGenerators( gen );
    
    hull := RelationsOfHullModule( gen );
    
    hull := UnionOfRelations( hull, rel );
    
    if IsHomalgGeneratorsOfLeftModule( gen ) and IsHomalgRelationsOfLeftModule( rel ) then
        gen_new := HomalgGeneratorsForLeftModule( gen_new, hull );
    elif IsHomalgGeneratorsOfRightModule( gen ) and IsHomalgGeneratorsOfRightModule( rel ) then
        gen_new := HomalgGeneratorsForRightModule( gen_new, hull );
    else
        Error( "the set of generators and the set of relations must either be both left or both right\n" );
    fi;
    
    if HasProcedureToReadjustGenerators( gen ) then
        SetProcedureToReadjustGenerators( gen_new, ProcedureToReadjustGenerators( gen ) );
    fi;
    
    if HasProcedureToNormalizeGenerators( gen ) then
        SetProcedureToNormalizeGenerators( gen_new, ProcedureToNormalizeGenerators( gen ) );
    fi;
    
    return gen_new;
    
end );

##
InstallMethod( BasisOfModule,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfLeftModule ],
        
  function( gen )
    local bas;
    
    if not IsBound( gen!.BasisOfModule ) then
        gen!.BasisOfModule := BasisOfRows( MatrixOfGenerators( gen ) );
        SetCanBeUsedToDecideZeroEffectively( gen, false );
    fi;
    
    bas := HomalgGeneratorsForLeftModule( gen!.BasisOfModule, HomalgRing( gen ) );
    
    SetCanBeUsedToDecideZeroEffectively( bas, true );
    
    return HomalgRelationsForLeftModule( MatrixOfGenerators( bas ) ); ## FIXME: written for \/ in Modules.gi (should become obsolete when DefectOfHoms arrives)
    
end );

##
InstallMethod( BasisOfModule,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfRightModule ],
        
  function( gen )
    local bas;
    
    if not IsBound( gen!.BasisOfModule ) then
        gen!.BasisOfModule := BasisOfColumns( MatrixOfGenerators( gen ) );
        SetCanBeUsedToDecideZeroEffectively( gen, false );
    fi;
    
    bas := HomalgGeneratorsForRightModule( gen!.BasisOfModule, HomalgRing( gen ) );
    
    SetCanBeUsedToDecideZeroEffectively( bas, true );
        
    return HomalgRelationsForRightModule( MatrixOfGenerators( bas ) ); ## FIXME: written for \/ in Modules.gi (should become obsolete when DefectOfHoms arrives)
    
end );

##
InstallMethod( DecideZero,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen )
    local gen_new;
    
    if not IsBound( gen!.DecideZero ) then
        gen!.DecideZero := DecideZero( MatrixOfGenerators( gen ), RelationsOfHullModule( gen ) );
        SetIsReduced( gen, false );
    fi;
    
    gen_new := NewHomalgGenerators( gen!.DecideZero, gen );
    
    SetIsReduced( gen_new, true );
    
    return gen_new;
    
end );

##
InstallMethod( DecideZero,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsReduced ],
        
  function( gen )
    
    return gen;
    
end );

##
InstallMethod( GetRidOfObsoleteGenerators,	### defines: GetRidOfObsoleteGenerators (BetterBasis)
        "for sets of relations of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( _gen )
    local R, RP, gen;
    
    R := HomalgRing( _gen );
    
    RP := homalgTable( R );
    
    #=====# begin of the core procedure #=====#
    
    gen := DecideZero( _gen );
    
    if IsHomalgGeneratorsOfLeftModule( gen ) then
        
        if IsBound(RP!.SimplifyBasisOfRows) then
            gen := RP!.SimplifyBasisOfRows( gen );
        else
            gen := MatrixOfGenerators( gen );
        fi;
        
        gen := CertainRows( gen, NonZeroRows( gen ) );
        
    else
        
        if IsBound(RP!.SimplifyBasisOfColumns) then
            gen := RP!.SimplifyBasisOfColumns( gen );
        else
            gen := MatrixOfGenerators( gen );
        fi;
        
        gen := CertainColumns( gen, NonZeroColumns( gen ) );
        
    fi;
    
    return NewHomalgGenerators( gen, _gen );
    
end );

##
InstallMethod( SyzygiesGenerators,
        "for sets of relations of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfLeftModule,
          IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfLeftModule ],
        
  function( gen, rel )
    
    return HomalgRelationsForLeftModule( SyzygiesGenerators( MatrixOfGenerators( gen ), rel ) );
    
end );

##
InstallMethod( SyzygiesGenerators,
        "for sets of relations of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and IsHomalgGeneratorsOfRightModule,
          IsHomalgRelationsOfFinitelyPresentedModuleRep and IsHomalgRelationsOfRightModule ],
        
  function( gen, rel )
    
    return HomalgRelationsForRightModule( SyzygiesGenerators( MatrixOfGenerators( gen ), rel ) );
    
end );

##
InstallMethod( \*,
        "for sets of generators of homalg modules",
        [ IsHomalgMatrix, IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( TI, gen )
    local generators;
    
    generators := gen!.generators;
    
    if IsHomalgGeneratorsOfLeftModule( gen ) then
        return NewHomalgGenerators( TI * generators, gen ); ## the hull relations remain unchanged :)
    else
        return NewHomalgGenerators( generators * TI, gen ); ## the hull relations remain unchanged :)
    fi;
    
end );

##
InstallMethod( \*,
        "for sets of generators of homalg modules",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep, IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( gen1, gen2 )
    local gen;
    
    if not ( IsHomalgGeneratorsOfLeftModule( gen1 ) and IsHomalgGeneratorsOfLeftModule( gen2 ) )
       and not ( IsHomalgGeneratorsOfRightModule( gen1 ) and IsHomalgGeneratorsOfRightModule( gen2 ) ) then
        Error( "the two sets of generators must either be both left or both right\n" );
    fi;
    
    gen := MatrixOfGenerators( gen1 ) * gen2;
    
    return gen;
    
end );

####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( HomalgGeneratorsForLeftModule,
  function( arg )
    local nargs, ar, R, generators, relations_of_hullmodule, gen;
    
    nargs := Length( arg );
    
    for ar in arg{ [ 2 .. nargs ] } do
        if IsHomalgRing( ar ) then
            R := ar;
            break;
        fi;
    od;
    
    if IsHomalgMatrix( arg[1] ) then
        generators := arg[1];
    elif IsBound( R ) then
        generators := HomalgMatrix( arg[1], R );
    else
        Error( "if the first argument isn't of type IsHomalgMatrix, then the last argument must be of type IsHomalgRing; but recieved: ", arg[nargs], "\n" );
    fi;
    
    if not IsBound( R ) then
        R := HomalgRing( generators );
    fi;
    
    for ar in arg{ [ 2 .. nargs ] } do
        if IsHomalgRelations( ar ) then
            if not IsHomalgRelationsOfLeftModule( ar ) then
                Error( "the set of relations of the hull module of the generators is not a set of relations of a left module\n" );
            fi;
            relations_of_hullmodule := ar;
            break;
        elif IsHomalgMatrix( ar ) then
            relations_of_hullmodule := HomalgRelationsForLeftModule( ar );
            break;
        elif IsList( ar ) and not IsStringRep( ar ) and IsBound( R ) then
            relations_of_hullmodule := HomalgRelationsForLeftModule( ar, R );
            break;
        elif nargs > 2 then
            if IsBound( R ) then
                relations_of_hullmodule := HomalgRelationsForLeftModule( ar, R );
                break;
            else
                Error( "if more than two arguments are provided and the second argument is neither of type IsHomalgRelations nor of type IsHomalgMatrix, then the last argument must be of type IsHomalgRing; but recieved: ", arg[nargs], "\n" );
            fi;
        fi;
    od;
    
    if not IsBound( relations_of_hullmodule ) then
        relations_of_hullmodule :=
          HomalgRelationsForLeftModule( HomalgZeroMatrix( 0, NrColumns( generators ), R ) );
    fi;
    
    gen := rec( generators := generators,
                relations_of_hullmodule := relations_of_hullmodule );
    
    ## Objectify:
    Objectify( TheTypeHomalgGeneratorsOfLeftModule, gen );
    
    return gen;
    
end );

InstallGlobalFunction( HomalgGeneratorsForRightModule,
  function( arg )
    local nargs, ar, R, generators, relations_of_hullmodule, gen;
    
    nargs := Length( arg );
    
    for ar in arg{ [ 2 .. nargs ] } do
        if IsHomalgRing( ar ) then
            R := ar;
            break;
        fi;
    od;
    
    if IsHomalgMatrix( arg[1] ) then
        generators := arg[1];
    elif IsBound( R ) then
        generators := HomalgMatrix( arg[1], R );
    else
        Error( "if the first argument isn't of type IsHomalgMatrix, then the last argument must be of type IsHomalgRing; but recieved: ", arg[nargs], "\n" );
    fi;
    
    if not IsBound( R ) then
        R := HomalgRing( generators );
    fi;
    
    for ar in arg{ [ 2 .. nargs ] } do
        if IsHomalgRelations( ar ) then
            if not IsHomalgRelationsOfRightModule( ar ) then
                Error( "the set of relations of the hull module of the generators is not a set of relations of a right module\n" );
            fi;
            relations_of_hullmodule := ar;
            break;
        elif IsHomalgMatrix( ar ) then
            relations_of_hullmodule := HomalgRelationsForRightModule( ar );
            break;
        elif IsList( ar ) and not IsStringRep( ar ) and IsBound( R ) then
            relations_of_hullmodule := HomalgRelationsForLeftModule( ar, R );
            break;
        elif nargs > 2 then
            if IsBound( R ) then
                relations_of_hullmodule := HomalgRelationsForRightModule( ar, R );
                break;
            else
                Error( "if more than two arguments are provided and the second argument is neither of type IsHomalgRelations nor of type IsHomalgMatrix, then the last argument must be of type IsHomalgRing; but recieved: ", arg[nargs], "\n" );
            fi;
        fi;
    od;
    
    if not IsBound( relations_of_hullmodule ) then
        relations_of_hullmodule :=
          HomalgRelationsForRightModule( HomalgZeroMatrix( NrRows( generators ), 0, R ) );
    fi;
    
    gen := rec( generators := generators,
                relations_of_hullmodule := relations_of_hullmodule );
    
    ## Objectify:
    Objectify( TheTypeHomalgGeneratorsOfRightModule, gen );
    
    return gen;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg generators",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( o )
    local g;
    
    g := NrGenerators( o );
    
    if g = 0 then
        Print( "<An empty set of generators " );
    elif g = 1 then
        Print( "<A set consisting of a single generator " );
    else
        Print( "<A set of ", g, " generators " );
    fi;
    
    Print( "of a homalg " );
    
    if IsHomalgGeneratorsOfLeftModule( o ) then
        Print( "left " );
    else
        Print( "right " );
    fi;
    
    Print( "module>" );
    
end );

InstallMethod( Display,
        "for homalg generators",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep ],
        
  function( o )
    local g;
    
    g := NrGenerators( o );
    
    if g = 0 then
        Print( "an empty set of generators\n" );
    else
        if g = 1 then
            Print( "a set consisting of a single generator given by (the" );
        else
            Print( "a set of ", g, " generators given by the" );
        fi;
        
        if IsHomalgGeneratorsOfLeftModule( o ) then
            Print( " row" );
        else
            Print( " column" );
        fi;
        
        if g = 1 then
            Print( " of)" );
        else
            Print( "s of" );
        fi;
        
        Print( " the matrix\n\n" );
        
        Display( MatrixOfGenerators( o ) );
    fi;
    
end );

InstallMethod( Display,
        "for homalg generators",
        [ IsHomalgGeneratorsOfFinitelyGeneratedModuleRep and HasProcedureToReadjustGenerators ],
        
  function( o )
    local mat, proc, i;
    
    mat := MatrixOfGenerators( o );
    
    proc := ProcedureToReadjustGenerators( o );
    
    if IsHomalgGeneratorsOfLeftModule( o ) then
        for i in [ 1 .. NrGenerators( o ) ] do
            Display( proc[1]( CertainRows( mat, [ i ] ), proc[2], proc[3] ) ); Print( "\n" );
        od;
    else
        for i in [ 1 .. NrGenerators( o ) ] do
            Display( proc[1]( CertainColumns( mat, [ i ] ), proc[2], proc[3] ) ); Print( "\n" );
        od;
    fi;
    
end );

#############################################################################
##
##  HomalgFunctor.gi            homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for functors.
##
#############################################################################

####################################
#
# representations:
#
####################################

# a new representation for the category IsHomalgFunctor:
DeclareRepresentation( "IsHomalgFunctorRep",
        IsHomalgFunctor,
        [ ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgFunctors",
        NewFamily( "TheFamilyOfHomalgFunctors" ) );

# a new type:
BindGlobal( "TheTypeHomalgFunctor",
        NewType(  TheFamilyOfHomalgFunctors,
                IsHomalgFunctorRep ) );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( NameOfFunctor,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( Functor )
    local functor_name;
    
    if IsBound( Functor!.name ) then
        functor_name := Functor!.name;
        if not IsOperation( ValueGlobal( functor_name ) ) and not IsFunction( ValueGlobal( functor_name ) ) then
            Error( "the functor ", functor_name, " neither points to an operation nor a function\n" );
        fi;
    else
        Error( "the provided functor is nameless\n" );
    fi;
    
    return functor_name;
    
end );

##
InstallMethod( MultiplicityOfFunctor,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( Functor )
    
    if IsBound( Functor!.number_of_arguments ) then
        return Functor!.number_of_arguments;
    fi;
    
    return 1;
    
end );

##
InstallMethod( FunctorMap,
        "for homalg morphisms",
        [ IsHomalgFunctorRep, IsMorphismOfFinitelyGeneratedModulesRep, IsList ],
        
  function( Functor, phi, fixed_arguments_of_multi_functor )
    local functor_name, number_of_arguments, arg_positions, S, T, pos,
          arg_before_pos, arg_behind_pos, arg_source, arg_target,
          F_source, F_target, arg_phi, hull_phi, emb_source, emb_target;
    
    if not fixed_arguments_of_multi_functor = [ ]
       and not ( ForAll( fixed_arguments_of_multi_functor, a -> IsList( a ) and Length( a ) = 2 and IsPosInt( a[1] ) ) ) then
        Error( "the last argument has a wrong syntax\n" );
    fi;
    
    functor_name := NameOfFunctor( Functor );
        
    number_of_arguments := MultiplicityOfFunctor( Functor );
    
    arg_positions := List( fixed_arguments_of_multi_functor, a -> a[1] );
    
    if Length( arg_positions ) <> number_of_arguments - 1 then
        Error( "the number of fixed arguments provided for the functor must be one less than the total number\n" );
    elif not IsDuplicateFree( arg_positions ) then
        Error( "the provided list of positions is not duplicate free: ", arg_positions, "\n" );
    elif Maximum( arg_positions ) > number_of_arguments then
        Error( "the list of positions must be a subset of [ 1 .. ", number_of_arguments, " ], but received: :",  arg_positions, "\n" );
    fi;
    
    S := SourceOfMorphism( phi );
    T := TargetOfMorphism( phi );
    
    pos := Filtered( [ 1 .. number_of_arguments ], a -> not a in arg_positions )[1];
    
    arg_positions := fixed_arguments_of_multi_functor;
    
    Sort( arg_positions, function( v, w ) return v[1] < w[1]; end );
    
    arg_before_pos := List( arg_positions{[ 1 .. pos - 1 ]}, a -> a[2] );
    arg_behind_pos := List( arg_positions{[ pos .. number_of_arguments - 1 ]}, a -> a[2] );
    
    if IsBound( Functor!.( pos ) ) and Functor!.( pos )[1] = "covariant" then
        arg_source := Concatenation( arg_before_pos, [ S ], arg_behind_pos );
        arg_target := Concatenation( arg_before_pos, [ T ], arg_behind_pos );
    elif IsBound( Functor!.( pos ) ) and Functor!.( pos )[1] = "contravariant" then
        arg_source := Concatenation( arg_before_pos, [ T ], arg_behind_pos );
        arg_target := Concatenation( arg_before_pos, [ S ], arg_behind_pos );
    else
        Error( "the functor ", functor_name, " must be either co- or contravriant in its argument number ", pos, "\n" );
    fi;
    
    F_source := CallFuncList( ValueGlobal( functor_name ), arg_source );
    F_target := CallFuncList( ValueGlobal( functor_name ), arg_target );
    
    if IsBound( Functor!.OnMorphisms ) then
        arg_phi := Concatenation( arg_before_pos, [ phi ], arg_behind_pos );
        hull_phi := CallFuncList( Functor!.OnMorphisms, arg_phi );
    else
        hull_phi := phi;
    fi;
    
    emb_source := F_source!.NaturalEmbedding;
    emb_target := F_target!.NaturalEmbedding;
    
    hull_phi :=
      HomalgMorphism( hull_phi, TargetOfMorphism( emb_source ), TargetOfMorphism( emb_target ) );
    
    return CompleteImSq( emb_source, hull_phi, emb_target );
    
end );

##
InstallMethod( FunctorMap,
        "for homalg morphisms",
        [ IsHomalgFunctorRep, IsMorphismOfFinitelyGeneratedModulesRep ],
        
  function( Functor, phi )
    
    return FunctorMap( Functor, phi, [ ] );
    
end );

##
InstallMethod( InstallFunctorOnObjects,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( Functor )
    local functor_name, number_of_arguments, natural_transformation,
          filter_obj, filter1_obj, filter2_obj;
    
    functor_name := ValueGlobal( NameOfFunctor( Functor ) );
        
    number_of_arguments := MultiplicityOfFunctor( Functor );
    
    if number_of_arguments = 1 then
        
        filter_obj := Functor!.1[2];
        
        if IsFilter( filter_obj ) then
            
            if IsBound( Functor!.natural_transformation ) then
                
                natural_transformation := ValueGlobal( Functor!.natural_transformation );
                
                InstallOtherMethod( natural_transformation,
                        "for homalg modules",
                        [ filter_obj ],
                  function( o )
                    
                    functor_name( o );			## this sets the attribute named "natural_transformation"
                    
                    return natural_transformation( o );	## not an infinite loop because of the side effect of the above line
                    
                end );
                
            fi;
            
            InstallOtherMethod( functor_name,
                    "for homalg modules",
                    [ filter_obj ],
              function( o )
                local obj;
                
                if IsHomalgRing( o ) then
                    ## I personally prefer the row convention and hence left modules:
                    obj := AsLeftModule( o );
                else
                    obj := o;
                fi;
                
                return Functor!.OnObjects( obj );
                
            end );
            
        else
            
            Error( "wrong syntax: ", filter_obj, "\n" );
            
        fi;
        
    elif number_of_arguments = 2 then
        
        filter1_obj := Functor!.1[2];
        filter2_obj := Functor!.2[2];
        
        if IsFilter( filter1_obj ) and IsFilter( filter2_obj ) then
            
            InstallOtherMethod( functor_name,
                    "for homalg modules",
                    [ filter1_obj, filter2_obj ],
              function( o1, o2 )
                local obj1, obj2;
                
                if IsHomalgModule( o1 ) and IsHomalgModule( o2 ) then	## the most probable case
                    obj1 := o1;
                    obj2 := o2;
                elif IsHomalgModule( o1 ) and IsHomalgRing( o2 ) then
                    obj1 := o1;
                    
                    if IsLeft( o1 ) then
                        obj2 := AsLeftModule( o2 );
                    else
                        obj2 := AsRightModule( o2 );
                    fi;
                elif IsHomalgRing( o1 ) and IsHomalgModule( o2 ) then
                    obj2 := o2;
                    
                    if IsLeft( o2 ) then
                        obj1 := AsLeftModule( o1 );
                    else
                        obj1 := AsRightModule( o1 );
                    fi;
                elif IsHomalgRing( o1 ) and IsHomalgRing( o2 ) then
                    if not IsIdenticalObj( o1, o2 ) then
                        Error( "the two rings are not identical\n" );
                    fi;
                    
                    ## I personally prefer the row convention and hence left modules:
                    obj1 := AsLeftModule( o1 );
                    obj2 := obj1;
                else
                    ## the default:
                    obj1 := o1;
                    obj2 := o2;
                fi;
                
                return Functor!.OnObjects( obj1, obj2 );
                
            end );
            
            InstallOtherMethod( functor_name,
                    "for homalg modules",
                    [ filter1_obj ],
              function( o )
                local R;
                
                if IsHomalgRing( o ) then
                    ## I personally prefer the row convention and hence left modules:
                    R := AsLeftModule( o );
                else
                    R := HomalgRing( o );
                    if IsLeft( o ) then
                        R := AsLeftModule( R );
                    else
                        R := AsRightModule( R );
                    fi;
                fi;
                
                return Functor!.OnObjects( o, R  );
                
            end );
            
        else
            
            Error( "wrong syntax: ", filter1_obj, filter2_obj, "\n" );
            
        fi;
        
    fi;
    
end );

##
InstallMethod( InstallFunctorOnMorphisms,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( Functor )
    local functor_name, number_of_arguments, filter_mor,
          filter1_obj, filter1_mor, filter2_obj, filter2_mor;
    
    functor_name := ValueGlobal( NameOfFunctor( Functor ) );
        
    number_of_arguments := MultiplicityOfFunctor( Functor );
    
    if number_of_arguments = 1 then
        
        filter_mor := Functor!.1[3];
        
        if IsFilter( filter_mor ) then
            
            InstallOtherMethod( functor_name,
                    "for homalg morphisms",
                    [ filter_mor ],
              function( m )
                
                return FunctorMap( Functor, m );
                
            end );
            
        else
            
            Error( "wrong syntax: ", filter_mor, "\n" );
            
        fi;
        
    elif number_of_arguments = 2 then
        
        filter1_obj := Functor!.1[2];
        filter1_mor := Functor!.1[3];
        
        filter2_obj := Functor!.2[2];
        filter2_mor := Functor!.2[3];
        
        if IsFilter( filter1_mor ) and IsFilter( filter2_mor ) then
            
            InstallOtherMethod( functor_name,
                    "for homalg morphisms",
                    [ filter1_mor ],
              function( m )
                local R;
                
                R := HomalgRing( m );
                
                if IsLeft( m ) then
                    R := AsLeftModule( R );
                else
                    R := AsRightModule( R );
                fi;
                
                return FunctorMap( Functor, m, [ [ 2, R ] ] );
                
            end );
            
            InstallOtherMethod( functor_name,
                    "for homalg morphisms",
                    [ filter1_mor, filter2_obj ],
              function( m, o )
                local obj;
                
                if IsHomalgModule( o ) then	## the most probable case
                    obj := o;
                elif IsHomalgRing( o ) then
                    if IsLeft( m ) then
                        obj := AsLeftModule( o );
                    else
                        obj := AsRightModule( o );
                    fi;
                else
                    ## the default:
                    obj := o;
                fi;
                
                return FunctorMap( Functor, m, [ [ 2, obj ] ] );
                
            end );
            
            InstallOtherMethod( functor_name,
                    "for homalg morphisms",
                    [ filter1_obj, filter2_mor ],
              function( o, m )
                local obj;
                
                if IsHomalgModule( o ) then	## the most probable case
                    obj := o;
                elif IsHomalgRing( o ) then
                    if IsLeft( m ) then
                        obj := AsLeftModule( o );
                    else
                        obj := AsRightModule( o );
                    fi;
                else
                    ## the default:
                    obj := o;
                fi;
                
                return FunctorMap( Functor, m, [ [ 1, obj ] ] );
                
            end );
            
        else
            
            Error( "wrong syntax: ", filter1_mor, filter2_mor, "\n" );
            
        fi;
        
    fi;
    
end );

##
InstallMethod( InstallFunctor,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( Functor )
    
    InstallFunctorOnObjects( Functor );
    
    InstallFunctorOnMorphisms( Functor );
    
    #InstallFunctorOnComplexes( Functor );
    
    #InstallFunctorOnChainMaps( Functor );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( CreateHomalgFunctor,
  function( arg )
    local ar, functor, type;
    
    functor := rec( );
    
    for ar in arg do
        if not IsString( ar ) and IsList( ar ) and Length( ar ) = 2 and IsString( ar[1] ) then
            functor.( ar[1] ) := ar[2];
        fi;
    od;
    
    type := TheTypeHomalgFunctor;
    
    ## Objectify:
    Objectify( type, functor );
    
    return functor;
    
end );


####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( o )
    
    Print( "<A functor for homalg>" );
    
end );

InstallMethod( Display,
        "for homalg functors",
        [ IsHomalgFunctorRep ],
        
  function( o )
    
    Print( NameOfFunctor( o ) );
    
end );

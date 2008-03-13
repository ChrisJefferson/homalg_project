#############################################################################
##
##  IO.gi                       homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff to use the legendary GAP4 I/O package of Max Neunhoeffer.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgStream,
        "for homalg matrices",
        [ IsHomalgExternalObjectWithIOStream ],
        
  function( o )
    
    if IsBound(o!.stream) then
        return o!.stream;
    fi;
    
    return fail;
    
end );

##
InstallMethod( HomalgExternalCASystemPID,
        "for homalg matrices",
        [ IsHomalgExternalObjectWithIOStream ],
        
  function( o )
    
    return HomalgStream( o ).pid;
    
end );

##
InstallGlobalFunction( HomalgCreateStringForExternalCASystem,
  function( L )
    local l, s;
    
    if not IsList( L ) then
        Error( "the first argument must be a list\n" );
    fi;
    
    l := Length( L );
    
    s := List( [ 1 .. l ], function( a )
                             local R, CAS, stream, t;
                             if IsString( L[a] ) then
                                 return L[a];
                             else
                                 if IsHomalgExternalObjectRep( L[a] )
                                    or IsHomalgExternalRingRep( L[a] ) then
                                     t := HomalgPointer( L[a] );
                                 elif IsHomalgExternalMatrixRep( L[a] ) then
                                     if not IsVoidMatrix( L[a] ) then
                                         t := HomalgPointer( L[a] ); ## now we enforce evaluation!!!
                                     else
                                         R := HomalgRing( L[a] );
                                         CAS := HomalgExternalCASystem( R );
                                         stream := HomalgStream( R );
                                         stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;
                                         t := Concatenation( "homalg_variable_", String( stream.HomalgExternalVariableCounter ) );
                                         MakeImmutable( t );
                                         SetEval( L[a], HomalgExternalObject( t, CAS, stream ) ); ## CAUTION: HomalgPointer( L[a] ) now exists but still points to nothing!!!
                                         ResetFilterObj( L[a], IsVoidMatrix );
                                     fi;
                                 else
                                     t := String( L[a] );
                                 fi;
                                 if a < l and not IsString( L[a+1] ) then
                                     t := Concatenation( t, "," );
                                 fi;
                                 return t;
                             fi;
                           end );
    
    return Flat( s );
                           
end );

##
InstallGlobalFunction( HomalgSendBlocking,
  function( arg )
    local L, nargs, properties, ar, option, R, ext_obj, e, RP, CAS, cas_version, stream,
          homalg_variable, l, eol, enter, max;
    
    if IsBound( HOMALG.HomalgSendBlockingInput ) then
        Add( HOMALG.HomalgSendBlockingInput, arg );
    fi;
    
    if not IsList( arg[1] ) then
        Error( "the first argument must be a list\n" );
    elif IsString( arg[1] ) then
        L := [ arg[1] ];
    else
        L := arg[1];
    fi;
    
    nargs := Length( arg );
    
    properties := [];
    
    for ar in arg{[ 2 .. nargs ]} do
        if not IsBound( option ) and IsString( ar ) then
            option := ar;
        elif not IsBound( R ) and IsHomalgExternalRingRep( ar ) then
            R := ar;
            ext_obj := R;
        elif not IsBound( ext_obj )
          and HasIsHomalgExternalObjectWithIOStream( ar ) and IsHomalgExternalObjectWithIOStream( ar ) then
            ext_obj := ar;
        elif IsOperation( ar ) then
            Add( properties, ar );
        else
            Error( "this argument should be in { IsString, IsHomalgExternalRingRep, IsHomalgExternalObjectWithIOStream } bur recieved: ", ar,"\n" );
        fi;
    od;
    
    if not IsBound( ext_obj ) then ## R is also not yet defined
        e := Filtered( L, a -> IsHomalgExternalMatrixRep( a ) or IsHomalgExternalRingRep( a ) or 
                     ( IsHomalgExternalObjectRep( a )
                       and HasIsHomalgExternalObjectWithIOStream( a )
                       and IsHomalgExternalObjectWithIOStream( a ) ) );
        if e <> [ ] then
            ext_obj := e[1];
            for ar in e do
                if IsHomalgExternalMatrixRep( ar ) then
                    R := HomalgRing( ar );
                    ext_obj := R;
                    break;
                elif IsHomalgExternalRingRep( ar ) then
                    R := ar;
                    break;
                fi;
            od;
        else
            Error( "either the list provided by the first argument must contain at least one external matrix or an external ring or one of the remaining arguments must be an external ring or an external object with IO stream\n" );
        fi;
    fi;
    
    if IsBound( R ) then
        RP := HomalgTable( R );
        
        if IsBound(RP!.HomalgSendBlocking) then
            return RP!.HomalgSendBlocking( arg );
        fi;
    fi;
    
    CAS := HomalgExternalCASystem( ext_obj );
    cas_version := HomalgExternalCASystemVersion( ext_obj );
    stream := HomalgStream( ext_obj );
    
    if not IsBound( stream.HomalgExternalVariableCounter ) then
        
        if Length( CAS ) > 3 and LowercaseString( CAS{[1..4]} ) = "sage" then
            stream.cas := "sage"; ## normalized name on which the user should have no control
            stream.SendBlocking := SendSageBlocking;
            stream.define := "=";
            stream.eol_verbose := "";
            stream.eol_quiet := ";";
        elif Length( CAS ) > 7 and LowercaseString( CAS{[1..8]} ) = "singular" then
            stream.cas := "singular"; ## normalized name on which the user should have no control
            stream.SendBlocking := SendSingularBlocking;
            stream.define := "=";
            stream.eol_verbose := ";";
            stream.eol_quiet := ";";
        elif Length( CAS ) > 4 and LowercaseString( CAS{[1..5]} ) = "maple" then
            stream.cas := "maple"; ## normalized name on which the user should have no control
            if cas_version = "10" then
                stream.SendBlocking := SendMaple10Blocking;
            elif cas_version = "9.5" then
                stream.SendBlocking := SendMaple95Blocking;
            elif cas_version = "9" then
                stream.SendBlocking := SendMaple9Blocking;
            else
                stream.SendBlocking := SendMaple10Blocking;
            fi;
            stream.define := ":=";
            stream.eol_verbose := ";";
            stream.eol_quiet := ":";
        else
            Error( "the computer algebra system ", CAS, " is not yet supported as an external computing engine for homalg\n" );
        fi;
        
        stream.HomalgExternalVariableCounter := 0;
        stream.HomalgExternalCommandCounter := 0;
        stream.HomalgExternalOutputCounter := 0;
        stream.HomalgExternalCallCounter := 0;
        stream.HomalgBackStreamMaximumLength := 0;
        
    fi;
    
    if not IsBound( option ) then
        stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;
        homalg_variable := Concatenation( "homalg_variable_", String( stream.HomalgExternalVariableCounter ) );
        MakeImmutable( homalg_variable );
    fi;
    
    L := HomalgCreateStringForExternalCASystem( L );
    
    l := Length( L );
    
    if l > 0 and L{[l..l]} = "\n" then
        enter := "";
        eol := "";
    else
        enter := "\n";
        if l > 0 and
           ( L{[l-Length( stream.eol_verbose )+1..l]} = stream.eol_verbose
             or L{[l-Length( stream.eol_quiet )+1..l]} = stream.eol_quiet ) then
            eol := "";
        elif not IsBound( option ) then
            eol := stream.eol_quiet; ## as little back-traffic over the stream as possible
        else
            if PositionSublist( LowercaseString( option ), "command" ) <> fail then
                eol := stream.eol_quiet; ## as little back-traffic over the stream as possible
            else
                eol := stream.eol_verbose;
            fi;
        fi;
    fi;
    
    if not IsBound( option ) then
        L := Concatenation( homalg_variable, stream.define, L, eol, enter );
    else
        L := Concatenation( L, eol, enter );
        
        if PositionSublist( LowercaseString( option ), "command" ) <> fail then
            stream.HomalgExternalCommandCounter := stream.HomalgExternalCommandCounter + 1;
        else
            stream.HomalgExternalOutputCounter := stream.HomalgExternalOutputCounter + 1;
        fi;
    fi;
    
    if IsBound( HOMALG.HomalgSendBlocking ) then
        Add( HOMALG.HomalgSendBlocking, L );
    fi;
    
    stream.HomalgExternalCallCounter := stream.HomalgExternalCallCounter + 1;
    
    stream.SendBlocking( stream, L );
    
    max := Maximum( stream.HomalgBackStreamMaximumLength, Length( stream.lines ) );
    
    if max > stream.HomalgBackStreamMaximumLength then
        stream.HomalgBackStreamMaximumLength := max;
        if HOMALG.SaveHomalgMaximumBackStream = true then
            stream.HomalgMaximumBackStream := stream.lines;
        fi;
    fi;
    
    if not IsBound( option ) then
        L := HomalgExternalObject( homalg_variable, CAS, stream );
        
        if properties <> [ ] and IsHomalgExternalObjectWithIOStream( L ) then
            for ar in properties do
                Setter( ar )( L, true );
            od;
        fi;
        
        return L;
    elif PositionSublist( LowercaseString( option ), "display" ) <> fail then
        if stream.cas = "maple" then
            return stream.lines{[ 1 .. Length( stream.lines ) - 36 ]};
        else
            return Concatenation( stream.lines, "\n" );
        fi;
    elif stream.cas = "maple" then
        ## unless meant for display, normalize the white spaces caused by Maple
        return NormalizedWhitespace( stream.lines );
    else
        return stream.lines;
    fi;
    
end );

##
InstallGlobalFunction( StringToIntList,
  function( arg )
    local l, lint;
    
    l := SplitString( arg[1], ",", "[ ]\n" );
    lint := List( l, Int ); 
    
    if fail in lint then
        Error( "the first argument is not a string containg a list of integers: ", arg[1], "\n");
    fi;
    
    return lint;
    
end );

##
InstallGlobalFunction( StringToElementStringList,
  function( arg )
    
    return SplitString( arg[1], ",", "[ ]\n" );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg external objects with an IO stream",
        [ IsHomalgExternalObjectRep and IsHomalgExternalObjectWithIOStream ],
        
  function( o )
    
    Print( "<A homalg object defined externally in the CAS " );
    Print( HomalgExternalCASystem( o ), " running with pid ", HomalgExternalCASystemPID( o ), ">" ); 
    
end );


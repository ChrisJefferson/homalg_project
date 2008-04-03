#############################################################################
##
##  IO.gi                     RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff to use the fantastic GAP4 I/O package of Max Neunhöffer.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( HomalgCreateStringForExternalCASystem,
  function( arg )
    local nargs, L, l, stream, break_lists, s;
    
    nargs := Length( arg );
    
    if nargs = 0 or not IsList( arg[1] ) then
        Error( "the first argument must be a list\n" );
    fi;
    
    L := arg[1];
    
    l := Length( L );
    
    break_lists := false;
    
    if nargs > 0 and IsRecord( arg[2] ) then
        stream := arg[2];
        if IsBound( stream.break_lists ) and stream.break_lists = true then
            break_lists := true;
        fi;
    fi;
    
    if nargs > 1 and arg[3] = "break_lists" then
        break_lists := true;
    fi;
    
    s := List( [ 1 .. l ], function( a )
                             local CAS, stream, t;
                             if IsString( L[a] ) then
                                 return L[a];
                             else
                                 if IsHomalgExternalObjectRep( L[a] )
                                    or IsHomalgExternalRingRep( L[a] ) then
                                     t := HomalgPointer( L[a] );
                                 elif IsHomalgExternalMatrixRep( L[a] ) then
                                     if not IsVoidMatrix( L[a] ) or HasEval( L[a] ) then
                                         t := HomalgPointer( L[a] ); ## now we enforce evaluation!!!
                                     else
                                         CAS := HomalgExternalCASystem( L[a] );
                                         stream := HomalgStream( L[a] );
                                         stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;
                                         t := Concatenation( "homalg_variable_", String( stream.HomalgExternalVariableCounter ) );
                                         MakeImmutable( t );
                                         SetEval( L[a], HomalgExternalObject( t, CAS, stream ) ); ## CAUTION: HomalgPointer( L[a] ) now exists but still points to nothing!!!
                                         ResetFilterObj( L[a], IsVoidMatrix );
                                     fi;
                                 elif break_lists and IsList( L[a] ) and not IsString( L[a] ) then
                                     if ForAll( L[a], IsString ) then
                                         t := JoinStringsWithSeparator( L[a] );
                                     else
                                         t := String( List( L[a], i -> i ) ); ## get rid of the range representation of lists
                                         t := t{ [ 2 .. Length( t ) - 1 ] };
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
    local L, nargs, properties, ar, option, need_command, need_display, need_output,
          break_lists, R, ext_obj, prefix, suffix, e, RP, CAS, PID, stream,
          homalg_variable, l, eoc, enter, max;
    
    if IsBound( HOMALG_RINGS.HomalgSendBlockingInput ) then
        Add( HOMALG_RINGS.HomalgSendBlockingInput, arg );
    fi;
    
    Info( InfoRingsForHomalg, 10, "HomalgSendBlocking <-- ", arg );
    
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
        if not IsBound( option ) and IsString( ar ) and not ar in [ "", "break_lists" ] then ## the first occurrence of an option decides
            if PositionSublist( LowercaseString( ar ), "command" ) <> fail then
                need_command := true;
                need_display := false;
                need_output := false;
            elif PositionSublist( LowercaseString( ar ), "display" ) <> fail then
                need_display := true;
                need_command := false;
                need_output := false;
            elif PositionSublist( LowercaseString( ar ), "output" ) <> fail then
                need_output := true;
                need_command := false;
                need_display := false;
            else
                Error( "option must be one of {\"need_command\", \"need_display\", \"need_output\" }, but received: ", ar, "\n" );
            fi;
            option := ar;
        elif not IsBound( break_lists ) and IsString( ar ) and ar = "break_lists" then
            break_lists := ar;
        elif not IsBound( R ) and IsHomalgExternalRingRep( ar ) then
            R := ar;
            ext_obj := R;
            stream := HomalgStream( ext_obj );
        elif not IsBound( R ) and IsHomalgExternalMatrixRep( ar ) then
            R := HomalgRing( ar );
            ext_obj := R;
            stream := HomalgStream( ext_obj );
        elif not IsBound( ext_obj ) and IsHomalgExternalObject( ar )
          and HasIsHomalgExternalObjectWithIOStream( ar ) and IsHomalgExternalObjectWithIOStream( ar ) then
            ext_obj := ar;
            stream := HomalgStream( ext_obj );
        elif not IsBound( stream ) and IsRecord( ar ) and IsBound( ar.lines ) and IsBound( ar.pid ) then
            stream := ar;
            if IsBound( stream.name ) then
                ext_obj := HomalgExternalObject( "", stream.name, stream );
            fi;
        elif IsFilter( ar ) then
            Add( properties, ar );
        elif IsList( ar ) and ar <> [ ] and ForAll( ar, IsFilter ) then
            Append( properties, ar );
        elif not IsBound( prefix ) and ( ( IsList( ar ) and not IsString( ar ) ) or ar = [ ] ) then
            prefix := ar;
        elif not IsBound( suffix ) and IsList( ar ) and not IsString( ar ) then
            suffix := ar;
        else
            Error( "this argument should be in { IsList, IsString, IsFilter, IsRecord, IsHomalgExternalObjectWithIOStream, IsHomalgExternalRingRep, IsHomalgExternalMatrixRep } but recieved: ", ar,"\n" );
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
                    break;
                elif IsHomalgExternalRingRep( ar ) then
                    R := ar;
                    break;
                fi;
            od;
        else
            Error( "either the list provided by the first argument must contain at least one external matrix or an external ring or one of the remaining arguments must be an external ring or an external object with IO stream\n" );
        fi;
        
        stream := HomalgStream( ext_obj );
        
    fi;
    
    if IsBound( R ) then
        RP := HomalgTable( R );
        
        if IsBound(RP!.HomalgSendBlocking) then
            return RP!.HomalgSendBlocking( arg );
        fi;
    fi;
    
    CAS := HomalgExternalCASystem( ext_obj );
    PID := HomalgExternalCASystemPID( ext_obj );
    
    if not IsBound( stream.HomalgExternalVariableCounter ) then
        
        stream.HomalgExternalVariableCounter := 0;
        stream.HomalgExternalCommandCounter := 0;
        stream.HomalgExternalOutputCounter := 0;
        stream.HomalgExternalCallCounter := 0;
        stream.HomalgBackStreamMaximumLength := 0;
        stream.HomalgExternalWarningsCounter := 0;
        
    fi;
    
    if not IsBound( option ) then
        stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;
        homalg_variable := Concatenation( "homalg_variable_", String( stream.HomalgExternalVariableCounter ) );
        MakeImmutable( homalg_variable );
    fi;
    
    if not IsBound( break_lists ) then
        break_lists := "do_not_break_lists";
    fi;
    
    if IsBound( prefix ) and prefix <> [ ] then
        prefix := Concatenation( HomalgCreateStringForExternalCASystem( prefix, stream, break_lists ), " " );
    fi;
    
    if IsBound( suffix ) then
        suffix := HomalgCreateStringForExternalCASystem( suffix, stream, break_lists );
    fi;
    
    L := HomalgCreateStringForExternalCASystem( L, stream, break_lists );
    
    l := Length( L );
    
    if l > 0 and L{[l..l]} = "\n" then
        enter := "";
        eoc := "";
    else
        enter := "\n";
        if l > 0 and
           ( ( Length( stream.eoc_verbose ) > 0
               and l-Length( stream.eoc_verbose )+1 > 0
               and L{[l-Length( stream.eoc_verbose )+1..l]} = stream.eoc_verbose )
             or
             ( l-Length( stream.eoc_quiet )+1 > 0
               and L{[l-Length( stream.eoc_quiet )+1..l]} = stream.eoc_quiet ) ) then
            eoc := "";
        elif not IsBound( option ) then
            eoc := stream.eoc_quiet; ## as little back-traffic over the stream as possible
        else
            if need_command then
                eoc := stream.eoc_quiet; ## as little back-traffic over the stream as possible
            else
                eoc := stream.eoc_verbose;
            fi;
        fi;
    fi;
    
    if not IsBound( option ) then
        
        if IsBound( prefix ) then
            if IsBound( suffix ) then
                L := Concatenation( prefix, homalg_variable, suffix, " ", stream.define, " ", L, eoc, enter );
            else
                L := Concatenation( prefix, homalg_variable, " ", stream.define, " ", L, eoc, enter );
            fi;
        else
            L := Concatenation( homalg_variable, " ", stream.define, " ", L, eoc, enter );
        fi;
        
    else
        
        if IsBound( prefix ) then
            L := Concatenation( prefix, " ", L, eoc, enter );
        else
            L := Concatenation( L, eoc, enter );
        fi;
        
        if need_command then
            stream.HomalgExternalCommandCounter := stream.HomalgExternalCommandCounter + 1;
        else
            stream.HomalgExternalOutputCounter := stream.HomalgExternalOutputCounter + 1;
        fi;
    fi;
    
    if IsBound( HOMALG_RINGS.HomalgSendBlocking ) then
        Add( HOMALG_RINGS.HomalgSendBlocking, L );
    fi;
    
    Info( InfoRingsForHomalg, 7, stream.prompt, L{[ 1 .. Length( L ) -1 ]} );
    
    stream.HomalgExternalCallCounter := stream.HomalgExternalCallCounter + 1;
    
    SendBlockingToCAS( stream, L );
    
    if stream.errors <> "" then
        if IsBound( stream.only_warning ) and PositionSublist( stream.errors, stream.only_warning ) <> fail then
            stream.warnings := stream.errors;
            stream.HomalgExternalWarningsCounter := stream.HomalgExternalWarningsCounter + 1;
        else
            Error( "\033[1m", "the external CAS ", CAS, " (running with PID ", PID, ") returned the following error:\n", stream.errors ,"\033[0m\n" );
        fi;
    fi;
    
    max := Maximum( stream.HomalgBackStreamMaximumLength, Length( stream.lines ) );
    
    if max > stream.HomalgBackStreamMaximumLength then
        stream.HomalgBackStreamMaximumLength := max;
        if HOMALG_RINGS.SaveHomalgMaximumBackStream = true then
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
    elif need_display then
        if stream.cas = "maple" then
            return Concatenation( stream.lines{ [ 1 .. Length( stream.lines ) - 36 ] }, "\033[0m" );
        else
            return Concatenation( stream.lines, "\033[0m\n" );
        fi;
    elif stream.cas = "maple" then
        ## unless meant for display, normalize the white spaces caused by Maple
        L := NormalizedWhitespace( stream.lines );
    else
        L := stream.lines;
    fi;
    
    if need_output then
        Info( InfoRingsForHomalg, 5, stream.output_prompt, "\"", L, "\"" );
        if IsBound( stream.check_output ) and stream.check_output = true
           and '\n' in L and not ',' in L then
            Error( "\033[1m", "the output received from the external CAS ", CAS, " (running with PID ", PID, ") contains an ENTER = '\\n' but no COMMA = ',' ... this is most probably a mistakte!!!", "\033[0m\n" );
        fi;
    fi;
    
    return L;
    
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

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg external objects with an IO stream",
        [ IsHomalgExternalObjectRep and IsHomalgExternalObjectWithIOStream ],
        
  function( o )
    
    Print( "<A homalg external object residing in the CAS " );
    Print( HomalgExternalCASystem( o ), " running with pid ", HomalgExternalCASystemPID( o ), ">" ); 
    
end );

InstallMethod( ViewObj,
        "for homalg external objects with an IO stream",
        [ IsHomalgExternalRingRep and IsHomalgExternalObjectWithIOStream ],
        
  function( o )
    
    Print( "<A homalg external ring residing in the CAS " );
    Print( HomalgExternalCASystem( o ), " running with pid ", HomalgExternalCASystemPID( o ), ">" ); 
    
end );


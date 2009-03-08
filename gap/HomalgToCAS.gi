#############################################################################
##
##  HomalgToCAS.gi            IO_ForHomalg package           Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff to use the fantastic GAP4 I/O package of Max.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( homalgFlush,
  function( arg )
    local nargs, verbose, stream, container, weak_pointers, l, pids, R, p, i,
          var, active_ring_creation_number, ring_creation_numbers, deleted,
          streams;
    
    ## the internal garbage collector:
    GASMAN( "collect" );
    
    nargs := Length( arg );
    
    verbose := true;
    
    if nargs > 0 and IsStringRep( arg[nargs] ) then
        nargs := nargs - 1;
        verbose := false;
    fi;
    
    if nargs = 0 and IsBound( HOMALG.ContainerForWeakPointersOnHomalgExternalRings ) then
        
        container := HOMALG.ContainerForWeakPointersOnHomalgExternalRings;
        
        weak_pointers := container!.weak_pointers;
        
        l := container!.counter;
        
        pids := [ ];
        
        for i in [ 1 .. l ] do
            R := ElmWPObj( weak_pointers, i );
            if R <> fail then
                p := homalgExternalCASystemPID( R );
                if not p in pids or IsBound( homalgStream( R )!.active_ring ) then
                    Add( pids, p );
                    if verbose then
                        homalgFlush( R );
                    else
                        homalgFlush( R, "quiet" );
                    fi;
                fi;
            fi;
        od;
        
        deleted := Filtered( [ 1 .. l ], i -> not IsBoundElmWPObj( weak_pointers, i ) );
        
        container!.deleted := deleted;
        
        if IsBound( HOMALG_IO.InformAboutCASystemsWithoutActiveRings )
           and HOMALG_IO.InformAboutCASystemsWithoutActiveRings = true then
            
            pids := [ ];
            
            for i in [ 1 .. l ] do
                R := ElmWPObj( weak_pointers, i );
                if R <> fail then
                    Add( pids, homalgExternalCASystemPID( R ) );
                fi;
            od;
            
            pids := DuplicateFreeList( pids );
            
            streams := container!.streams;
            
            l := Length( streams );
            
            deleted := [ ];
            
            for i in [ 1 .. l ] do
                if not streams[i].pid in pids then
                    Add( deleted, streams[i].pid );
                fi;
            od;
            
            if deleted <> [ ] and verbose then
                Print( "the external CASs with pids ", deleted, " have no active rings: they can be terminated by launching TerminateCAS()\n" );
            fi;
            
        fi;
        
    elif nargs > 0 then
        
        if IsRecord( arg[1] ) then
            stream := arg[1];
            R := stream;
        else
            R := arg[1];
            stream := homalgStream( R );
        fi;
        
        container := stream.homalgExternalObjectsPointingToVariables;
        
        weak_pointers := container!.weak_pointers;
        
        l := container!.counter;
        
        ## exclude already deleted external objects:
        var := Difference( [ 1 .. l ], container!.deleted );
        
        if IsBound( stream.active_ring ) then
            
            ## set the argument to be the active ring
            if IsHomalgExternalRingRep( R ) and
               not IsIdenticalObj( R, stream.active_ring ) then
                homalgSendBlocking( "\"we've just reset the ring for garbage collection\"", "need_command", R, HOMALG_IO.Pictograms.initialize );
            fi;
            
            active_ring_creation_number := stream.active_ring!.creation_number;
            
            ring_creation_numbers := container!.ring_creation_numbers;
            
            ## this is important for computer algebra systems like Singular,
            ## which have the "feature" that a variable is stored in the ring which was active
            ## when the variable was assigned...
            ## one can often map all existing variables to the active ring,
            ## but this results in various disasters:
            ## non-zero entries of a matrix over a ring S (e.g. polynomial ring)
            ## often become zero when the matrix is mapped to another ring (e.g. exterior ring),
            ## and of course remain zero when the matrix is mapped back to the original ring.
            
            var := Filtered( var, i -> not IsBoundElmWPObj( weak_pointers, i ) and IsBound( ring_creation_numbers[i] ) and ring_creation_numbers[i] = active_ring_creation_number );
            
            ## free the entries corresponding to external objects about to be deleted
            Perform( var, function( i ) Unbind( ring_creation_numbers[i] ); end );
            
        else
            
            var := Filtered( var, i -> not IsBoundElmWPObj( weak_pointers, i ) );
            
        fi;
        
        deleted := Union2( container!.deleted, var );
        
        l := Length( var );
        
        if IsBound( stream.multiple_delete ) and ( l > 1 or ( not IsBound( stream.delete ) and l > 0 ) ) then
            
            stream.multiple_delete( List( var, v -> Concatenation( stream.variable_name, String( v ) ) ), R );
            
            container!.deleted := deleted;
            
        elif IsBound( stream.delete ) and l > 0 then
            
            for p in var do
                stream.delete( Concatenation( stream.variable_name, String( p ) ), R );
            od;
            
            container!.deleted := deleted;
            
        fi;
        
        if IsBound( stream.garbage_collector ) then
            
            ## the external garbage collector:
            stream.garbage_collector( stream );
            
            if verbose then
                Print( "completed garbage collection in the external CAS ", stream.name, " with pid ", stream.pid, "\n" );
            fi;
            
        fi;
        
    fi;
    
end );

##
InstallGlobalFunction( _SetElmWPObj_ForHomalg,	## is not based on homalgFlush for performance reasons
  function( stream, ext_obj )
    local container, weak_pointers, l, DeletePeriod, var,
          active_ring_creation_number, ring_creation_numbers, deleted;
    
    container := stream.homalgExternalObjectsPointingToVariables;
    
    weak_pointers := container!.weak_pointers;
    
    l := container!.counter;
    
    if IsBound( stream.DeletePeriod ) then
        if IsBool( stream.DeletePeriod ) then
            DeletePeriod := stream.DeletePeriod;
        else
            DeletePeriod := l mod stream.DeletePeriod = 0;
        fi;
    else
        DeletePeriod := true;
    fi;
    
    ## exclude already deleted external objects:
    var := Difference( [ 1 .. l ], container!.deleted );
    
    if IsBound( stream.active_ring ) then
        
        active_ring_creation_number := stream.active_ring!.creation_number;
        
        ring_creation_numbers := container!.ring_creation_numbers;
        
        ## set the active ring for the new external object
        ring_creation_numbers[l + 1] := active_ring_creation_number;
        
        if DeletePeriod then
            
            ## this is important for computer algebra systems like Singular,
            ## which have the "feature" that a variable is stored in the ring which was active
            ## when the variable was assigned...
            ## one can often map all existing variables to the active ring,
            ## but this results in various disasters:
            ## non-zero entries of a matrix over a ring S (e.g. polynomial ring)
            ## often become zero when the matrix is mapped to another ring (e.g. exterior ring),
            ## and of course remain zero when the matrix is mapped back to the original ring S.
            
            var := Filtered( var, i -> not IsBoundElmWPObj( weak_pointers, i ) and IsBound( ring_creation_numbers[i] ) and ring_creation_numbers[i] = active_ring_creation_number );
            
            ## free the entries corresponding to external objects about to be deleted
            Perform( var, function( i ) Unbind( ring_creation_numbers[i] ); end );
            
        fi;
        
    else
        
        if DeletePeriod then
            
            var := Filtered( var, i -> not IsBoundElmWPObj( weak_pointers, i ) );
            
        fi;
        
    fi;
    
    l := l + 1;
    
    container!.counter := l;
    
    if not Concatenation( stream.variable_name, String( l ) ) = homalgPointer( ext_obj ) then
        Error( "\033[01m\033[5;31;47mexpecting an external object with pointer = ", Concatenation( stream.variable_name, String( l ) ), " but recieved one with pointer = ", homalgPointer( ext_obj ), "\033[0m" );
    fi;
    
    SetElmWPObj( weak_pointers, l, ext_obj );
    
    if DeletePeriod then
        
        l := Length( var );
        
        deleted := Union2( container!.deleted, var );
        
        if IsBound( stream.multiple_delete ) and ( l > 1 or ( not IsBound( stream.delete ) and l > 0 ) ) then
            
            stream.multiple_delete( List( var, v -> Concatenation( stream.variable_name, String( v ) ) ), stream );
            
            container!.deleted := deleted;
            
        elif IsBound( stream.delete ) and l > 0 then
            
            Perform( var, function( p ) stream.delete( Concatenation( stream.variable_name, String( p ) ), stream ); end );
            
            container!.deleted := deleted;
            
        fi;
        
        ## never ever call the internal or the external garbage collector in this procedure
        
    fi;
    
end );

##
InstallGlobalFunction( homalgCreateStringForExternalCASystem,
  function( arg )
    local nargs, L, l, stream, break_lists, s;
    
    nargs := Length( arg );
    
    if nargs = 0 or not IsList( arg[1] ) then
        Error( "the first argument must be a list\n" );
    fi;
    
    L := arg[1];
    
    l := Length( L );
    
    break_lists := false;
    
    if nargs > 1 and IsRecord( arg[2] ) then
        stream := arg[2];
        if IsBound( stream.break_lists ) and stream.break_lists = true then
            break_lists := true;
        fi;
    fi;
    
    if nargs > 2 and arg[3] = "break_lists" then
        break_lists := true;
    fi;
    
    s := List( [ 1 .. l ], function( a )
                             local CAS, stream, t;
                             if IsStringRep( L[a] ) then
                                 return L[a];
                             else
                                 if IshomalgExternalObjectRep( L[a] )
                                    or IsHomalgExternalRingRep( L[a] ) then
                                     t := homalgPointer( L[a] );
                                 elif IsHomalgExternalMatrixRep( L[a] ) then
                                     if not ( HasIsVoidMatrix( L[a] ) and IsVoidMatrix( L[a] ) )
                                        or HasEval( L[a] ) then
                                         t := homalgPointer( L[a] ); ## now we enforce evaluation!!!
                                     else
                                         CAS := homalgExternalCASystem( L[a] );
                                         stream := homalgStream( L[a] );
                                         stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;	## never interchange this line with the next one
                                         t := Concatenation( stream.variable_name, String( stream.HomalgExternalVariableCounter ) );
                                         MakeImmutable( t );
                                         SetEval( L[a], homalgExternalObject( t, CAS, stream ) ); ## CAUTION: homalgPointer( L[a] ) now exists but still points to nothing!!!
                                         _SetElmWPObj_ForHomalg( stream, Eval( L[a] ) );
                                         ResetFilterObj( L[a], IsVoidMatrix );
                                     fi;
                                 elif break_lists and IsList( L[a] ) and not IsStringRep( L[a] ) then
                                     if ForAll( L[a], IsStringRep ) then
                                         t := JoinStringsWithSeparator( L[a] );
                                     elif ForAll( L[a], e -> IsHomalgExternalMatrixRep( e ) or IsHomalgExternalRingElementRep( e ) ) then
                                         t := JoinStringsWithSeparator( List( L[a], homalgPointer ) );
                                     else
                                         t := String( List( L[a], i -> i ) ); ## get rid of the range representation of lists
                                         t := t{ [ 2 .. Length( t ) - 1 ] };
                                     fi;
                                 else
                                     t := String( L[a] );
                                 fi;
                                 if a < l and not IsStringRep( L[a+1] ) then
                                     t := Concatenation( t, "," );
                                 fi;
                                 return t;
                             fi;
                           end );
    
    return Flat( s );
                           
end );

##
InstallGlobalFunction( homalgSendBlocking,
  function( arg )
    local L, nargs, io_info_level, info_level, properties,
          need_command, need_display, need_output, ar, pictogram, ring_element,
          option, break_lists, R, ext_obj, stream, type, prefix, suffix, e,
          RP, CAS, PID, homalg_variable, l, eoc, enter, fs, max, display_color;
    
    if IsBound( HOMALG_IO.homalgSendBlockingInput ) then
        Add( HOMALG_IO.homalgSendBlockingInput, arg );
    fi;
    
    Info( InfoIO_ForHomalg, 10, "homalgSendBlocking <-- ", arg );
    
    if not IsList( arg[1] ) then
        Error( "the first argument must be a list\n" );
    elif IsStringRep( arg[1] ) then
        L := [ arg[1] ];
    else
        L := arg[1];
    fi;
    
    nargs := Length( arg );
    
    io_info_level := InfoLevel( InfoIO_ForHomalg );
    info_level := 7;
    
    properties := [];
    
    need_command := false;
    need_display := false;
    need_output := false;
    
    for ar in arg{[ 2 .. nargs ]} do ## the order of the following might be important for the performance!!!
        if IsList( ar ) and ar <> [ ] and ForAll( ar, IsFilter ) then	## this must come before prefix and suffix
            Append( properties, ar );
        elif not IsBound( prefix ) and IsList( ar ) and not IsStringRep( ar ) then
            prefix := ar;
        elif not IsBound( suffix ) and IsList( ar ) and not IsStringRep( ar ) then
            suffix := ar;
        elif not IsBound( R ) and IsHomalgExternalMatrixRep( ar ) then
            R := HomalgRing( ar );
            ext_obj := R;
            stream := homalgStream( ext_obj );
        elif not IsBound( R ) and IsHomalgExternalRingRep( ar ) then
            R := ar;
            ext_obj := R;
            stream := homalgStream( ext_obj );
        elif not IsBound( ext_obj ) and IshomalgExternalObject( ar )
          and IshomalgExternalObjectWithIOStreamRep( ar ) then
            ext_obj := ar;
            stream := homalgStream( ext_obj );
        elif IsRecord( ar ) and IsBound( ar.lines ) and IsBound( ar.pid ) then
            if not IsBound( stream ) or not IsBound( ext_obj ) then
                stream := ar;
                if IsBound( stream.name ) then
                    ext_obj := homalgExternalObject( "", stream.name, stream );
                fi;
            fi;
        elif not IsBound( pictogram ) and IsStringRep( ar ) and Length( ar ) <= 5 then
            pictogram := ar;
        elif not IsBound( ring_element ) and ar = "return_ring_element"  then
            ring_element := true;
        elif not IsBound( option ) and IsStringRep( ar ) and Length( ar ) > 5 and ar <> "break_lists" then ## the first occurrence of an option decides
            if PositionSublist( LowercaseString( ar ), "command" ) <> fail then
                need_command := true;
            elif PositionSublist( LowercaseString( ar ), "display" ) <> fail then
                need_display := true;
                info_level := 8;
            elif PositionSublist( LowercaseString( ar ), "output" ) <> fail then
                need_output := true;
            else
                Error( "option must be one of {\"need_command\", \"need_display\", \"need_output\" }, but received: ", ar, "\n" );
            fi;
            option := ar;
        elif not IsBound( type ) and IsType( ar ) then
            type := ar;
        elif IsFilter( ar ) then
            Add( properties, ar );
        elif not IsBound( break_lists ) and ar = "break_lists" then
            break_lists := ar;
        else
            Error( "this argument should be in { IsList, IsStringRep, IsFilter, IsRecord, IshomalgExternalObjectWithIOStreamRep, IsHomalgExternalRingRep, IsHomalgExternalMatrixRep } but recieved: ", ar,"\n" );
        fi;
    od;
    
    if not IsBound( ext_obj ) then ## R is also not yet defined
        
        e := Filtered( L, a -> IsHomalgExternalMatrixRep( a ) or IsHomalgExternalRingRep( a ) or IshomalgExternalObjectWithIOStreamRep( a ) );
        
        if e <> [ ] then
            ext_obj := e[1];
            for ar in e do
                if IsHomalgExternalMatrixRep( ar ) then
                    R := HomalgRing( ar );
                    break;
                elif IsHomalgExternalRingRep( ar ) then
                    R := ar;
                    break;
                elif IsHomalgExternalRingElementRep( ar ) then
                    R := HomalgRing( ar );
                    break;
                fi;
            od;
        else
            Error( "either the list provided by the first argument must contain at least one external matrix or an external ring or one of the remaining arguments must be an external ring or an external object with IO stream\n" );
        fi;
        
        stream := homalgStream( ext_obj );
        
    fi;
    
    if not IsBound( pictogram ) then
        pictogram := "   ";
    elif io_info_level >= 3 then
        if pictogram = HOMALG_IO.Pictograms.TriangularBasis and IsBound( HOMALG.color_BOT ) then
            pictogram := Concatenation( HOMALG.color_BOT, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.BasisOfModule and IsBound( HOMALG.color_BOB ) then
            pictogram := Concatenation( HOMALG.color_BOB, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.DecideZero and IsBound( HOMALG.color_BOD ) then
            pictogram := Concatenation( HOMALG.color_BOD, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.SyzygiesGenerators and IsBound( HOMALG.color_BOH ) then
            pictogram := Concatenation( HOMALG.color_BOH, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.TriangularBasisC and IsBound( HOMALG.color_BOW ) then
            pictogram := Concatenation( HOMALG.color_BOW, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.BasisCoeff and IsBound( HOMALG.color_BOC ) then
            pictogram := Concatenation( HOMALG.color_BOC, pictogram, "\033[0m" );
        elif pictogram = HOMALG_IO.Pictograms.DecideZeroEffectively and IsBound( HOMALG.color_BOP ) then
            pictogram := Concatenation( HOMALG.color_BOP, pictogram, "\033[0m" );
        elif need_output or need_display then
            pictogram := Concatenation( HOMALG_IO.Pictograms.color_need_output, pictogram, "\033[0m" );
        else
            pictogram := Concatenation( HOMALG_IO.Pictograms.color_need_command, pictogram, "\033[0m" );
        fi;
    fi;
    
    if IsBound( R ) then
        
        if IsBound( stream.active_ring )
           and not IsIdenticalObj( R, stream.active_ring )
           and IsBound( stream.setring )
           and IsFunction( stream.setring ) then
            stream.setring( R );
            if IsBound( stream.setinvol )
               and IsFunction( stream.setinvol ) then
                stream.setinvol( R );
            fi;
        fi;
        
        RP := homalgTable( R );
        
        if IsBound(RP!.homalgSendBlocking) then
            return RP!.homalgSendBlocking( arg );
        fi;
    fi;
    
    CAS := homalgExternalCASystem( ext_obj );
    PID := homalgExternalCASystemPID( ext_obj );
    
    if not IsBound( break_lists ) then
        break_lists := "do_not_break_lists";
    fi;
    
    if IsBound( prefix ) and prefix <> [ ] then
        prefix := Concatenation( homalgCreateStringForExternalCASystem( prefix, stream, break_lists ), " " );
    fi;
    
    if IsBound( suffix ) then
        suffix := homalgCreateStringForExternalCASystem( suffix, stream, break_lists );
    fi;
    
    L := homalgCreateStringForExternalCASystem( L, stream, break_lists );
    
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
        
        stream.HomalgExternalVariableCounter := stream.HomalgExternalVariableCounter + 1;	## never interchange this line with the next one
        homalg_variable := Concatenation( stream.variable_name, String( stream.HomalgExternalVariableCounter ) );
        MakeImmutable( homalg_variable );
        
        ## now that we have just increased the variable counter
        ## and created the new variable we need to
        ## immediately create the enveloping external object
        ## and insert it in the weak pointer list using _SetElmWPObj_ForHomalg,
        ## before we start executing commands in the external CAS,
        ## that might cause an error (this would then lead to an
        ## inconsistency in the weak pointer list of external objects)
        if IsBound( ring_element ) then
            if not IsBound( type ) then
                ext_obj := HomalgExternalRingElement( homalg_variable, R );
            else
                ext_obj := HomalgExternalRingElement( homalg_variable, R, type );
            fi;
        else
            if not IsBound( type ) then
                ext_obj := homalgExternalObject( homalg_variable, CAS, stream );
            else
                ext_obj := homalgExternalObject( homalg_variable, CAS, stream, type );
            fi;
        fi;
        
        if properties <> [ ] and IshomalgExternalObjectWithIOStreamRep( ext_obj ) then
            for ar in properties do
                Setter( ar )( ext_obj, true );
            od;
        fi;
        
        ## the following line relies on the feature, that homalgExternalObjects
        ## are now assigned homalg_variables strictly sequentially!!!
        _SetElmWPObj_ForHomalg( stream, ext_obj );
        
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
    
    ConvertToStringRep( L );
    
    if ( IsBound( HOMALG_IO.save_CAS_commands_to_file ) and HOMALG_IO.save_CAS_commands_to_file = true )
       or IsBound( stream.CAS_commands_file ) then
        if not IsBound( stream.CAS_commands_file ) then
            stream.CAS_commands_file := Concatenation( "commands_file_of_", CAS, "_with_PID_", String( PID ) );
            fs := IO_File( stream.CAS_commands_file, "w" );
            if fs = fail then
                Error( "unable to open the file ", stream.CAS_commands_file, " for writing\n" );
            fi;
            if IO_Close( fs ) = fail then
                Error( "unable to close the file ", stream.CAS_commands_file, "\n" );
            fi;
        fi;
        
        fs := IO_File( stream.CAS_commands_file, "a" );
        
        if IO_WriteFlush( fs, L ) = fail then
            Error( "unable to write in the file ", stream.CAS_commands_file, "\n" );
        fi;
        
        if IO_Close( fs ) = fail then
            Error( "unable to close the file ", stream.CAS_commands_file, "\n" );
        fi;
    fi;
    
    if io_info_level >= 7 then
        Info( InfoIO_ForHomalg, info_level, pictogram, " ", stream.prompt, L{[ 1 .. Length( L ) - 1 ]} );
    elif io_info_level >= 4 then
        Info( InfoIO_ForHomalg, 4, pictogram, " ", stream.prompt, "..." );
    elif io_info_level >= 3 then
        Info( InfoIO_ForHomalg, 3, pictogram );
    fi;
    
    stream.HomalgExternalCallCounter := stream.HomalgExternalCallCounter + 1;
    
    SendBlockingToCAS( stream, L );
    
    if stream.errors <> "" then
        if IsBound( stream.only_warning ) and PositionSublist( stream.errors, stream.only_warning ) <> fail then
            stream.warnings := stream.errors;
            stream.HomalgExternalWarningsCounter := stream.HomalgExternalWarningsCounter + 1;
        else
            Error( "the external CAS ", CAS, " (running with PID ", PID, ") returned the following error:\n", "\033[01m", stream.errors ,"\033[0m\n" );
        fi;
    elif IsBound( stream.error_stdout ) and PositionSublist( stream.lines, stream.error_stdout ) <> fail then
        Error( "the external CAS ", CAS, " (running with PID ", PID, ") returned the following error:\n", "\033[01m", stream.lines ,"\033[0m\n" );
    fi;
    
    max := Maximum( stream.HomalgBackStreamMaximumLength, Length( stream.lines ) );
    
    if max > stream.HomalgBackStreamMaximumLength then
        stream.HomalgBackStreamMaximumLength := max;
        if HOMALG_IO.SaveHomalgMaximumBackStream = true then
            stream.HomalgMaximumBackStream := stream.lines;
        fi;
    fi;
    
    if not IsBound( option ) then
        
        return ext_obj;
        
    elif need_display then
        if IsBound( stream.color_display ) then
            display_color := stream.color_display;
        else
            display_color := "";
        fi;
        if stream.cas = "maple" then
            L := stream.lines{ [ 1 .. Length( stream.lines ) - 36 ] };
        else
            L := stream.lines;
        fi;
        
        return Concatenation( display_color, L, "\033[0m\n" );
        
    elif stream.cas = "maple" then
        
        ## unless meant for display, normalize the white spaces caused by Maple
        L := NormalizedWhitespace( stream.lines );
        
    else
        
        L := stream.lines;
        
    fi;
    
    if need_output then
        if IsBound( stream.remove_enter ) and stream.remove_enter = true then
            RemoveCharacters( L, "\n" );
        fi;
        RemoveCharacters( L, "\\ " );
        Info( InfoIO_ForHomalg, 5, "/------------------" );
        Info( InfoIO_ForHomalg, 5, stream.output_prompt, "\"", L, "\"" );
        Info( InfoIO_ForHomalg, 5, "\\==================" );
        if IsBound( stream.check_output ) and stream.check_output = true
           and '\n' in L and not ',' in L then
            Error( "\033[01m", "the output received from the external CAS ", CAS, " (running with PID ", PID, ") contains an ENTER = '\\n' but no COMMA = ',' ... this is most probably a mistake!!!", "\033[0m\n" );
        fi;
    fi;
    
    if not need_command then
        return L;
    fi;
    
end );

##
InstallGlobalFunction( homalgDisplay,
  function( arg )
    local L, ar;
    
    if IsList( arg[1] ) then
        L := arg[1];
    else
        L := [ arg[1] ];
    fi;
    
    ar := Concatenation( [ L ], arg{[ 2 .. Length( arg ) ]}, [ "need_display" ] );
    
    Print( CallFuncList( homalgSendBlocking, ar ) );
    
end );

##
InstallGlobalFunction( StringToInt,
  function( s )
    
    if s = "" then
        Error( "received an empty string while expecting a string containing an integer\n" );
    else
        return Int( s );
    fi;
    
end );

##
InstallGlobalFunction( StringToIntList,
  function( arg )
    local l, lint;
    
    if arg[1] = "[]" then
        return [ ];
    fi;
    
    l := SplitString( arg[1], ",", "[ ]\n" );
    lint := List( l, Int );
    
    if fail in lint then
        Error( "the first argument is not a string containg a list of integers: ", arg[1], "\n");
    fi;
    
    return lint;
    
end );

##
InstallGlobalFunction( StringToDoubleIntList,
  function( s )
    local l, lint;
    
    if s = "[]" then
        return [ ];
    fi;
    
    l := SplitString( s, "", ",[ ]\n" );
    lint := List( l, Int );
    
    if fail in lint then
        Error( "the first argument is not a string containg a list of list of two integers: ", s, "\n");
    fi;
    
    l := Length( lint );
    
    if IsOddInt( l ) then
        Error( "expected an even number of integers: ", s, "\n");
    fi;
    
    return List( [ 1 .. l/2 ], a -> [ lint[2*a-1], lint[2*a] ] ) ;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg external objects with an IO stream",
        [ IshomalgExternalObjectWithIOStreamRep ],
        
  function( o )
    
    Print( "<A homalg external object residing in the CAS " );
    
    if IsBound( homalgStream( o ).color_display ) then
        Print( "\033[1m" );
    fi;
    
    Print( homalgExternalCASystem( o ), "\033[0m running with pid ", homalgExternalCASystemPID( o ), ">" );
    
end );


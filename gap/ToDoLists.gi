#############################################################################
##
##  ToDoLists.gi                                 ToolsForHomalg package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Sebastian Gutsche, RWTH-Aachen University
##                  Markus Lange-Hegermann, RWTH-Aachen University
##
##  Implementations for ToDo-Lists.
##
#############################################################################

DeclareRepresentation( "IsToDoListRep",
        IsToDoList and IsAttributeStoringRep,
        [ ] );

BindGlobal( "TheFamilyOfToDoLists",
        NewFamily( "TheFamilyOfToDoLists" ) );

BindGlobal( "TheTypeToDoList",
        NewType( TheFamilyOfToDoLists,
                IsToDoListRep ) );

################################
##
## Methods for ToDo-lists.
##
################################

##
InstallMethod( NewToDoList,
               "without arguments",
               [ ],
               
  function( )
    local todo_list;
    
    todo_list := ObjectifyWithAttributes( rec(), TheTypeToDoList );
    
    todo_list!.todos := [ ];
    
    todo_list!.already_done := [ ];
    
    todo_list!.garbage := [ ];
    
    todo_list!.from_others := [ ];
    
    return todo_list;
    
end );



################################
##
## Methods for all objects
##
################################

##
InstallMethod( ToDoList,
               "for an object",
               [ IsAttributeStoringRep ],
               
  function( object )
    
    return NewToDoList( );
    
end );

##
InstallMethod( AddToToDoList,
               "for a todo list entry",
               [ IsToDoListEntry ],
               
  function( entry )
    local result, source, todo_list;
    
    result := ProcessAToDoListEntry( entry );
    
    source := SourcePart( entry );
    
    if source = fail then
        
        return;
        
    fi;
    
    todo_list := ToDoList( source[ 1 ] );
    
    if result = true then
        
        Add( todo_list!.already_done, entry );
        
    elif result = false then
        
        Add( todo_list!.todos, entry );
        
        SetFilterObj( source[ 1 ], HasSomethingToDo );
        
    elif result = fail then
        
        Add( todo_list!.garbage, entry );
        
    fi;
    
end );

##
InstallImmediateMethod( ProcessToDoList,
                        IsObject and HasSomethingToDo,
                        0,
                        
  function( M )
    local todo_list, todos, i, result, remove_list;
    
    todo_list := ToDoList( M );
    
    todos := todo_list!.todos;
    
    remove_list := [ ];
    
    for i in Length( todos ) do
        
        result := ProcessAToDoListEntry( todos[ i ] );
        
        if result = true then
            
            Add( todo_list!.already_done, todos[ i ] );
            
            Add( remove_list, i );
            
        elif result = fail then
            
            Add( todo_list!.garbage, todos[ i ] );
            
            Add( remove_list, i );
            
        fi;
        
    od;
    
    for i in remove_list do
        
        ##This is sensitive
        Remove( todos, i );
        
    od;
    
    if Length( todos ) = 0 then
        
        ResetFilterObj( M, HasSomethingToDo );
        
    fi;
    
    TryNextMethod();
    
end );

##############################
##
## View & Display
##
##############################

##
InstallMethod( ViewObj,
               "for todo lists",
               [ IsToDoList ],
               
  function( list )
    
    Print( "<A ToDo-List currently containing " );
    
    Print( Length( list!.todos ) );
    
    Print( " aktive, " );
    
    Print( Length( list!.already_done ) );
    
    Print( " done, and " );
    
    Print( Length( list!.garbage ) );
    
    Print( " failed entries>" );
    
end );

##
InstallMethod( Display,
               "for todo lists",
               [ IsToDoList ],
               
  function( list )
    
    Print( "A ToDo-List currently containing " );
    
    Print( Length( list!.todos ) );
    
    Print( " aktive, " );
    
    Print( Length( list!.already_done ) );
    
    Print( " done, and " );
    
    Print( Length( list!.garbage ) );
    
    Print( " failed entries." );
    
end );
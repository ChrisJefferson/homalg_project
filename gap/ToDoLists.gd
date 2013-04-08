#############################################################################
##
##  ToDoLists.gd                                 ToolsForHomalg package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Sebastian Gutsche, RWTH-Aachen University
##                  Markus Lange-Hegermann, RWTH-Aachen University
##
##  Declarations for ToDo-Lists.
##
#############################################################################

DeclareCategoryWithDocumentation( "IsToDoList",
                                  IsObject,
                                  [ "This is the category of ToDo-lists.",
                                    "Every ToDo-list is an object of this category,",
                                    "which basically contains the ToDo-lists." ],
                                  [ "ToDo-list", "Category" ]
                                 );

DeclareFilter( "HasSomethingToDo", IsObject );


##########################################
##
##  Properties & Attributes
##
##########################################

DeclareOperationWithDocumentation( "NewToDoList",
                                   [ ],
                                   "Creates a new empty ToDo-list.",
                                   "nothing",
                                   [ "ToDo-list", "Constructor" ]
                                 );


DeclareGlobalFunctionWithDocumentation( "Process_A_ToDo_List_Entry",
                                        [ "Gets a ToDo-list entry, which is a pair of a list of strings and a weak pointer object,",
                                          "and processes it. If the action was done, it returns true, if not, it returns false, and it returns",
                                          "fail if the action is not possible anymore due to deleted objects." ],
                                        "a boolean",
                                        [ "ToDo-list", "This_is_the_magic" ]
                                      );



##########################################
##
## Methods for all objects
##
##########################################

DeclareAttributeWithDocumentation( "ToDoList",
                                   IsObject,
                                   "Returns the ToDo-list of an object, or creates a new one.",
                                   "A ToDo-list",
                                   [ "ToDo-list", "Methods_for_all_objects" ]
                                 );

DeclareAttributeWithDocumentation( "ProcessToDoList",
                                   IsObject,
                                   [ "This is the magic! This attribute is never set. Creating an ToDo-list entry installs",
                                     "an ImmediateMethod for this attribute for the specific category of the object to which",
                                     "ToDo-list is added, and the filter the entry contains.",
                                     "It is then triggert if the filters become applicable, so the ToDo-list is processed" ],
                                   "nothing",
                                   "A",
                                   [ "ToDo-list", "This_is_the_magic" ] );

DeclareOperation( "ProcessToDoList_Real",
                  [ IsObject ] );

DeclareOperationWithDocumentation( "TraceProof",
                                   [ IsObject, IsString, IsObject ],
                                   [ "If the object <A>obj</A> has the attribute <A>name</A>,",
                                     "and its value is <A>val</A>, and the knowledge has",
                                     "been obtained trough ToDoList-entries,",
                                     "this method traces the way the property was set,",
                                     "and returns a tree which describes the full way of how the attribute became known." ],
                                   "a tree",
                                   "obj,name,val",
                                   [ "ToDo-list", "Proof_tracking" ] 
                                 );

DeclareGlobalFunction( "ToolsForHomalg_ToDoList_TaceProof_RecursivePart" );
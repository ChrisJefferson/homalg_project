LoadPackage( "AutoDoc" );

CreateAutomaticDocumentation( "ToolsForHomalg", "gap/AutoDocEntries.g", "doc/", false, [ [ "ToDo-list", "Proof_tracking", [ "This is a way to trakc proofs from ToDoLists.",
                                                                                                                            "Not only for debugging, but also for knowing how things work together." ] ],
                                                                                        [ "Trees", [ "The trees are used in ToDoLists.",
                                                                                                     "They are a technical feature, and fairly general, so they also can be used somewhere elese" ] ] ]);

QUIT;

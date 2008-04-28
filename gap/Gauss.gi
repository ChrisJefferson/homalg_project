#############################################################################
##
##  Gauss.gi               Gauss package                      Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for Gauss.
##
#############################################################################

##
InstallMethod( EchelonMatTransformation,
        "generic method for matrices",
        [ IsMatrix ],
        function( mat )
    local copymat, v, vc, f;
    copymat := [];
    f := DefaultFieldOfMatrix(mat);
    for v in mat do
        vc := ShallowCopy(v);
        ConvertToVectorRepNC(vc,f);
        Add(copymat, vc);
    od;
    return EchelonMatTransformationDestructive( copymat );
end);

##
InstallMethod( EchelonMatTransformationDestructive,
        "generic method for matrices",
        [ IsMatrix and IsMutable ],
        function( mat )
    local zero,      # zero of the field of <mat>
          nrows,     # number of rows in <mat>
          ncols,     # number of columns in <mat>
          vectors,   # list of basis vectors
          heads,     # list of pivot positions in 'vectors'
          i,         # loop over rows
          j,         # loop over columns
          T,         # transformation matrix
          coeffs,    # list of coefficient vectors for 'vectors'
          relations, # basis vectors of the null space of 'mat'
          row, head, x, row2, rank, list;
    
    nrows := Length( mat );
    ncols := Length( mat[1] );
    
    zero  := Zero( mat[1][1] );
    
    heads   := ListWithIdenticalEntries( ncols, 0 );
    vectors := [];
    
    T         := IdentityMat( nrows, zero );
    coeffs    := [];
    relations := [];
    
    for i in [ 1 .. nrows ] do
        
        row := mat[i];
        row2 := T[i];
        
        # Reduce the row with the known basis vectors.
        for j in [ 1 .. ncols ] do
            head := heads[j];
            if head <> 0 then
                x := - row[j];
                if x <> zero then
                    AddRowVector( row2, coeffs[ head ],  x );
                    AddRowVector( row,  vectors[ head ], x );
                fi;
            fi;
        od;
        
        
        j:= PositionNot( row, zero );
        if j <= ncols then
            
            # We found a new basis vector.
            x:= Inverse( row[j] );
            if x = fail then
                TryNextMethod();
            fi;
            Add( coeffs,  row2 * x );
            Add( vectors, row  * x );
            heads[j]:= Length( vectors );
            
            #else
            #    Add( relations, row2 );
        fi;
        
    od;
    
    # gauss upwards:
    
    list := Filtered( heads, x->x<>0 );
    rank := Length( list );
    
    for j in [ncols,ncols-1..1] do
        head := heads[j];
        if head <> 0 then
            for i in Filtered( [1..head-1], x -> not x in heads{[j+1..ncols]} ) do
                row := vectors[i];
                row2 := coeffs[i];
                x := - row[j];
                if x <> zero then
                    AddRowVector( row2, coeffs[head], x );
                    AddRowVector( row, vectors[head], x );
                fi;
            od;
        fi;
    od;
    
    #exchange rows:
    
    vectors := vectors{list};
    
    coeffs{[1..rank]} := coeffs{list};
    
    return [ vectors, coeffs ];
    
end );

##
InstallMethod( EchelonMat,
        "generic method for matrices",
        [ IsMatrix ],
        function( mat )
    local copymat, v, vc, f;
    copymat := [];
    f := DefaultFieldOfMatrix(mat);
    for v in mat do
        vc := ShallowCopy(v);
        ConvertToVectorRepNC(vc,f);
        Add(copymat, vc);
    od;
    return EchelonMatDestructive( copymat );
end);

##
InstallMethod( EchelonMatDestructive,
        "generic method for matrices",
        [ IsMatrix and IsMutable ],
        function( mat )
    local zero,      # zero of the field of <mat>
          nrows,     # number of rows in <mat>
          ncols,     # number of columns in <mat>
          vectors,   # list of basis vectors
          heads,     # list of pivot positions in 'vectors'
          i,         # loop over rows
          j,         # loop over columns
          row, head, x, row2, rank, list;
    
    nrows := Length( mat );
    ncols := Length( mat[1] );
    
    zero  := Zero( mat[1][1] );
    
    heads   := ListWithIdenticalEntries( ncols, 0 );
    vectors := [];
    
    for i in [ 1 .. nrows ] do
        
        row := mat[i];
        
        # Reduce the row with the known basis vectors.
        for j in [ 1 .. ncols ] do
            head := heads[j];
            if head <> 0 then
                x := - row[j];
                if x <> zero then
                    AddRowVector( row,  vectors[ head ], x );
                fi;
            fi;
        od;
        
        
        j:= PositionNot( row, zero );
        if j <= ncols then
            
            # We found a new basis vector.
            x:= Inverse( row[j] );
            if x = fail then
                TryNextMethod();
            fi;
            Add( vectors, row  * x );
            heads[j]:= Length( vectors );
            
        fi;
        
    od;
    
    # gauss upwards:
    
    list := Filtered( heads, x->x<>0 );
    rank := Length( list );
    
    for j in [ncols,ncols-1..1] do
        head := heads[j];
        if head <> 0 then
            for i in Filtered( [1..head-1], x -> not x in heads{[j+1..ncols]} ) do
                row := vectors[i];
                x := - row[j];
                if x <> zero then
                    AddRowVector( row, vectors[head], x );
                fi;
            od;
        fi;
    od;
    
    #exchange rows:
    
    list := Filtered( heads, x->x<>0 );
    
    vectors := vectors{list};
    
    return vectors;
    
end );

##
InstallMethod( ReduceMatWithEchelonMat,
        "for general matrices over a field, second argument must be in REF",
        [ IsMatrix, IsMatrix ],
  function( mat, N )
    local nrows1, ncols, nrows2, M, f, v, vc, zero, i, row2, j, k, row1, x;
    nrows1 := Length( mat );
    nrows2 := Length( N );
    if nrows1 = 0 or nrows2 = 0 then
        return mat;
    fi;
    ncols := Length( mat[1] );
    if ncols <> Length( N[1] ) then
        return fail;
    elif ncols = 0 then
        return mat;
    fi;
    
    M := [];
    f := DefaultFieldOfMatrix( mat );
    for v in mat do
        vc := ShallowCopy( v );
        ConvertToVectorRepNC( vc, f );
        Add( M, vc );
    od;
    
    zero := Zero( M[1][1] );
    
    for i in [1 .. nrows2] do
        row2 := N[i];
        j := PositionNot( row2, zero );
        if j <= ncols then
            for k in [1 .. nrows1] do
                row1 := M[k];
                x := - row1[j];
                if x <> zero then
                    AddRowVector( row1, row2, x );
                fi;
            od;
        fi;
    od;
    
    return M;
    
end );

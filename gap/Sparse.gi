#############################################################################
##
##  Sparse.gi                  Gauss package                  Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B f��r Mathematik, RWTH Aachen
##
##  Implementation stuff for performing algorithms on sparse matrices.
##
#############################################################################

##
InstallMethod( EchelonMat,
        "method for sparse matrices",
        [ IsSparseMatrix ],
  function( mat )
    if IsField( mat!.ring ) then
        return EchelonMatDestructive( CopyMat( mat ) );
    else
        return HermiteMatDestructive( CopyMat( mat ) );
    fi;
  end
);

##
InstallMethod( EchelonMatTransformation,
        "method for sparse matrices",
        [ IsSparseMatrix ],
  function( mat )
    if IsField( mat!.ring ) then
        return EchelonMatTransformationDestructive( CopyMat( mat ) );
    else
        return HermiteMatTransformationDestructive( CopyMat( mat ) );
    fi;
  end
);

##
InstallMethod( ReduceMat,
        "for sparse matrices over a ring, second argument must be in REF",
        [ IsSparseMatrix, IsSparseMatrix ],
  function( mat, N )
    if IsField( mat!.ring ) then
        return ReduceMatWithEchelonMat( mat, N );
    else
        return ReduceMatWithHermiteMat( mat, N );
    fi;
  end
);

##
InstallGlobalFunction( KernelMatSparse,
  function( arg )
    local M;
    
    M := CopyMat( arg[1] );
    
    if IsField( M!.ring ) and Length( arg ) = 1 then
        return KernelMatDestructive( M, [ 1 .. M!.nrows ] );
    elif IsField( M!.ring ) and Length( arg ) > 1 then
        return KernelMatDestructive( M, arg[2] );
    elif Length( arg ) = 1 then
        return KernelHermiteMatDestructive( M, [ 1 .. M!.nrows ] );
    elif Length( arg ) > 1 then
        return KernelHermiteMatDestructive( M, arg[2] );
    fi;
    
  end
);

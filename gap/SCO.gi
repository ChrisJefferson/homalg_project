#############################################################################
##
##  SCO.gi                   SCO package                      Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for SCO.
##
#############################################################################

##
DeclareRepresentation( "IsOrbifoldTriangulationRep",
        IsOrbifoldTriangulation, [ "vertices", "max_simplices", "isotropy", "mu" ] );

##
BindGlobal( "TheFamilyOfOrbifoldTriangulations",
        NewFamily( "TheFamilyOfOrbifoldTriangulations" ) );

##
BindGlobal( "TheTypeOrbifoldTriangulation",
        NewType( TheFamilyOfOrbifoldTriangulations, IsOrbifoldTriangulationRep ) );

##
DeclareRepresentation( "IsSimplicialSetRep",
        IsSimplicialSet, [ "simplicial_set" ] );

##
BindGlobal( "SimplicialSetFamily",
        NewFamily( "SimplicialSetFamily" ) );

##
BindGlobal( "SimplicialSetType",
        NewType( SimplicialSetFamily, IsSimplicialSetRep ) );

##
##
InstallMethod( OrbifoldTriangulation, "constructor",
        [ IsList, IsRecord, IsList ],
  function( s , i , m)
    local v, mm, ind, triangulation;
    v := Union( s );
    mm := function( x )
        for ind in m do
            if ind{[1..4]} = x then return ind[5]; fi;
        od;
        return x->x;
    end;
    triangulation := rec( vertices := v, max_simplices := s, isotropy := i, mu := mm );
    return Objectify( TheTypeOrbifoldTriangulation, triangulation );
end );

##
InstallMethod( SimplicialSet, "constructor",
        [ IsOrbifoldTriangulation, IsInt ],
  function( ot, n )
    local a, L, P, dim, x, y, g, S, u;
    L := [];
    P := [];
    for a in ot!.vertices do
        L[a] := Filtered( ot!.max_simplices, x->a in x );
        P[a] := [];
        P[a][1] := List( L[a], x->[x] );
        if not IsBound( ot!.isotropy.( a ) ) or Order( ot!.isotropy.( a ) ) = 1 then
            for dim in [2..n+1] do
                P[a][dim] := Concatenation( List( P[a][dim-1], x->List( Filtered( L[a], y->y>x[1] ), z->Concatenation( [ z, () ], x ) ) ) );
            od;
        else
            for dim in [2..n+1] do
                P[a][dim] := [];
                for x in P[a][dim-1] do
                    for g in Elements( ot!.isotropy.( a ) ) do
                        for y in L[a] do
                            if not ( x[1] = y and Order(g) = 1 ) then
                                Append( P[a][dim], [ Concatenation( [ y, g ], x ) ]);
                            fi;
                        od;
                    od;
                od;
            od;
        fi; 
    od;
    
    S := [];
    S[1] := Set( ot!.max_simplices, x->[x] );
    
    for dim in [2..n+1] do
        u := [];
        for a in ot!.vertices do
            u := Union( u, P[a][dim]);
        od;
        S[dim] := Set(u);
    od;
    
    return Objectify( SimplicialSetType, rec( simplicial_set := S ) );
    
end );

##
InstallMethod( Dimension, "for Simplicial Sets",
        [ IsSimplicialSetRep ],
  function( s )
    return Length( s!.simplicial_set );
end );

##
InstallMethod( BoundaryOperator, "calculate i-th boundary",
        [ IsInt, IsList, IsFunction ],
  function( i, L, mu)
    local n, tau, rho, j, rand;
    rand := ShallowCopy( L );
    n := ( Length( L ) - 1 ) / 2;
    tau := Intersection( Filtered( L, x->IsList( x ) ) );
    if i = 0 then
        rand := L{[3..Length( L )]};
        rho := Intersection( Filtered( rand, x->IsList( x ) ) );
    elif i = n then
        rand := L{[1..Length( L ) - 2]};
        rho := Intersection( Filtered( rand, x->IsList( x ) ) );
    fi;
    if i = 0 or i = n then
        for j in [2,4..Length( rand ) - 1] do
            rand[j] := mu( [ tau, rho, rand[j-1], rand[j+1] ] )( rand[j] );
        od;
        return rand;
    fi;
    rand := rand{Difference( [1..Length( rand )],[2*i+1,2*i+2] )};
    rho := Intersection( Filtered( rand, x->IsList( x ) ) );
    for j in [2,4..Length( rand ) - 1] do
        if j = 2*i then
            rand[j] := mu( [ tau, rho, L[j-1], L[j+1] ] )( L[j] ) * mu( [ tau, rho, L[j+1], L[j+3] ] )( L[j+2] );
        else
            rand[j] := mu( [ tau, rho, rand[j-1], rand[j+1] ] )( rand[j] );
        fi;
    od;
    return rand;
end );

##
##
InstallMethod( CreateCohomologyMatrix, "for an internal ring",
        [ IsOrbifoldTriangulation, IsSimplicialSet, IsHomalgInternalRingRep ],
  function( ot, s, R )
    local d, S, matrices, RP, k, m, p, i, ind, pos, res;
    
    d := Dimension( s );
    S := s!.simplicial_set;
    matrices := [];
    RP := homalgTable( R );
    
    if HasIsFieldForHomalg( R ) and IsFieldForHomalg( R ) and IsBound( RP!.ZeroMatrix ) then #right now: always sparse!
        
        for k in [2..Dimension( s )] do
            if Length( S[k] ) = 0 then
                matrices[k-1] := RP!.ZeroMatrix( HomalgVoidMatrix( Length( S[k-1] ), 1, R ) ); #FIXME : ??
            else
                matrices[k-1] := RP!.ZeroMatrix( HomalgVoidMatrix( Length( S[k-1] ), Length( S[k] ), R ) );
                for p in [1..Length( S[k] )] do
                    for i in [0..k] do
                        ind := PositionSet( S[k-1], BoundaryOperator( i, S[k][p], ot!.mu ) );
                        if not ind = fail then
                            # matrices[k-1][ind][p] := matrices[k-1][ind][p] + MinusOne( R )^i;
                            pos := PositionSorted( matrices[k-1]!.indices[ind], p );
                            if IsBound( matrices[k-1]!.indices[ind][pos] ) and matrices[k-1]!.indices[ind][pos] = p then
                                res := matrices[k-1]!.entries[ind][pos] + MinusOne( R )^i;
                                if res = Zero( R ) then
                                    Remove( matrices[k-1]!.indices[ind], pos );
                                    Remove( matrices[k-1]!.entries[ind], pos );
                                else
                                    matrices[k-1]!.entries[ind][pos] := res;
                                fi;
                            else
                                Add( matrices[k-1]!.indices[ind], p, pos );
                                Add( matrices[k-1]!.entries[ind], MinusOne( R )^i, pos );
                            fi;
                        fi;
                    od;
                od;
            fi;
        od;
        
        return List( matrices, function( m ) local s; s := HomalgVoidMatrix( R ); SetEval( s, m ); ResetFilterObj( s, IsVoidMatrix); return s; end );
        
    else
        
        for k in [2..Dimension( s )] do
            if Length( S[k] ) = 0 then
                matrices[k-1] := NullMat( Length( S[k-1] ), 1 );
            else
                matrices[k-1] := NullMat( Length( S[k-1] ), Length( S[k] ) );
                for p in [1..Length( S[k] )] do
                    for i in [0..k] do
                        ind := PositionSet( S[k-1], BoundaryOperator( i, S[k][p], ot!.mu ) );
                        if not ind = fail then
                            matrices[k-1][ind][p] := matrices[k-1][ind][p] + MinusOne( R )^i;
                        fi;
                    od;
                od;
            fi;
        od;
        return List( matrices, m -> HomalgMatrix( m * One( R ), R ) );
        
    fi;
    
end );

##
InstallMethod( CreateHomologyMatrix, "for any ring",
        [ IsOrbifoldTriangulation, IsSimplicialSet, IsHomalgRing ],
  function( ot, s, R )
    return List( CreateCohomologyMatrix( ot, s, R ), Involution );    
end);

##
InstallMethod( CreateCohomologyMatrix, "for an external ring",
        [ IsOrbifoldTriangulation, IsSimplicialSet, IsHomalgExternalRingRep ],
  function( ot, s, R )
    local internal_ring;
    internal_ring := HomalgRingOfIntegers();    # FIXME ?
    return List( CreateCohomologyMatrix( ot, s, internal_ring ), function(m) SetExtractHomalgMatrixToFile( m, true ); return HomalgMatrix( m, R ); end );    
end );

##
InstallMethod( Homology,
        [ IsOrbifoldTriangulation, IsSimplicialSet, IsHomalgRing ],
  function( ot, s, R )
    local morphisms, C, m;
    morphisms := CreateHomologyMatrix( ot, s, R );
    C := HomalgComplex( HomalgMorphism( morphisms[1] ), 0 );
    for m in morphisms{[ 2 .. Length( morphisms ) ]} do
        Add( C, m );
    od;
    C!.SkipHighestDegreeHomology := true;
    C!.HomologyOnLessGenerators := true;
    C!.DisplayHomology := true;
    C!.StringBeforeDisplay := "----------------------------------------------->>>>  ";
    return Homology( C );
  end
);
  
##
InstallMethod( Cohomology,
        [ IsOrbifoldTriangulation, IsSimplicialSet, IsHomalgRing ],
  function( ot, s, R )
    local morphisms, C, m;
    morphisms := CreateCohomologyMatrix( ot, s, R );
    C := HomalgCocomplex( HomalgMorphism( morphisms[1] ), -1 );
    for m in morphisms{[ 2 .. Length( morphisms ) ]} do
        Add( C, m );
    od;
    C!.SkipHighestDegreeCohomology := true;
    C!.CohomologyOnLessGenerators := true;
    C!.DisplayCohomology := true;
    C!.StringBeforeDisplay := "----------------------------------------------->>>>  ";
    return Cohomology( C );
  end
);

##
InstallMethod( SCO_Examples, "",
        [ ],
  function( )
    local directory, separator;
    if IsBound( PackageInfo("SCO")[1] ) and IsBound( PackageInfo("SCO")[1].InstallationPath ) then
        directory := PackageInfo("SCO")[1].InstallationPath;
    else
        directory := "./";
    fi;
    if IsBound( GAPInfo.UserHome ) then
        separator := GAPInfo.UserHome{[1]};
    else
        separator := "/";
    fi;
    if Length( directory ) > 0 and directory{[Length( directory )]} <> separator then
        directory := Concatenation( directory, separator );
    fi;
    Read( Concatenation( directory, "examples", separator, "examples.g" ) );
end );

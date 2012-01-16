#ifndef POLYMAKEDATA
#define POLYMAKEDATA 1

#include <polymake/Main.h>
#include <polymake/Matrix.h>
#include <polymake/IncidenceMatrix.h>
#include <polymake/Rational.h>

#include <iostream>
#include <map>
#include <utility>

using std::cerr;
using std::endl;
using std::string;
using std::map;
using std::pair;

typedef pair<int, pm::perl::Object*> object_pair;
typedef pm::perl::Object perlobj;
typedef map<int, pm::perl::Object*>::iterator iterator;

struct Polymake_Data {
   polymake::Main *main_polymake_session;
   polymake::perl::Scope *main_polymake_scope;
   map<int, pm::perl::Object*> *polymake_objects;
   int new_polymake_object_number;
};

void POLYMAKE_FREE(void *data);
Obj POLYMAKE_TYPEFUNC_CONE(void *data);
Obj POLYMAKE_TYPEFUNC_FAN(void *data);
Obj POLYMAKE_TYPEFUNC_POLYTOPE(void *data);

#endif

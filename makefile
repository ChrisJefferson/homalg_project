SHELL=/bin/bash
# DIRS=$$(ls -d */)
DIRS=4ti2Interface Convex Gauss ExamplesForHomalg GaussForHomalg GradedModules HomalgToCAS GradedRingForHomalg IO_ForHomalg LocalizeRingForHomalg MatricesForHomalg PolymakeInterface RingsForHomalg SCO ToolsForHomalg ToricVarieties Modules homalg 
ECHO=echo
MAKE=make
POLYMAKE_CONFIG_PATH=$(shell command -v polymake-config)
SINGULAR_PATH=$(shell command -v Singular)
SAGE_PATH=$(shell command -v sage)
M2_PATH=$(shell command -v M2)
MAGMA_PATH=$(shell command -v magma)
MAPLE_PATH=$(shell command -v maple)

all: doc test

doc: 
	-for d in $(DIRS); do ( cd $$d; $(MAKE) doc; cd - ); done

doc: doc_Convex doc_Gauss doc_ExamplesForHomalg doc_GaussForHomalg doc_GradedModules doc_HomalgToCAS doc_GradedRingForHomalg doc_IO_ForHomalg doc_LocalizeRingForHomalg doc_MatricesForHomalg doc_RingsForHomalg doc_SCO doc_ToolsForHomalg doc_ToricVarieties doc_Modules doc_homalg 

docclean:
	-for d in $(DIRS); do ( cd $$d; $(MAKE) docclean; cd - ); done

# test: test_Modules test_Convex
#	-for d in $(DIRS); do ( cd $$d; $(MAKE) test; cd - ); done

test: test_Convex test_Gauss test_ExamplesForHomalg test_GaussForHomalg test_GradedModules test_HomalgToCAS test_GradedRingForHomalg test_IO_ForHomalg test_LocalizeRingForHomalg test_MatricesForHomalg test_RingsForHomalg test_SCO test_ToolsForHomalg test_ToricVarieties test_Modules test_homalg 

build:
ifndef GAP_HOME
	$(error environment variable GAP_HOME is not set)
endif
ifneq ($(POLYMAKE_CONFIG_PATH),)
	cd PolymakeInterface && ./configure $$GAP_HOME && $(MAKE)
endif
	cd Gauss && GAPPATH=$$GAP_HOME ./configure && $(MAKE)

ci-test: doc build
ifneq ($(POLYMAKE_CONFIG_PATH),)
	cd Convex && $(MAKE) ci-test
	cd ToricVarieties && $(MAKE) ci-test
endif
	cd Gauss && $(MAKE) ci-test
	cd ExamplesForHomalg && $(MAKE) ci-test
	cd GaussForHomalg && $(MAKE) ci-test
	cd GradedModules && $(MAKE) ci-test
	cd HomalgToCAS && $(MAKE) ci-test
	cd GradedRingForHomalg && $(MAKE) ci-test
	cd IO_ForHomalg && $(MAKE) ci-test
	cd LocalizeRingForHomalg && $(MAKE) ci-test
	cd MatricesForHomalg && $(MAKE) ci-test
ifneq ($(SINGULAR_PATH),)
ifneq ($(SAGE_PATH),)
ifneq ($(M2_PATH),)
ifneq ($(MAGMA_PATH),)
ifneq ($(MAPLE_PATH),)
	cd RingsForHomalg && $(MAKE) ci-test
endif
endif
endif
endif
endif
	cd SCO && $(MAKE) ci-test
	# no tests
	# cd ToolsForHomalg && $(MAKE) ci-test
	cd Modules && $(MAKE) ci-test
	cd homalg && $(MAKE) ci-test
	./gather_performance_data.py

############################################
doc_4ti2Interface:
	cd 4ti2Interface; $(MAKE) doc; cd -;

doc_Convex:
	cd Convex; $(MAKE) doc; cd -;

doc_Gauss:
	cd Gauss; $(MAKE) doc; cd -; 

doc_ExamplesForHomalg:
	cd ExamplesForHomalg; $(MAKE) doc; cd -; 

doc_GaussForHomalg:
	cd GaussForHomalg; $(MAKE) doc; cd -; 

doc_GradedModules:
	cd GradedModules; $(MAKE) doc; cd -; 

doc_HomalgToCAS:
	cd HomalgToCAS; $(MAKE) doc; cd -; 

doc_GradedRingForHomalg:
	cd GradedRingForHomalg; $(MAKE) doc; cd -; 

doc_IO_ForHomalg:
	cd IO_ForHomalg; $(MAKE) doc; cd -; 

doc_LocalizeRingForHomalg:
	cd LocalizeRingForHomalg; $(MAKE) doc; cd -; 

doc_MatricesForHomalg:
	cd MatricesForHomalg; $(MAKE) doc; cd -; 

doc_PolymakeInterface:
	cd PolymakeInterface; $(MAKE) doc; cd -; 

doc_RingsForHomalg:
	cd RingsForHomalg; $(MAKE) doc; cd -; 

doc_SCO:
	cd SCO; $(MAKE) doc; cd -; 

doc_ToolsForHomalg:
	cd ToolsForHomalg; $(MAKE) doc; cd -; 

doc_ToricVarieties:
	cd ToricVarieties; $(MAKE) doc; cd -; 

doc_Modules:
	cd Modules; $(MAKE) doc; cd -; 

doc_homalg:
	cd homalg; $(MAKE) doc; cd -; 

############################################
test_Convex:
	cd Convex; $(MAKE) test; cd -;

test_Gauss:
	cd Gauss; $(MAKE) test; cd -; 

test_ExamplesForHomalg:
	cd ExamplesForHomalg; $(MAKE) test; cd -; 

test_GaussForHomalg:
	cd GaussForHomalg; $(MAKE) test; cd -; 

test_GradedModules:
	cd GradedModules; $(MAKE) test; cd -; 

test_HomalgToCAS:
	cd HomalgToCAS; $(MAKE) test; cd -; 

test_GradedRingForHomalg:
	cd GradedRingForHomalg; $(MAKE) test; cd -; 

test_IO_ForHomalg:
	cd IO_ForHomalg; $(MAKE) test; cd -; 

test_LocalizeRingForHomalg:
	cd LocalizeRingForHomalg; $(MAKE) test; cd -; 

test_MatricesForHomalg:
	cd MatricesForHomalg; $(MAKE) test; cd -; 

test_RingsForHomalg:
	cd RingsForHomalg; $(MAKE) test; cd -; 

test_SCO:
	cd SCO; $(MAKE) test; cd -; 

test_ToolsForHomalg:
	cd ToolsForHomalg; $(MAKE) test; cd -; 

test_ToricVarieties:
	cd ToricVarieties; $(MAKE) test; cd -; 

test_Modules:
	cd Modules; $(MAKE) test; cd -; 

test_homalg:
	cd homalg; $(MAKE) test; cd -; 

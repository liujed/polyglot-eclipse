#
# Makefile to build the jltools source to source compiler
# includes a makefile in each package to handle building of respective 
# packages
#


# set up some reasonable defaults (for building in CUCS)
JC 			= javac
JAVA			= java
JAR			= jar

JAVADOC_MAIN		= com.sun.tools.javadoc.Main
JAVADOC_DOCLET		= -doclet iContract.doclet.Standard

CUP_RUNTIME		= /home/nks/lib
CLASSPATH		= $(SOURCE):/usr/local/jdk1.2.1/jre/lib/rt.jar:$(CUP_RUNTIME)
CLASSPATHFLAG		= -classpath $(CLASSPATH)
JC_FLAGS 		= $(CLASSPATHFLAG)

JAR_FILE		= jltools.jar
JAR_FLAGS		= cf 

JAVADOC_OUTPUT		= ./javadoc
JAVADOC_FLAGS		= -mx40m -ms40m -classpath /home/nks/lib/iDoclet.jar:/usr/local/jdk1.2.1/lib/tools.jar:$(CLASSPATH) 

SOURCE			= .
PERSONAL_MAKEFILE	= Makefile.personal

BIN 			= .
CC			= gcc

# allow users to overload the above by overriding the above settings.
-include $(PERSONAL_MAKEFILE)

# let the included makefiles know that we called them. otherwise, they'll try to 
# call here.
CALLED_FROM_PARENT 	= true

#implicit rule to build class files
%.class: %.java
	$(JC) $(JC_FLAGS) $<

#everything:
all: util lex parse types ast visit ext/op frontend ext/op/runtime main

#include all of our package makefiles. they give us what class files are in each.
include jltools/util/Makefile
include jltools/lex/Makefile
include jltools/parse/Makefile
include jltools/ast/Makefile 
include jltools/types/Makefile
include jltools/visit/Makefile
include jltools/ext/op/Makefile
include jltools/ext/op/runtime/Makefile
include jltools/frontend/Makefile
include jltools/main/Makefile

# JIF
include jltools/ext/jif/lex/Makefile
include jltools/ext/jif/parse/Makefile
include jltools/ext/jif/ast/Makefile
include jltools/ext/jif/types/Makefile
include jltools/ext/jif/visit/Makefile
include jltools/ext/jif/extension/Makefile

#generated files:
gen: $(PARSE_GEN) $(EXTOP_GEN) $(JIFPARSE_GEN)

#other targets:
util: gen $(UTIL_TARGET) 

types: util $(TYPES_TARGET)

lex: util types parse $(LEX_TARGET)

parse: $(PARSE_TARGET)

ast: util types $(AST_TARGET)

visit: util types ast $(VISIT_TARGET)

ext/op: util types ast ext/op/runtime $(EXTOP_TARGET)

ext/op/runtime: $(EXT_OP_RUNTIME_TARGET)

frontend: util types lex parse ast visit $(FRONTEND_TARGET)

#jif
jif: gen ext/jif/parse ext/jif/lex ext/jif/ast ext/jif/types ext/jif/extension ext/jif/visit

ext/jif/parse: util $(EXTJIFPARSE_TARGET)

ext/jif/lex: util ext/jif/parse ext/jif/types ext/jif/extension $(EXTJIFLEX_TARGET)

ext/jif/ast: util ext/jif/types  $(EXTJIFAST_TARGET)

ext/jif/types: util types $(JIFTYPES_TARGET)

ext/jif/visit: util visit $(JIFVISIT_TARGET)

ext/jif/extension: util ext/jif/ast/ $(JIFEXTN_TARGET)

main: $(BIN)/jlc $(BIN)/jlcd frontend jif ext/op ext/op/runtime $(MAIN_TARGET)

$(BIN)/jlc: jltools/main/jlc.c
	$(CC) -o $(BIN)/jlc jltools/main/jlc.c

$(BIN)/jlcd: jltools/main/jlc.c
	$(CC) -D DEBUG -o $(BIN)/jlcd jltools/main/jlc.c

#clean: (just delete the class files)
clean: 
	rm -f jltools/util/*.class
	rm -f jltools/lex/*.class
	rm -f jltools/parse/*.class
	rm -f jltools/ast/*.class
	rm -f jltools/types/*.class
	rm -f jltools/visit/*.class
	rm -f jltools/ext/op/*.class
	rm -f jltools/frontend/*.class
	rm -f jltools/main/*.class
	rm -f jltools/runtime/*.class
	rm -f jltools/ext/jif/parse/*.class
	rm -f jltools/ext/jif/ast/*.class
	rm -f jltools/ext/jif/lex/*.class
	rm -f jltools/ext/jif/types/*.class
	rm -f jltools/ext/jif/visit/*.class
	rm -f jltools/ext/jif/extension/*.class

# Delete class files as well as the grammar files, so that we can regenerate 
# them. Also delete the javadoc & jar file, if they exis, as well as the jlc and 
# jlcd executables.
clobber superclean: clean
	rm -f jltools/parse/Grm.java
	rm -f jltools/parse/sym.java
	rm -f jltools/ext/op/Grm.java
	rm -f jltools/ext/op/sym.java
	rm -f jltools/ext/jif/parse/Grm.java
	rm -f jltools/ext/jif/parse/sym.java
	rm -f $(JAR_FILE)
	rm -rf $(JAVADOC_OUTPUT)
	rm -f $(BIN)/jlc
	rm -f $(BIN)/jlcd
	rm -f $(BIN)/jlc.exe
	rm -f $(BIN)/jlcd.exe


# create a jar file
jar: all
	$(JAR) $(JAR_FLAGS) $(JAR_FILE) jltools/*/*.class

javadoc: FORCE
	-mkdir -p $(JAVADOC_OUTPUT)
	$(JAVADOC) $(JAVADOC_FLAGS) -d $(JAVADOC_OUTPUT) \
		-classpath $(CLASSPATH) $(JAVADOC_DOCLET) -package\
			jltools.ast      \
			jltools.lex      \
			jltools.frontend \
			jltools.parse    \
			jltools.types    \
			jltools.util     \
			jltools.visit    \
			jltools.main     \
			jltools.ext.op   \
			jltools.ext.op.runtime \
			jltools.ext.jif.ast \
			jltools.ext.jif.lex \
			jltools.ext.jif.parse \
			jltools.ext.jif.types \
			jltools.ext.jif.visit

FORCE:

classpath: # type "eval `make classpath`" to set classpath
	@echo setenv CLASSPATH "$(CLASSPATH)"

#!/bin/bash

python3.12 ./Tools/cases_generator/opcode_id_generator.py \
    -o ./Include/opcode_ids.h.new ./Python/bytecodes.c
python3.12 ./Tools/cases_generator/target_generator.py \
    -o ./Python/opcode_targets.h.new ./Python/bytecodes.c
python3.12 ./Tools/cases_generator/uop_id_generator.py \
    -o ./Include/internal/pycore_uop_ids.h.new ./Python/bytecodes.c
python3.12 ./Tools/cases_generator/py_metadata_generator.py \
    -o ./Lib/_opcode_metadata.py.new ./Python/bytecodes.c
python3.12 ./Tools/build/update_file.py ./Include/internal/pycore_uop_ids.h ./Include/internal/pycore_uop_ids.h.new
python3.12 ./Tools/build/update_file.py ./Python/opcode_targets.h ./Python/opcode_targets.h.new
python3.12 ./Tools/cases_generator/tier1_generator.py \
    -o ./Python/generated_cases.c.h.new ./Python/bytecodes.c
python3.12 ./Tools/cases_generator/tier2_generator.py \
    -o ./Python/executor_cases.c.h.new ./Python/bytecodes.c
python3.12 ./Tools/build/update_file.py ./Include/opcode_ids.h ./Include/opcode_ids.h.new
python3.12 ./Tools/build/update_file.py ./Lib/_opcode_metadata.py ./Lib/_opcode_metadata.py.new
python3.12 ./Tools/cases_generator/optimizer_generator.py \
    -o ./Python/optimizer_cases.c.h.new \
    ./Python/optimizer_bytecodes.c \
    ./Python/bytecodes.c
python3.12 ./Tools/cases_generator/opcode_metadata_generator.py \
    -o ./Include/internal/pycore_opcode_metadata.h.new ./Python/bytecodes.c
python3.12 ./Tools/build/update_file.py ./Include/internal/pycore_opcode_metadata.h ./Include/internal/pycore_opcode_metadata.h.new
python3.12 ./Tools/build/update_file.py ./Python/executor_cases.c.h ./Python/executor_cases.c.h.new
python3.12 ./Tools/build/update_file.py ./Python/generated_cases.c.h ./Python/generated_cases.c.h.new
python3.12 ./Tools/cases_generator/uop_metadata_generator.py -o \
    ./Include/internal/pycore_uop_metadata.h.new ./Python/bytecodes.c
# Regenerate Objects/typeslots.inc from Include/typeslotsh
# using Objects/typeslots.py
python3.12 ./Objects/typeslots.py \
	< ./Include/typeslots.h \
	./Objects/typeslots.inc.new
python3.12 ./Tools/build/update_file.py ./Python/optimizer_cases.c.h ./Python/optimizer_cases.c.h.new
# Regenerate Doc/library/token-list.inc from Grammar/Tokens
# using Tools/build/generate_token.py
python3.12 ./Tools/build/generate_token.py rst \
	./Grammar/Tokens \
	./Doc/library/token-list.inc
python3.12 ./Tools/build/update_file.py ./Objects/typeslots.inc ./Objects/typeslots.inc.new
# Regenerate Include/internal/pycore_token.h from Grammar/Tokens
# using Tools/build/generate_token.py
python3.12 ./Tools/build/generate_token.py h \
	./Grammar/Tokens \
	./Include/internal/pycore_token.h
# Regenerate 3 files using using Parser/asdl_c.py:
# - Include/internal/pycore_ast.h
# - Include/internal/pycore_ast_state.h
# - Python/Python-ast.c
/usr/bin/mkdir -p ./Include
/usr/bin/mkdir -p ./Python
python3.12 ./Parser/asdl_c.py \
	./Parser/Python.asdl \
	-H ./Include/internal/pycore_ast.h.new \
	-I ./Include/internal/pycore_ast_state.h.new \
	-C ./Python/Python-ast.c.new
# Regenerate Parser/token.c from Grammar/Tokens
# using Tools/build/generate_token.py
python3.12 ./Tools/build/generate_token.py c \
	./Grammar/Tokens \
	./Parser/token.c
# Regenerate Lib/keyword.py from Grammar/python.gram and Grammar/Tokens
# using Tools/peg_generator/pegen
PYTHONPATH=./Tools/peg_generator python3.12 -m pegen.keywordgen \
	./Grammar/python.gram \
	./Grammar/Tokens \
	./Lib/keyword.py.new
# Regenerate Lib/token.py from Grammar/Tokens
# using Tools/build/generate_token.py
python3.12 ./Tools/build/generate_token.py py \
	./Grammar/Tokens \
	./Lib/token.py
# Regenerate Modules/_sre/sre_constants.h and Modules/_sre/sre_targets.h
# from Lib/re/_constants.py using Tools/build/generate_sre_constants.py
python3.12 ./Tools/build/generate_sre_constants.py \
	./Lib/re/_constants.py \
	./Modules/_sre/sre_constants.h \
	./Modules/_sre/sre_targets.h
Python/Python-ast.c.new, Include/internal/pycore_ast.h.new, Include/internal/pycore_ast_state.h.new regenerated.
python3.12 ./Tools/build/update_file.py ./Include/internal/pycore_ast.h ./Include/internal/pycore_ast.h.new
python3.12 ./Tools/build/freeze_modules.py --frozen-modules
python3.12 ./Tools/build/update_file.py ./Include/internal/pycore_ast_state.h ./Include/internal/pycore_ast_state.h.new
# Updating Makefile.pre.in
# Updating PCbuild/_freeze_module.vcxproj
# Updating PCbuild/_freeze_module.vcxproj.filters
# Updating Python/frozen.c
The Makefile was updated, you may need to re-run make.
PYTHONPATH=./Tools/peg_generator python3.12 -m pegen -q python \
./Tools/peg_generator/pegen/metagrammar.gram \
-o ./Tools/peg_generator/pegen/grammar_parser.py.new
python3.12 ./Tools/build/update_file.py ./Python/Python-ast.c ./Python/Python-ast.c.new
PYTHONPATH=./Tools/peg_generator python3.12 -m pegen -q c \
	./Grammar/python.gram \
	./Grammar/Tokens \
	-o ./Parser/parser.c.new
python3.12 ./Tools/build/update_file.py ./Tools/peg_generator/pegen/grammar_parser.py \
./Tools/peg_generator/pegen/grammar_parser.py.new
# Regenerate Programs/test_frozenmain.h
# from Programs/test_frozenmain.py
# using Programs/freeze_test_frozenmain.py
LD_LIBRARY_PATH=/home/damien/cpython ./python ./Programs/freeze_test_frozenmain.py Programs/test_frozenmain.h
Programs/test_frozenmain.h written
# Regenerate Lib/test/levenshtein_examples.json
python3.12 ./Tools/build/generate_levenshtein_examples.py ./Lib/test/levenshtein_examples.json
/home/damien/cpython/Lib/test/levenshtein_examples.json already exists, skipping regeneration.
To force, add --overwrite to the invocation of this tool or delete the existing file.
python3.12 ./Tools/clinic/clinic.py --make --exclude Lib/test/clinic.test.c --srcdir .
python3.12 ./Tools/build/update_file.py ./Lib/keyword.py ./Lib/keyword.py.new
python3.12 ./Tools/build/update_file.py ./Include/internal/pycore_uop_metadata.h ./Include/internal/pycore_uop_metadata.h.new
python3.12 ./Tools/build/update_file.py ./Parser/parser.c ./Parser/parser.c.new
python3.12 ./Tools/build/generate_global_objects.py
# not changed: /home/damien/cpython/Include/internal/pycore_global_strings.h
# not changed: /home/damien/cpython/Include/internal/pycore_runtime_init_generated.h
# not changed: /home/damien/cpython/Include/internal/pycore_unicodeobject_generated.h
# not changed: /home/damien/cpython/Include/internal/pycore_global_objects_fini_generated.h

Note: make regen-stdlib-module-names, make regen-limited-abi, 
make regen-configure, make regen-sbom, and make regen-unicodedata should be run manually

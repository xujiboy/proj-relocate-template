
.PHONY: all my_example compile_linux clean_up
.EXPORT_ALL_VARIABLES:  # make all variables available for child processes

#################################################################################
# GLOBALS                                                                       #
#################################################################################

VENV_NAME ?= new_env
PYTHON_INTERPRETER = python3

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## compile and build the distribution tar ball
all: proj_to_distribute.tar.gz

## project run
my_example:
	$(PYTHON_INTERPRETER) bin/example_run.py --show_message --show_array

## build to-be-distributed project and clean up directory before tarring
build: compile_linux clean_up
	cp -rf requirement.txt bin makefile $@/
	mv $(VENV_NAME).tar.gz $@/

## compile for distribution for Linux
compile_linux: compile.py
	vagrant up --provision
	vagrant ssh -c "cd /vagrant; ./compile_linux.sh $(VENV_NAME)"
	vagrant suspend

clean_up:
	rm -rf lib/*.c
	rm -rf build/temp.*
	cd build && mv lib.linux* lib
	cd build/lib/ && \
	ls *.so | xargs -n 1 basename > oldname && \
	ls *.so | xargs -n 1 basename | cut -d'.' -f1,3 > newname && \
	cat oldname | paste -d' ' oldname newname | sed 's/^/mv /' | bash && \
	rm -r newname oldname

## tar and compress the compiled project
proj_to_distribute.tar.gz: build
	tar -czvf $@ $^
	echo "$@ is created."
		




#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
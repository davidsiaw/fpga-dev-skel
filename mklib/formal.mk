# rules for building formal verification

FORMAL_DOCKER_PREFIX=docker run --rm -v $$(pwd):/src --workdir /src
FORMAL_DOCKER_IMAGE=davidsiaw/yosys-docker
FORMAL_CMD_PREFIX=$(FORMAL_DOCKER_PREFIX) $(FORMAL_DOCKER_IMAGE)

FORMAL_YOSYS=$(APICULA_CMD_PREFIX) yosys
FORMAL_SBY=$(FORMAL_CMD_PREFIX) sby
FORMAL_READ_VERILOG_PARAMS:=-formal

obj/formal.sby: obj/args/topmodule $(VERILOG_FILES)
	mkdir -p obj
	rm -f $@
	echo "[tasks]" > $@
	# echo "cover" >> $@
	echo "bmc" >> $@
	# echo "prove" >> $@

	echo "[options]" >> $@
	#echo "cover: mode cover" >> $@
	echo "bmc: mode bmc" >> $@
	#echo "prove: mode prove" >> $@
	echo "depth 30" >> $@

	echo "[engines]" >> $@
	#echo "cover: smtbmc z3" >> $@
	echo "bmc: smtbmc" >> $@
	#echo "prove: abc pdr" >> $@

	echo "[script]" >> $@
	for filename in $(filter-out $<,$^) ; do \
	  echo "read $(FORMAL_READ_VERILOG_PARAMS) /src/$$filename" >> $@ ; \
	done
	echo "prep -top $(shell cat $<)" >> $@

formal.log: obj/formal.sby
	$(FORMAL_SBY) $< -f --prefix obj/sby | tee $@

formal: formal.log

.PHONY: formal
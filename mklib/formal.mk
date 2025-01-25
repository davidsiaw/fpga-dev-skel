# rules for building formal verification

FORMAL_DOCKER_PREFIX=docker run --rm -v $$(pwd):/src --workdir /src
FORMAL_DOCKER_IMAGE=davidsiaw/yosys-docker
FORMAL_CMD_PREFIX=$(FORMAL_DOCKER_PREFIX) $(FORMAL_DOCKER_IMAGE)

FORMAL_YOSYS=$(APICULA_CMD_PREFIX) yosys
FORMAL_SBY=$(FORMAL_CMD_PREFIX) sby
FORMAL_READ_VERILOG_PARAMS:=-formal

VCD_CMD=docker run --rm -v $$(pwd)/obj:/src/obj davidsiaw/vcd

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
	@$(FORMAL_SBY) $< -f --prefix obj/sby | tee $@
	@filenames=`find . -name "*.vcd"`; \
	if [ "$$filenames" == "" ]; then \
	  echo "No failing waveforms"; \
	else \
	  echo "***********************"; \
	  echo "Failing waveforms:"; \
	  for filename in $$filenames ; do \
	  	echo "from trace $$filename:"; \
	    $(VCD_CMD) $$filename; \
	  done; \
	fi

formal: formal.log

.PHONY: formal formal.log

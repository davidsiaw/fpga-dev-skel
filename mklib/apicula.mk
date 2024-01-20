# build gowin fs using yosys

APICULA_DOCKER_PREFIX=docker run --rm -v $(PWD):/src --workdir /src
APICULA_DOCKER_IMAGE=davidsiaw/ocs
APICULA_CMD_PREFIX=$(APICULA_DOCKER_PREFIX) $(APICULA_DOCKER_IMAGE)
APICULA_FREQ := 27

YOSYS=$(APICULA_CMD_PREFIX) yosys
NEXTPNR_GOWIN=$(APICULA_CMD_PREFIX) nextpnr-gowin
GOWIN_PACK=$(APICULA_CMD_PREFIX) gowin_pack
READ_VERILOG_PARAMS:=

obj/apicula_verilogfiles: $(VERILOG_FILES)
	mkdir -p obj
	rm -f $@
	for filename in $^ ; do \
	    echo "read_verilog $(READ_VERILOG_PARAMS) $$filename" >> $@ ; \
	done

obj/apicula_defines: obj/defines
	for filename in $(shell ls $<) ; do \
	    echo "verilog_defines -D$$filename=`cat $$filename`" >> $@; \
	done

obj/apicula_synth: obj/args/topmodule
	mkdir -p obj
	echo "synth_gowin -json obj/apicula.json -top $(shell cat obj/args/topmodule)" > $@

APICULA_YS_PARTIALS=obj/apicula_defines obj/apicula_verilogfiles obj/apicula_synth

obj/apicula.ys: $(APICULA_YS_PARTIALS)
	mkdir -p obj
	rm -f $@
	echo "# this file is generated by the makefile" > $@
	for filename in $^ ; do \
	    cat $$filename >> $@ ; \
	done

obj/apicula.json: obj/apicula.ys
	echo "# $< #"
	cat $< > obj/yosys.log
	echo "#################" >> obj/yosys.log
	$(YOSYS) $< | tee -a obj/yosys.log

obj/gowin_pnr_apicula.json: obj/apicula.json obj/args/device_name obj/args/freq_mhz obj/args/apicula_cst $(shell cat obj/args/apicula_cst)
	$(NEXTPNR_GOWIN) --json $< --write $@ --device $(shell cat obj/args/device_name) --freq $(shell cat obj/args/freq_mhz) --cst $(shell cat obj/args/apicula_cst) $(subst totee,nextpnr_apicula,$(TEE))

obj/apicula_pack.fs: obj/gowin_pnr_apicula.json obj/args/apicula_class
	$(GOWIN_PACK) -d $(shell cat obj/args/apicula_class) -o $@ $< | $(subst totee,gowin_pack,$(TEE))

upload_apicula: obj/apicula_pack.fs obj/args/name
	$(OPENFPGALOADER) -b $(shell cat obj/args/name) obj/apicula_pack.fs

apicula: obj/apicula_pack.fs

.INTERMEDIATE: $(APICULA_YS_PARTIALS) obj/apicula.ys

.PHONY: apicula upload_apicula

IVERILOG_CMD_BASE=docker run --rm -ti -v $(PWD):/src --workdir=/src davidsiaw/ocs
IVERILOG_CMD=$(IVERILOG_CMD_BASE) iverilog
VVP_CMD=$(IVERILOG_CMD_BASE) vvp

obj/test.out: src/test/test.v $(VERILOG_FILES)
	$(IVERILOG_CMD) -DTESTBENCH -o $@ $^

test: obj/test.out
	$(VVP_CMD) $<

# defaults you can change by going `make gowin TOP=mymodule`
TARGET:=tangnano9k
TOP:=top

VERILOG_FILES=$(shell find src -type f -name '*.sv')
TARGET_DIR=obj/args

$(TARGET_DIR)/%: targets/$(TARGET)
	mkdir -p $(TARGET_DIR)
	cat targets/$(TARGET) | while read line; \
	do \
	  IFS='=' read -ra toks <<< "$$line"; \
	  echo "$${toks[1]}" > "$(TARGET_DIR)/$${toks[0]}"; \
	done

all: apicula gowin

clean:
	rm -rf obj

.PHONY: clean all unpack_target

include mklib/*.mk

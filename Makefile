STOP_TIME := 100ns

SRC_DIR := ./src
TEST_DIR := ./test
WORK_DIR := ./work

LIB_NAME := tp_lib

SIM_FILE := $(WORK_DIR)/$(LIB_NAME).ghw

HDL_OPTS     := --workdir=$(WORK_DIR) --work=$(LIB_NAME) --ieee=synopsys 
HDL_SIM_OPTS := --wave=$(SIM_FILE) --stop-time=$(STOP_TIME)

HDL_COMPILER   := ghdl -a $(HDL_OPTS)
HDL_ELABORATOR := ghdl -e $(HDL_OPTS)
HDL_SIM        := ghdl -r $(HDL_OPTS)
HDL_VIEWER     := gtkwave

bold    := $(shell tput bold)
red     := $(shell tput setaf 1)
green   := $(shell tput setaf 2)
yellow  := $(shell tput setaf 3)
blue    := $(shell tput setaf 4)
magenta := $(shell tput setaf 5)
cyan    := $(shell tput setaf 6)
sgr0    := $(shell tput sgr0)

$(TEST_DIR)/comp_%: $(TEST_DIR)/%.vhd
	@echo "$(yellow)### Compiling testbench $^$(sgr0)"
	$(HDL_COMPILER) $^

$(SRC_DIR)/comp_%: $(SRC_DIR)/%.vhd
	@echo "$(red)### Compiling $^$(sgr0)"
	$(HDL_COMPILER) $^

$(LIB_NAME).%: $(SRC_DIR)/comp_% $(TEST_DIR)/comp_%_tb
	@echo "$(green)### Elaborating $(subst $(LIB_NAME).,,$@)_tb$(sgr0)"
	$(HDL_ELABORATOR) $(subst $(LIB_NAME).,, $@)_tb

sim_%: $(LIB_NAME).%
	@echo "$(blue)### Simulating $(subst $(LIB_NAME).,,$<)_tb$(sgr0)"
	$(HDL_SIM) $(subst $(LIB_NAME).,, $<)_tb $(HDL_SIM_OPTS)
	
	@echo "$(magenta)### Opening traces in viewer$(sgr0)"
	$(HDL_VIEWER) $(SIM_FILE) > /dev/null 2>&1

.PHONY: clean
clean:
	rm $(WORK_DIR)/*
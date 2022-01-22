SRC_DIR := ../SRC_xpe2i5a002

LIB_NAME := tp_lib

HDL_COMPILER   := ncvhdl -V93 -WORK tp_lib -MESSAGES -NOCOPYRIGHT -LINE
HDL_ELABORATOR := ncelab -access rw -messages
HDL_SIM        := ncsim -gui

bold    := $(shell tput bold)
red     := $(shell tput setaf 1)
green   := $(shell tput setaf 2)
yellow  := $(shell tput setaf 3)
blue    := $(shell tput setaf 4)
magenta := $(shell tput setaf 5)
cyan    := $(shell tput setaf 6)
sgr0    := $(shell tput sgr0)

$(SRC_DIR)/%: $(SRC_DIR)/%.vhd
	@echo "$(red)### Compiling $<$(sgr0)"
	$(HDL_COMPILER) $<

$(LIB_NAME).%: $(SRC_DIR)/% $(SRC_DIR)/%_tb
	@echo "$(green)### Elaborating $(subst $(LIB_NAME).,,$@)_tb$(sgr0)"
	$(HDL_ELABORATOR) $(subst $(LIB_NAME).,, $@)_tb

sim_%: $(LIB_NAME).%
	@echo "$(blue)### Simulating $(subst $(LIB_NAME).,,$<)_tb$(sgr0)"
	$(HDL_SIM) $(subst $(LIB_NAME).,, $<)_tb

.PHONY: clean
clean:
	rm -rf $(WORK_DIR)

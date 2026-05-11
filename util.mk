# util.mk - Miscellaneous utility functions for use in Makefiles

# Throws an error if the value of the variable named by $(1) is not in the list given by $(2)
define validate-option
  # value must be part of the list
  ifeq ($$(filter $($(1)),$(2)),)
    $$(error Value of $(1) must be one of the following: $(2))
  endif
  # value must be a single word (no whitespace)
  ifneq ($$(words $($(1))),1)
    $$(error Value of $(1) must be one of the following: $(2))
  endif
endef

# Returns the path to the command $(1) if exists. Otherwise returns an empty string.
find-command = $(shell which $(1) 2>/dev/null)

# Detect prefix for MIPS toolchain
find-mips-prefix = $(shell test -n "$(call find-command,$(1)-ld)" && test -n "$(call find-command,$(1)-gcc)" && echo $(1))

MIPS_PREFIX_CANDIDATES := mips64-elf mips-n64 mips64 mips-linux-gnu mips64-linux-gnu mips64-none-elf mips mips-suse-linux
define _find-mips-toolchain-internal
$(eval DETECTED_PREFIX :=)
$(eval _unused := $(foreach prefix,$(MIPS_PREFIX_CANDIDATES),\
  $(if $(DETECTED_PREFIX),,\
    $(if $(call find-mips-prefix,$(prefix)),\
      $(eval DETECTED_PREFIX := $(prefix)-)))))
$(if $(DETECTED_PREFIX),,$(error Unable to detect a suitable MIPS toolchain installed))
$(DETECTED_PREFIX)
endef

find-mips-toolchain = $(strip $(call _find-mips-toolchain-internal))

# Set printf commands
PRINT = printf

# Whether to colorize build messages
COLOR ?= 1

ifeq ($(COLOR),1)
NO_COL    := \033[0m
BLACK     := \033[0;30m
RED       := \033[0;31m
GREEN     := \033[0;32m
YELLOW    := \033[0;33m
BLUE      := \033[0;34m
MAGENTA   := \033[0;35m
CYAN      := \033[0;36m
WHITE     := \033[0;37m

# Bold/Bright Versions
B_RED     := \033[1;31m
B_GREEN   := \033[1;32m
B_YELLOW  := \033[1;33m
B_BLUE    := \033[1;34m
B_MAGENTA := \033[1;35m
B_CYAN    := \033[1;36m
B_WHITE   := \033[1;37m

BLINK := \033[33;5m
REVERSE := \033[7m
endif

# Common build print status function
define print
  @$(PRINT) "$(GREEN)$(1) $(YELLOW)$(2)$(GREEN) -> $(CYAN)$(3)$(NO_COL)\n"
endef

# For tools, run a shell command and error out if it fails
define run_tool
  DUMMY != $(1) >&2 || echo FAIL
  ifeq ($$(DUMMY),FAIL)
    $$(error $(2))
  endif
endef

# Check if a string is numeric, it removes all digits 0-9. If the result is empty, it's a number.
is_numeric = $(if $(subst 0,,$(subst 1,,$(subst 2,,$(subst 3,,$(subst 4,,$(subst 5,,$(subst 6,,$(subst 7,,$(subst 8,,$(subst 9,,$(1))))))))))),,yes)

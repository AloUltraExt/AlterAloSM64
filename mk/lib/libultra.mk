LIBULTRA ?= L

# LIBULTRA - sets the libultra OS version to use
$(eval $(call validate-option,LIBULTRA,D F H I J K L BB))

ifeq ($(LIBULTRA),BB)
  ULTRA_SRC_DIRS := $(shell find lib/ultra -type d)
  ULTRA_VER_DEF  := LIBULTRA_VERSION=OS_VER_L BBPLAYER LIBULTRA_STR_VER=\"L\"
else
  ULTRA_SRC_DIRS := $(shell find lib/ultra -type d -not -path "lib/ultra/bb/*")
  ULTRA_VER_DEF  := LIBULTRA_VERSION=OS_VER_$(LIBULTRA) LIBULTRA_STR_VER=\"$(LIBULTRA)\"
endif

DEFINES += $(ULTRA_VER_DEF)

ULTRA_C_FILES := $(foreach dir,$(ULTRA_SRC_DIRS),$(wildcard $(dir)/*.c))
ULTRA_S_FILES := $(foreach dir,$(ULTRA_SRC_DIRS),$(wildcard $(dir)/*.s))

ULTRA_O_C_FILES  := $(foreach file,$(ULTRA_C_FILES),$(BUILD_DIR)/$(file:.c=.o))
ULTRA_O_AS_FILES := $(foreach file,$(ULTRA_S_FILES),$(BUILD_DIR)/$(file:.s=.o))

ULTRA_O_FILES := $(ULTRA_O_C_FILES) $(ULTRA_O_AS_FILES)
DEP_FILES += $(ULTRA_O_FILES:.o=.d)

LIBULTRA_AR := $(BUILD_DIR)/libultra.a
AR_LIBS += $(LIBULTRA_AR)
LIBS += ultra

libultra: $(LIBULTRA_AR)
	@$(SHA1SUM) $(LIBULTRA_AR)
	@$(PRINT) "${REVERSE}Build library libultra done.$(NO_COL)\n"
	@$(PRINT) "${B_WHITE}==== Build Options ====$(NO_COL)\n"
	@$(PRINT) "${B_GREEN}Version:        $(B_CYAN)$(LIBULTRA)$(NO_COL)\n"

# Link libultra
$(LIBULTRA_AR): $(ULTRA_O_FILES)
	@$(PRINT) "$(GREEN)Linking libultra:  $(CYAN)$@ $(NO_COL)\n"
	$(V)$(AR) rcs -o $@ $(ULTRA_O_FILES)

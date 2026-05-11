LIBGCC_SRC_DIRS := lib/gcc

LIBGCC_C_FILES  := $(foreach dir,$(LIBGCC_SRC_DIRS),$(wildcard $(dir)/*.c))
LIBGCC_O_FILES  := $(foreach file,$(LIBGCC_C_FILES),$(BUILD_DIR)/$(file:.c=.o))

DEP_FILES += $(LIBGCC_O_FILES:.o=.d)

LIBGCC_AR := $(BUILD_DIR)/libgcc.a
AR_LIBS += $(LIBGCC_AR)
LIBS += gcc

libgcc: $(LIBGCC_AR)
	@$(SHA1SUM) $(LIBGCC_AR)
	@$(PRINT) "${REVERSE}Build library libgcc done.$(NO_COL)\n"

# Link libgcc
$(LIBGCC_AR): $(LIBGCC_O_FILES)
	@$(PRINT) "$(GREEN)Linking libgcc:  $(CYAN)$@ $(NO_COL)\n"
	$(V)$(AR) rcs -o $@ $(LIBGCC_O_FILES)

GODDARD_SRC_DIRS := src/goddard src/goddard/dynlists

GODDARD_C_FILES  := $(foreach dir,$(GODDARD_SRC_DIRS),$(wildcard $(dir)/*.c))
GODDARD_O_FILES  := $(foreach file,$(GODDARD_C_FILES),$(BUILD_DIR)/$(file:.c=.o))

DEP_FILES += $(GODDARD_O_FILES:.o=.d)

# Convert intro textures
INTRO_RAW_FILES  := $(wildcard $(TEXTURE_DIR)/intro_raw/*.png)
$(BUILD_DIR)/src/goddard/renderer.o: $(addprefix $(BUILD_DIR)/,$(patsubst %.png,%.inc.c,$(INTRO_RAW_FILES)))

LIBGODDARD_AR := $(BUILD_DIR)/libgoddard.a
AR_LIBS += $(LIBGODDARD_AR)
LIBS += goddard

libgoddard: $(LIBGODDARD_AR)
	@$(SHA1SUM) $(LIBGODDARD_AR)
	@$(PRINT) "${REVERSE}Build library libgoddard done.$(NO_COL)\n"

# Link libgoddard
$(LIBGODDARD_AR): $(GODDARD_O_FILES)
	@$(PRINT) "$(GREEN)Linking libgoddard:  $(CYAN)$@ $(NO_COL)\n"
	$(V)$(AR) rcs -o $@ $(GODDARD_O_FILES)

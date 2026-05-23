# =================================================================================
# Makefile — Nintendo Switch cross-compilation build for zelda3
# =================================================================================

.SUFFIXES:

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/libnx/switch_rules

#---------------------------------------------------------------------------------
# Target Configurations & Clean Absolute Path Setup
#---------------------------------------------------------------------------------
TARGET        := zelda3
BUILD         := bin

# Define the absolute path to your project root cleanly
PROJECT_ROOT  := $(shell cd $(CURDIR)/../.. && pwd)

# Explicitly map source folders under the project root
SOURCES       := $(PROJECT_ROOT)/src \
                 $(PROJECT_ROOT)/src/snes \
                 $(PROJECT_ROOT)/third_party/gl_core \
                 $(PROJECT_ROOT)/third_party/opus-1.3.1-stripped

# Find the explicit C files using absolute paths
CFILES        := $(wildcard $(PROJECT_ROOT)/src/*.c) \
                 $(wildcard $(PROJECT_ROOT)/src/snes/*.c) \
                 $(PROJECT_ROOT)/third_party/gl_core/gl_core_3_1.c \
                 $(PROJECT_ROOT)/third_party/opus-1.3.1-stripped/opus_decoder_amalgam.c

INCLUDES      := include $(PROJECT_ROOT)/src $(PROJECT_ROOT)/src/snes
APP_TITLE     := The Legend of Zelda: A Link to the Past
APP_AUTHOR    := snesrev & Lywx
APP_VERSION   := $(shell git rev-parse --short HEAD 2>/dev/null || echo "release")

#---------------------------------------------------------------------------------
# Options for Code Generation
#---------------------------------------------------------------------------------
ARCH    := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE

CFLAGS  := -g -Wall -O2 -ffunction-sections -Wno-parentheses \
           $(ARCH) $(DEFINES)

CFLAGS  += -D__SWITCH__ $(INCLUDE) -DSTBI_NO_THREAD_LOCALS `sdl2-config --cflags`

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
CFLAGS   += -std=gnu11

ASFLAGS  := -g $(ARCH)
LDFLAGS  := -specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

LIBS     := `$(PREFIX)pkg-config --libs sdl2` -lnx -lm

LIBDIRS  := $(PORTLIBS) $(LIBNX)

#---------------------------------------------------------------------------------
# Outer Phase: Directory Environment Routing
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT     := $(CURDIR)/$(TARGET)
export TOPDIR     := $(CURDIR)

# Pass absolute paths directly to VPATH so make can trace flattened objects
export VPATH      := $(SOURCES) $(foreach dir,$(DATA),$(CURDIR)/$(dir))
export DEPSDIR    := $(CURDIR)/$(BUILD)

export LD         := $(CXX)

# Object tracking targets generated safely via flattened absolute arrays
export OFILES_BIN := $(addsuffix .o,$(BINFILES))
export OFILES_SRC := $(CPPFILES:.cpp=.o) $(notdir $(CFILES:.c=.o)) $(SFILES:.s=.o)
export OFILES     := $(OFILES_BIN) $(OFILES_SRC)
export HFILES_BIN := $(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE    := $(foreach dir,$(INCLUDES),-I$(dir)) \
                     $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                     -I$(CURDIR)/$(BUILD)

export LIBPATHS   := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

ifeq ($(strip $(CONFIG_JSON)),)
	jsons := $(wildcard *.json)
	ifneq (,$(findstring $(TARGET).json,$(jsons)))
		export APP_JSON := $(TOPDIR)/$(TARGET).json
	else
		ifneq (,$(findstring config.json,$(jsons)))
			export APP_JSON := $(TOPDIR)/config.json
		endif
	endif
else
	export APP_JSON := $(TOPDIR)/$(CONFIG_JSON)
endif

ifeq ($(strip $(ICON)),)
	icons := $(wildcard *.jpg)
	ifneq (,$(findstring $(TARGET).jpg,$(icons)))
		export APP_ICON := $(TOPDIR)/$(TARGET).jpg
	else
		ifneq (,$(findstring icon.jpg,$(icons)))
			export APP_ICON := $(TOPDIR)/icon.jpg
		endif
	endif
else
	export APP_ICON := $(TOPDIR)/$(ICON)
endif

ifeq ($(strip $(NO_ICON)),)
	export NROFLAGS += --icon=$(APP_ICON)
endif

ifeq ($(strip $(NO_NACP)),)
	export NROFLAGS += --nacp=$(CURDIR)/$(TARGET).nacp
endif

ifneq ($(APP_TITLEID),)
	export NACPFLAGS += --titleid=$(APP_TITLEID)
endif

ifneq ($(ROMFS),)
	export NROFLAGS += --romfsdir=$(CURDIR)/$(ROMFS)
endif

.PHONY: $(BUILD) clean all

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).nro $(TARGET).nacp $(TARGET).elf $(TARGET).nsp $(TARGET).nso $(TARGET).npdm

#---------------------------------------------------------------------------------
# Inner Phase: Compilation Rules
#---------------------------------------------------------------------------------
else
.PHONY:	all

DEPENDS	:=	$(OFILES:.o=.d)

ifeq ($(strip $(APP_JSON)),)
all	:	$(OUTPUT).nro
ifeq ($(strip $(NO_NACP)),)
$(OUTPUT).nro	:	$(OUTPUT).elf $(OUTPUT).nacp
else
$(OUTPUT).nro	:	$(OUTPUT).elf
endif
else
all	:	$(OUTPUT).nsp
$(OUTPUT).nsp	:	$(OUTPUT).nso $(OUTPUT).npdm
$(OUTPUT).nso	:	$(OUTPUT).elf
endif

$(OUTPUT).elf	:	$(OFILES)
	@echo linking $(notdir $@)
	@$(LD) $(LDFLAGS) $(LIBPATHS) $^ $(LIBS) -o $@

$(OFILES_SRC)	: $(HFILES_BIN)

%.bin.o	%_bin.h :	%.bin
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
# Explicit compilation rules for deep third-party dependencies
#---------------------------------------------------------------------------------
gl_core_3_1.o: $(PROJECT_ROOT)/third_party/gl_core/gl_core_3_1.c
	@echo $(notdir $<)
	@$(CC) $(CFLAGS) -c $< -o $@

opus_decoder_amalgam.o: $(PROJECT_ROOT)/third_party/opus-1.3.1-stripped/opus_decoder_amalgam.c
	@echo $(notdir $<)
	@$(CC) $(CFLAGS) -c $< -o $@

endif
#---------------------------------------------------------------------------------------

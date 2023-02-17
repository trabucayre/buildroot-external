################################################################################
#
# icestorm
#
################################################################################

ICESTORM_VERSION = 8649e3e0bd0e09429898d2569ef65cc9fd3eafd7
ICESTORM_SITE = $(call github,YosysHQ,icestorm,$(ICESTORM_VERSION))

ICESTORM_LICENSE = MIT
ICESTORM_LICENSE_FILES = COPYING

ICESTORM_DEPENDENCIES = python3

# For third-party, icestorm is mandatory at
# compile time.
ICESTORM_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ICESTORM_ICEPROG),y)
ICESTORM_ENABLE_ICEPROG = 1
ICESTORM_DEPENDENCIES += host-pkgconf libftdi1
else
ICESTORM_ENABLE_ICEPROG = 0
endif

define ICESTORM_CONFIGURE_CMDS
	echo -n "" > $(@D)/config.mk
	echo "PREFIX ?= /usr" >> $(@D)/config.mk
	echo "DEBUG ?= 0" >> $(@D)/config.mk
	echo "ICEPROG ?= $(ICESTORM_ENABLE_ICEPROG)" >> $(@D)/config.mk
	echo "CXX ?= $(TARGET_CXX)" >> $(@D)/config.mk
	echo "CC ?= $(TARGET_CC)" >> $(@D)/config.mk
	echo "PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY)" >> $(@D)/config.mk
	echo "LDLIBS = -lm -lstdc++" >> $(@D)/config.mk
	echo "CFLAGS += $(TARGET_CFLAGS) -MD -MP -std=c99" >> $(@D)/config.mk
	echo "CXXFLAGS += $(TARGET_CXXFLAGS) -MD -MP -std=c++11" >> $(@D)/config.mk
	echo "CHIPDB_SUBDIR ?= icebox" >> $(@D)/config.mk
	echo "PYTHON3 ?= $(HOST_DIR)/bin/python3" >> $(@D)/config.mk
endef

define ICESTORM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define ICESTORM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
endef

define ICESTORM_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))

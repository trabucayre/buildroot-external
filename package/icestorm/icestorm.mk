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


ICESTORM_MAKE_OPTS=PREFIX=/usr \
	PYTHON3=$(HOST_DIR)/bin/python3 \
	DEBUG=0 \
	ICEPROG=0 \
	PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY) \
	STATIC=0 \
	CHIPDB_SUBDIR=icebox

ifeq ($(BR2_PACKAGE_ICESTORM_ICEPROG),y)
ICESTORM_MAKE_OPTS += ICEPROG=1
ICESTORM_DEPENDENCIES += host-pkgconf libftdi1
else
ICESTORM_MAKE_OPTS += ICEPROG=0
endif

define ICESTORM_CONFIGURE_CMDS
	echo -n "" > $(@D)/config.mk
endef

define ICESTORM_BUILD_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(ICESTORM_MAKE_OPTS)
endef

define ICESTORM_INSTALL_TARGET_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(ICESTORM_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

define ICESTORM_INSTALL_STAGING_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(ICESTORM_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))

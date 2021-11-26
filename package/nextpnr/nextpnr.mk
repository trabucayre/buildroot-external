################################################################################
#
# nextpnr
#
################################################################################
NEXTPNR_VERSION = fd2d4a8f999947ece42f791e19ddc4c2d8b823f2
NEXTPNR_SITE = $(call github,YosysHQ,nextpnr,$(NEXTPNR_VERSION))

NEXTPNR_LICENSE = MIT
NEXTPNR_LICENSE_FILES = COPYING

NEXTPNR_DEPENDENCIES = python3 boost

NEXTPNR_CONF_OPTS= \
	-DBUILD_GUI=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_HEAP=OFF \
	-DUSE_OPENMP=OFF \
	-DCOVERAGE=OFF \
	-DSTATIC_BUILD=OFF \
	-DEXTERNAL_CHIPDB=OFF \
	-DWERROR=OFF \
	-DPROFILER=OFF \
	-DUSE_IPO=OFF \
	-DBBA_IMPORT=bba/bba-export.cmake

NEXTPNR_ARCH =

ifeq ($(BR2_PACKAGE_NEXTPNR_PYTHON),y)
NEXTPNR_CONF_OPTS += -DBUILD_PYTHON=ON
else
NEXTPNR_CONF_OPTS += -DBUILD_PYTHON=OFF
endif

ifeq ($(BR2_PACKAGE_NEXTPNR_GENERIC),y)
NEXTPNR_ARCH += generic
endif

ifeq ($(BR2_PACKAGE_NEXTPNR_ICE40),y)
NEXTPNR_ARCH += ice40
NEXTPNR_CONF_OPTS += -DICESTORM_INSTALL_PREFIX=$(STAGING_DIR)/usr
endif

NEXTPNR_CONF_OPTS += -DARCH=$(NEXTPNR_ARCH)

define NEXTPNR_PRE_CONF
	cd $(@D)/bba; \
		cmake .; \
		$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)/bba
endef

NEXTPNR_PRE_CONFIGURE_HOOKS += NEXTPNR_PRE_CONF

$(eval $(cmake-package))

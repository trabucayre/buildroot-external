################################################################################
#
# yosys
#
################################################################################
YOSYS_VERSION = yosys-0.11
YOSYS_SITE = $(call github,YosysHQ,yosys,$(YOSYS_VERSION))

YOSYS_LICENSE = ISC
YOSYS_LICENSE_FILES = COPYING

YOSYS_DEPENDENCIES = host-bison host-flex host-gawk yosys-abc

YOSYS_MAKEFILE_CONF= \
	ENABLE_ABC=1 \
	ABCEXTERNAL=yosys-abc \
	ENABLE_GLOB=$(if $(BR2_PACKAGE_YOSYS_GLOB),1,0) \
	ENABLE_EDITLINE=0 \
	ENABLE_GHDL=0 \
	ENABLE_VERIFIC=0 \
	DISABLE_VERIFIC_EXTENSIONS=0 \
	DISABLE_VERIFIC_VHDL=0 \
	ENABLE_COVER=1 \
	ENABLE_LIBYOSYS=$(if $(BR2_PACKAGE_YOSYS_LIBYOSYS),1,0) \
	ENABLE_PROTOBUF=0 \
	ENABLE_GCOV=0 \
	ENABLE_GPROF=0 \
	ENABLE_DEBUG=0 \
	ENABLE_NDEBUG=0 \
	ENABLE_CCACHE=0 \
	ENABLE_SCCACHE=0 \
	LINK_CURSES=0 \
	LINK_TERMCAP=0 \
	LINK_ABC=0 \
	DISABLE_SPAWN=0 \
	DISABLE_ABC_THREADS=0

YOSYS_CONF_OPTS=

ifeq ($(BR2_PACKAGE_YOSYS_PLUGINS),y)
YOSYS_DEPENDENCIES += host-pkgconf libffi
YOSYS_MAKEFILE_CONF += ENABLE_PLUGINS=1
YOSYS_CONF_OPTS += PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY)
else
YOSYS_MAKEFILE_CONF += ENABLE_PLUGINS=0
endif

ifeq ($(BR2_PACKAGE_YOSYS_PYOSYS),y)
YOSYS_DEPENDENCIES += python3 boost
YOSYS_MAKEFILE_CONF += ENABLE_PYOSYS=1 \
	PYTHON_EXECUTABLE=$(HOST_DIR)/bin/python \
	PYTHON_DESTDIR=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages
else
YOSYS_MAKEFILE_CONF += ENABLE_PYOSYS=0
endif

ifeq ($(BR2_PACKAGE_YOSYS_READLINE),y)
YOSYS_DEPENDENCIES += readline
YOSYS_MAKEFILE_CONF += ENABLE_READLINE=1
else
YOSYS_MAKEFILE_CONF += ENABLE_READLINE=0
endif

ifeq ($(BR2_PACKAGE_YOSYS_TCL),y)
YOSYS_DEPENDENCIES += tcl host-pkgconf
YOSYS_MAKEFILE_CONF += ENABLE_TCL=1
YOSYS_CONF_OPTS += TCL_INCLUDE=$(STAGING_DIR)/usr/include \
	PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY)
else
YOSYS_MAKEFILE_CONF += ENABLE_TCL=0
endif

ifeq ($(BR2_PACKAGE_YOSYS_ZLIB),y)
YOSYS_DEPENDENCIES += zlib
YOSYS_MAKEFILE_CONF += ENABLE_ZLIB=1
else
YOSYS_MAKEFILE_CONF += ENABLE_ZLIB=1
endif

define YOSYS_CONFIGURE_CMDS
	echo "CONFIG := gcc" > $(@D)/Makefile.conf
	$(foreach cfg, $(YOSYS_MAKEFILE_CONF), \
		echo "$(cfg)" >> $(@D)/Makefile.conf
	)
	$(if $(BR2_PACKAGE_YOSYS_PYOSYS), \
		echo "PYTHON_CONFIG=$(STAGING_DIR)/usr/bin/python3-config --embed" \
			>> $(@D)/Makefile.conf)
	$(SED) 's,^CXX = gcc,CXX = $(TARGET_CXX),g' $(@D)/Makefile \
		-e 's,^LD = gcc,LD = $(TARGET_CXX),g' $(@D)/Makefile \
		-e 's,-I$$(PREFIX)/include,,g' $(@D)/Makefile \
		-e 's,python$$(PYTHON_VERSION),$$(PYTHON_EXECUTABLE),g' $(@D)/Makefile \
		-e 's,PYTHON_DESTDIR :=,PYTHON_DESTDIR ?=,g' $(@D)/Makefile
endef

define YOSYS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(YOSYS_CONF_OPTS) \
		-C $(@D)
endef

define YOSYS_INSTALL_TARGET_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) $(YOSYS_CONF_OPTS) \
		-C $(@D) install PREFIX=/usr DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))

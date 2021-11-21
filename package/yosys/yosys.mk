################################################################################
#
# yosys
#
################################################################################
YOSYS_VERSION = yosys-0.11
YOSYS_SITE = $(call github,YosysHQ,yosys,$(YOSYS_VERSION))

YOSYS_LICENSE = ISC
YOSYS_LICENSE_FILES = COPYING

YOSYS_DEPENDENCIES = host-bison host-flex host-gawk readline tcl libffi \
	python3 boost zlib yosys-abc

YOSYS_CONF_OPTS=PREFIX=/usr

YOSYS_MAKE_CONF= \
	ENABLE_ABC=1 \
	ABCEXTERNAL=yosys-abc \
	ENABLE_GLOB=$(if $(BR2_PACKAGE_YOSYS_GLOB),1,0) \
	ENABLE_PLUGINS=$(if $(BR2_PACKAGE_YOSYS_PLUGINS),1,0) \
	ENABLE_READLINE=$(if $(BR2_PACKAGE_YOSYS_READLINE),1,0) \
	ENABLE_EDITLINE=$(if $(BR2_PACKAGE_YOSYS_EDITLINE),1,0) \
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
	DISABLE_ABC_THREADS=0 \
	ENABLE_TCL=$(if $(BR2_PACKAGE_YOSYS_TCL),1,0) \
	ENABLE_PYOSYS=$(if $(BR2_PACKAGE_YOSYS_PYOSYS),1,0) \
	ENABLE_ZLIB=$(if $(BR2_PACKAGE_YOSYS_ZLIB),1,0)

define YOSYS_CONFIGURE_CMDS
	echo "CONFIG := gcc" > $(@D)/Makefile.conf
	$(foreach cfg, $(YOSYS_MAKE_CONF), \
		echo $(cfg) >> $(@D)/Makefile.conf
	)
	$(SED) 's,^CXX = gcc,CXX = $(TARGET_CXX),g' $(@D)/Makefile
	$(SED) 's,^LD = gcc,LD = $(TARGET_CXX),g' $(@D)/Makefile
	$(SED) 's,-I$$(PREFIX)/include,,g' $(@D)/Makefile
endef

define YOSYS_BUILD_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define YOSYS_INSTALL_TARGET_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		PREFIX=/usr DESTDIR=$(TARGET_DIR) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))

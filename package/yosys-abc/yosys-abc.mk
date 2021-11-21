################################################################################
#
# yosys-abc
#
################################################################################
YOSYS_ABC_VERSION = f6fa2ddcfc89099726d60386befba874c7ac1e0d
YOSYS_ABC_SITE = $(call github,YosysHQ,abc,$(YOSYS_ABC_VERSION))

YOSYS_ABC_LICENSE = ISC
YOSYS_ABC_LICENSE_FILES = copyright.txt

YOSYS_ABC_DEPENDENCIES = readline

YOSYS_ABC_MAKE_FLAGS=PREFIX=/usr ABC_USE_PIC=1 \
	ABC_USE_STDINT_H=1 ABC_USE_LIBSTDCXX=1 \
	ARCHFLAGS="-DABC_USE_STDINT_H"

define YOSYS_ABC_CONFIGURE_CMDS
	$(SED) 's/^CC   :=/CC   ?=/g' $(@D)/Makefile
	$(SED) 's/^CXX  :=/CXX  ?=/g' $(@D)/Makefile
	$(SED) 's/^AR   :=/AR   ?=/g' $(@D)/Makefile
	$(SED) 's/^OS := $$(shell uname -s)/OS := Linux/g' $(@D)/Makefile
endef

define YOSYS_ABC_BUILD_CMDS
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(YOSYS_ABC_MAKE_FLAGS)
   	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(YOSYS_ABC_MAKE_FLAGS) libabc.so
endef

define YOSYS_ABC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/abc $(TARGET_DIR)/usr/bin/yosys-abc
	$(INSTALL) -D -m 0755 $(@D)/libabc.so $(TARGET_DIR)/usr/lib/libabc-yosys.so
endef

$(eval $(generic-package))

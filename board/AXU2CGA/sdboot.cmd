ipaddr=192.168.0.10
serverip=192.168.0.2
gatewayip=192.168.0.2
netmask=255.255.255.0

setenv devnum 0
setenv partid 1
setenv fdt_addr_r 0x1f00000
setenv fdtfile system.dtb
setenv kernel Image

setenv bootargs console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait earlyprintk video=DP-1:10240x768@60 drm.debug=0x2f drm_kms_helper.fbdev_emulation=true

mmc dev $devnum && mmcinfo; load mmc $devnum:$partid $fdt_addr_r $fdtfile && load mmc $devnum:$partid $kernel_addr_r $kernel && booti $kernel_addr_r - $fdt_addr_r

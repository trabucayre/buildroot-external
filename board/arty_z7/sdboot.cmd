#ipaddr=192.168.0.10
#serverip=192.168.0.2
#gatewayip=192.168.0.2
#netmask=255.255.255.0
#hostname=syref
#devicetree_image=zynq-zed.dtb
#mmcargs=setenv bootargs console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait earlyprintk
#sdboot=run mmc_loadbit; run mmcargs; load mmc 0 0x2080000 ${kernel_image} && load mmc 0 0x2000000 ${devicetree_image} && bootz 0x2080000 - 0x2000000

setenv devnum 0
setenv partid 1
setenv kernel_image zImage
setenv fdtfile zynq-arty-z7.dtb

setenv bootargs console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait earlyprintk

# FPGA configuration
setenv bitstream_image system.bit.bin
setenv loadbit_addr 0x100000
setenv mmc_loadbit 'echo Loading bitstream from SD/MMC/eMMC to RAM.. && mmcinfo && load mmc 0 ${loadbit_addr} ${bitstream_image} && fpga load 0 ${loadbit_addr} ${filesize}'

mmc dev $devnum && mmcinfo; run mmc_loadbit; load mmc $devnum:$partid $fdt_addr_r $fdtfile && load mmc $devnum:$partid $kernel_addr_r $kernel_image && bootz $kernel_addr_r - $fdt_addr_r


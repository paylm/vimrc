### debain 10 安装纪录

## 1. 镜像下载: debian 10 dvd 完遬镜像 4G
+ 添加/etc/apt/source.list

## 2. 处理显卡驱动lscpi -vv | grep -i VGA 

查看显卡驱动状态
```
00:02.0 VGA compatible controller: Intel Corporation Device 9b41 (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Device 22af
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 158
        Region 0: Memory at ed000000 (64-bit, non-prefetchable) [size=16M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 4000 [size=64]
        [virtual] Expansion ROM at 000c0000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: i915    //查看driver 是否在使用
        Kernel modules: i915

```
如无法安装，则使用闭源驱动
dpkg -r xserver-xorg-video-esva
详情见:https://wiki.debian.org/zh_CN/NvidiaGraphicsDrivers#vesa
再启动startx 成功

## 3 处理网卡驱动
查看lspci -vv | grep network
00:14.3 Network controller: Intel Corporation Device 02f0
详情如下:
```
00:14.3 Network controller: Intel Corporation Device 02f0
        Subsystem: Intel Corporation Device 0070
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 161
        Region 0: Memory at ef738000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
```
如果启无线网卡驱动状态启用失败，此时
 安装新版内核


https://wiki.debian.org/iwlwifi
ii  firmware-iwlwifi                       20200918-1~bpo10+1                           all          Binary firmware for Intel Wireless cards

在加载内核模块时提示无权限:
modprobe iwlwifi 

原因Secure EFI 控制阻止加载，需要关闭关闭Secure Boot
见https://wiki.debian.org/SecureBoot
```
In case it is difficult to control Secure Boot state through the EFI setup program, mokutil can also be used to disable or re-enable Secure Boot for operating systems loaded through shim and GRUB:

Run: mokutil --disable-validation or mokutil --enable-validation.

Choose a password between 8 and 16 characters long. Enter the same password to confirm it.
Reboot.
When prompted, press a key to perform MOK management.
Select "Change Secure Boot state".
Enter each requested character of your chosen password to confirm the change. Note that you have to press Return/Enter after each character.
Select "Yes".
Select "Reboot".

```

完成成重启系统，网卡和显示正常。。。

## 无法播放声音的办法
+ 查看网卡驱动是否正常
```
➜  ~ lspci -vv -s 00:1f.3
00:1f.3 Audio device: Intel Corporation Device 02c8 (prog-if 80)
        Subsystem: Lenovo Device 22af
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 162
        Region 0: Memory at ef73c000 (64-bit, non-prefetchable) [size=16K]
        Region 4: Memory at eea00000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>
        Kernel driver in use: sof-audio-pci   // 查看到此时系统使用的驱动与硬件驱动不一样，需要调整治
        Kernel modules: snd_hda_intel, snd_sof_pci

```
+ 处理方法
``
lsmod | grep snd_hda_intel
snd_hda_intel          57344  6
snd_intel_dspcfg       24576  3 snd_hda_intel,snd_sof_pci,snd_sof_intel_hda_common
snd_hda_codec         163840  5 snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec_realtek,snd_soc_hdac_hda                                                                
snd_hda_core          106496  9 snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_ext_core,snd_hda_codec,snd_hda_codec_realtek,snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_sof_intel_hda
snd_pcm               131072  9 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_sof,snd_sof_intel_hda_common,snd_compress,snd_soc_core,snd_hda_core                                       
snd                   106496  22 snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hwdep,snd_hda_intel,snd_hda_codec,snd_hda_codec_realtek,snd_timer,snd_compress,thinkpad_acpi,snd_soc_core,snd_pcm

```
内核已加载此模块，只有没关联硬件上
需要改grub, 优先使用snd_hda_intel
编辑Linux Kernel启动项：这里以使用人数最多的Grub2为例子：
在/etc/default/grub里编辑，在GRUB_CMDLINE_LINUX_DEFAULT加上

``` 
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet snd_hda_intel.dmic_detect=0"
GRUB_CMDLINE_LINUX=""

```
snd_hda_intel.dmic_detect=0
然后保存退出，重新生成Grub Config：（注意提权）
grub-mkconfig -o /boot/grub/grub.cfg
 重启一下，就能看到Intel的声卡控制芯片了～
 此时查看声卡驱动
 ```
 ➜  ~ lspci -vv -s 00:1f.3
00:1f.3 Audio device: Intel Corporation Device 02c8 (prog-if 80)
        Subsystem: Lenovo Device 22af
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+                                                                                
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-                                                                                 
        Latency: 64
        Interrupt: pin A routed to IRQ 162
        Region 0: Memory at ef73c000 (64-bit, non-prefetchable) [size=16K]
        Region 4: Memory at eea00000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel, snd_sof_pci
 ```

{
  rpiKernel,
  ...
}:
let
  kernel = rpiKernel.override {
    extraConfig = ''
      SOUND n
      WLAN n
      BLUETOOTH n

      DRM n
      MEDIA_SUPPORT n

      HWMON n
      STAGING n
      MACINTOSH n
      ISDN n
      PCMCIA n

      JFS_FS n
      XFS_FS n
      GFS2_FS n
      OCFS2_FS n
      REISERFS_FS n
      QNX4FS_FS n
      UFS_FS n
      SQUASHFS m

      KVM n
      VHOST_NET n

      I2C y
      I2C_BCM2835 y
      SPI y
      SPI_BCM2835 y
      GPIO_CDEV y
      GPIO_CDEV_V1 y
      BCM2835_WDT y
      RASPBERRYPI_FIRMWARE y
      THERMAL y

      USB y
      USB_DWC2 y
      USB_STORAGE y
      USB_HID y
      USB_SERIAL y
      USB_SERIAL_PL2303 y
      USB_SERIAL_CP210X y
      USB_SERIAL_FTDI_SIO y

      EXT4_FS y
      VFAT_FS y
      FUSE_FS y

      NETDEVICES y
      GENET y

      CRYPTO_AES_ARM64 y

      TMPFS y
      DEVTMPFS y
      DEVTMPFS_MOUNT y
      CGROUPS y
      FHANDLE y
      INOTIFY_USER y
      SYSFS y
      PROC_FS y
      SIGNALFD y
      TIMERFD y
      EPOLL y
      NET y
    '';
  };
in
kernel

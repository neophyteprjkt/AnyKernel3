### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Neophyte Kernel by k4ngcaribug @ telegram
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=ginkgo
device.name2=
supported.versions=
supported.patchlevels=11-16
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
split_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# Get Android version from build.prop
android_ver=$(file_getprop /system/build.prop ro.build.version.release)

# Convert to integer (strip potential decimal points)
android_ver=${android_ver%%.*}

# Check if Android version is 11 or lower
if [ "$android_ver" -le 11 ] 2>/dev/null; then
    patch_cmdline "legacy_timestamp_source" "legacy_timestamp_source=1"
    ui_print "Legacy timestamp workaround enabled"
else
    patch_cmdline "legacy_timestamp_source" "legacy_timestamp_source=0"
    ui_print "Timestamp patch not needed"
fi

flash_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
flash_dtbo;

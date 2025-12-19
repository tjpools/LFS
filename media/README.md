# /media - Removable Media Mount Points

## Purpose
Contains mount points for removable media devices that are automatically mounted by the system, such as USB drives, CDs/DVDs, and SD cards.

## Key Characteristics
- **Automatic mounting**: System creates subdirectories when devices are inserted
- **User-accessible**: Mounted with permissions for regular users
- **Temporary**: Mount points come and go with devices
- **Per-user**: Modern systems create per-user directories

## Typical Structure

### Modern Systems (per-user)
```
/media/
├── username/
│   ├── USB_DRIVE/       # USB flash drive
│   ├── SANDISK_32GB/    # SD card
│   ├── Ubuntu 22.04/    # DVD/CD
│   └── External_HDD/    # External hard drive
└── other_user/
    └── their_devices/
```

### Legacy Systems (shared)
```
/media/
├── cdrom/              # CD/DVD drive
├── usb0/               # First USB device
├── usb1/               # Second USB device
└── floppy/             # Floppy disk (vintage!)
```

## How It Works

### Automatic Mounting
Modern desktop environments use **udisks2** and **udev** to:
1. Detect when a device is inserted
2. Create a mount point in `/media/username/`
3. Mount the filesystem
4. Notify the user
5. Unmount when ejected
6. Remove the mount point

### Manual Mounting
You can also mount devices manually:
```bash
# Create mount point
sudo mkdir /media/myusb

# Mount device
sudo mount /dev/sdb1 /media/myusb

# Unmount when done
sudo umount /media/myusb
```

## Common Device Types

### USB Flash Drives
- Appear as `/dev/sdb1`, `/dev/sdc1`, etc.
- Usually FAT32, exFAT, or NTFS
- Auto-mounted to `/media/username/DRIVE_LABEL/`

### External Hard Drives
- Appear as `/dev/sdb`, `/dev/sdc`, etc.
- Can have multiple partitions
- May use ext4, NTFS, or HFS+

### CD/DVD Drives
- Appear as `/dev/sr0`, `/dev/cdrom`
- ISO 9660 or UDF filesystem
- Read-only (unless burning)

### SD Cards
- Appear as `/dev/mmcblk0p1`
- Usually FAT32 or exFAT
- Common in cameras and Raspberry Pi

## Useful Commands

### List mounted media
```bash
# All mounted filesystems
mount | grep /media

# Or use df
df -h | grep /media

# Or use lsblk
lsblk
```

### Manually mount a USB drive
```bash
# Identify the device
lsblk
sudo fdisk -l

# Mount it
sudo mount /dev/sdb1 /media/usb

# With specific filesystem type
sudo mount -t vfat /dev/sdb1 /media/usb
sudo mount -t ntfs-3g /dev/sdb1 /media/usb
```

### Safely unmount (eject)
```bash
# Unmount before removing!
umount /media/username/USB_DRIVE

# Or eject CD/DVD
eject /dev/sr0
```

### Check device information
```bash
# List all block devices
lsblk -f

# Detailed disk info
sudo fdisk -l /dev/sdb

# USB devices
lsusb
```

## Desktop Environment Integration

### GNOME
- Nautilus file manager shows devices in sidebar
- Click to mount, "eject" icon to unmount
- Settings in GNOME Disks

### KDE Plasma
- Dolphin file manager shows devices
- Device Notifier applet in system tray
- KDE Partition Manager for advanced options

### Command Line
```bash
# udisksctl - modern way to mount
udisksctl mount -b /dev/sdb1
udisksctl unmount -b /dev/sdb1
```

## Filesystem Types

Common filesystems on removable media:

| Filesystem | Use Case | Linux Support |
|------------|----------|---------------|
| FAT32 | USB drives, universal compatibility | Native |
| exFAT | Large files on USB | Requires exfat-utils |
| NTFS | Windows external drives | Requires ntfs-3g |
| ext4 | Linux external drives | Native |
| ISO 9660 | CDs/DVDs | Native |
| HFS+ | Mac drives | Requires hfsprogs |

## /media vs /mnt

| Directory | Purpose |
|-----------|---------|
| `/media` | Automatic mounting of removable media |
| `/mnt` | Manual/temporary mounting by admin |

Think of `/media` as plug-and-play, `/mnt` as manual.

## Permissions and Security

### Auto-mounted devices
- Typically mounted with user ownership
- User can read/write without sudo
- Sync option prevents data loss

### Manual mounting
```bash
# Mount with specific user ownership
sudo mount -o uid=1000,gid=1000 /dev/sdb1 /media/usb

# Mount read-only
sudo mount -o ro /dev/sdb1 /media/usb
```

## Troubleshooting

### Device not auto-mounting
```bash
# Check udev rules
ls /etc/udev/rules.d/

# Check udisks service
systemctl status udisks2

# Manual mount as fallback
sudo mount /dev/sdb1 /media/usb
```

### "Device is busy" error
```bash
# Find what's using it
lsof +D /media/username/device

# Force unmount (use carefully!)
sudo umount -l /media/username/device
```

### Permission denied
```bash
# Check mount options
mount | grep /media

# Remount with proper permissions
sudo mount -o remount,uid=1000 /media/usb
```

## Best Practices
✅ Always safely eject/unmount before removing
✅ Use `sync` command to flush writes before unmounting
✅ Check `dmesg` for hardware detection issues
❌ Never just pull out a mounted device
❌ Don't force unmount unless absolutely necessary

# /mnt - Temporary Mount Point

## Purpose
A generic mount point for temporarily mounting filesystems by system administrators. Used for manual, temporary filesystem mounts.

## Key Characteristics
- **Manual mounting**: Admin explicitly mounts filesystems here
- **Temporary**: Not intended for permanent mounts
- **Root access**: Typically requires sudo
- **Flexible**: Can contain subdirectories for organization

## Common Uses

### Network Shares
```bash
# Mount NFS share
sudo mount -t nfs server:/share /mnt/nfs

# Mount Windows/Samba share
sudo mount -t cifs //server/share /mnt/samba -o username=user
```

### Additional Hard Drives
```bash
# Mount second hard drive temporarily
sudo mount /dev/sdb1 /mnt/secondary

# Mount by UUID
sudo mount UUID=xxxx-xxxx /mnt/backup
```

### ISO Files
```bash
# Mount ISO image
sudo mount -o loop disk.iso /mnt/iso
```

### Recovery Operations
```bash
# Mount root filesystem from live USB for repair
sudo mount /dev/sda1 /mnt
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
```

## Typical Organization

### Option 1: Direct mounting
```
/mnt/
├── (temporarily mounted filesystem)
```

### Option 2: Subdirectories
```
/mnt/
├── backup/          # Backup drive
├── nas/             # Network storage
├── usb/             # USB drive
├── iso/             # ISO images
└── win/             # Windows partition
```

## /mnt vs /media

| Directory | Usage | Mounting | Typical User |
|-----------|-------|----------|--------------|
| `/mnt` | Temporary, manual mounts | Admin (manual) | System admin |
| `/media` | Removable media | Automatic (udev) | Regular user |

**Simple rule**: 
- USB stick you plug in → `/media`
- Network share you manually mount → `/mnt`

## Common Mounting Scenarios

### 1. Mount Network Drive
```bash
# Create mount point
sudo mkdir -p /mnt/nas

# Mount NFS
sudo mount -t nfs 192.168.1.100:/export/data /mnt/nas

# Mount CIFS/SMB
sudo mount -t cifs //192.168.1.100/share /mnt/nas \
  -o username=myuser,password=mypass
```

### 2. Mount Additional Disk
```bash
# Find the device
lsblk
sudo fdisk -l

# Create mount point
sudo mkdir /mnt/data

# Mount
sudo mount /dev/sdb1 /mnt/data

# Check
df -h /mnt/data
```

### 3. Mount ISO Image
```bash
# Mount ISO
sudo mount -o loop ubuntu-22.04.iso /mnt/iso

# Browse contents
ls /mnt/iso

# Unmount when done
sudo umount /mnt/iso
```

### 4. Mount Windows Partition
```bash
# Mount NTFS partition
sudo mount -t ntfs-3g /dev/sda3 /mnt/windows

# Or with specific options
sudo mount -t ntfs-3g /dev/sda3 /mnt/windows \
  -o permissions,uid=1000,gid=1000
```

## Mount Options

### Common Options
```bash
# Read-only
sudo mount -o ro /dev/sdb1 /mnt/data

# Read-write (default)
sudo mount -o rw /dev/sdb1 /mnt/data

# No execution of binaries
sudo mount -o noexec /dev/sdb1 /mnt/data

# Remount with different options
sudo mount -o remount,ro /mnt/data
```

### Network Filesystem Options
```bash
# NFS with options
sudo mount -t nfs -o rw,soft,timeo=30 \
  server:/export /mnt/nfs

# CIFS with credentials
sudo mount -t cifs //server/share /mnt/smb \
  -o credentials=/root/.smbcreds,uid=1000
```

## Permanent Mounts

For permanent mounts, use `/etc/fstab` instead:

```bash
# /etc/fstab example
/dev/sdb1    /mnt/data    ext4    defaults    0  2
//nas/share  /mnt/nas     cifs    credentials=/root/.smb  0  0
```

Then:
```bash
# Mount all from fstab
sudo mount -a

# Or specific mount
sudo mount /mnt/data
```

## Unmounting

### Basic unmount
```bash
sudo umount /mnt/data
```

### If busy
```bash
# Find what's using it
lsof +D /mnt/data
fuser -m /mnt/data

# Kill processes
sudo fuser -km /mnt/data

# Lazy unmount (last resort)
sudo umount -l /mnt/data
```

## System Recovery Example

When you boot from Live USB to fix a broken system:

```bash
# Mount the root filesystem
sudo mount /dev/sda1 /mnt

# Mount other important filesystems
sudo mount /dev/sda2 /mnt/boot  # if separate boot partition
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /dev/pts /mnt/dev/pts

# Change root into the mounted system
sudo chroot /mnt

# Now you can repair your system
# ...

# When done, exit and unmount
exit
sudo umount -R /mnt
```

## Security Considerations

### Sensitive Mounts
```bash
# Mount with restricted permissions
sudo mount -o noexec,nosuid,nodev /dev/sdb1 /mnt/untrusted
```

### Encrypted Volumes
```bash
# LUKS encrypted device
sudo cryptsetup open /dev/sdb1 encrypted_volume
sudo mount /dev/mapper/encrypted_volume /mnt/secure
```

## Best Practices

✅ **Do:**
- Create descriptive subdirectories: `/mnt/backup`, `/mnt/nas`
- Unmount filesystems when done
- Use appropriate permissions and options
- Document mounts in `/etc/fstab` if permanent
- Check available space before mounting large filesystems

❌ **Don't:**
- Leave sensitive network shares mounted indefinitely
- Mount untrusted devices without `noexec` option
- Force unmount unless absolutely necessary
- Use `/mnt` for permanent application data

## Useful Commands

```bash
# List all mounts
mount | grep /mnt

# Show disk usage
df -h /mnt/*

# Show detailed mount info
findmnt /mnt/data

# Test mount from fstab
sudo mount -av

# Unmount all under /mnt
sudo umount -R /mnt
```

## Troubleshooting

### Mount fails
```bash
# Check device exists
lsblk

# Check filesystem type
sudo file -s /dev/sdb1
sudo blkid /dev/sdb1

# Try to repair filesystem
sudo fsck /dev/sdb1
```

### Permission issues
```bash
# Check who owns the mount point
ls -ld /mnt/data

# Mount with specific user
sudo mount -o uid=1000,gid=1000 /dev/sdb1 /mnt/data
```

### Network mount hangs
```bash
# Use soft mount with timeout
sudo mount -t nfs -o soft,timeo=30 server:/share /mnt/nfs

# Check network connectivity
ping server
showmount -e server
```

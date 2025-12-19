# /dev - Device Files

## Purpose
Contains device files that represent hardware devices and virtual devices. In Linux, "everything is a file" - including hardware.

## Key Characteristics
- **Virtual directory**: Populated dynamically by the system (udev)
- **Device nodes**: Special files representing hardware
- **No disk space**: Files don't consume actual disk space
- **Access control**: Permissions control hardware access

## Common Device Types

### Block Devices (b)
Storage devices that transfer data in blocks:
- `sda`, `sdb` - SATA/SCSI hard drives
- `sda1`, `sda2` - Partitions on drives
- `nvme0n1` - NVMe SSDs
- `sr0` - CD/DVD drive
- `loop0` - Loopback device

### Character Devices (c)
Devices that transfer data character by character:
- `tty*` - Terminals
- `pts/*` - Pseudo-terminals (SSH sessions)
- `console` - System console
- `input/*` - Input devices (keyboard, mouse)

### Special Devices
- `null` - Black hole - discards all data written to it
- `zero` - Provides infinite stream of null bytes
- `random` - Random number generator (blocking)
- `urandom` - Random number generator (non-blocking)
- `full` - Always returns "disk full" error

### Standard Streams
- `stdin` → Link to `/proc/self/fd/0`
- `stdout` → Link to `/proc/self/fd/1`
- `stderr` → Link to `/proc/self/fd/2`

## Device Naming Conventions

### Storage
- `sd*` - SCSI/SATA drives (sda, sdb, sdc...)
- `hd*` - Old IDE drives (hda, hdb...)
- `nvme*` - NVMe SSDs
- `mmcblk*` - SD cards

### Terminals
- `tty*` - Terminal devices
- `ttyS*` - Serial ports
- `ttyUSB*` - USB serial devices

## Practical Examples

```bash
# View all disks
ls -l /dev/sd*

# Write to null device (discard output)
echo "test" > /dev/null

# Generate random data
head -c 10 /dev/urandom | base64

# Check which terminal you're using
tty  # Returns something like /dev/pts/0

# View disk info
lsblk  # Lists block devices
```

## Device Management
- Modern systems use **udev** to dynamically create/remove device files
- Rules in `/etc/udev/rules.d/` control device creation
- Use `lsblk`, `lsusb`, `lspci` to discover devices

## Permission Model
```
brw-rw---- 1 root disk    8, 0 Dec 18 10:00 sda
crw-rw-rw- 1 root tty     5, 0 Dec 18 10:00 tty
```
- First char: `b`=block, `c`=character, `l`=link
- Numbers: Major, Minor device numbers

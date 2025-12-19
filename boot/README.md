# /boot - Boot Loader Files

## Purpose
Contains static files required for the boot process, including the Linux kernel, initial RAM disk, and bootloader configuration.

## Key Characteristics
- **Critical**: System won't boot without these files
- **Static**: Changed only during kernel updates
- **Small partition**: Often a separate, small partition (200-500MB)
- **Root access only**: Modifications require superuser privileges

## Common Contents

### Kernel Files
- `vmlinuz-*` - Compressed Linux kernel
- `vmlinuz` - Symbolic link to current kernel
- `System.map-*` - Kernel symbol table

### Initial RAM Disk
- `initrd.img-*` - Initial RAM disk image
- `initramfs-*` - Initial RAM filesystem (modern systems)

### Bootloader (GRUB)
- `grub/` - GRUB bootloader configuration
  - `grub.cfg` - Main configuration file
  - `grubenv` - Environment variables
  - `fonts/` - Boot screen fonts
  - `themes/` - Boot menu themes

### Configuration
- `config-*` - Kernel configuration used during build

## Boot Process Overview
```
1. BIOS/UEFI → Finds bootloader
2. Bootloader (GRUB) → Reads /boot/grub/grub.cfg
3. Loads kernel → /boot/vmlinuz-*
4. Loads initrd → /boot/initrd.img-*
5. Kernel starts → Mounts root filesystem
6. Init process begins
```

## Important Commands
```bash
# List kernel versions
ls -lh /boot/vmlinuz-*

# Update GRUB config (after changes)
sudo update-grub

# Check current running kernel
uname -r
```

## Safety Note
⚠️ **Never delete files from /boot unless you know what you're doing!**
Always keep at least one working kernel.

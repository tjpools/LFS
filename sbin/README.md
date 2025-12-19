# /sbin - System Binaries

## Purpose
Contains essential system administration binaries that are typically used by the root user for system maintenance and configuration.

## Key Characteristics
- **System administration**: Commands for managing the system
- **Root access**: Most commands require superuser privileges
- **Essential**: Required for system boot and recovery
- **Static**: Similar to `/bin` but for admin tasks

## Common Contents

### Filesystem Management
- `mkfs.*` - Create filesystems (mkfs.ext4, mkfs.xfs)
- `fsck.*` - Filesystem check and repair
- `mount`, `umount` - Mount/unmount filesystems
- `fdisk`, `parted` - Partition editors
- `blkid` - Block device identification
- `tune2fs` - Tune filesystem parameters

### Network Configuration
- `ifconfig` - Interface configuration (legacy)
- `ip` - Modern network configuration tool
- `route` - Routing table manipulation (legacy)
- `iptables` - Firewall configuration
- `dhclient` - DHCP client

### System Boot & Init
- `init` - First process (initialization)
- `shutdown` - Shutdown/reboot system
- `reboot`, `halt`, `poweroff` - System control
- `telinit` - Change init runlevel

### Device Management
- `udevadm` - udev management tool
- `modprobe` - Load/unload kernel modules
- `insmod`, `rmmod` - Kernel module operations
- `lsmod` - List loaded modules

### Logical Volume Management (LVM)
- `pvcreate`, `pvdisplay` - Physical volume ops
- `vgcreate`, `vgdisplay` - Volume group ops
- `lvcreate`, `lvdisplay` - Logical volume ops

### RAID Management
- `mdadm` - Manage software RAID arrays

### System Maintenance
- `quotacheck`, `quotaon` - Disk quota management
- `ethtool` - Ethernet device settings
- `mke2fs` - Create ext2/ext3/ext4 filesystem
- `swapon`, `swapoff` - Enable/disable swap

## /sbin vs /bin

| Aspect | /sbin | /bin |
|--------|-------|------|
| **Purpose** | System administration | User commands |
| **Users** | Primarily root | All users |
| **Examples** | fsck, ip, iptables | ls, cat, grep |
| **Permissions** | Often needs root | Generally anyone |
| **Boot** | Essential for boot | Essential for boot |

## /sbin vs /usr/sbin

| Directory | Purpose | Boot |
|-----------|---------|------|
| `/sbin` | Essential system binaries | Required for boot |
| `/usr/sbin` | Non-essential system binaries | Can wait until /usr mounts |

## Common Commands Examples

### Filesystem Operations
```bash
# Create ext4 filesystem
sudo mkfs.ext4 /dev/sdb1

# Check filesystem
sudo fsck /dev/sdb1

# Mount filesystem
sudo mount /dev/sdb1 /mnt

# Check disk space
df -h
```

### Network Configuration
```bash
# Show network interfaces (modern)
ip addr show
ip link show

# Show routing table
ip route show

# Legacy commands
ifconfig
route -n
```

### System Control
```bash
# Reboot system
sudo reboot

# Shutdown system
sudo shutdown -h now
sudo poweroff

# Shutdown at specific time
sudo shutdown -h 22:00
```

### Module Management
```bash
# List loaded modules
lsmod

# Load a module
sudo modprobe module_name

# Remove a module
sudo modprobe -r module_name

# Module information
modinfo e1000e
```

### Partition Management
```bash
# List partitions
sudo fdisk -l

# Edit partitions (interactive)
sudo fdisk /dev/sdb

# Modern alternative
sudo parted /dev/sdb
```

### LVM Operations
```bash
# Create physical volume
sudo pvcreate /dev/sdb1

# Create volume group
sudo vgcreate vg_data /dev/sdb1

# Create logical volume
sudo lvcreate -L 10G -n lv_data vg_data

# Display info
sudo pvdisplay
sudo vgdisplay
sudo lvdisplay
```

## Access and PATH

### Root's PATH includes /sbin
```bash
# As root
echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

### Regular user's PATH often doesn't
```bash
# As regular user
echo $PATH
# /usr/local/bin:/usr/bin:/bin:/usr/games

# Command not found
ip addr show
# bash: ip: command not found

# Use full path
/sbin/ip addr show

# Or use sudo (which has /sbin in PATH)
sudo ip addr show
```

### Add /sbin to user PATH (if needed)
```bash
# In ~/.bashrc
export PATH="/sbin:/usr/sbin:$PATH"
```

## Filesystem Commands Detail

### mkfs.* - Create Filesystems
```bash
# ext4
sudo mkfs.ext4 /dev/sdb1

# XFS
sudo mkfs.xfs /dev/sdb1

# FAT32
sudo mkfs.vfat -F 32 /dev/sdb1

# With label
sudo mkfs.ext4 -L MyDisk /dev/sdb1
```

### fsck - Filesystem Check
```bash
# Check and repair
sudo fsck /dev/sdb1

# Force check
sudo fsck -f /dev/sdb1

# Auto repair
sudo fsck -y /dev/sdb1

# Check specific type
sudo fsck.ext4 /dev/sdb1
```

### mount/umount
```bash
# Mount
sudo mount /dev/sdb1 /mnt

# Mount with options
sudo mount -o ro,noexec /dev/sdb1 /mnt

# Unmount
sudo umount /mnt

# Force unmount
sudo umount -f /mnt

# Lazy unmount
sudo umount -l /mnt
```

## Network Commands Detail

### ip - Modern Network Tool
```bash
# Show interfaces
ip addr show
ip link show

# Show routing
ip route show

# Add IP address
sudo ip addr add 192.168.1.100/24 dev eth0

# Bring interface up/down
sudo ip link set eth0 up
sudo ip link set eth0 down

# Add route
sudo ip route add 10.0.0.0/8 via 192.168.1.1
```

### iptables - Firewall
```bash
# List rules
sudo iptables -L -n -v

# Allow port
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Block IP
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# Save rules (Debian/Ubuntu)
sudo iptables-save > /etc/iptables/rules.v4
```

## Module Management Detail

### modprobe
```bash
# Load module
sudo modprobe e1000e

# Load with parameters
sudo modprobe mymodule param=value

# Remove module
sudo modprobe -r e1000e

# Show dependencies
modprobe --show-depends e1000e
```

### lsmod
```bash
# List all modules
lsmod

# Search for specific
lsmod | grep e1000

# Show module info
modinfo e1000e
```

## Boot and Init

### System Shutdown/Reboot
```bash
# Reboot immediately
sudo reboot

# Shutdown immediately
sudo shutdown -h now
sudo halt
sudo poweroff

# Shutdown in 10 minutes
sudo shutdown -h +10

# Shutdown at 10 PM
sudo shutdown -h 22:00 "Going down for maintenance"

# Cancel scheduled shutdown
sudo shutdown -c
```

### systemd (modern init)
```bash
# Systemd is in /sbin/ or /lib/systemd/
/sbin/init  # Usually symlink to systemd

# Reboot
sudo systemctl reboot

# Poweroff
sudo systemctl poweroff

# Emergency mode
sudo systemctl emergency
```

## LVM (Logical Volume Manager)

### Physical Volumes
```bash
# Create PV
sudo pvcreate /dev/sdb1

# Display PVs
sudo pvdisplay
sudo pvs  # Short format

# Remove PV
sudo pvremove /dev/sdb1
```

### Volume Groups
```bash
# Create VG
sudo vgcreate vg_data /dev/sdb1 /dev/sdc1

# Display VGs
sudo vgdisplay
sudo vgs

# Extend VG
sudo vgextend vg_data /dev/sdd1

# Remove VG
sudo vgremove vg_data
```

### Logical Volumes
```bash
# Create LV
sudo lvcreate -L 10G -n lv_data vg_data
sudo lvcreate -l 100%FREE -n lv_data vg_data  # Use all space

# Display LVs
sudo lvdisplay
sudo lvs

# Extend LV
sudo lvextend -L +5G /dev/vg_data/lv_data
sudo resize2fs /dev/vg_data/lv_data  # Resize filesystem

# Remove LV
sudo lvremove /dev/vg_data/lv_data
```

## RAID Management

### mdadm
```bash
# Create RAID 1 array
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Display array status
sudo mdadm --detail /dev/md0
cat /proc/mdstat

# Add device to array
sudo mdadm --add /dev/md0 /dev/sdd1

# Remove device
sudo mdadm --fail /dev/md0 /dev/sdb1
sudo mdadm --remove /dev/md0 /dev/sdb1

# Stop array
sudo mdadm --stop /dev/md0
```

## Security & Permissions

### Most commands need root
```bash
# As regular user - fails
mkfs.ext4 /dev/sdb1
# Permission denied

# With sudo
sudo mkfs.ext4 /dev/sdb1
# Works
```

### Check permissions
```bash
ls -l /sbin/ip
-rwxr-xr-x 1 root root 719032 /sbin/ip
# World-executable, but operations need root
```

### SUID binaries
Some binaries have setuid bit:
```bash
ls -l /sbin/unix_chkpwd
-rwsr-xr-x 1 root root 36296 /sbin/unix_chkpwd
# 's' bit allows running as root
```

## Symlinks

Many modern systems merge directories:
```bash
# /sbin might be symlink to /usr/sbin
ls -ld /sbin
lrwxrwxrwx 1 root root 8 /sbin -> usr/sbin

# This is part of UsrMerge
```

## Package Management

Most /sbin binaries are from system packages:
```bash
# Find which package provides a binary
dpkg -S /sbin/ip          # Debian/Ubuntu
rpm -qf /sbin/ip          # Red Hat/Fedora

# List files in package
dpkg -L iproute2          # Debian/Ubuntu
rpm -ql iproute2         # Red Hat/Fedora
```

## Best Practices

✅ **Do:**
- Use `sudo` to run commands in /sbin
- Learn modern alternatives (ip instead of ifconfig)
- Test commands on non-production systems first
- Read man pages before using unfamiliar tools
- Keep backups before filesystem operations

❌ **Don't:**
- Run filesystem tools on mounted partitions
- Use force options without understanding consequences
- Modify critical filesystems without backups
- Ignore error messages
- Use deprecated tools (ifconfig, route) on modern systems

## Troubleshooting

### Command not found
```bash
# Add to PATH temporarily
export PATH="/sbin:/usr/sbin:$PATH"

# Or use full path
/sbin/ip addr show

# Or use sudo
sudo ip addr show
```

### Operation not permitted
```bash
# Most /sbin commands need root
sudo command args
```

### Legacy vs modern commands
```bash
# Old way
ifconfig eth0
route -n

# New way (preferred)
ip addr show eth0
ip route show
```

# /etc - System Configuration Files

## Purpose
The "et cetera" directory contains system-wide configuration files and shell scripts used during boot.

## Key Characteristics
- **Text-based**: Most files are human-readable text
- **System-wide**: Affects all users
- **Root access**: Usually requires sudo to modify
- **No binaries**: Only configuration files and scripts

## Essential Files

### User & Group Management
- `passwd` - User account information
- `shadow` - Encrypted passwords (readable by root only)
- `group` - Group definitions
- `sudoers` - Sudo privileges configuration

### System Configuration
- `hostname` - System hostname
- `hosts` - Static hostname-to-IP mappings
- `resolv.conf` - DNS resolver configuration
- `fstab` - Filesystem mount table
- `timezone` - System timezone

### Network
- `network/interfaces` - Network interface configuration (Debian)
- `netplan/*.yaml` - Network configuration (Ubuntu 18+)
- `hosts.allow`, `hosts.deny` - TCP wrapper access control

### Shell & Environment
- `bash.bashrc` - System-wide bash configuration
- `profile` - System-wide environment settings
- `environment` - Global environment variables
- `shells` - List of valid login shells

### Services & Daemons
- `systemd/` - Systemd service configurations
- `init.d/` - Legacy init scripts
- `cron.d/`, `crontab` - Scheduled task configurations

### Application Configs
- `ssh/` - SSH server configuration
- `apache2/` or `httpd/` - Web server config
- `nginx/` - Nginx web server config
- `mysql/` - MySQL database config

## Important Subdirectories

### /etc/default/
Default settings for various services
```
/etc/default/grub        # GRUB bootloader defaults
/etc/default/useradd     # Default settings for new users
```

### /etc/init.d/
Service control scripts (legacy)
```bash
sudo /etc/init.d/apache2 start
```

### /etc/systemd/
Systemd configurations
```
/etc/systemd/system/     # Custom service units
/etc/systemd/user/       # User service units
```

### /etc/apt/ (Debian/Ubuntu)
Package manager configuration
```
/etc/apt/sources.list    # Repository sources
/etc/apt/sources.list.d/ # Additional sources
```

### /etc/skel/
Skeleton directory - template for new user home directories
Files here are copied to new user accounts

## Common Tasks

### View system users
```bash
cat /etc/passwd
```

### Check hostname
```bash
cat /etc/hostname
hostnamectl  # Modern way
```

### View mounted filesystems
```bash
cat /etc/fstab
```

### Check DNS servers
```bash
cat /etc/resolv.conf
```

### Edit sudo privileges
```bash
sudo visudo  # NEVER edit /etc/sudoers directly!
```

## File Format Examples

### /etc/passwd format
```
username:x:UID:GID:comment:home_directory:shell
root:x:0:0:root:/root:/bin/bash
tjpools:x:1000:1000:User:/home/tjpools:/bin/bash
```

### /etc/fstab format
```
# <device> <mount point> <type> <options> <dump> <pass>
UUID=xxx  /              ext4   defaults  0       1
UUID=yyy  /boot          ext4   defaults  0       2
```

## Best Practices
- ✅ Always backup before editing: `sudo cp file file.backup`
- ✅ Use proper tools: `visudo`, `vipw`, etc.
- ✅ Test changes before rebooting
- ❌ Never delete files you don't understand
- ❌ Avoid binary files in /etc

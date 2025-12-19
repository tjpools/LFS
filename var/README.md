# /var - Variable Data

## Purpose
Contains variable data that changes during system operation: logs, caches, spools, databases, and other files that grow or change.

## Key Characteristics
- **Variable**: Content changes frequently
- **Persistent**: Data survives reboots
- **Growing**: Files can grow significantly
- **Critical**: Contains important logs and data

## Main Structure

```
/var/
├── log/            # Log files
├── cache/          # Application caches
├── tmp/            # Temporary files (persists across reboots)
├── spool/          # Print queues, mail, cron jobs
├── lib/            # Application state data
├── www/            # Web server content (legacy)
├── mail/           # User mailboxes
├── run/            # Runtime data (symlink to /run)
├── lock/           # Lock files (symlink to /run/lock)
├── opt/            # Variable data for /opt packages
└── local/          # Variable data for /usr/local
```

## /var/log - System Logs

The most important directory - all system logs:

### Core System Logs
```
/var/log/
├── syslog              # General system log
├── auth.log            # Authentication logs
├── kern.log            # Kernel logs
├── dmesg               # Boot messages
├── boot.log            # Boot process log
├── messages            # General messages (Red Hat/Fedora)
└── faillog             # Failed login attempts
```

### Service Logs
```
/var/log/
├── apache2/            # Apache web server
│   ├── access.log
│   └── error.log
├── nginx/              # Nginx web server
│   ├── access.log
│   └── error.log
├── mysql/              # MySQL database
│   └── error.log
├── postgresql/         # PostgreSQL database
└── audit/              # SELinux audit logs
```

### Application Logs
```
/var/log/
├── apt/                # Package manager (Debian/Ubuntu)
│   ├── history.log
│   └── term.log
├── dpkg.log            # Package installation log
├── alternatives.log    # update-alternatives log
└── unattended-upgrades/ # Automatic updates
```

### System Management
```
/var/log/
├── journal/            # systemd journal
│   └── <machine-id>/
├── cron.log            # Cron job logs
├── daemon.log          # Daemon messages
└── user.log            # User-space logs
```

## /var/log Common Commands

### View Logs
```bash
# Real-time monitoring
tail -f /var/log/syslog

# Follow multiple logs
tail -f /var/log/{syslog,auth.log}

# View with systemd
journalctl -f
journalctl -u ssh.service
journalctl --since today

# Search logs
grep "error" /var/log/syslog
grep -r "failed" /var/log/
```

### Log Rotation
```bash
# Configuration
ls /etc/logrotate.d/

# Manual rotation
sudo logrotate -f /etc/logrotate.conf

# Check last rotation
ls -lt /var/log/*.gz
```

## /var/cache - Application Caches

Cached data that can be regenerated:

```
/var/cache/
├── apt/                # APT package cache
│   └── archives/       # Downloaded .deb files
├── fontconfig/         # Font cache
├── man/                # Formatted man pages
├── ldconfig/           # Shared library cache
└── debconf/            # Debian package config cache
```

### Clean Caches
```bash
# APT cache
sudo apt clean              # Remove all cached packages
sudo apt autoclean          # Remove obsolete packages

# Check size
du -sh /var/cache/apt

# Manual cleanup
sudo rm -rf /var/cache/apt/archives/*.deb
```

## /var/tmp - Temporary Files

Like `/tmp` but persists across reboots:

### Differences from /tmp

| Directory | Cleared | Use Case |
|-----------|---------|----------|
| `/tmp` | On reboot | Short-term, session files |
| `/var/tmp` | After 30 days | Longer-term temporary files |

### Common Uses
```bash
# Large downloads
cd /var/tmp
wget https://example.com/large-file.iso

# Package build cache
/var/tmp/portage/        # Gentoo builds
/var/tmp/rpm-tmp/        # RPM temporary files
```

## /var/spool - Data Spools

Queued data waiting to be processed:

```
/var/spool/
├── cron/               # Cron job schedules
│   ├── crontabs/       # User crontabs
│   └── anacron/        # Anacron jobs
├── mail/               # Email queue
├── cups/               # Print jobs
├── at/                 # at command jobs
└── postfix/            # Mail server queue
```

### Mail Spool
```bash
# User mailboxes
/var/spool/mail/username
/var/mail/username  # Symlink

# Check mail
mail
```

### Cron Jobs
```bash
# User crontabs
/var/spool/cron/crontabs/username

# Edit crontab
crontab -e

# List crontabs
crontab -l
```

### Print Queue
```bash
# Print jobs
ls /var/spool/cups/

# Clear print queue
cancel -a
```

## /var/lib - Application State

Variable state information for applications:

```
/var/lib/
├── docker/             # Docker images and containers
│   ├── containers/
│   ├── images/
│   └── volumes/
├── mysql/              # MySQL databases
├── postgresql/         # PostgreSQL databases
├── dpkg/               # Package manager database
│   ├── status          # Installed packages
│   └── available       # Available packages
├── systemd/            # systemd state
├── snapd/              # Snap packages
└── flatpak/            # Flatpak packages
```

### Critical Data
⚠️ **Important**: `/var/lib` contains database files, container data, and application state. **Always backup before changes!**

### Docker Data
```bash
# Docker uses /var/lib/docker
du -sh /var/lib/docker

# Volumes
ls /var/lib/docker/volumes/

# Images
docker images
```

### Database Files
```bash
# MySQL/MariaDB
/var/lib/mysql/

# PostgreSQL
/var/lib/postgresql/

# MongoDB
/var/lib/mongodb/
```

## /var/www - Web Content

Traditional location for web server content:

```
/var/www/
├── html/               # Default web root
│   └── index.html
├── example.com/        # Virtual host
└── blog.example.com/   # Another virtual host
```

**Note**: Modern FHS recommends `/srv/www` instead, but `/var/www` is still widely used.

## /var/run and /var/lock

On modern systems, these are symlinks:

```bash
/var/run → /run
/var/lock → /run/lock
```

Maintained for backward compatibility.

## Disk Usage Management

### Check Usage
```bash
# Total /var size
du -sh /var

# By subdirectory
du -sh /var/* | sort -h

# Largest files
find /var -type f -size +100M -ls

# Disk space
df -h /var
```

### Common Space Hogs

1. **Logs**: `/var/log`
```bash
du -sh /var/log
# Clean old logs
sudo find /var/log -name "*.gz" -mtime +30 -delete
```

2. **Package Cache**: `/var/cache/apt`
```bash
sudo apt clean
```

3. **Docker**: `/var/lib/docker`
```bash
docker system prune -a
```

4. **Systemd Journal**: `/var/log/journal`
```bash
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M
```

## Log Rotation

### Configuration
```bash
# Main config
/etc/logrotate.conf

# Per-application
/etc/logrotate.d/
├── apache2
├── nginx
├── mysql-server
└── rsyslog
```

### Example logrotate Config
```bash
# /etc/logrotate.d/myapp
/var/log/myapp/*.log {
    daily                # Rotate daily
    rotate 7             # Keep 7 days
    compress             # Compress old logs
    delaycompress        # Don't compress latest
    missingok            # OK if log missing
    notifempty           # Don't rotate if empty
    create 0644 root root # New log permissions
}
```

### Manual Rotation
```bash
# Force rotation
sudo logrotate -f /etc/logrotate.conf

# Debug mode
sudo logrotate -d /etc/logrotate.conf
```

## Monitoring /var

### Disk Space Alerts
```bash
#!/bin/bash
# Alert if /var exceeds 80%
USAGE=$(df /var | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt 80 ]; then
    echo "WARNING: /var is ${USAGE}% full!"
fi
```

### Log Monitoring
```bash
# Watch for errors
tail -f /var/log/syslog | grep -i error

# Count errors per hour
grep error /var/log/syslog | grep "$(date +%H):" | wc -l
```

## Backup Strategies

### What to Backup

✅ **Critical** (must backup):
- `/var/lib/mysql` - Databases
- `/var/lib/postgresql` - Databases
- `/var/lib/docker/volumes` - Docker volumes
- `/var/www` - Website content
- `/var/spool/cron` - Cron jobs
- `/var/mail` - Email

❓ **Optional**:
- `/var/log` - Logs (useful for forensics)
- `/var/cache` - Can be regenerated

❌ **Skip**:
- `/var/tmp` - Temporary files
- `/var/run` - Runtime data

### Backup Commands
```bash
# Databases
mysqldump --all-databases > backup.sql

# Docker volumes
docker run --rm -v myvolume:/data -v $(pwd):/backup \
  alpine tar czf /backup/volume-backup.tar.gz /data

# Web content
tar czf www-backup.tar.gz /var/www

# All of /var (selective)
tar czf var-backup.tar.gz \
  --exclude=/var/tmp \
  --exclude=/var/cache \
  --exclude=/var/run \
  /var
```

## Separate Partition for /var

### Benefits
- Prevent /var from filling root partition
- Different mount options
- Easier backup/restore
- Better I/O management

### /etc/fstab Entry
```bash
/dev/sdb1  /var  ext4  defaults,noexec,nosuid  0  2
```

### Migration
```bash
# Stop services
sudo systemctl stop apache2 mysql

# Copy to new partition
sudo rsync -avx /var/ /mnt/newvar/

# Mount new partition
sudo umount /var
sudo mount /dev/sdb1 /var

# Restart services
sudo systemctl start apache2 mysql
```

## Security Considerations

### Permissions
```bash
# /var should be root-owned
ls -ld /var
drwxr-xr-x 14 root root 4096 /var

# Log directory
ls -ld /var/log
drwxr-xr-x 10 root root 4096 /var/log

# Sensitive logs
ls -l /var/log/auth.log
-rw-r----- 1 syslog adm 12345 /var/log/auth.log
```

### Mount Options
```bash
# /etc/fstab
/dev/sdb1  /var  ext4  defaults,nosuid,nodev  0  2
```

- `nosuid` - No setuid binaries
- `nodev` - No device files
- `noexec` - No executables (can break some services)

## Troubleshooting

### Disk Full
```bash
# Find what's using space
du -sh /var/* | sort -h

# Find large files
find /var -type f -size +100M -ls

# Check inodes
df -i /var
```

### Log Files Growing
```bash
# Truncate log
sudo truncate -s 0 /var/log/syslog

# Or better, fix logrotate
sudo logrotate -f /etc/logrotate.conf
```

### Permission Denied
```bash
# Check ownership
ls -l /var/log/app.log

# Fix ownership
sudo chown syslog:adm /var/log/app.log

# Fix permissions
sudo chmod 640 /var/log/app.log
```

## Summary

- `/var` contains variable data that changes
- `/var/log` - All system and application logs
- `/var/cache` - Cacheable data (can be deleted)
- `/var/lib` - Critical application state (databases, Docker)
- `/var/tmp` - Temporary files that survive reboot
- `/var/spool` - Queued data (mail, print, cron)
- Monitor disk usage regularly
- Configure log rotation
- Backup critical data
- Consider separate partition for large deployments

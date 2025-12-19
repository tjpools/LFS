# /srv - Service Data

## Purpose
Contains data for services provided by the system. Used for data that needs to be accessed by external users or services.

## Key Characteristics
- **Service data**: Data served to external users/systems
- **Site-specific**: Content varies by what services you run
- **Organized**: Typically organized by service protocol
- **Optional**: Many systems leave this empty

## Philosophy

According to the Filesystem Hierarchy Standard (FHS):
> `/srv` contains site-specific data which is served by this system.

Think of `/srv` as the home for data your server **serves** to others.

## Typical Structure

### By Protocol
```
/srv/
├── www/              # Web server data
│   ├── html/        # Static websites
│   ├── wordpress/   # WordPress installations
│   └── api/         # API endpoints
├── ftp/              # FTP server data
│   ├── public/      # Public downloads
│   └── uploads/     # User uploads
├── git/              # Git repositories
│   ├── project1.git
│   └── project2.git
├── nfs/              # NFS exports
│   └── shared/
└── tftp/             # TFTP boot files
    └── pxeboot/
```

### By Service Name
```
/srv/
├── apache2/          # Apache web server
├── nginx/            # Nginx web server
├── samba/            # Samba file shares
├── nextcloud/        # Nextcloud data
└── gitea/            # Gitea Git hosting
```

### Hybrid Approach
```
/srv/
├── www/
│   ├── example.com/
│   ├── blog.example.com/
│   └── api.example.com/
├── git/
│   └── repos/
└── backup/
    └── snapshots/
```

## Common Use Cases

### 1. Web Server
```
/srv/www/
├── example.com/
│   ├── public_html/
│   │   ├── index.html
│   │   ├── css/
│   │   └── js/
│   └── logs/
└── blog.example.com/
    └── public_html/
```

Apache/Nginx config:
```nginx
server {
    root /srv/www/example.com/public_html;
    server_name example.com;
}
```

### 2. FTP Server
```
/srv/ftp/
├── public/           # Anonymous FTP
│   └── downloads/
└── users/           # User directories
    ├── alice/
    └── bob/
```

### 3. Git Repositories
```
/srv/git/
├── project1.git/
├── project2.git/
└── website.git/
```

Create bare repo:
```bash
sudo mkdir -p /srv/git/myproject.git
cd /srv/git/myproject.git
sudo git init --bare
```

Clone from server:
```bash
git clone user@server:/srv/git/myproject.git
```

### 4. Network File Shares
```
/srv/nfs/
├── public/          # Read-only public share
├── shared/          # Read-write team share
└── backup/          # Backup storage
```

NFS export (`/etc/exports`):
```
/srv/nfs/shared  192.168.1.0/24(rw,sync,no_subtree_check)
```

### 5. Media Server
```
/srv/media/
├── movies/
├── music/
├── photos/
└── podcasts/
```

### 6. Docker Volumes
```
/srv/docker/
├── mysql/
│   └── data/
├── postgres/
│   └── data/
└── redis/
    └── data/
```

## /srv vs Other Directories

| Directory | Purpose | Who Uses It |
|-----------|---------|-------------|
| `/srv` | Data served by the system | Web servers, FTP, Git |
| `/var/www` | Traditional web server location | Apache, Nginx |
| `/home` | User home directories | Individual users |
| `/opt` | Third-party applications | Application software |
| `/var/lib` | Application state data | Databases, Docker |

**Key Difference**: `/srv` is for data actively served to external clients.

## Traditional vs Modern

### Traditional Web Server Location
Many systems historically used:
```
/var/www/html/
```

### Modern FHS Recommendation
```
/srv/www/html/
```

### Both Work
Choose based on:
- Your distribution's conventions
- Team preferences
- Existing infrastructure

## Permissions

### Web Server
```bash
# Typical permissions
sudo chown -R www-data:www-data /srv/www/
sudo chmod -R 755 /srv/www/

# Files readable, directories executable
find /srv/www -type f -exec chmod 644 {} \;
find /srv/www -type d -exec chmod 755 {} \;
```

### FTP Server
```bash
# FTP root
sudo chown -R ftp:ftp /srv/ftp/
sudo chmod 755 /srv/ftp/

# User directories
sudo chmod 750 /srv/ftp/users/alice/
```

### Git Repositories
```bash
# Shared Git repos
sudo chown -R git:git /srv/git/
sudo chmod -R 770 /srv/git/

# Make sure group can write
sudo chmod g+s /srv/git/
```

## Setting Up Services in /srv

### Web Server Example
```bash
# Create structure
sudo mkdir -p /srv/www/mysite.com/public_html
sudo mkdir -p /srv/www/mysite.com/logs

# Set ownership
sudo chown -R $USER:www-data /srv/www/mysite.com

# Set permissions
sudo chmod -R 755 /srv/www/mysite.com

# Create simple page
echo "<h1>Hello from /srv</h1>" | \
  sudo tee /srv/www/mysite.com/public_html/index.html
```

### Git Server Example
```bash
# Create Git user
sudo useradd -r -m -d /srv/git -s /bin/bash git

# Create repository
sudo -u git mkdir /srv/git/myrepo.git
sudo -u git git init --bare /srv/git/myrepo.git

# Access via SSH
git clone git@server:/srv/git/myrepo.git
```

### FTP Server Example
```bash
# Install vsftpd
sudo apt install vsftpd

# Configure
sudo vim /etc/vsftpd.conf
# Set: anon_root=/srv/ftp/public
# Set: local_root=/srv/ftp/users/$USER

# Create directories
sudo mkdir -p /srv/ftp/public
sudo mkdir -p /srv/ftp/users

# Set permissions
sudo chown ftp:ftp /srv/ftp/public
sudo chmod 755 /srv/ftp/public
```

## Backup Considerations

### What to Backup
```bash
# All service data
sudo tar -czf srv_backup.tar.gz /srv/

# Specific services
sudo tar -czf www_backup.tar.gz /srv/www/
sudo tar -czf git_backup.tar.gz /srv/git/
```

### Automated Backups
```bash
#!/bin/bash
# Backup /srv daily
BACKUP_DIR="/backup/srv"
DATE=$(date +%Y%m%d)

sudo rsync -av --delete /srv/ "$BACKUP_DIR/$DATE/"
```

### Separate Partition
Consider mounting `/srv` on separate partition:
```bash
# /etc/fstab
/dev/sdb1  /srv  ext4  defaults  0  2
```

Benefits:
- Easier to expand storage
- Isolate service data
- Separate backup strategy
- Better disk quotas

## Storage Management

### Check space usage
```bash
# Total usage
du -sh /srv

# By service
du -sh /srv/*

# Detailed breakdown
du -h /srv/ | sort -h
```

### Monitor disk space
```bash
# Current usage
df -h /srv

# Watch in real-time
watch -n 5 df -h /srv
```

### Quotas
Set quotas if needed:
```bash
# Enable quotas
sudo quotacheck -cum /srv
sudo quotaon /srv

# Set user quota
sudo setquota -u www-data 10G 12G 0 0 /srv
```

## Security Best Practices

### Permissions
✅ **Do:**
- Use appropriate ownership (www-data, git, etc.)
- Restrict write access (755 for dirs, 644 for files)
- Use group permissions for team access
- Enable SELinux/AppArmor contexts

❌ **Don't:**
- Use 777 permissions
- Run services as root
- Store sensitive data unencrypted
- Mix data from different security contexts

### Isolation
```bash
# Separate mount with restrictions
# /etc/fstab
/dev/sdb1  /srv  ext4  defaults,noexec,nosuid  0  2
```

### Firewall
```bash
# Only allow web traffic
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

## Common Patterns

### Multi-tenancy
```
/srv/www/
├── customer1/
│   ├── site1.com/
│   └── site2.com/
└── customer2/
    └── site3.com/
```

### Staging vs Production
```
/srv/
├── production/
│   └── www/
│       └── mysite.com/
└── staging/
    └── www/
        └── mysite-staging.com/
```

### Version Control
```
/srv/www/mysite.com/
├── current → releases/v1.2.3/
├── releases/
│   ├── v1.2.1/
│   ├── v1.2.2/
│   └── v1.2.3/
└── shared/
    ├── uploads/
    └── config/
```

## Real-World Examples

### WordPress Site
```
/srv/www/blog.example.com/
├── public_html/
│   ├── wp-content/
│   │   ├── themes/
│   │   ├── plugins/
│   │   └── uploads/
│   ├── wp-config.php
│   └── index.php
└── logs/
    ├── access.log
    └── error.log
```

### GitLab-like Setup
```
/srv/git/
├── repositories/
│   ├── user1/
│   │   └── project1.git/
│   └── user2/
│       └── project2.git/
└── uploads/
```

### Nextcloud Instance
```
/srv/nextcloud/
├── data/
│   └── username/
│       └── files/
├── config/
└── apps/
```

## Troubleshooting

### Permission Denied
```bash
# Check ownership
ls -ld /srv/www

# Fix ownership
sudo chown -R www-data:www-data /srv/www

# Check permissions
ls -la /srv/www/

# Fix permissions
sudo chmod -R 755 /srv/www/
```

### Disk Full
```bash
# Find large files
sudo find /srv -type f -size +100M

# Check what's using space
sudo du -sh /srv/* | sort -h

# Clean up if needed
sudo find /srv -type f -name "*.log" -mtime +30 -delete
```

### SELinux Issues
```bash
# Check context
ls -Z /srv/www

# Fix context
sudo restorecon -R /srv/www

# Or set permanently
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/www(/.*)?"
sudo restorecon -R /srv/www
```

## Summary

Key takeaways:
- `/srv` is for data served to external clients
- Organize by protocol or service name
- Set appropriate permissions and ownership
- Consider separate partition for large deployments
- Both `/srv` and `/var/www` are acceptable (distribution-dependent)
- Plan for backups and monitoring
- Security: minimize permissions, use proper contexts

# /opt - Optional Application Software

## Purpose
Contains add-on application software packages that are not part of the default system installation. Used for third-party and proprietary software.

## Key Characteristics
- **Self-contained**: Each app in its own subdirectory
- **Optional**: Not essential for system operation
- **Third-party**: Commercial or proprietary software
- **Static**: Doesn't change with system updates

## Typical Structure

```
/opt/
├── google/
│   └── chrome/              # Google Chrome browser
├── teamviewer/              # TeamViewer remote desktop
├── sublime_text/            # Sublime Text editor
├── discord/                 # Discord chat app
├── zoom/                    # Zoom video conferencing
├── pycharm/                 # PyCharm IDE
└── lampp/                   # XAMPP web server stack
    ├── bin/
    ├── etc/
    ├── lib/
    └── share/
```

## Package Organization

Each package should be self-contained:
```
/opt/application/
├── bin/               # Executables
├── lib/               # Libraries
├── share/             # Shared data
├── etc/               # Configuration
└── doc/               # Documentation
```

## Common Software in /opt

### Development Tools
- **JetBrains IDEs**: IntelliJ IDEA, PyCharm, WebStorm
- **Visual Studio Code** (some installations)
- **Eclipse IDE**
- **Android Studio**

### Commercial Software
- **Google Chrome** (sometimes)
- **Slack**
- **Zoom**
- **TeamViewer**
- **Dropbox**

### Server Stacks
- **XAMPP/LAMPP** - Apache, MySQL, PHP stack
- **Oracle Database**
- **IBM WebSphere**

### Games
- **Steam** games
- Proprietary game installations

## Installation Methods

### Manual Installation
```bash
# Download and extract
sudo mkdir -p /opt/myapp
sudo tar -xzf myapp.tar.gz -C /opt/myapp

# Create symbolic link to binary
sudo ln -s /opt/myapp/bin/myapp /usr/local/bin/myapp
```

### Package Managers
```bash
# Some packages install to /opt automatically
sudo apt install google-chrome-stable
# Installs to /opt/google/chrome/

# Snap packages often use /opt
sudo snap install pycharm-professional
```

### Installer Scripts
```bash
# Many third-party installers target /opt
sudo ./install.sh --prefix=/opt/application
```

## Accessing Installed Software

### Add to PATH
```bash
# In ~/.bashrc or ~/.profile
export PATH="/opt/application/bin:$PATH"

# System-wide in /etc/profile.d/
echo 'export PATH="/opt/application/bin:$PATH"' | \
  sudo tee /etc/profile.d/application.sh
```

### Create Symlinks
```bash
# Link binary to system path
sudo ln -s /opt/application/bin/app /usr/local/bin/app
```

### Desktop Launchers
Create `.desktop` file in `/usr/share/applications/`:
```ini
[Desktop Entry]
Name=My Application
Exec=/opt/myapp/bin/myapp
Icon=/opt/myapp/share/icon.png
Type=Application
Categories=Development;
```

## /opt vs Other Directories

| Directory | Purpose | Managed By |
|-----------|---------|------------|
| `/opt` | Third-party, self-contained apps | Manual / Vendor |
| `/usr` | System-provided programs | Package manager |
| `/usr/local` | Locally compiled software | Administrator |
| `~/.local` | User-installed applications | User |

## Filesystem Hierarchy Standard

According to FHS:
- Large packages should go in `/opt/<package>`
- Or in `/opt/<provider>/<package>` for vendor-specific software

Examples:
- `/opt/google/chrome` (vendor/product)
- `/opt/kde3` (just product)

## Managing /opt Software

### List installed software
```bash
ls -la /opt
du -sh /opt/*
```

### Update software
Most /opt software has its own update mechanism:
```bash
# Check for built-in updaters
/opt/application/bin/updater

# Or download new version manually
```

### Remove software
```bash
# Simply remove directory (usually)
sudo rm -rf /opt/application

# Don't forget to remove symlinks
sudo rm /usr/local/bin/app

# And desktop files
sudo rm /usr/share/applications/app.desktop
```

## Real-World Examples

### Google Chrome
```
/opt/google/chrome/
├── chrome                 # Main binary
├── chrome-wrapper        # Wrapper script
├── lib*.so               # Libraries
└── locales/              # Translations
```

### JetBrains PyCharm
```
/opt/pycharm/
├── bin/
│   ├── pycharm.sh       # Startup script
│   └── fsnotifier       # File watcher
├── lib/                  # Java libraries
├── plugins/              # IDE plugins
└── help/                 # Documentation
```

### XAMPP/LAMPP
```
/opt/lampp/
├── bin/                  # Apache, MySQL binaries
├── htdocs/              # Web root
├── etc/                 # Config files
├── lib/                 # Libraries
└── logs/                # Log files
```

## Configuration Files

### Application Configs
- Stored in `/opt/application/etc/`
- Or in `/etc/opt/application/`

### User Configs
- Usually in `~/.config/application/`
- Follows XDG standards

## Permissions

### Typical Ownership
```bash
# Owned by root
sudo chown -R root:root /opt/application

# World-readable, root-writable
sudo chmod -R 755 /opt/application
```

### Special Cases
Some apps need specific permissions:
```bash
# Allow regular users to run
sudo chmod 755 /opt/application/bin/app

# Restrict configuration
sudo chmod 600 /opt/application/etc/config
```

## Best Practices

✅ **Do:**
- Keep each application in its own directory
- Document custom installations
- Create symlinks to `/usr/local/bin` for CLI tools
- Backup before updates
- Use version numbers in directory names: `/opt/myapp-1.2.3`

❌ **Don't:**
- Mix files from different applications
- Install system libraries here (use `/usr/local/lib`)
- Store user data here (use `/var` or `~`)
- Modify package-managed files

## Backup and Migration

### Backup
```bash
# Backup entire /opt
sudo tar -czf opt_backup.tar.gz /opt

# Backup specific application
sudo tar -czf myapp_backup.tar.gz /opt/myapp
```

### Migration to new system
```bash
# Copy to new system
sudo tar -xzf opt_backup.tar.gz -C /

# Restore symlinks
sudo ln -s /opt/myapp/bin/myapp /usr/local/bin/myapp

# Restore desktop files
sudo cp /opt/myapp/share/*.desktop /usr/share/applications/
```

## Troubleshooting

### Application won't start
```bash
# Check executable permissions
ls -l /opt/application/bin/app

# Check for missing libraries
ldd /opt/application/bin/app

# Check logs
tail -f /opt/application/logs/error.log
```

### Path issues
```bash
# Verify PATH includes /opt
echo $PATH

# Check symlinks
ls -l /usr/local/bin/app

# Run with full path
/opt/application/bin/app
```

## Modern Alternatives

While `/opt` is still used, modern alternatives include:

- **Flatpak**: `/var/lib/flatpak/`
- **Snap**: `/snap/`
- **AppImage**: Run from any location
- **Docker**: Containerized applications

These provide better isolation and easier management.

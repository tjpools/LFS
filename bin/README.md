# /bin - Essential User Binaries

## Purpose
Contains essential command binaries that are required for the system to boot and run in single-user mode. These commands must be available to all users.

## Key Characteristics
- **Essential**: Required for basic system functionality
- **Available to all users**: No special permissions needed
- **Static**: Generally doesn't change often
- **Small executables**: Basic utilities only

## Common Contents

### File Management
- `ls` - List directory contents
- `cp` - Copy files and directories
- `mv` - Move/rename files
- `rm` - Remove files
- `mkdir` - Make directories
- `rmdir` - Remove directories
- `touch` - Create empty files

### Text Processing
- `cat` - Concatenate and display files
- `grep` - Search text patterns
- `sed` - Stream editor
- `more`, `less` - Text file viewers

### System
- `bash`, `sh` - Shell interpreters
- `echo` - Display text
- `pwd` - Print working directory
- `date` - Display/set date and time

### Compression
- `gzip`, `gunzip` - Compress/decompress files
- `tar` - Archive utility

## vs /usr/bin
- `/bin` → Essential for booting and single-user mode
- `/usr/bin` → Additional user commands (larger set)

## Examples
```bash
ls /bin       # List all binaries
which bash    # Shows /bin/bash
/bin/echo "Hello from /bin!"
```

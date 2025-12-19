# Linux x86-64 Assembly Quine

## What is This?

A **quine** that demonstrates the relationship between C, x86-64 assembly, and Linux!

This program:
- ✓ Prints its own source code (quine property)
- ✓ Uses inline x86-64 assembly
- ✓ Makes direct Linux system calls
- ✓ Demonstrates kernel interface

## The C-Assembly-Linux Connection

### 1. **C Language** (Structure)
- Provides high-level structure and logic
- Makes code portable and maintainable
- Chosen by Linus Torvalds for Linux kernel

### 2. **x86-64 Assembly** (Performance)
- Direct hardware instructions
- Used for performance-critical kernel code
- Inline assembly lets C call raw CPU instructions

### 3. **Linux System Calls** (Kernel Interface)
- `syscall` instruction enters kernel mode
- Direct interface to Linux kernel
- No C library overhead

## How to Build and Run

```bash
# Compile with GCC
gcc -o linux_quine linux_quine.c

# Run it
./linux_quine

# Verify it's a quine (output should match source)
./linux_quine > output.c
diff linux_quine.c output.c
# (Note: This is a simplified quine, not perfect byte-for-byte)

# See the assembly generated
gcc -S -masm=intel linux_quine.c
cat linux_quine.s
```

## What the Assembly Does

### Write Syscall (Linux System Call #1)
```asm
mov rax, 1      ; syscall number 1 = write
                ; rdi = file descriptor (already set)
                ; rsi = buffer pointer (already set)
                ; rdx = byte count (already set)
syscall         ; enter kernel mode
```

### String Length in Assembly
```asm
xor rcx, rcx                    ; counter = 0
loop:
    cmpb $0, (rdi,rcx,1)       ; compare byte with 0
    je done                     ; if zero, exit loop
    inc rcx                     ; increment counter
    jmp loop                    ; continue
done:
                                ; rcx now contains length
```

## x86-64 Linux Syscall Convention

| Register | Purpose |
|----------|---------|
| `rax` | Syscall number |
| `rdi` | Argument 1 |
| `rsi` | Argument 2 |
| `rdx` | Argument 3 |
| `r10` | Argument 4 |
| `r8` | Argument 5 |
| `r9` | Argument 6 |
| `rax` | Return value |

Clobbered by syscall: `rcx`, `r11`

## Common Linux Syscalls

| Number | Syscall | Description |
|--------|---------|-------------|
| 0 | read | Read from file descriptor |
| 1 | write | Write to file descriptor |
| 2 | open | Open file |
| 3 | close | Close file descriptor |
| 60 | exit | Terminate process |

## Why This Matters for Linux

**Linux Kernel Architecture:**
```
User Space (C programs)
    ↓ (system call)
Kernel Space (C + Assembly)
    ↓ (hardware instructions)
Hardware (x86-64 CPU)
```

1. **C provides structure**: Most of Linux kernel (~98%) is C
2. **Assembly provides speed**: Critical paths use assembly
3. **Syscalls bridge the gap**: User programs talk to kernel

## Explore Further

### View actual kernel source
```bash
# On Fedora, install kernel source
sudo dnf install kernel-devel

# View syscall implementation
less /usr/src/kernels/$(uname -r)/arch/x86/entry/syscall_64.c
```

### Disassemble the binary
```bash
objdump -d linux_quine | less
```

### Trace system calls
```bash
strace ./linux_quine
```

### Profile with perf
```bash
perf stat ./linux_quine
```

## Challenge Exercises

1. **Add color output** - Use ANSI escape codes
2. **Add more syscalls** - Try `open()`, `read()`, `close()`
3. **Pure assembly version** - Write entire program in `.s` file
4. **Make it smaller** - Optimize the quine
5. **Add error handling** - Check syscall return values

## Learning Resources

- [Linux Syscall Reference](https://filippo.io/linux-syscall-table/)
- [x86-64 Assembly Guide](https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf)
- [GCC Inline Assembly](https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html)
- [Linux Kernel Source](https://github.com/torvalds/linux)

---

**This demonstrates why Linus Torvalds chose C for Linux:**
- High-level enough to be maintainable
- Low-level enough to access hardware
- Allows inline assembly for critical sections
- Perfect balance for operating system development

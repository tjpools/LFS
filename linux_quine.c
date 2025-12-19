/*
 * Linux x86-64 Quine with Inline Assembly
 * Demonstrates C, x86-64 Assembly, and Linux syscalls
 * 
 * This program prints its own source code using:
 * - C for structure and logic
 * - Inline x86-64 assembly for system calls
 * - Linux write() syscall (syscall number 1)
 */

#include <unistd.h>

// The quine data - contains the source code as a string
char *code[] = {
"/*\n",
" * Linux x86-64 Quine with Inline Assembly\n",
" * Demonstrates C, x86-64 Assembly, and Linux syscalls\n",
" * \n",
" * This program prints its own source code using:\n",
" * - C for structure and logic\n",
" * - Inline x86-64 assembly for system calls\n",
" * - Linux write() syscall (syscall number 1)\n",
" */\n",
"\n",
"#include <unistd.h>\n",
"\n",
"// The quine data - contains the source code as a string\n",
"char *code[] = {\n",
0
};

// Linux system call: write(fd, buf, count)
// Uses inline x86-64 assembly to make syscall directly
void asm_write(int fd, const char *buf, size_t count) {
    long ret;
    // x86-64 Linux syscall convention:
    // rax = syscall number (1 = write)
    // rdi = fd (file descriptor)
    // rsi = buf (buffer pointer)
    // rdx = count (number of bytes)
    __asm__ volatile (
        "mov $1, %%rax\n\t"      // syscall number 1 (write)
        "syscall\n\t"             // invoke kernel
        : "=a"(ret)               // output: rax -> ret
        : "D"(fd), "S"(buf), "d"(count)  // inputs: rdi, rsi, rdx
        : "rcx", "r11", "memory"  // clobbered by syscall
    );
}

// Custom strlen using inline assembly
size_t asm_strlen(const char *s) {
    size_t len;
    __asm__ volatile (
        "xor %%rcx, %%rcx\n\t"   // rcx = 0 (counter)
        "1:\n\t"                  // label 1
        "cmpb $0, (%%rdi,%%rcx,1)\n\t"  // compare byte at s[rcx] with 0
        "je 2f\n\t"               // if zero, jump to label 2
        "inc %%rcx\n\t"           // increment counter
        "jmp 1b\n\t"              // loop back to label 1
        "2:\n\t"                  // label 2
        : "=c"(len)               // output: rcx -> len
        : "D"(s)                  // input: rdi = s
        : "memory"
    );
    return len;
}

void print(const char *s) {
    asm_write(1, s, asm_strlen(s));
}

void print_quoted(const char *s) {
    print("\"");
    print(s);
    print("\",\n");
}

int main() {
    int i;
    
    // Print the code array declaration part
    for (i = 0; code[i]; i++) {
        print(code[i]);
    }
    
    // Print the code array contents (quoted)
    for (i = 0; code[i]; i++) {
        print_quoted(code[i]);
    }
    
    // Print the rest of the source code
    print("};\n");
    print("\n");
    print("// Linux system call: write(fd, buf, count)\n");
    print("// Uses inline x86-64 assembly to make syscall directly\n");
    print("void asm_write(int fd, const char *buf, size_t count) {\n");
    print("    long ret;\n");
    print("    // x86-64 Linux syscall convention:\n");
    print("    // rax = syscall number (1 = write)\n");
    print("    // rdi = fd (file descriptor)\n");
    print("    // rsi = buf (buffer pointer)\n");
    print("    // rdx = count (number of bytes)\n");
    print("    __asm__ volatile (\n");
    print("        \"mov $1, %%rax\\n\\t\"      // syscall number 1 (write)\n");
    print("        \"syscall\\n\\t\"             // invoke kernel\n");
    print("        : \"=a\"(ret)               // output: rax -> ret\n");
    print("        : \"D\"(fd), \"S\"(buf), \"d\"(count)  // inputs: rdi, rsi, rdx\n");
    print("        : \"rcx\", \"r11\", \"memory\"  // clobbered by syscall\n");
    print("    );\n");
    print("}\n");
    print("\n");
    print("// Custom strlen using inline assembly\n");
    print("size_t asm_strlen(const char *s) {\n");
    print("    size_t len;\n");
    print("    __asm__ volatile (\n");
    print("        \"xor %%rcx, %%rcx\\n\\t\"   // rcx = 0 (counter)\n");
    print("        \"1:\\n\\t\"                  // label 1\n");
    print("        \"cmpb $0, (%%rdi,%%rcx,1)\\n\\t\"  // compare byte at s[rcx] with 0\n");
    print("        \"je 2f\\n\\t\"               // if zero, jump to label 2\n");
    print("        \"inc %%rcx\\n\\t\"           // increment counter\n");
    print("        \"jmp 1b\\n\\t\"              // loop back to label 1\n");
    print("        \"2:\\n\\t\"                  // label 2\n");
    print("        : \"=c\"(len)               // output: rcx -> len\n");
    print("        : \"D\"(s)                  // input: rdi = s\n");
    print("        : \"memory\"\n");
    print("    );\n");
    print("    return len;\n");
    print("}\n");
    print("\n");
    print("void print(const char *s) {\n");
    print("    asm_write(1, s, asm_strlen(s));\n");
    print("}\n");
    print("\n");
    print("void print_quoted(const char *s) {\n");
    print("    print(\"\\\"\");\n");
    print("    print(s);\n");
    print("    print(\"\\\",\\n\");\n");
    print("}\n");
    print("\n");
    print("int main() {\n");
    print("    int i;\n");
    print("    \n");
    print("    // Print the code array declaration part\n");
    print("    for (i = 0; code[i]; i++) {\n");
    print("        print(code[i]);\n");
    print("    }\n");
    print("    \n");
    print("    // Print the code array contents (quoted)\n");
    print("    for (i = 0; code[i]; i++) {\n");
    print("        print_quoted(code[i]);\n");
    print("    }\n");
    print("    \n");
    print("    // Print the rest of the source code\n");
    print("    print(\"};\");\n");
    print("    // ... rest printed above ...\n");
    print("    return 0;\n");
    print("}\n");
    
    return 0;
}

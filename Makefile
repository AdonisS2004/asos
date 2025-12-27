# prefixes
CROSS_COMPILER ?= riscv64-unknown-elf-
GCC = $(CROSS_COMPILER)gcc
AS = $(CROSS_COMPILER)as
LD = $(CROSS_COMPILER)ld
QEMU = qemu-system-riscv64

# compiler flags
CFLAGS = -Wall -Wextra -mcmodel=medany -ffreestanding
# linker flags
LGCC = /opt/homebrew/lib/gcc/riscv64-unknown-elf/15.1.0/libgc.a
LDFLAGS = -T linker.ld -L$(LGCC) -nostdlib 

# source files
SRCS_C = kernel.c
SRCS_ASM = entry.S

# object files
OBJS = $(SRCS_C:.c=.o) $(SRCS_ASM:.S=.o)

# target executable
TARGET = kernel.elf

# build
build: $(TARGET)

# run
run: $(TARGET)
	$(QEMU) -machine virt -bios none -kernel $(TARGET) -serial mon:stdio

# clean
clean:
	rm -f $(OBJS) $(TARGET)

# rule to create target executable
$(TARGET): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@
# rule to compile C files
%.o: %.c
	$(GCC) $(CFLAGS) -c $< -o $@
# rules to compile Assembly files
%.o: %.S
	$(AS) -c $< -o $@
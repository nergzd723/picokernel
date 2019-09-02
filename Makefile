NASM=nasm
# https://en.wikipedia.org/wiki/GNU_linker
LD=~/.local/binutils/bin/i386-unkown-linux-gnu-ld
# https://en.wikipedia.org/wiki/QEMU
# Virtual machine
QEMU=qemu-system-i386
GCC=gcc
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra 
ASFLAGS = -f elf
OBJECTS = loader.o \
frame_buffer.o \
pic.o \
serial_port.o \
assembly_interface.o \
interrupts.o \
kmain.o
all:
	$(NASM) $(ASFLAGS) loader.s -o loader.o
	$(NASM) $(ASFLAGS) interrupts.s -o interrupts.o
	$(NASM) $(ASFLAGS) assembly_interface.s -o assembly_interface.o
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc $(CFLAGS) pic.c -o pic.o
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc $(CFLAGS) frame_buffer.c -o frame_buffer.o
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc $(CFLAGS) serial_port.c -o serial_port.o
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc $(CFLAGS) kmain.c -o kmain.o
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -T -o picokernel.bin -ffreestanding -O2 -nostdlib $(OBJECTS) -lgcc

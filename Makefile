NASM=nasm
cc = ~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Iinclude
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
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -c pic.c -o pic.o $(CFLAGS)
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -c frame_buffer.c -o frame_buffer.o $(CFLAGS)
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -c serial_port.c -o serial_port.o $(CFLAGS)
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -c interrupts.c -o interrupts.o $(CFLAGS)
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -T -o picokernel.bin -ffreestanding -O2 -nostdlib $(OBJECTS) -lgcc

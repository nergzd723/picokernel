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
all: os.iso
%.o: %.c
	# Compile c files with gcc
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc $(CFLAGS)  $< -o $@
%.o: %.s
	# assemble s files with nasm
	$(NASM) $(ASFLAGS) $< -o $@
kernel.elf: $(OBJECTS)
	~/i686-x0r3d-elf/bin/i686-x0r3d-elf-gcc -T -o picokernel.bin -ffreestanding -O2 -nostdlib $(OBJECTS) -lgcc
os.iso: kernel.elf
	mkdir -p iso/boot/grub              # create the folder structure
	cp stage2_eltorito iso/boot/grub/   # copy the bootloader
	cp kernel.elf iso/boot/             # copy the kernel
	cp menu.lst iso/boot/grub           # copy the configuration file
	mkisofs -R                              \
          -b boot/grub/stage2_eltorito    \
          -no-emul-boot                   \
          -boot-load-size 4               \
          -A os                           \
          -input-charset utf8             \
          -quiet                          \
          -boot-info-table                \
          -o os.iso                       \
          iso
run: os.iso
	# view contents of register with `p $$eax`
	$(QEMU) -monitor stdio -cdrom $< -serial file:log/log.txt

clean:
	rm *.iso
	rm $(OBJECTS)
	rm *.elf
	rm *.out
	rm -rf iso/

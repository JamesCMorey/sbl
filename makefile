# Linker options
LD_OPTIONS = -m elf_i386 --oformat binary
LD_MBR = -Ttext=0x7C00 $(LD_OPTIONS)
LD_OS = -Ttext=0x7E00 $(LD_OPTIONS)

# Files
DISK = disk.img
MBR = mbr.out
OS = os.out

# QEMU options
QEMU = qemu-system-i386 -nographic -drive format=raw,file=$(DISK)

# Rules
all: $(DISK)

run: $(DISK)
	$(QEMU)

debug: $(DISK)
	$(QEMU) -s -S

$(DISK): $(MBR) $(OS)
	dd if=$(MBR) of=$(DISK) conv=notrunc
	dd if=$(OS)  of=$(DISK) conv=notrunc seek=1

$(MBR): mbr.o
	ld $(LD_MBR) -o $@ $<

$(OS): os.o
	ld $(LD_OS) -o $@ $<

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *.o *.out $(DISK)

d:
	gdb -ex "target remote localhost:1234"

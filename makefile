LD_OPTIONS = -Ttext=0x7C00 -m elf_i386 -entry _start --oformat binary
DISK = a.out

run:$(DISK) makefile
	qemu-system-i386 -drive format=raw,file=$(DISK)

$(DISK):main.o
	ld $(LD_OPTIONS) -o $@ $<

main.o:main.s
	as --32 $< -o $@

clean:
	rm -f main.o $(DISK)

LD_MBR_OPTIONS = -Ttext=0x7C00 -m elf_i386 --oformat binary
DISK = disk.img

MBR = mbr.out
#OS = os.out

SRCS = $(wildcard *.s)
BINS = $(SRCS:.s=.out)

run:$(DISK)
	qemu-system-i386 -drive format=raw,file=$(DISK)

debug:$(DISK)
	qemu-system-i386 -s -S -drive format=raw,file=$(DISK) &

$(DISK):$(MBR)#$(BINS)
	dd if=$(MBR) of=$(DISK) conv=notrunc

$(MBR):mbr.o
	ld $(LD_MBR_OPTIONS) -o $@ $<

%.o:%.s
	@echo "Processing $< into $@"
	as --32 $< -o $@

clean:
	rm -f *.o *.out

d:
	gdb -ex "target remote localhost:1234"

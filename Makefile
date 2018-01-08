BINARIES := ccp.bin bdos.bin bios.bin
DIFF := meld
ASM ?= z80asm

LOAD_ADDR := 0xA880

BIOS_START := 0xDB00
SCREEN_START := 0xC000
BDOS_START := 0xB280
CCP_START := 0xAA80

# Skip 1024 * 20 bytes (system sectors)
FAT_OFFSET := 0x5000

disk.qdi: cpm
	dd if=/dev/zero of=$@ bs=1024 count=$$[80*2*5]
	dd if=bootloader.bin of=$@ conv=notrunc bs=1
	dd if=ccp.bin of=$@ seek=$$[$(CCP_START) - $(LOAD_ADDR)] conv=notrunc bs=1
	dd if=bdos.bin of=$@ seek=$$[$(BDOS_START) - $(LOAD_ADDR)] conv=notrunc bs=1
	dd if=bootscreen.scr of=$@ seek=$$[$(SCREEN_START) - $(LOAD_ADDR)] conv=notrunc bs=1
	dd if=bios.bin of=$@ seek=$$[$(BIOS_START) - $(LOAD_ADDR)] conv=notrunc bs=1

	# Create 128 empty directory entries (yep, the slowest way)
	for ((e=0;e<128;e++)) \
		do \
		for ((i=0;i<16;i++)) \
		do \
			printf '\xE5'; \
		done | dd conv=notrunc bs=1 of=$@ seek=$$[$(FAT_OFFSET) + 32 * $$e] >/dev/null 2>&1; \
		echo -n .; \
	done;

cpm: $(BINARIES)

%.bin: %.asm
	$(ASM) $< -o $@ -l 2>$(<:.asm=.lst)

clean:
	-rm $(BINARIES) *.lst disk.qdi

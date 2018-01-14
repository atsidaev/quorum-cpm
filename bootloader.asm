		include "defines.inc"
		include "quorum_hw.inc"
BOOTLOADER_LENGTH:	EQU 100h
CPM_INIT_LENGTH:	EQU 100h

		org 8800h
DISK_HEADER:

LOADING_ADDR:	dw CCP_START - BOOTLOADER_LENGTH - CPM_INIT_LENGTH
ENTRY_POINT:	dw CCP_START - BOOTLOADER_LENGTH
SYSTEM_SECTORS_COUNT:db	 14h

; something
		db 0, 0, 1, 1, 1, 3

SINGLE_SIDE:	db 1
NUM_SECTORS_ON_TRACK:dw	5
TRACKS_ON_DISK?: db  50h

; Have no idea what is stored here. Need to reverse CP/M DPB structure filling code
		db 0, 28h, 0, 4, 0Fh, 0, 85h, 1
		db 7Fh,	0, 0C0h, 0, 20h, 0, 4, 0

CRC:		db  4Bh
DISK_HEADER_END:

; start with validness check
		jp	CHECK_CRC

CHECK_CRC:
		ld	hl, DISK_HEADER
		push	hl
		ld	b, DISK_HEADER_END - DISK_HEADER - 1	; length of disk header (all except the CRC byte)
		ld	a, 66h		; some initialization vector? wtf

_read_header:
		add	a, (hl)		; add contents of next memory cell to A
		inc	hl
		djnz	_read_header ; repeat until the end of the disk header
		cp	(hl)		; check	that sum equals	to the latest byte (at 0x881F)
		pop	hl
		jr	nz, EXIT_BOOT	; exit if CRC is not valid
		ld	a, e		; floppy status	set previously by ROM (0x21 for Quorum-64)
		ld	(FLOPPY_STATUS), a
		ld	a, (SYSTEM_SECTORS_COUNT)
		ld	b, a
		ld	de, NUM_SECTORS_ON_TRACK
		ld	hl, (LOADING_ADDR)
		ex	de, hl

READ_OS:
		xor	a		; read sectors starting from the first one

loc_8843:
		inc	a
		out	(PORT_WD93_SECTOR), a
		ex	de, hl
		call	READ_SECTOR
		jr	nz, EXIT_BOOT	; deselect drive and turn off the motor
		dec	b
		jr	z, ALL_READ	; if all sectors were read, execute ENTRY_POINT
		ex	de, hl		; otherwise point headers to next sector
		in	a, (PORT_WD93_SECTOR)
		cp	(hl)
		jr	c, loc_8843
		ld	a, (SINGLE_SIDE)
		or	a
		jr	z, NEXT_TRACK	; if only one side then	simply go to next track
		ld	a, (FLOPPY_STATUS) ; otherwise check side
		bit	4, a		; check	bottom side
		jr	nz, _select_top_side

_select_bottom_side:			; bottom disk side
		set	4, a
		ld	(FLOPPY_STATUS), a
		out	(PORT_FDD_STATUS), a
		jr	READ_OS		; read sectors starting	from first one

_select_top_side:
		res	4, a
		ld	(FLOPPY_STATUS), a
		out	(PORT_FDD_STATUS), a

NEXT_TRACK:
		ld	a, 58h ; 'X'    ; WD1793 Step In command
		call	STEP_IN
		jr	READ_OS		; read sectors starting	from first one

ALL_READ:
		ld	hl, (ENTRY_POINT)
		jp	(hl)		; start CP/M

EXIT_BOOT:
		ld	a, 0		; deselect drive and turn off the motor
		out	(PORT_FDD_STATUS), a
		out	(PORT_MEMORY0), a		; switch lower memory to ROM
		jp	0		; reset

READ_SECTOR:
		ld	a, 80h
		out	(PORT_WD93_COMMAND_STATUS), a	; read sector
		call	_delay
		ld	c, 83h
		call	READ_DATA
		in	a, (PORT_WD93_COMMAND_STATUS)
		and	1Dh
		ret

READ_DATA:
		in	a, (PORT_WD93_COMMAND_STATUS)
		rrca
		ret	nc
		rrca
		jr	nc, READ_DATA
		ini
		jr	READ_DATA

STEP_IN:
		out	(PORT_WD93_COMMAND_STATUS), a
		call	_delay
_step_in_l:
		in	a, (PORT_WD93_COMMAND_STATUS)
		rrca			; check	BUSY flag
		ret	nc
		jr	_step_in_l

_delay:
		xor	a

_delay_l:
		dec	a
		nop
		jr	nz, _delay_l
		ret
; End of function _delay
FLOPPY_STATUS:	db 0

_some_garbage: ;?
		db 32h,	0B3h, 88h, 3Ah,	4, 88h,	47h, 11h
		db 0Ch,	88h, 2Ah, 0, 88h, 0EBh,	0AFh, 3Ch
		db 0D3h, 82h, 0EBh, 0CDh, 86h, 88h, 20h, 31h
		db 5, 28h, 2Ah,	0EBh, 0DBh, 82h, 0BEh, 38h
		db 0EEh, 3Ah, 0Bh, 88h,	0B7h, 28h, 17h,	3Ah
		db 0B3h, 88h, 0CBh, 67h, 20h, 9, 0CBh, 0E7h
		db 32h,	0B3h, 88h, 0D3h, 85h, 18h, 0D7h, 0CBh
		db 0A7h, 32h, 0B3h, 88h, 0D3h, 85h, 3Eh, 58h
		db 0CDh, 0A2h, 88h, 18h, 0C9h, 2Ah, 2, 88h
		db 0E9h, 3Eh, 0, 0D3h

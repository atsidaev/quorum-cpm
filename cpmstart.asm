		include "defines.inc"
		include "quorum_hw.inc"

CPM_INIT_LENGTH:	EQU 100h
AINTM1:	EQU 0038h

; BIOS and CCP addresses
NP_END:	EQU 0Ef31h
CONOUT: EQU 0DB0Ch
BOOTCMD:EQU 0AA87h
BUFD1:	EQU 0F800h

		ORG CCP_START - CPM_INIT_LENGTH

CPM_START:
		di
		ld	sp, CPM_START
		ld	a, 3
		out	(PORT_MEMORY0), a
		ld	bc, PORT_CPM
		ld	a, 84h
		out	(c), a
		ld	hl, BUFD1 ; some unused (yet) address
		ld	b, 7Fh		; high of PORT_ZX128
		ld	a, 1Fh		; page 7
		out	(c), a
		ld 	(hl), a
		ld 	a, 5Fh	; D0 | D1 | D2 | SCR_P | EX_RAM - enable 256k mode
		out	(c), a	; if we have 128k only then we overwrite 0x1F there with 0x5F
		ld	(hl), a
		ld	a, 19h		; page 0
		out	(c), a
		ld	(hl), a
		ld	a, 1Fh
		out	(c), a
		cp	(hl)	; check	if 7 page still contains 0x1F. This is true for 256k+ only
		ld	a, 0Ch	; 12 pages for ram-disk (192k)
		jr	z, loc_A8B4
		ld	a, (hl)
		cp	19h		; 0x19 can be there only if we have 64k of RAM total
		ld	a, 4	; otherwise we can alloc 4 pages for ram-disk (64k)
		jr	nz, loc_A8B4
		xor	a		; no ram-disk

loc_A8B4:
		ld      (NP_END), a
		or      a
		push    af
		ld      hl, 0
		jr      z, DONE_WITH_RAMDISK

; Fill catalog record of ramdisk
		ld      a, 19h
		out     (c), a
		ld      hl, 0C000h
		ld      de, 400h

loc_A8C8:
		ld      (hl), 0E5h
		inc     hl
		dec     de
		ld      a, e
		or      d
		jr      nz, loc_A8C8
		ld      a, 1Fh
		out     (c), a
		ld      hl, 0DB60h ; some address in BIOS?

DONE_WITH_RAMDISK:
		pop     af
		ld      (0DBAFh), hl ; another address in BIOS
		ld      hl, 0
		jr      z, loc_A8EB
		inc     a
		ld      de, 10h

loc_A8E4:
		dec     a
		jr      z, loc_A8EA
		add     hl, de
		jr      loc_A8E4

loc_A8EA:
		dec     hl

loc_A8EB:
		ld	(0DBA1h), hl
		ld	a, 0C3h ; JP
		ld	(AINTM1), a	; injecting IM1	vector opcode
		ld	hl, 0DB33h	; injecting IM1	vector address
		ld	(AINTM1 + 1), hl
		im	1
		ld	a, (0EF14h)
		out	(0FEh),	a
		ld	hl, LINE1
		call	PRINT
		ld	hl, DISK_NAME
		call	PRINT
		ld	hl, LINE2
		call	PRINT
		ld	hl, CMD_LENGTH
		ld	a, (hl)
		or	a
		jr	z, loc_A9E7
		ld	de, BOOTCMD
		ld	bc, 20h
		ldir

loc_A9E7:
		jp	BIOS_START ; BOOT vector is the first BIOS command

PRINT:
		ld	a, (hl)
		or	a
		ret	z
		ld	c, a
		call CONOUT
		inc	hl
		jr	PRINT

		db 0, 0

LINE1:		db 1Bh,	81h, 82h, 1Bh, 42h, 1, 0, 0 	; move cursor somewhere
LINE2:		db 1Bh,	96h, 80h, 0, 0,	0, 0, 0  ; move cursor to (x,y=)(16,0) ?
DISK_NAME: db 'Quorum CP/M-80 2.2', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
CMD:

;; start NC.COM
;CMD_LENGTH:	db 2
;CMD_NAME:	db 'NC', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;			db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; go directly to CCP
CMD_LENGTH:	db 0
CMD_NAME:	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

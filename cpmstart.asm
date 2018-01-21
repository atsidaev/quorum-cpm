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
		ld	b, 7Fh		; high of PORT_ZX128
		push bc
		ld	hl, 0FFFFh
		ld	a, 1Fh		; page 7
		out	(c), a
		ld 	(hl), a
		ld 	a, 5Fh	; D0 | D1 | D2 | SCR_P | EX_RAM - enable 256k mode
		out	(c), a	; if we have 128k only then we overwrite 0x1F there with 0x5F
		ld	(hl), a
		ld	a, 19h		; page 0
		out	(c), a
		ld e,(hl)	
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
		jr z,_im1_set

; Fill catalog record of ramdisk
_ramdisk_cat:
		ld      a, 19h
		out     (c), a
		ld (hl),e
		ld      hl, 0C000h
		ld      de, 1fh
_ramdisk_cat_l0:
		ld a,(hl)
		cp 0e5h
		jr z,_ramdisk_cat_l1
		cp 020h
		jr nc,_ramdisk_cat_l2
_ramdisk_cat_l1:
		inc hl
		ld a,(hl)
		cp 020h
		jr c,_ramdisk_cat_l2
		add hl,de
		ld a,h
		cp 0c4h
		jr c,_ramdisk_cat_l0
		jr _set_page_7
_ramdisk_cat_l2:
		ld hl,0c000h
		ld de,0c001h
		ld bc,003ffh
		ld (hl), 0E5h
		ldir
_set_page_7:
		pop bc
		ld      a, 1Fh
		out     (c), a
_im1_set:
		ld      a, 0C9h ; some address in BIOS?
		ld	(AINTM1), a	; injecting IM1	vector opcode
		im	1
		ld	hl, LINE1
		call	PRINT
		ld	hl, DISK_NAME
		call	PRINT
		ld	hl, LINE2
		call	PRINT
		ld	hl, CMD_LENGTH
		ld	de, BOOTCMD
		ld	a, (hl)
		or	a
		jr	z, _im1_set_end
		ld	bc, 20h
		ldir
		xor a
_im1_set_end:
		ld (de),a
		jp	BIOS_START ; BOOT vector is the first BIOS command

PRINT:
		ld	a, (hl)
		or	a
		ret	z
		ld	c, a
		call CONOUT
		inc	hl
		jr	PRINT

		db 0, 0, 0, 0, 0, 0, 0, 0, 0

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

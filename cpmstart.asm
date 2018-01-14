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
		jr	loc_A98D

; simple delay loop only, isn't it?
IM1:
		push	af
		xor	a
loc_A988:
		dec	a
		jr	nz, loc_A988
		pop	af
		ret

loc_A98D:
		ld	a, 3
		out	(PORT_MEMORY0), a
		ld	bc, PORT_CPM
		ld	a, 84h
		out	(c), a
		ld	hl, BUFD1
		ld	bc, PORT_ZX128
		ld	a, 1Fh		; page 7
		out	(c), a
		ld	(hl), a
		ld	a, 19h		; page 0
		out	(c), a
		ld	(hl), a
		ld	a, 1Fh
		out	(c), a
		cp	(hl)		; check	if page	switched
		ld	a, 4
		jr	z, loc_A9B2	; go if	128k+ found
		xor	a

loc_A9B2:
		ld	(NP_END), a
		ld	a, 0C3h ; JP
		ld	(AINTM1), a	; injecting IM1	vector opcode
		ld	hl, IM1		; injecting IM1	vector address
		ld	(AINTM1 + 1), hl
		im	1
		ld	a, 1
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

		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0

LINE1:		db 1Bh,	81h, 82h, 1Bh, 42h, 1, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0	; move cursor somewhere
LINE2:		db 1Bh,	96h, 80h, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0 ; move cursor to (x,y=)(16,0) ?
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

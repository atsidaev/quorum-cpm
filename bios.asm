	INCLUDE "defines.inc"

SCREEN1:	EQU 0C000h
BANK_SWITCH_0040: EQU 40h
word_4:	EQU 0004h
AINTM1:	EQU 0038h
AINTM2:	EQU 0035h
SPBIOS: EQU	0F000H
BUF_ED: EQU	0BF80H

unk_F99A: EQU 0F99Ah ; wtf? CALL here

	ORG 0DB00H
BOOT:		jp	_BOOT
WBOOT:		jp	_WBOOT
CONST:		jp	_CONST
CONIN:		jp	_CONIN
CONOUT:		jp	_CONOUT
SYSTEM:		jp	_SYSTEM
PUNCH:		jp	0
READER:		jp	0
HOME:		jp	_HOME
SETDSK:		jp	_SETDSK
SETTRK:		jp	_SETTRK
SETSEC:		jp	_SETSEC
SETDMA:		jp	_SETDMA
READ:		jp	_READ
WRITE:		jp	_WRITE
LISTST:		jp	_LISTST
SECTRAN:	jp	_SECTRAN

INT1_HANDLER:
		jp	loc_DC97
INT2_HANDLER:
		jp	loc_DC9C
		jp	0
		db    0
word_DB3D:	dw 0AA7Dh
		db    0
		db    0
		db    0
		db  4Eh
		db    0
		db    0
		db    0
		db    0
		db    0
		db  80h
		db 0F6h
		db  77h
		db 0DBh
		db  96h
		db 0F7h
		db    0
		db 0F7h
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		dw 8000h
		db 0F6h
		db  8Dh
		db 0DBh
		db 0B6h
		db 0F7h
		db  32h
		db 0F7h
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  80h
		db 0F6h
		db  9Ch
		db 0DBh
		db 0D6h
		db 0F7h
		db  64h
		db 0F7h
		db    1
		db    5
		db    1
		db    3
		db    2
		db    1
byte_DB76:	db 0FFh
		db  28h
		db    0
		db    4
		db  0Fh
		db    0
		db  85h
		db    1
		db  7Fh
		db    0
		db 0C0h
		db    0
		db  20h
		db    0
		db    4
		db    0
		db    1
		db    5
		db    1
		db    2
		db    0
		db    2
byte_DB8C:	db 0
		db  14h
		db    0
		db    4
		db  0Fh
		db    1
		db 0C3h
		db    0
		db  7Fh
		db    0
		db 0C0h
		db    0
		db  20h
		db    0
		db    2
		db    0
		db  80h
		db    0
		db    3
		db    7
		db    0
		dw 3Fh
		db  1Fh
		db    0
		db  80h
		db    0
		db    0
		db    0
		db    0
		db    0
_BOOT:
		di
		ld	sp, 80h
		xor	a
		ld	(word_4), a
		ld	de, (word_DB3D)
		push	de
		ld	hl, 5
		call	INJECT_JUMP
		pop	hl
		ld	de, BDOS_START
		call	INJECT_JUMP
		call	sub_E01B
		ld	hl, CCP_START
		push	hl
		jr	loc_DBD6
_WBOOT:
		di
		ld	sp, 80h
		ld	hl, CCP_START + 3
		push	hl
loc_DBD6:
		xor	a
		ld	(byte_DB76), a
		ld	(byte_DB8C), a
		ld	(byte_E0D3), a
		ld	(byte_E0D2), a
		ld	hl, AINTM2
		ld	(AIM2),	hl
		ld	de, INT2_HANDLER
		call	INJECT_JUMP
		ld	hl, AINTM1
		ld	de, INT1_HANDLER
		call	INJECT_JUMP
		ld	hl, 0
		ld	de, WBOOT
		call	INJECT_JUMP
		ld	a, 0C3h
		ld	hl, DOPINT
		cp	(hl)
		jr	z, loc_DC0B
		ld	(hl), 0C9h
loc_DC0B:
		ld	a, 0E7h
		ld	i, a
		im	2
		ld	a, (CCP_START + 6)
		cp	7Fh
SET_BDOS_VECTOR:
		call	z, sub_DC37
		call	sub_DC32
		ld	a, (word_4)
		ld	c, a
		ret
INJECT_JUMP:
		ld	(hl), 0C3h
		inc	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
		ret
sub_DC28:
		ld	a, (hl)
		inc	hl
		or	a
		ret	z
		ld	c, a
		call	CONOUT
		jr	sub_DC28
sub_DC32:
		ld	hl, unk_DC7D
		jr	loc_DC3A
sub_DC37:
		ld	hl, word_DC5E
loc_DC3A:
		ld	a, (hl)
		inc	hl
		cp	45h
		ret	z
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		cp	52h
		jr	z, loc_DC52
		cp	53h
		ret	nz
		ld	c, (hl)
		inc	hl
		ld	b, (hl)
		inc	hl
		ldir
		jr	loc_DC3A
loc_DC52:
		ld	b, (hl)
		inc	hl
		ld	a, (hl)
		inc	hl
		ex	de, hl
loc_DC57:
		ld	(hl), a
		inc	hl
		djnz	loc_DC57
_SELDSK:
		ex	de, hl
		jr	loc_DC3A
word_DC5E:	dw 853h
		db 0ABh
		db    4
		db    0
		db  88h
		db 0AAh
		db    0
		db    0
		db  52h
		db 0D5h
		db 0B1h
		db  5Bh
		db    0
		db  53h
		db 0D7h
		db 0B1h
		db  0Bh
		db    0
		db  24h
		db  24h
		db  24h
		db  20h
		db  20h
		db  20h
		db  20h
		db  20h
		db  53h
		db  55h
		db  42h
		db  45h
unk_DC7D:	db  53h
		db  7Dh
		db 0B5h
		db    3
		db    0
		db    0
		db    2
		db    0
		db  52h
		db  81h
		db 0B5h
		db  49h
		db    0
		db  52h
		db 0BBh
		db 0BFh
		db  45h
		db    0
		db  53h
		db 0BFh
		db 0BFh
		db    2
		db    0
		db  80h
		db    0
		db  45h
loc_DC97:
		push	af
		ld	a, 1
		jr	loc_DC9F
loc_DC9C:
		push	af
		ld	a, 2
loc_DC9F:
		ld	(3Dh), a ; wtf
		push	hl
		push	de
		push	bc
		ld	hl, FRAMES
		ld	b, 4
loc_DCAA:
		inc	(hl)
		jr	nz, loc_DCB0
		inc	hl
		djnz	loc_DCAA
loc_DCB0:
		call	sub_E58E
		call	sub_E103
		ld	hl, COUNMO
		dec	(hl)
		jr	nz, loc_DCC2
		xor	a
		out	(85h), a
		ld	(MFDCUP), a
loc_DCC2:
		call	DOPINT
		pop	bc
		pop	de
		pop	hl
		pop	af
		ei
		ret
_SETDSK:
		ld	a, c
loc_DCCC:
		cp	3
		jr	c, loc_DCD5
		xor	a
		ld	l, a
		ld	h, a
		inc	a
		ret
loc_DCD5:
		ld	hl, word_DCFC
		ld	(byte_E0D5), a
		ld	b, 0
		add	hl, bc
		add	hl, bc
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ld	a, c
		cp	2
		ret	z
		push	hl
		ld	bc, 0Ah
		add	hl, bc
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		dec	hl
		ld	a, (hl)
		dec	hl
		ld	(word_E0DF), hl
		inc	a
		call	nz, sub_DEA3
		pop	hl
		ret
word_DCFC:	dw 0DB40h
		dw 0DB50h
		dw 0DB60h
_HOME:
		ld	c, 0
_SETTRK:
		ld	a, c
		ld	(word_E0D9), a
		ret

_SETSEC:
		ld	a, c
		ld	(word_E0D9+1), a
		ret
_SECTRAN:
		ld	h, b
		ld	l, c
		inc	hl
		ret

_SETDMA:
		ld	l, c
		ld	h, b
		ld	(word_E0DB), hl
		ret
_READ:
		ld	a, (byte_E0D5)
		cp	2 			; Is RAM DISK?
		jp	z, loc_E054
		call	sub_DF2B
		call	sub_DD59
		jr	z, loc_DD3E
		call	sub_DD54
		jr	nz, loc_DD32
		ld	de, BUFD2
		jr	loc_DD41
loc_DD32:
		call	sub_DD74
		call	sub_DF81
		jr	z, loc_DD3E
		xor	a
		ld	(byte_E0E6), a
loc_DD3E:
		ld	de, BUFD1
loc_DD41:
		ld	hl, (word_E0E4)
		add	hl, de
		ex	de, hl
		ld	hl, (word_E0DB)
		ex	de, hl
		ld	bc, 80h
		ldir
		ld	a, (byte_E0D4)
		or	a
		ret
sub_DD54:
		ld	hl, 0E0EBh
		jr	loc_DD5C
sub_DD59:
		ld	hl, 0E0E6h
loc_DD5C:
		ld	de, 0E0E1h
		ld	b, 3
loc_DD61:
		ld	a, (de)
		cp	(hl)
		ret	nz
		inc	de
		inc	hl
		djnz	loc_DD61
		ret
sub_DD69:
					
		ld	hl, (word_E0DF)
		ld	(word_E0E9), hl
		ld	de, 0E0EBh
		jr	loc_DD77
sub_DD74:
					
		ld	de, 0E0E6h
loc_DD77:
		ld	hl, 0E0E1h
		ld	bc, 3
		ldir
		ret
_WRITE:
		ld	a, (byte_E0D5)
		cp	2
		jp	z, loc_E05A
		ld	a, c
		push	af
		call	sub_DF2B
		pop	af
		cp	1
		jr	nz, loc_DDC2
		xor	a
		ld	(byte_E0D3), a
		call	sub_DD54
		jr	z, loc_DDA5
		call	sub_DDA8
		ret	nz
		call	sub_DDDF
		ret	nz
		jr	sub_DDA8
loc_DDA5:
		call	sub_DE1E
sub_DDA8:
		ld	a, (byte_E0D2)
		or	a
		ret	z
		xor	a
		ld	(byte_E0D2), a
		ld	hl, 0E0E9h
		call	sub_DE6E
		ld	hl, BUFD2
		call	sub_DFB7
		ret	nz
		ld	(byte_E0EB), a
		ret

loc_DDC2:
		or	a
		jr	nz, loc_DE06
		call	sub_DD54
		jr	z, sub_DE1E
		call	sub_DDA8
		ret	nz
		ld	a, (byte_E0D3)
		or	a
		jr	z, loc_DDDB
		call	sub_DE3E
		jr	nz, loc_DDDB
		jr	loc_DE1B
loc_DDDB:
		xor	a
		ld	(byte_E0D3), a
sub_DDDF:
		call	sub_DD69
		call	sub_DD59
		jr	nz, loc_DDF4
		ld	bc, 400h
		ld	hl, BUFD1
		ld	de, BUFD2
		ldir
		jr	sub_DE1E
loc_DDF4:
		call	sub_DE6B
		ld	hl, BUFD2
		call	sub_DF87
		jr	z, sub_DE1E
		push	af
		xor	a
		ld	(byte_E0EB), a
		pop	af
		ret

loc_DE06:
		call	sub_DDA8
		ret	nz
		ld	a, 0FFh
		ld	(byte_E0D3), a
		ld	a, (byte_E0D5)
		ld	(word_E0EE), a
		ld	hl, (word_E0D9)
		ld	(word_E0EE+1), hl
loc_DE1B:
		call	sub_DD69
sub_DE1E:
					
		call	sub_DD59
		jr	nz, loc_DE27
		xor	a
		ld	(byte_E0E6), a
loc_DE27:
		ld	de, BUFD2
		ld	hl, (word_E0E4)
		add	hl, de
		ex	de, hl
		ld	hl, (word_E0DB)
		ld	bc, 80h
		ld	a, 0FFh
		ld	(byte_E0D2), a
		ldir
		xor	a
		ret
sub_DE3E:
		ld	hl, (word_E0EE)
		ld	a, (byte_E0F0)
		ld	e, a
		ld	a, (byte_E0D5)
		cp	l
		ret	nz
		ld	a, (word_E0D9)
		sub	h
		ret	c
		ld	hl, (word_E0DF)
		inc	hl
		inc	hl
		jr	z, loc_DE64
		dec	a
		ret	nz
		ld	a, (word_E0D9+1)
		add	a, (hl)
loc_DE5C:
		inc	hl
		inc	hl
		inc	hl
		sub	(hl)
		cp	e
		ret	nc
		xor	a
		ret
loc_DE64:
		ld	a, (word_E0D9+1)
		cp	e
		ret	c
		jr	loc_DE5C
sub_DE6B:
					
		ld	hl, 0E0DFh
sub_DE6E:
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		out	(85h), a
		ld	(MFDCUP), a
		call	sub_DFE0
		dec	de
		inc	hl
		ld	a, (de)
		out	(81h), a
		ld	a, (hl)
		out	(83h), a
		or	a
		ld	c, 18h
		jr	nz, loc_DE8A
		ld	c, 0
loc_DE8A:
		ld	(de), a
		inc	hl
		ld	a, (hl)
		out	(82h), a
		dec	de
		dec	de
		dec	de
		dec	de
		ld	a, (de)
		and	3
		or	c
		out	(80h), a
		call	sub_E015
loc_DE9C:
		in	a, (80h)
		rrca
		jr	c, loc_DE9C
		ei
aBiosErrOnATrk03Hd0S:
		ret
sub_DEA3:
		push	hl
		ld	a, (hl)
		and	0Fh
		ld	hl, 0E0E1h
		ld	(hl), a
		xor	a
		inc	hl
		ld	(hl), a
		inc	a
		inc	hl
		ld	(hl), a
loc_DEB1:
		call	sub_DF81
		jr	z, loc_DED9
		ld	hl, aCantReadDisk
		call	sub_DC28
		call	CONIN
		jr	loc_DEB1
aCantReadDisk:
		db '\r\n* Can`t read disk *\r\n', 0
loc_DED9:
		call	sub_DD74
		ld	hl, BUFD1
		ld	a, 66h
		ld	b, 1Fh
loc_DEE3:
		add	a, (hl)
		inc	hl
		dec	b
		jr	nz, loc_DEE3
		cp	(hl)
		jr	z, loc_DEFF
		ld	hl, PARDA
		ld	a, (byte_E0D5)
		or	a
		jr	z, loc_DEF7
		ld	hl, PARDB
loc_DEF7:
		ld	de, BUFD1 + 0Ah
		ld	bc, 15h
		ldir
loc_DEFF:
		pop	hl
		push	hl
		ld	a, (MFDCUP)
		and	0CFh
		ld	(byte_E0E6), a
		ld	(hl), a
		inc	hl
		ld	(hl), 0FFh
		inc	hl
		ld	de, BUFD1 + 10h
		ld	bc, 0Fh
		ex	de, hl
		ldir
		pop	de
		xor	a
		dec	de
		ld	(de), a
		dec	de
		ld	hl, BUFD1 + 0Ah
		ld	a, (hl)
		ld	(de), a
		dec	de
		inc	hl
		ld	a, (hl)
		ld	(de), a
		dec	de
		inc	hl
		ld	a, (hl)
		ld	(de), a
		xor	a
		ret
sub_DF2B:
		ld	hl, (word_E0DF)
		ld	a, (hl)
		ld	(byte_E0E1), a
		dec	hl
		dec	hl
		ld	b, (hl)
		ld	c, 0
		ld	a, (word_E0D9+1)
		dec	a
		inc	b
		ld	d, a
		ld	e, a
loc_DF3E:
		dec	b
		jr	z, loc_DF4B
		or	a
		ld	a, e
		rra
		ld	e, a
		scf
		ld	a, c
		rla
		ld	c, a
		jr	loc_DF3E
loc_DF4B:
		ld	a, c
		and	d
		rra
		ld	(word_E0E4+1), a
		ld	a, 0
		rra
		ld	(word_E0E4), a
		dec	hl
		ld	d, (hl)
aCanTReadDisk:
		dec	d
		ld	a, (word_E0D9)
		jr	nz, loc_DF60
		rra
loc_DF60:
		ld	(byte_E0E2), a
		call	c, sub_DF78
		dec	d
		jr	nz, loc_DF72
		dec	hl
		ld	a, e
		sub	(hl)
		jr	c, loc_DF72
		ld	e, a
		call	sub_DF78
loc_DF72:
		ld	a, e
		inc	a
		ld	(byte_E0E3), a
		ret
sub_DF78:
		ld	a, (byte_E0E1)
		or	10h
		ld	(byte_E0E1), a
		ret
sub_DF81:
					
		call	sub_DE6B
		ld	hl, BUFD1
sub_DF87:
		ld	b, 3
loc_DF89:
		call	sub_DFE0
		push	hl
		di
		ld	a, 84h
		out	(80h), a
		call	sub_E015
		ld	c, 83h
		call	sub_DFAA
		pop	hl
		in	a, (80h)
		and	7Dh
		jr	z, loc_E004
		djnz	loc_DF89
loc_DFA3:
		call	sub_DFF7
		ld	a, 80h
		jr	loc_E004
sub_DFAA:
		in	a, (80h)
		rrca
		ret	nc
		rrca
		jp	nc, sub_DFAA
		ini
		jp	sub_DFAA
sub_DFB7:
		call	sub_DFE0
		di
		ld	a, 0A4h
		out	(80h), a
		call	sub_E015
		in	a, (80h)
		and	40h
		jr	nz, loc_DFA3
		ld	c, 83h
		call	sub_DFD3
		in	a, (80h)
		and	7Dh
		jr	loc_E004
sub_DFD3:
		in	a, (80h)
		rrca
		ret	nc
		rrca
		jp	nc, sub_DFD3
		outi
		jp	sub_DFD3
sub_DFE0:
					
		di
		ld	a, 64h
		ld	(COUNMO), a
		ld	a, (MFDCUP)
		bit	5, a
		jr	nz, sub_DFF7
		set	5, a
		out	(85h), a
		ld	(MFDCUP), a
		call	sub_E00A
sub_DFF7:
					
		ld	a, 0D0h
		out	(80h), a
		call	sub_E015
loc_DFFE:
		in	a, (80h)
		rrca
		jr	c, loc_DFFE
		xor	a
loc_E004:
		ld	(byte_E0D4), a
		or	a
		ei
		ret
sub_E00A:
		ld	a, (MOTDEL)
		ld	b, a
loc_E00E:
		xor	a
		call	sub_E017
		djnz	loc_E00E
		ret
sub_E015:
		ld	a, 14h
sub_E017:
		dec	a
		jr	nz, sub_E017
		ret
sub_E01B:
		ld	a, (NP_END)
		or	a
		ret	z
		call	sub_E039
		ld	hl, 400h
		ld	(BANK_SWITCH_0040 + 3), hl
		ld	hl, 0BFFFh
		ld	(hl), 0E5h
		ld	d, h
		ld	e, l
		inc	de
		ld	bc, 7FFDh
		ld	a, 19h
		jp	40h
sub_E039:
		ld	hl, BANK_SWITCH
		ld	de, BANK_SWITCH_0040
		ld	bc, BANK_SWITCH_END - BANK_SWITCH
		ldir
		ret
BANK_SWITCH:
		out     (c), a
		ld      bc, 80h
		ldir
		ld      bc, 7FFDh
		ld      a, 1Fh
		out     (c), a
		ret
BANK_SWITCH_END:

loc_E054:
		xor	a
		jr	loc_E05C

loc_E057:
		xor	a
		dec	a
		ret
loc_E05A:
		ld	a, 0FFh
loc_E05C:
		ld	(byte_E0CD), a
		ld	a, (word_E0D9)
		ld	hl, 0EF31h
		cp	(hl)
		jr	nc, loc_E057
		di
		call	sub_E039
		ld	hl, 0BF80h
		ld	de, 0F600h
		ld	bc, 80h
		ldir
		ld	c, a
		ld	hl, 0E0CEh
		add	hl, bc
		ld	a, (hl)
		push	af
		ld	a, (word_E0D9+1)
		dec	a
		rrca
		ld	e, a
		and	7Fh
		add	a, 0C0h
		ld	d, a
		ld	a, 80h
		and	e
		ld	e, a
		ld	hl, 0BF80h
		ld	a, (byte_E0CD)
		or	a
		ex	de, hl
		call	nz, sub_E0BE
		pop	af
		ld	bc, 7FFDh
		call	BANK_SWITCH_0040
		ld	a, (byte_E0CD)
		inc	a
		jr	z, loc_E0B1
		ld	de, 0BF80h
		ld	hl, (word_E0DB)
		ld	bc, 80h
		ex	de, hl
		ldir
loc_E0B1:
		ld	hl, BUF_BD
		ld	de, BUF_ED
		ld	bc, 80h
		ldir
		xor	a
		ret
sub_E0BE:
		push	hl
		ld	hl, (word_E0DB)
		push	bc
		push	de
		ld	bc, 80h
		ldir
		pop	hl
		pop	bc
		pop	de
		ret
byte_E0CD:	db 0
					
		db  19h
		db  1Bh
		db  1Ch
		db  1Eh
byte_E0D2:	db 0
byte_E0D3:	db 0
byte_E0D4:	db 0
					
byte_E0D5:	db 0
		db    0
		db    0
		db    0
word_E0D9:	dw 1404h
word_E0DB:	dw 80h
					
		db    0
		db    0
word_E0DF:	dw 0DB75h
byte_E0E1:	db 1
byte_E0E2:	db 2
byte_E0E3:	db 3
word_E0E4:	dw 180h
					
byte_E0E6:	db 1
		db    2
		db    3
word_E0E9:	dw 0DB75h
byte_E0EB:	db 0
		db    2
		db    4
word_E0EE:	dw 0
byte_E0F0:	db 0
		db  74h
		db 0DBh
		db  11h
		db  1Fh
		db    3
		db    0
		db    2
		db  11h
		db  1Fh
		db    3
		db  74h
		db 0DBh
		db    0
		db    2
		db    4
_CONOUT:
		jp	loc_E16E
sub_E103:
		ld	hl, FLCUR
		bit	7, (hl)
		ret	z
		ld	a, (FRAMES)
		ld	b, a
		and	7
		ret	nz
		bit	3, b
		ld	c, 0FFh
		set	0, (hl)
		jr	z, loc_E11B

loc_E118:
		res	0, (hl)
		inc	c
loc_E11B:
		call	sub_E15E
loc_E11E:
		ld	a, e
		rla
		rla
		rla
		and	38h
		xor	0FEh
		; injection of bit number to bit operations
		ld	(loc_E13A + 1), a
		res	6, a
		ld	(loc_E136 + 1), a
		call	sub_E149
		inc	e
		rlc	c
		jr	c, loc_E13A	; bit is injected in code
loc_E136:
		res     6, (hl)         ; bit is injected in code
		jr      loc_E13C
loc_E13A:
		set     6, (hl)         ; bit is injected in code
loc_E13C:
		djnz    loc_E11E
		ret

sub_E13F:
		ld	hl, FLCUR
		bit	0, (hl)
		ret	z
		ld	c, 0FFh
		jr	loc_E118
sub_E149:
		push	de
		pop	hl
		srl	h
		rr	l
		srl	h
		rr	l
		srl	h
		rr	l
		ld	a, d
		and	18h
		or	0C7h
		ld	h, a
		ret
sub_E15E:
		ld	de, (NUMCOL)
		ld	a, (WD_POS)
		ld	b, a
		push	bc
		xor	a
loc_E168:
		add	a, e
		djnz	loc_E168
		ld	e, a
		pop	bc
		ret
loc_E16E:
		di
		ld	(BUFSP), sp
		ld	sp, SPBIOS
		push	hl
		push	de
		push	bc
		push	af
		push	bc
		call	sub_E13F
		pop	bc
		ld	hl, 0E2A5h
		push	hl
		ld	hl, (NUMCOL)
		ld	a, (BUFESC)
		dec	a
		ld	b, a
		ld	a, c
		jp	m, loc_E271
		jp	z, loc_E245
		dec	b
		jr	z, loc_E20E
		dec	b
		jr	z, loc_E1EC
		dec	b
		jr	z, loc_E1B3
		dec	b
		jr	z, loc_E1AE
		dec	b
		jr	z, loc_E1A9
		dec	b
		jr	nz, loc_E1E5
		ld	(FLCUR), a
		jr	loc_E1E5
loc_E1A9:
		ld	(CODE),	a	; codepage
		jr	loc_E1E5
loc_E1AE:
		ld	(ATTRIB), a
		jr	loc_E1E5
loc_E1B3:
		bit	3, a
		jr	nz, loc_E1BE
		ld	(BORDER), a
		out	(0FEh),	a
		jr	loc_E1E5
loc_E1BE:
		and	3
		bit	1, a
		jr	z, loc_E1E1
		push	hl
		rra
		ld	hl, (AD_S64)
		ld	de, 4004h
		jr	c, loc_E1D4
		ld	hl, 0E3BAh
		ld	de, 2B06h
loc_E1D4:
		ld	(word_E1E3), hl
		ld	(word_E27D), hl
		ld	(WD_POS), de
		pop	hl
		jr	loc_E1E5
loc_E1E1:
		ld	c, a
		db 0CDh
word_E1E3:	dw 0E3BAh
loc_E1E5:
		xor	a
loc_E1E6:
		ld	(BUFESC), a
		jp	loc_E2A1
loc_E1EC:
		ld	de, (WD_SCR)
		inc	e
		cp	80h
		jr	c, loc_E1F7
		sub	60h
loc_E1F7:
		sub	1Fh
		cp	e
		jr	c, loc_E1FE
		ld	a, 1
loc_E1FE:
		ld	c, a
loc_E1FF:
		dec	c
		jr	z, loc_E1E5
		push	bc
		call	sub_E27F
		pop	bc
		jr	loc_E1FF
loc_E209:
		push	af
		call	sub_E2DB
		pop	af
loc_E20E:
		cp	80h
		jr	c, loc_E214
		sub	60h
loc_E214:
		sub	1Fh
		cp	1Ah
		jr	c, loc_E21C
		ld	a, 19h
loc_E21C:
		ld	c, a
loc_E21D:
		dec	c
		jr	z, loc_E227
		push	bc
		call	sub_E291
		pop	bc
		jr	loc_E21D
loc_E227:
		ld	a, 3
		ld	(BUFESC), a
		ret
loc_E22D:
		ld	a, 2
		ld	(BUFESC), a
		jp	sub_E2DB
loc_E235:
		ld	a, 4
		jr	loc_E1E6
loc_E239:
		ld	a, 5
		jr	loc_E1E6
loc_E23D:
		ld	a, 6
		jr	loc_E1E6
loc_E241:
		ld	a, 7
		jr	loc_E1E6
loc_E245:
		cp	80h
		jr	nc, loc_E209
		cp	59h
		jr	z, loc_E22D
		push	af
		xor	a
		ld	(BUFESC), a
		pop	af
		cp	45h
		jr	z, loc_E2C5
		cp	4Bh
		jp	z, loc_E370
		cp	4Ah
		jp	z, loc_E357
		cp	42h
		jr	z, loc_E235
		cp	43h
		jr	z, loc_E239
		cp	53h
		jr	z, loc_E23D
		cp	44h
		jr	z, loc_E241
loc_E271:
		ld	c, a
		cp	20h
		jr	c, loc_E2EA
loc_E276:
		push	hl
		call	sub_E395
		pop	hl
		ld	c, a
		db 0CDh
word_E27D:	dw 0E3BAh
sub_E27F:
		inc	l
		ld	a, (WD_SCR)
		dec	a
		cp	l
		jr	nc, loc_E2A1
		dec	l
		ld	a, (FLCUR)
		bit	2, a
		jr	nz, loc_E2A1
		ld	l, 0
sub_E291:
		inc	h
loc_E292:
		ld	a, h
		cp	18h
		jr	c, loc_E2A1
		ld	h, 17h
		ld	a, (FLCUR)
		bit	1, a
		call	z, sub_E49C
loc_E2A1:
		ld	(NUMCOL), hl
		ret
		pop	af
		pop	bc
		pop	de
		pop	hl
		ld	sp, (BUFSP)
		ei
		ret
loc_E2AF:
		ld	l, 0
		jr	loc_E2A1
loc_E2B3:
		ld	a, l
		cp	1
		jr	nc, loc_E2C2
		ld	a, h
		cp	1
		jr	c, loc_E292
		dec	h
		ld	a, (WD_SCR)
		ld	l, a
loc_E2C2:
		dec	l
		jr	loc_E2A1
loc_E2C5:
		ld	hl, SCREEN1
		xor	a
		ld	c, 18h
		call	sub_E2E0
		ld	a, (ATTRIB)
		ld	c, 3
		call	sub_E2E0
		ld	a, (BORDER)
		out	(0FEh),	a
sub_E2DB:
		ld	hl, 0
		jr	loc_E2A1
sub_E2E0:
		ld	b, 0
loc_E2E2:
		ld	(hl), a
		inc	hl
		djnz	loc_E2E2
		dec	c
		jr	nz, sub_E2E0
		ret
loc_E2EA:
		cp	1
		jr	z, sub_E2DB
		cp	7
		jr	z, loc_E324
		cp	8
		jr	z, loc_E2B3
		cp	0Ah
		jr	z, sub_E291
		cp	0Ch
		jr	z, loc_E2C5
		cp	0Dh
		jr	z, loc_E2AF
		cp	0Eh
		jr	z, loc_E33B
		cp	0Fh
		jr	z, loc_E349
		cp	14h
		jr	z, loc_E357
		cp	15h
		jp	z, sub_E27F
		cp	16h
		jr	z, loc_E370
		cp	18h
		jr	z, loc_E36E
		cp	1Bh
		jr	z, loc_E335
		cp	1Fh
		jr	z, loc_E2C5
		ret
loc_E324:
		ld	hl, (SCBEEP)
		ld	a, (BORDER)
loc_E32A:
		xor	10h
		out	(0FEh),	a
		ld	b, l
loc_E32F:
		djnz	$
		dec	h
		jr	nz, loc_E32A
		ret
loc_E335:
		ld	a, 1
		ld	(BUFESC), a
		ret
loc_E33B:
		ld	hl, CODE	; codepage
		bit	0, (hl)
		ret	z
		res	1, (hl)
		ld	hl, 0EF50h
		res	0, (hl)
		ret
loc_E349:
		ld	hl, CODE	; codepage
		bit	0, (hl)
		ret	z
		set	1, (hl)
		ld	hl, FLGKBD
		set	0, (hl)
		ret
loc_E357:
		ld	l, 0
		push	hl
		ld	a, (WD_SCR)
		ld	d, l
		ld	e, a
		ld	a, 17h
		sub	h
		ld	b, a
		ld	hl, 0
loc_E366:
		add	hl, de
		djnz	loc_E366
		ex	de, hl
		pop	hl
		push	hl
		jr	loc_E378
loc_E36E:
		ld	l, 0
loc_E370:
		push	hl
		ld	a, (WD_SCR)
		sub	l
		ld	d, 0
		ld	e, a
loc_E378:
		ld	a, (FLCUR)
		push	af
		or	4
		ld	(FLCUR), a
loc_E381:
		push	de
		ld	c, 20h
		call	loc_E276
		pop	de
		dec	de
		ld	a, e
		or	d
		jr	nz, loc_E381
		pop	af
		ld	(FLCUR), a
		pop	hl
		jp	loc_E2A1
sub_E395:
		ld	a, (CODE)	; codepage
		and	7
		jr	nz, loc_E39E
		ld	a, c
		ret
loc_E39E:
		dec	a
		jr	nz, loc_E3A5
		ld	a, c
		and	7Fh
		ret
loc_E3A5:
		dec	a
		jr	nz, loc_E3AF
		ld	a, c
		and	7Fh
		cp	60h
		jr	loc_E3B6
loc_E3AF:
		dec	a
		ld	a, c
		ret	nz
		and	7Fh
		cp	40h
loc_E3B6:
		ret	c
		add	a, 80h
		ret
		cp	2
		jr	c, loc_E3D5
		push	hl
		call	loc_E3E7
		push	de
		ld	a, d
		rra
		rra
		rra
		or	0D8h
		ld	d, a
		ld	a, (ATTRIB)
		ld	(de), a
		pop	de
		ld	a, c
		call	loc_E41C
		pop	hl
		ret
loc_E3D5:
		or	a
		jr	z, loc_E3DA
		ld	a, 0FCh
loc_E3DA:
		ld	(loc_E430+1), a
		ld	(loc_E43C+1), a
		ld	(loc_E466+1), a
		ld	(loc_E479+1), a
		ret
loc_E3E7:
		ld	a, l
		srl	a
		srl	a
		sub	l
		neg
		bit	5, a
		push	af
		jr	z, loc_E3F5
		dec	a
loc_E3F5:
		ld	e, a
		ld	a, h
		and	7
		rrca
		rrca
		rrca
		or	e
		ld	e, a
		pop	af
		jr	nz, loc_E402
		dec	e
loc_E402:
		ld	a, h
		and	18h
		or	0C7h
		inc	a
		ld	d, a
		inc	l
		srl	l
		jr	c, loc_E415
		srl	l
		jr	c, loc_E438
		dec	e
		jr	nc, loc_E461
loc_E415:
		srl	l
		jr	nc, loc_E474
		dec	e
		jr	loc_E491
loc_E41C:
		ld	bc, (ADDRZG)
		ld	l, a
		ld	h, 0
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, bc
		dec	h
		ld	b, 8
loc_E42A:
		jr	loc_E43C
		ld	c, 3
loc_E42E:
		ld	a, (de)
		and	c
loc_E430:
		or	0
		xor	(hl)
		ld	(de), a
		inc	d
		inc	hl
		djnz	loc_E42E
loc_E438:
		ld	a, 4Ch
		jr	loc_E494
loc_E43C:
		ld	c, 0
loc_E43E:
		ld	a, (hl)
		push	hl
		xor	c
		ld	l, a
		ld	a, (de)
		rrca
		rrca
		rrca
		rrca
		ld	h, a
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		ld	a, h
		ld	(de), a
		ld	a, e
		and	1Fh
		cp	1Fh
		jr	z, loc_E45C
		inc	e
		ld	a, (de)
		and	3Fh
		or	l
		ld	(de), a
		dec	e
loc_E45C:
		inc	d
		pop	hl
		inc	hl
		djnz	loc_E43E
loc_E461:
		ld	a, 39h
		jr	loc_E493
loc_E465:
		ld	a, (hl)
loc_E466:
		xor	0
		rra
		rra
		ld	c, a
		ld	a, (de)
		and	0C0h
		or	c
		ld	(de), a
		inc	d
		inc	hl
		djnz	loc_E465
loc_E474:
		ld	a, 0
		jr	loc_E493
loc_E478:
		ld	a, (hl)
loc_E479:
		xor	0
		ld	c, a
		ld	a, (de)
		rra
		rra
		sla	c
		rla
		sla	c
		rla
		ld	(de), a
		inc	e
		ld	a, (de)
		and	0Fh
		or	c
		ld	(de), a
		dec	e
		inc	d
		inc	hl
		djnz	loc_E478
loc_E491:
		ld	a, 10h
loc_E493:
		inc	e
loc_E494:
		ld	(loc_E42A+1), a
		ld	a, d
		sub	8
		ld	d, a
		ret
sub_E49C:
		push	hl
		ld	hl, SCREEN1
		ld	b, 3
loc_E4A2:
		push	bc
		ld	b, 7
loc_E4A5:
		push	bc
		ld	bc, 20h
		call	loc_E4E9
		ld	de, BUFD1 + 20h
		add	hl, de
		pop	bc
		djnz	loc_E4A5
		ld	bc, 720h
		call	loc_E4E9
		and	a
		sbc	hl, de
		pop	bc
		djnz	loc_E4A2
		ld	hl, 0D0E0h
		xor	a
		ld	b, 8
loc_E4C5:
		push	bc
		ld	b, 20h
loc_E4C8:
		ld	(hl), a
		inc	hl
		djnz	loc_E4C8
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_E4C5
		ld	hl, SCREEN1 + 1800h + 20h
		ld	de, SCREEN1 + 1800h
		ld	bc, 2E0h
		ldir
		ld	b, 20h
		ld	a, (ATTRIB)
loc_E4E3:
		ld	(de), a
		inc	de
		djnz	loc_E4E3
		pop	hl
		ret
loc_E4E9:
		ld	(loc_E4F3+1), bc
		ld	b, 8
loc_E4EF:
		push	bc
		ld	b, 20h
loc_E4F2:
		push	hl
loc_E4F3:
		ld	de, 720h
		add	hl, de
		pop	de
		ld	a, (hl)
		ld	(de), a
		ex	de, hl
		inc	hl
		djnz	loc_E4F2
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_E4EF
		ret
		pop	hl
		ld	de, 0FFE0h
		add	hl, de
		ex	de, hl
		pop	hl
		ret
		db  3Ah
		db  51h
_CONST:
		ld	a, (FLAGS)
		or	a
		ret	z
		ld	a, 1
		ret
_CONIN:
		ei
loc_E519:
		call	_CONST
		jr	z, loc_E519
		push	hl
		ld	hl, FLAGS
		ld	a, (hl)
		bit	6, a
		jr	z, loc_E547
		push	de
		and	3Fh
		ld	e, a
		ld	d, 0
		push	hl
		ld	hl, TFNKBD	; "DIR "
		add	hl, de
		ld	a, (hl)
		ld	(LASTK), a
		inc	hl
		ld	a, (hl)
		pop	hl
		pop	de
		inc	(hl)
		or	a
		jr	nz, loc_E540
		ld	(hl), 0
loc_E540:
		ld	a, (hl)
		and	7
		jr	nz, loc_E54E
		ld	(hl), 0
loc_E547:
		res	7, (hl)
		di
		call	sub_E776
		ei
loc_E54E:
		pop	hl
		ld	a, (LASTK)
		ret
loc_E553:
		ld	l, 2Fh
		ld	de, 0FFFFh
		ld	bc, 0FEFEh
loc_E55B:
		in	a, (c)
		cpl
		and	3Fh
		jr	z, loc_E570
		ld	h, a
		ld	a, l
loc_E564:
		inc	d
		ret	nz
loc_E566:
		sub	8
		srl	h
		jr	nc, loc_E566
		ld	d, e
		ld	e, a
		jr	nz, loc_E564
loc_E570:
		dec	l
		rlc	b
		jr	c, loc_E55B
		ld	l, 5Fh
		ld	a, c
		ld	bc, 0FE7Eh
		cp	7Eh
		jr	nz, loc_E55B
		ld	a, d
		inc	a
		ret	z
		cp	28h
		ret	z
		cp	19h
		ret	z
		ld	a, e
		ld	e, d
		ld	d, a
		cp	18h
		ret
sub_E58E:
		call	loc_E553
		ret	nz
		ld	a, (FLAGS)
		or	a
		ret	m
		ld	hl, KSTAT0
loc_E59A:
		bit	7, (hl)
		jr	nz, loc_E5A5
		inc	hl
		dec	(hl)
		dec	hl
		jr	nz, loc_E5A5
		ld	(hl), 0FFh
loc_E5A5:
		ld	a, l
		ld	hl, KSTAT4
		cp	l
		jr	nz, loc_E59A
		ld	b, d
		call	loc_E601
sub_E5B0:
		ret	nc
		ld	hl, KSTAT0
		cp	(hl)
		jr	z, loc_E5F3
		ex	de, hl
		ld	hl, KSTAT4
		cp	(hl)
CHECK_KEYBOARD:
		jr	z, loc_E5F3
		bit	7, (hl)
		jr	nz, loc_E5C6
		ex	de, hl
		bit	7, (hl)
		ret	z
loc_E5C6:
		ld	e, a
		ld	(hl), a
		inc	hl
		ld	(hl), 5
		inc	hl
		ld	a, (REPDEL)
		ld	(hl), a
		inc	hl
		ld	d, b
		push	hl
		ex	de, hl
		ld	(SCANK), hl
		ex	de, hl
		call	sub_E6AF
		pop	hl
		ld	(hl), a
loc_E5DD:
		or	a
		ret	z
		ld	c, a
		ld	a, (CODE)	; codepage
		and	3
		ld	a, c
		jr	z, loc_E5EA
		and	7Fh
loc_E5EA:
		ld	(LASTK), a
		ld	hl, FLAGS
		set	7, (hl)
		ret
loc_E5F3:
					
		inc	hl
		ld	(hl), 5
		inc	hl
		dec	(hl)
		ret	nz
		ld	a, (REPPER)
		ld	(hl), a
		inc	hl
		ld	a, (hl)
		jr	loc_E5DD
loc_E601:
		ld	a, e
		db 0FEh
		ld	e, b
		ret	nc
		cp	18h
		ret	z
		cp	27h
		ret	z
		scf
		ret

loc_E60D:
		sub	80h
		cp	10h
		jr	nc, loc_E61A
		ld	hl, TCDKBD	; "0123456789.+"
		ld	e, a
		add	hl, de
		ld	a, (hl)
		ret
loc_E61A:
		sub	10h
		rlca
		rlca
		rlca
		ld	e, a
		or	40h
		ld	(FLAGS), a
		ld	hl, TFNKBD	; "DIR "
		add	hl, de
		ld	a, (hl)
		ret
loc_E62B:
		ld	hl, FLGKBD
		cp	1
		jr	nz, loc_E638
		ld	a, (hl)
		xor	80h
		ld	(hl), a
		jr	loc_E656
loc_E638:
		cp	2
		jr	nz, loc_E649
		set	0, (hl)
		bit	5, c
		jr	z, loc_E656
		ld	a, 3
loc_E644:
		ld	(CODE),	a	; codepage
		jr	loc_E656
loc_E649:
		cp	3
		ret	nz
		res	0, (hl)
		bit	5, c
		jr	z, loc_E656
		ld	a, 1
		jr	loc_E644
loc_E656:
		call	sub_E776
		xor	a
		ret
loc_E65B:
		bit	3, b
		jr	nz, loc_E66C
		cp	2Dh
		jr	nz, loc_E666
		ld	a, 1Eh
		ret
loc_E666:
		cp	3Dh
		ret	nz
		ld	a, 1Fh
		ret
loc_E66C:
		bit	0, c
		jr	nz, loc_E68F
loc_E670:
		inc	b
		ret	z
		add	a, 10h
		cp	4Bh
		jr	nz, loc_E67B
		ld	a, 3Ah
		ret
loc_E67B:
		cp	37h
		jr	nz, loc_E682
		ld	a, 22h
		ret
loc_E682:
		cp	4Dh
		jr	nz, loc_E689
		ld	a, 2Bh
		ret
loc_E689:
		cp	3Dh
		ret	nz
		ld	a, 5Eh
		ret
loc_E68F:
		cp	3Bh
		jr	nz, loc_E697
		ld	a, 0F6h
		jr	loc_E6AD
loc_E697:
		cp	27h
		jr	nz, loc_E69F
		ld	a, 0FCh
		jr	loc_E6AD
loc_E69F:
		cp	2Ch
		jr	nz, loc_E6A7
		ld	a, 0E2h
		jr	loc_E722
loc_E6A7:
		cp	2Eh
		jr	nz, loc_E670
		ld	a, 0E0h
loc_E6AD:
		jr	loc_E722
sub_E6AF:

		ld	a, (FLGKBD)
		and	9Fh
		ld	c, a
		ld	a, (CODE)	; codepage
		and	3
		jr	z, loc_E6CE
		set	5, c
		dec	a
		jr	z, loc_E6CC
		dec	a
		jr	nz, loc_E6CE
		res	5, c
		set	6, c
		set	7, c
		jr	loc_E6CE
loc_E6CC:
		res	0, c
loc_E6CE:
		ld	hl, byte_E789
		ld	d, 0
		add	hl, de
		ld	a, (hl)
		cp	7Fh
		ret	z
		jp	nc, loc_E60D
		cp	20h
		jp	c, loc_E62B
		cp	30h
		jr	c, loc_E6EA
		cp	3Ah
		jr	c, loc_E753
		cp	40h
loc_E6EA:
		jp	c, loc_E65B
		bit	3, b
		jr	z, loc_E750
		bit	0, c
		jr	nz, loc_E716
		bit	6, c
		ret	nz
		bit	0, b
		jr	z, loc_E705
		bit	7, c
		ret	nz
		cp	5Bh
		ret	nc
		add	a, 20h
		ret
loc_E705:
		bit	7, c
		jr	z, loc_E711
loc_E709:
		add	a, 20h
		cp	80h
		ret	nz
		ld	a, 7Eh
		ret
loc_E711:
		cp	5Bh
		ret	c
		jr	loc_E709
loc_E716:
		cp	60h
		jr	z, loc_E722
		ld	hl, byte_E7E1
		sub	41h
		ld	e, a
		add	hl, de
		ld	a, (hl)
loc_E722:
					
		bit	6, c
		ret	nz
		bit	0, b
		jr	z, loc_E735
		bit	7, c
		ret	nz
		cp	60h
		ret	z
		cp	5Ch
		ret	z
		sub	20h
		ret
loc_E735:
		bit	7, c
		jr	z, loc_E743
		sub	20h
		cp	3Ch
		jr	z, loc_E747
		cp	40h
		jr	loc_E74C
loc_E743:
		cp	5Ch
		jr	nz, loc_E74A
loc_E747:
		ld	a, 7Ch
		ret
loc_E74A:
		cp	60h
loc_E74C:
		ret	nz
		ld	a, 7Eh
		ret
loc_E750:
		and	1Fh
		ret
loc_E753:
		inc	b
		ret	z
		bit	5, b
		jr	nz, loc_E76F
		sub	10h
		cp	22h
		jr	z, BEEP
		cp	27h
		jr	z, loc_E769
		cp	20h
		ret	nz
		ld	a, 5Fh
		ret
loc_E769:
		ld	a, 2Ah
		ret
BEEP:
		ld	a, 40h
		ret
loc_E76F:
		ld	e, a
		ld	hl,  TCDKBD+8
		add	hl, de
		ld	a, (hl)
		ret
sub_E776:
					
		push	bc
		ld	hl, (KBEEP)
		ld	a, (BORDER)
loc_E77D:
		xor	10h
		out	(0FEh),	a
		ld	b, l
loc_E782:
		djnz	$
		dec	h
		jr	nz, loc_E77D
		pop	bc
		ret
byte_E789:	db 42h,	48h, 59h, 36h, 35h, 54h, 47h, 56h
		db 4Eh,	4Ah, 55h, 37h, 34h, 52h, 46h, 43h
		db 4Dh,	4Bh, 49h, 38h, 33h, 45h, 44h, 58h
		db 0Eh,	4Ch, 4Fh, 39h, 32h, 57h, 53h, 5Ah
		db 20h,	0Dh, 50h, 30h, 31h, 51h, 41h, 0Eh
		db 8Bh,	83h, 5Bh, 8Ch, 8Fh, 89h, 86h, 2Eh
		db 8Ah,	2Fh, 5Dh, 8Eh, 88h, 85h, 27h, 82h
		db 80h,	76h, 7Ch, 7Fh, 8Dh, 87h, 84h, 81h
		db 62h,	60h, 5Ch, 3Dh, 8, 0FFh,	60h, 0FFh
		db 90h,	68h, 92h, 7Fh, 94h, 93h, 91h, 3
		db 0FFh, 2Ch, 3Bh, 2Dh,	1Bh, 9,	1, 2
byte_E7E1:	db 0E6h, 0E9h, 0F3h, 0F7h, 0F5h, 0E1h, 0F0h, 0F2h
		db 0FBh, 0EFh, 0ECh, 0E4h, 0F8h, 0F4h, 0FDh, 0FAh
		db 0EAh, 0EBh, 0F9h, 0E5h, 0E7h, 0EDh, 0E3h, 0FEh
		db 0EEh, 0F1h, 0E8h, 5Ch, 0FFh,	0
AIM2:		db  35h
AZNG:
		INCBIN "font6x8.chr"

		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
CODE:		db 0
					; RAM:loc_E33Bo ...
					; codepage
ATTRIB:		db 38h
BORDER:		db 7
NUMCOL:		db  16h
NUMSTR:		db  17h
ADDRZG:		dw 0E800h
BUFMEM:		db    0
BUFESC:		db 0
BUFSP:		dw 0B5BEh
FLCUR:		db 81h
ADDRSYM:	dw 0D0E4h
SCBEEP:		dw 0
MFDCUP:		db 0
COUNMO:		db 45h
DOPINT:
		ret
		db 0DAh
		db 0DCh
DATE:		db 0, 0, 0
TIME:		db 0, 0, 0, 0, 0, 0
MOTDEL:		db    4
NP_END:		db 0
WD_POS:		db    6
WD_SCR:		db  2Bh
AD_S64:		dw 0F006h
BUF_KB:		db 0D7h, 0Ah, 1, 0Ah, 1, 0Ah
		db 0, 0, 17h, 74h, 0E3h, 59h
PRN_C:		db 38h
					; PRN_ENCODE:ENCODE_KOI8r ...
KBEEP:		dw 4040h
KSTAT0:		db 0FFh, 0, 21h, 36h
KSTAT4:		db 21h,	1, 21h,	0Dh
LASTK:		db 0Dh
REPDEL:		db 23h
REPPER:		db 5
FLGKBD:		db 80h
					
FLAGS:		db 0
FRAMES:		db 25h,	0BAh, 8, 0
SCANK:		dw 0FF21h
TCDKBD:		db '0123456789.+', 3
			db '/*-'
TFNKBD:	db 'DIR ',0,0,0,0
		db 'SAVE ',0,0,0
		db 'USER ',0,0,0
		db 'TYPE ',0,0,0
		db 'REN ',0,0,0,0
TKBDD:		db 0, 0, 0, 0, 0, 8, 1Ah, 19h, 18h, 0
PARDA:		db 3, 1, 5, 0, 50h, 0, 28h, 0, 4, 0Fh, 0, 85h, 1, 7Fh
		db 0, 0C0h, 0, 20h, 0, 4, 0
PARDB:		db 3, 1, 5, 0, 50h, 0, 28h, 0, 4, 0Fh, 0, 85h, 1, 7Fh
		db 0, 0C0h, 0, 20h, 0, 4, 0
STACK_BOTTOM:	db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  38h
		db  38h
		db    0
		db    0
		db    0
		db 0,0,0,0
		db 18h
		db 0,0,0
		db 30h, 30h
		db 0FCh
		db 30h, 30h
		db 0, 0FCh
		db 0, 0
		db 8Bh,	0CBh, 0A8h
		db 0, 0
		db 0DFh, 0D7h, 0DFh, 0D7h, 0FFh, 0D7h, 20h, 1, 55h, 10h
		db 0D3h, 0E3h, 15h, 17h, 7Fh, 0E2h, 0A5h, 0E2h,	54h, 0
		db 30h, 30h, 30h
		db 3Bh,	0Fh, 0B4h
_SYSTEM:
		jp	loc_F018
_LISTST:
		jp	LPT_ST
		jp	unk_F08C+20h
		jp	0
		jp	0
		jp	0
		jp	0
		jp	0
loc_F018:
		call	LPT_ST
		jr	z, loc_F018
		ld	a, (PRN_C)
		bit	7, a
		ld	a, c
		call	z, PRN_ENCODE
		out	(0FBh),	a
		jr	loc_F02A
loc_F02A:
		out	(7Bh), a
		jr	loc_F02E
loc_F02E:
		out	(0FBh),	a
		ret
LPT_ST:
					; _SYSTEM:loc_F018p
		in	a, (1Bh)
		jr	loc_F035
loc_F035:
		cpl
		and	80h
		ret
PRN_ENCODE:

		ld	a, (CODE)	; codepage
		or	a
		jr	z, ENCODE_KOI8
		dec	a
		jr	z, ENCODE_ASCII
		dec	a
		jr	z, ENCODE_KOI7LAT
		dec	a
		jr	z, ENCODE_KOI7RUS
		ld	a, c
		ret
ENCODE_KOI8:
		ld	a, (PRN_C)
		bit	1, a
		ld	a, c
		jr	z, loc_F066
		ret
ENCODE_KOI7RUS:
		call	ENCODE_ASCII
		cp	40h
		jr	loc_F063
ENCODE_ASCII:
					; PRN_ENCODE:ENCODE_KOI7RUSp ...
		ld	a, c
		and	7Fh
		ret

ENCODE_KOI7LAT:
		call	ENCODE_ASCII
		cp	60h
loc_F063:
		ret	c
		add	a, 80h
loc_F066:
		cp	0C0h
		ret	c
		push	de
		ld	d, 0
		ld	c, 20h
		sub	0E0h
		jr	nc, loc_F075
		add	a, c
		jr	loc_F076
loc_F075:
		ld	c, d
loc_F076:
		ld	hl, unk_F08C
		ld	e, a
		add	hl, de
		pop	de
		ld	a, (hl)
		add	a, c
		ld	hl, PRN_C
		bit	0, (hl)
		ret	z
		sub	30h
		cp	0B0h
		ret	c
		add	a, 30h
		ret
unk_F08C:	db 0CEh, 0B0h, 0B1h, 0C6h, 0B4h, 0B5h, 0C4h, 0B3h, 0C5h, 0B8h, 0B9h, 0BAh, 0BBh, 0BCh, 0BDh, 0BEh
		db 0BFh, 0CFh, 0C0h, 0C1h, 0C2h, 0C3h, 0B6h, 0B2h, 0CCh, 0CBh, 0B7h, 0C8h, 0CDh, 0C9h, 0C7h, 0CAh

; 4x8 print procedures
loc_F0AC:
		ld	a, c
		cp	2
		jr	c, loc_F0C8
		push	hl
		call	sub_F0E2
		push	de
		ld	a, d
		rra
		rra
		rra
		or	0D8h
		ld	d, a
		ld	a, (ATTRIB)
		ld	(de), a
		pop	de
		ld	a, c
		call	loc_F0FA
		pop	hl
		ret


loc_F0C8:
		or	a
		ld	a, 0Fh
		ld	b, 0A1h
		jr	z, loc_F0D2	; code injection
		cpl
		ld	b, 0B1h

loc_F0D2:
		ld	(loc_F10C+1), a	; code injection
		cpl
		ld	(loc_F126+1), a
		ld	a, b
		ld	(loc_F11A), a
		ld	(loc_F130), a
		xor	a
		ret

sub_F0E2:
		ld	e, l
		srl	e
		ld	a, h
		and	7
		rrca
		rrca
		rrca
		or	e
		ld	e, a
		ld	a, h
		and	18h
		or	0C7h
		inc	a
		ld	d, a
		srl	l
		jr	c, loc_F122
		jr	loc_F139

loc_F0FA:
		sub	20h
		push	af
		rra
		ld	l, a
		ld	h, 0
		ld	bc, FONT4X8
		add	hl, hl

loc_F105:
		add	hl, hl
		add	hl, hl
		add	hl, bc
		pop	af
		ex	af, af'

loc_F10A:
		jr	loc_F126

loc_F10C:
		ld	c, 0Fh

loc_F10E:
		ld	b, 8

loc_F110:
		push	bc
		call	sub_F142
		rlca
		rlca
		rlca
		rlca
		ld	b, a
		ld	a, (de)

loc_F11A:
		and	c
		xor	b
		ld	(de), a
		inc	d
		inc	hl
		pop	bc
		djnz	loc_F110

loc_F122:
		ld	a, 1Ah
		jr	loc_F13A

loc_F126:

		ld	c, 0F0h
		ld	b, 8

loc_F12A:
		push	bc
		call	sub_F142
		ld	b, a
		ld	a, (de)

loc_F130:
		and	c
		xor	b
		ld	(de), a
		inc	d
		inc	hl
		pop	bc
		djnz	loc_F12A
		inc	e

loc_F139:
		xor	a

loc_F13A:
		ld	(loc_F10A+1), a
		ld	a, d
		sub	8
		ld	d, a
		ret

sub_F142:
		ex	af, af'
		bit	0, a
		jr	z, loc_F14C
		ex	af, af'
		ld	a, (hl)
		and	0Fh
		ret


loc_F14C:
		ex	af, af'
		ld	a, (hl)
		srl	a
		srl	a
		srl	a
		srl	a
		ret
; End of function sub_F142



_some_beep:
		ld	b, l
		out	(0FEh),	a

loc_F15A:
		djnz	$
		xor	10h
		out	(0FEh),	a
		ld	b, l

loc_F161:
		djnz	$
		dec	h
		jr	nz, _some_beep
		ret


loc_F167:
		ld	l, 0
		jr	loc_F10E

		ld	a, l
		or	a
		jr	nz, loc_F176
		ld	a, h
		or	a
		jr	z, loc_F105
		dec	h
		ld	l, 20h

loc_F176:
		dec	l
		jr	loc_F10E

		ld	a, h
		or	a
		jr	z, loc_F10E
		dec	h
		jr	loc_F10E

		ld	hl, SCREEN1
		xor	a
		ld	c, 18h
		call	unk_F99A
		ld	a, (ATTRIB)
		ld	c, 3
		call	unk_F99A
		ld	a, (BORDER)
		out	(0FEh),	a

loc_F196:
		ld	h, 0
		jr	loc_F167


loc_F19A:
		ld	b, 0

loc_F19C:
		ld	(hl), a
		inc	hl
		djnz	loc_F19C
		dec	c
		jr	nz, loc_F19A
		ret

		ld	a, 1
		ld	(BUFESC), a
		jr	loc_F196

		push	hl
		ld	de, SCREEN1 + 1800h
		ld	a, h
		ld	h, 0
		add	hl, de
		ex	de, hl
		ld	h, 0
		ld	l, a
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, de
		ex	de, hl
		pop	hl
		ret

		push	hl
		push	de
		push	bc
		ld	hl, SCREEN1
		ld	b, 3

loc_F1C8:
		push	bc
		ld	b, 7

loc_F1CB:
		push	bc
		ld	b, 8

loc_F1CE:
		push	bc
		ld	b, 20h

loc_F1D1:
		push	hl
		ld	de, 20h
		add	hl, de
		pop	de
		ld	a, (hl)
		ld	(de), a
		ex	de, hl
		inc	hl
		djnz	loc_F1D1
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_F1CE
		ld	de, BUFD1 + 20h
		add	hl, de
		pop	bc
		djnz	loc_F1CB
		ld	b, 8

loc_F1ED:
		push	bc
		ld	b, 20h

loc_F1F0:
		push	hl
		ld	de, 720h
		add	hl, de
		pop	de
		ld	a, (hl)
		ld	(de), a
		ex	de, hl
		inc	hl
		djnz	loc_F1F0
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_F1ED
		and	a
		sbc	hl, de
		pop	bc
		djnz	loc_F1C8
		ld	hl, 0D0E0h
		xor	a
		ld	b, 8

loc_F20F:
		push	bc
		ld	b, 20h

loc_F212:
		ld	(hl), a
		inc	hl
		djnz	loc_F212
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_F20F
		ld	hl, SCREEN1 + 1800h + 20h
		ld	de, SCREEN1 + 1800h
		ld	bc, 2E0h
		ldir
		ld	b, 20h
		ld	a, (ATTRIB)

loc_F22D:
		ld	(de), a
		inc	de
		djnz	loc_F22D
		pop	bc
		pop	hl
		ld	de, 0FFE0h
		add	hl, de
		ex	de, hl
		pop	hl
		ret

		push	hl
		push	de
		ld	a, (CODE)	; codepage
		or	a
		jr	z, loc_F261
		dec	a
		jr	z, loc_F25D
		dec	a
		jr	z, loc_F256
		dec	a
		jr	nz, loc_F261
		ld	a, c
		and	7Fh
		cp	40h

loc_F250:
		jr	c, loc_F260
		add	a, 80h
		jr	loc_F260


loc_F256:
		ld	a, c
		and	7Fh
		cp	60h
		jr	loc_F250


loc_F25D:
		ld	a, c
		and	7Fh

loc_F260:
		ld	c, a

loc_F261:
		ld	d, 0C0h
		ld	a, h
		cp	8
		jr	c, loc_F276
		cp	10h
		jr	nc, loc_F272
		ld	d, 0C8h
		sub	8
		jr	loc_F276


loc_F272:
		ld	d, 0D0h
		sub	10h

loc_F276:
		sla	a
		sla	a
		sla	a
		sla	a
		sla	a

FONT4X8:
		INCBIN "font4x8.chr"

BUF_BD:		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
DIRBUF:		db 0, 4Eh, 43h,	20h, 20h, 20h, 20h, 20h, 20h, 44h, 4Fh,	43h, 0,	0, 0, 80h
		db 3Fh,	1, 40h,	1, 41h,	1, 42h,	1, 43h,	1, 44h,	1, 45h,	1, 46h,	1
		db 0, 4Eh, 43h,	20h, 20h, 20h, 20h, 20h, 20h, 44h, 4Fh,	43h, 1,	0, 0, 27h
		db 47h,	1, 48h,	1, 49h,	1, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0
		db 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h
		db 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h
		db 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h
		db 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h, 0E5h
ALV0:		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FEh, 3Fh
		db 0FFh, 0C0h, 0, 0, 0,	0, 0, 0, 0, 33h
ALV1:		db 0B1h, 33h, 54h, 0, 0Ah, 0, 36h, 0DBh, 3Fh, 0AAh
		db 0F3h, 0A9h, 0F6h, 39h, 0B8h,	5Ch, 0B9h, 5Ch,	0Ah, 17h
		db 5Ch,	0, 0F7h, 15h, 7Fh, 10h,	0E1h, 15h, 3Bh,	0Fh
		db 7Fh,	10h, 54h, 0FFh,	0B4h, 12h, 0, 3Eh, 0, 18h
		db 24h,	42h, 7Eh, 42h, 42h, 0, 0, 7Ch, 22h, 3Ch
ALV2:		db 22h,	22h, 7Ch, 0, 0,	3Ch, 42h, 40h, 40h, 42h
		db 3Ch,	0, 0, 7Ch, 22h,	22h, 22h, 22h, 7Ch, 0
		db 0, 7Eh, 20h,	3Ch, 20h, 20h, 7Eh, 0, 0, 7Eh
		db 20h,	3Ch, 20h, 20h, 70h, 0, 0, 3Ch, 42h, 40h
		db 4Eh,	42h, 3Ch, 0, 0,	42h, 42h, 7Eh, 42h, 42h
CSV0:		db 0C7h, 0B5h, 8Fh, 0B3h, 4Dh, 8, 0CBh,	7Ch, 0ACh, 8Eh,	0B3h, 31h, 0D2h, 95h, 94h, 0A4h
		db 1Bh,	44h, 0E0h, 2Dh,	80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h,	80h, 80h, 80h, 80h
CSV1:		db 7Eh,	0, 0, 42h, 66h,	5Ah, 42h, 42h, 42h, 0, 0, 42h, 62h, 52h, 4Ah, 46h
		db 42h,	0, 0, 3Ch, 42h,	42h, 42h, 42h, 3Ch, 0, 0, 7Ch, 22h, 22h, 3Ch, 20h
CSV2:		db 70h,	0, 0, 3Ch, 42h,	42h, 52h, 4Ah, 3Ch, 0, 0, 7Ch, 22h, 22h, 3Ch, 24h
		db 22h,	0, 0, 3Ch, 40h,	3Ch, 2,	42h, 3Ch, 0, 0,	0FEh, 92h, 10h,	10h, 10h
REZ2:		db 38h,	0, 0, 42h, 42h,	42h, 42h, 42h, 3Ch, 0
BUFD1:	EQU $
BUFD2:	EQU $ + 0400H

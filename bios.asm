	INCLUDE "defines.inc"
	INCLUDE "quorum_hw.inc"
RESET:	EQU 0
CPM_SYSCALL: EQU 5
SCREEN:	EQU 0C000h
BANK_SWITCH_0040: EQU 40h
word_4:	EQU 0004h
AINTM1:	EQU 0038h
AINTM2:	EQU 0035h
SPBIOS: EQU	0F000H
BUF_ED: EQU	0BF80H
unk_40:	EQU 40h ; call here
unk_BF80: EQU 0BF80h
CCP_INBUFF: EQU 0AA86h

	ORG 0DB00H
BOOT:		jp	_BOOT
WBOOT:		jp	_WBOOT
CONST:		jp	_CONST
CONIN:		jp	_CONIN
CONOUT:		jp	_CONOUT
SYSTEM:		jp	_SYSTEM
PUNCH:		jp	_PUNCH
READER:		jp	_READER
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
		jp	loc_DC9A
INT2_HANDLER:
		jp	loc_DC9F
		jp	RESET
		db    0
word_DB3D:	dw 0AA7Dh
		db  15h
		db    0
		db    0
		db  5Dh	; ]
		db    0
		db    0
		db    0
		db    0
		db    0
		db  80h	; Ђ
		db 0F6h	; ц
		db  77h	; w
		db 0DBh	; Ы
		db  96h	; –
		db 0F7h	; ч
		db    0
		db 0F7h	; ч
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  80h	; Ђ
		db 0F6h	; ц
		db  8Dh	; Ќ
		db 0DBh	; Ы
		db 0B6h	; ¶
		db 0F7h	; ч
		db  32h	; 2
		db 0F7h	; ч
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  80h	; Ђ
		db 0F6h	; ц
		db  9Ch	; њ
		db 0DBh	; Ы
		db 0D6h	; Ц
		db 0F7h	; ч
		db  64h	; d
		db 0F7h	; ч
		db    1
		db    5
		db    1
		db    3
		db    1
		db    1
byte_DB76:	db 0FFh
		db  28h	; (
		db    0
		db    4
		db  0Fh
		db    0
		db  85h	; …
		db    1
		db  7Fh	; 
		db    0
		db 0C0h	; А
		db    0
		db  20h
		db    0
		db    4
		db    0
		db    0
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
		db 0C3h	; Г
		db    0
		db  7Fh	; 
		db    0
		db 0C0h	; А
		db    0
		db  20h
		db    0
		db    2
		db    0
		db  80h	; Ђ
		db    0
		db    3
		db    7
		db    0
		db    0
		db    0
		db  1Fh
		db    0
		db  80h	; Ђ
		db    0
		db    0
		db    0
		db    0
		db    0
word_DBAB:	dw 0DB40h
		dw 0DB50h
		dw 0
_BOOT:
		di
		ld	sp, 80h	; 'Ђ'
		xor	a
		ld	(CPM_SYSCALL-1), a
		ld	de, (word_DB3D)
		push	de
		ld	hl, CPM_SYSCALL
		call	INJECT_JUMP
		pop	hl
		ld	de, BDOS_START
		call	INJECT_JUMP
		ld	hl, 38h	; '8'
		ld	de, INT1_HANDLER
		call	INJECT_JUMP
		ld	hl, CCP_START
		push	hl
		jr	loc_DBE2
_WBOOT:
		di
		ld	sp, 80h	; 'Ђ'
		ld	hl, CCP_START + 3
		push	hl
loc_DBE2:
		xor	a
		ld	(byte_DB76), a
		ld	(byte_DB8C), a
		ld	(byte_E0B0), a
		ld	(byte_E0AF), a
		ld	hl, 35h	; '5'
		ld	(AIM2),	hl
		ld	de, INT2_HANDLER
		call	INJECT_JUMP
		ld	hl, 0
		ld	de, WBOOT
		call	INJECT_JUMP
		ld	a, 0C3h
		ld	hl, DOPINT
		cp	(hl)
		jr	z, loc_DC0E
		ld	(hl), 0C9h
loc_DC0E:
		ld	a, 0E7h	; 'з'
		ld	i, a
		im	2
		ld	a, (CCP_INBUFF)
		cp	7Fh
		call	z, sub_DC3A
		call	sub_DC35
		ld	a, (CPM_SYSCALL-1)
		ld	c, a
		ret
INJECT_JUMP:
		ld	(hl), 0C3h
		inc	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
		ret
sub_DC2B:
		ld	a, (hl)
		inc	hl
		or	a
		ret	z
		ld	c, a
		call	CONOUT
		jr	sub_DC2B
sub_DC35:
		ld	hl, unk_DC80
		jr	loc_DC3D
sub_DC3A:
		ld	hl, byte_DC61
loc_DC3D:
		ld	a, (hl)
		inc	hl
		cp	45h
		ret	z
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		cp	52h
		jr	z, loc_DC55
		cp	53h
		ret	nz
		ld	c, (hl)
		inc	hl
		ld	b, (hl)
		inc	hl
		ldir
		jr	loc_DC3D
loc_DC55:
		ld	b, (hl)
		inc	hl
		ld	a, (hl)
		inc	hl
		ex	de, hl
loc_DC5A:
		ld	(hl), a
		inc	hl
		djnz	loc_DC5A
		ex	de, hl
		jr	loc_DC3D
byte_DC61:	db 53h
		db    8
		db 0ABh	; «
		db    4
		db    0
		db  88h	; €
		db 0AAh	; Є
		db    0
		db    0
		db  52h	; R
		db 0D5h	; Х
		db 0B1h	; ±
		db  5Bh	; [
		db    0
		db  53h	; S
		db 0D7h	; Ч
		db 0B1h	; ±
		db  0Bh
		db    0
		db  24h	; $
		db  24h	; $
		db  24h	; $
		db  20h
		db  20h
		db  20h
		db  20h
		db  20h
		db  53h	; S
		db  55h	; U
		db  42h	; B
		db  45h	; E
unk_DC80:	db  53h
		db  7Dh	; }
		db 0B5h	; µ
		db    3
		db    0
		db    0
		db    2
		db    0
		db  52h	; R
		db  81h	; Ѓ
		db 0B5h	; µ
		db  49h	; I
		db    0
		db  52h	; R
		db 0BBh	; »
		db 0BFh	; ї
		db  45h	; E
		db    0
		db  53h	; S
		db 0BFh	; ї
		db 0BFh	; ї
		db    2
		db    0
		db  80h	; Ђ
		db    0
		db  45h	; E
loc_DC9A:
		push	af
		ld	a, 1
		jr	loc_DCA2
loc_DC9F:
		push	af
		ld	a, 2
loc_DCA2:
		ld	(003Dh), a ; wtf
		push	hl
		push	de
		push	bc
		ld	hl, FRAMES
		ld	b, 4
loc_DCAD:
		inc	(hl)
		jr	nz, loc_DCB3
		inc	hl
		djnz	loc_DCAD
loc_DCB3:
		call	sub_E506
		call	sub_E103
		ld	hl, COUNMO
		dec	(hl)
		jr	nz, loc_DCC5
		xor	a
		out	(PORT_FDD_STATUS), a
		ld	(MFDCUP), a
loc_DCC5:
		call	DOPINT
		pop	bc
		pop	de
		pop	hl
		pop	af
		ei
		ret
_SETDSK:
		ld	a, c
		cp	3
		jr	c, loc_DCD8
		xor	a
		ld	l, a
		ld	h, a
		inc	a
		ret
loc_DCD8:
		ld	hl, word_DBAB
		ld	(byte_E0B2), a
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
		ld	(word_E0BC), hl
		inc	a
		call	nz, sub_DE9D
		pop	hl
		ret
_HOME:
		ld	c, 0
_SETTRK:
		ld	a, c
		ld	(word_E0B6), a
		ret
_SETSEC:
		ld	a, c
		ld	(word_E0B6+1), a
		ret
_SECTRAN:
		ld	h, b
		ld	l, c
		inc	hl
		ret
_SETDMA:
		ld	(word_E0B8), bc
		ret
_READ:
		ld	a, (byte_E0B2)
		cp	2 			; Is RAM DISK?
		jp	z, loc_E021
		call	sub_DF26
		call	sub_DD55
		jr	z, loc_DD3B
		call	sub_DD50
		jr	nz, loc_DD2E
		ld	de, BUFD2
		jr	loc_DD3E
loc_DD2E:
		call	sub_DD70
		call	sub_DF86
		jr	z, loc_DD3B
		xor	0
		ld	(byte_E0C3), a
loc_DD3B:
		ld	de, BUFD1
loc_DD3E:
		ld	hl, (word_E0C1)
		add	hl, de
		ld	de, (word_E0B8)
		ld	bc, 80h	; 'Ђ'
		ldir
		ld	a, (byte_E0B1)
		or	a
		ret
sub_DD50:
		ld	hl, byte_E0C8
		jr	loc_DD58
sub_DD55:
		ld	hl, byte_E0C3
loc_DD58:
		ld	de, byte_E0BE
		ld	b, 3
loc_DD5D:
		ld	a, (de)
		cp	(hl)
		ret	nz
		inc	de
		inc	hl
		djnz	loc_DD5D
		ret
sub_DD65:
		ld	hl, (word_E0BC)
		ld	(word_E0C6), hl
		ld	de, byte_E0C8
		jr	loc_DD73
sub_DD70:
					
		ld	de, byte_E0C3
loc_DD73:
		ld	hl, byte_E0BE
		ld	bc, 3
		ldir
		ret
_WRITE:
		ld	a, (byte_E0B2)
		cp	2
		jp	z, loc_E027
		ld	a, c
		push	af
		call	sub_DF26
		pop	af
		cp	1
		jr	nz, loc_DDBF
		xor	a
		ld	(byte_E0B0), a
		call	sub_DD50
		jr	z, loc_DDA1
		call	sub_DDA4
		ret	nz
		call	sub_DDDC
		ret	nz
		jr	sub_DDA4
loc_DDA1:
		call	sub_DE1B
sub_DDA4:
		ld	a, (byte_E0AF)
		or	a
		ret	z
		ld	hl, word_E0C6
		call	loc_DE6B
		jr	nz, loc_DDB7
		ld	hl, BUFD2
		call	sub_DFB8
loc_DDB7:
		ld	(byte_E0C8), a
		ret	nz
		ld	(byte_E0AF), a
		ret
loc_DDBF:
		or	a
		jr	nz, loc_DE03
		call	sub_DD50
		jr	z, sub_DE1B
		call	sub_DDA4
		ret	nz
		ld	a, (byte_E0B0)
		or	a
		jr	z, loc_DDD8
		call	sub_DE3B
		jr	nz, loc_DDD8
		jr	loc_DE18
loc_DDD8:
		xor	a
		ld	(byte_E0B0), a
sub_DDDC:
		call	sub_DD65
		call	sub_DD55
		jr	nz, loc_DDF1
		ld	bc, 400h
		ld	hl, BUFD1
		ld	de, BUFD2
		ldir
		jr	sub_DE1B
loc_DDF1:
		call	sub_DE68
		ld	hl, BUFD2
		call	loc_DF8C
		jr	z, sub_DE1B
		push	af
		xor	a
		ld	(byte_E0C8), a
		pop	af
		ret
loc_DE03:
		call	sub_DDA4
		ret	nz
		ld	a, 0FFh
		ld	(byte_E0B0), a
		ld	a, (byte_E0B2)
		ld	(word_E0CB), a
		ld	hl, (word_E0B6)
		ld	(word_E0CB+1), hl
loc_DE18:
		call	sub_DD65
sub_DE1B:
		call	sub_DD55
		jr	nz, loc_DE24
		xor	a
		ld	(byte_E0C3), a
loc_DE24:
		ld	de, BUFD2
		ld	hl, (word_E0C1)
		add	hl, de
		ex	de, hl
		ld	hl, (word_E0B8)
		ld	bc, 80h	; 'Ђ'
		ld	a, 0FFh
		ld	(byte_E0AF), a
		ldir
		xor	a
		ret
sub_DE3B:
		ld	hl, (word_E0CB)
		ld	a, (byte_E0CD)
		ld	e, a
		ld	a, (byte_E0B2)
		cp	l
		ret	nz
		ld	a, (word_E0B6)
		sub	h
		ret	c
		ld	hl, (word_E0BC)
		inc	hl
		inc	hl
		jr	z, loc_DE61
		dec	a
		ret	nz
		ld	a, (word_E0B6+1)
		add	a, (hl)
loc_DE59:
		inc	hl
		inc	hl
		inc	hl
		sub	(hl)
		cp	e
		ret	nc
		xor	a
		ret
loc_DE61:
		ld	a, (word_E0B6+1)
		cp	e
		ret	c
		jr	loc_DE59
sub_DE68:
					
		ld	hl, word_E0BC
loc_DE6B:
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		out	(PORT_FDD_STATUS), a
		ld	(MFDCUP), a
		call	sub_DFD7
		dec	de
		inc	hl
		ld	a, (de)
		out	(PORT_WD93_TRACK), a
		ld	a, (hl)
		out	(PORT_WD93_DATA), a
		or	a
		ld	c, 18h
		jr	nz, loc_DE87
		ld	c, 0
loc_DE87:
		ld	(de), a
		inc	hl
		ld	a, (hl)
		out	(PORT_WD93_SECTOR), a
		ld	a, c
		out	(PORT_WD93_COMMAND_STATUS), a
		call	sub_E00C
loc_DE92:
		in	a, (PORT_WD93_COMMAND_STATUS)
		bit	0, a
		jr	nz, loc_DE92
		and	50h
		jp	loc_DFFB
sub_DE9D:
		push	hl
		ld	a, (hl)
		and	0Fh
		ld	hl, byte_E0BE
		ld	(hl), a
		xor	a
		inc	hl
		ld	(hl), a
		inc	a
		inc	hl
		ld	(hl), a
loc_DEAB:
		call	sub_DF86
		jr	z, loc_DED3
		ld	hl, aCanTReadDisk
		call	sub_DC2B
		call	CONIN
		jr	loc_DEAB
aCanTReadDisk:	DB '\r\n* Can`t read disk *\r\n',0
loc_DED3:
		call	sub_DD70
		ld	hl, BUFD1
		ld	a, 66h
		ld	b, 1Fh
loc_DEDD:
		add	a, (hl)
		inc	hl
		dec	b
		jr	nz, loc_DEDD
		cp	(hl)
		jr	z, loc_DEF4
		ld	hl, PARDA
		ld	de,  BUFD1+0Ah
		ld	bc, 15h
		ldir
		ld	a, (hl)
		ld	(BUFD1+9), a
loc_DEF4:
		pop	hl
		push	hl
		ld	a, (MFDCUP)
		and	0CFh
		ld	(byte_E0C3), a
		ld	(hl), a
		inc	hl
		ld	(hl), 0FFh
		inc	hl
		ld	de,  BUFD1+10h
		ld	bc, 0Fh
		ex	de, hl
		ldir
		pop	de
		xor	a
		dec	de
		ld	(de), a
		dec	de
		ld	hl,  BUFD1+9
		ld	a, (hl)
		push	af
		inc	hl
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
		dec	de
		pop	af
		ld	(de), a
		xor	a
		ret
sub_DF26:
		ld	hl, (word_E0BC)
		ld	a, (hl)
		ld	(byte_E0BE), a
		dec	hl
		dec	hl
		ld	b, (hl)
		ld	c, 0
		ld	a, (word_E0B6+1)
		dec	a
		inc	b
		ld	d, a
		ld	e, a
loc_DF39:
		dec	b
		jr	z, loc_DF43
		srl	e
		scf
		rl	c
		jr	loc_DF39
loc_DF43:
		ld	a, c
		and	d
		rra
		ld	(word_E0C1+1), a
		ld	a, 0
		rra
		ld	(word_E0C1), a
		dec	hl
		ld	d, (hl)
		dec	d
		ld	a, (word_E0B6)
		jr	nz, loc_DF58
		rra
loc_DF58:
		ld	(byte_E0BF), a
		jr	nc, loc_DF65
		ld	a, (byte_E0BE)
		or	10h
		ld	(byte_E0BE), a
loc_DF65:
		dec	hl
		ld	d, (hl)
		dec	hl
		ld	a, (hl)
		or	a
		jr	z, loc_DF80
		ld	c, a
		ld	b, e
		inc	b
		ld	e, 0
loc_DF71:
		dec	b
		jr	z, loc_DF80
		ld	a, e
		add	a, c
		cp	d
		jr	c, loc_DF7D
		jr	nz, loc_DF7C
		inc	a
loc_DF7C:
		sub	d
loc_DF7D:
		ld	e, a
		jr	loc_DF71
loc_DF80:
		ld	a, e
		inc	a
		ld	(byte_E0C0), a
		ret
sub_DF86:
					
		call	sub_DE68
		ld	hl, BUFD1
loc_DF8C:
		ld	b, 3
loc_DF8E:
		call	sub_DFD7
		push	hl
		di
		ld	a, 84h
		out	(PORT_WD93_COMMAND_STATUS), a
		call	sub_E00C
		ld	c, 83h
		call	sub_DFAD
		pop	hl
		and	7Eh
		jr	z, loc_DFFB
		djnz	loc_DF8E
		call	sub_DFEE
		ld	a, 80h
		jr	loc_DFFB
sub_DFAD:
		in	a, (PORT_WD93_COMMAND_STATUS)
		rrca
		ret	nc
		rrca
		jr	nc, sub_DFAD
		ini
		jr	sub_DFAD
sub_DFB8:
		call	sub_DFD7
		di
		ld	a, 0A4h	; '¤'
		out	(PORT_WD93_COMMAND_STATUS), a
		call	sub_E00C
		ld	c, PORT_WD93_DATA
		call	sub_DFCC
		and	0FEh
		jr	loc_DFFB
sub_DFCC:
		in	a, (PORT_WD93_COMMAND_STATUS)
		rrca
		ret	nc
		rrca
		jr	nc, sub_DFCC
		outi
		jr	sub_DFCC
sub_DFD7:
					
		di
		ld	a, 64h
		ld	(COUNMO), a
		ld	a, (MFDCUP)
		bit	5, a
		jr	nz, sub_DFEE
		set	5, a
		out	(PORT_FDD_STATUS), a
		ld	(MFDCUP), a
		call	sub_E001
sub_DFEE:
		ld	a, 0D0h	; 'Р'
		out	(PORT_WD93_COMMAND_STATUS), a
		call	sub_E00C
loc_DFF5:
		in	a, (PORT_WD93_COMMAND_STATUS)
		rrca
		jr	c, loc_DFF5
		xor	a
loc_DFFB:
		ld	(byte_E0B1), a
		or	a
		ei
		ret
sub_E001:
		ld	a, (MOTDEL)
		ld	b, a
loc_E005:
		xor	a
		call	sub_E00E
		djnz	loc_E005
		ret
sub_E00C:
		ld	a, 14h
sub_E00E:
		dec	a
		jr	nz, sub_E00E
		ret
loc_E012:
		out	(c), a
		ld	bc, 80h	; 'Ђ'
		ldir
		ld	bc, PORT_ZX128
		ld	a, 0Fh
		out	(c), a
		ret
loc_E021:
		xor	a
		jr	loc_E029
loc_E024:
		xor	a
		dec	a
		ret
loc_E027:
		ld	a, 0FFh
loc_E029:
		ld	(byte_E0A2), a
		ld	a, (word_E0B6)
		ld	hl, NP_END
		cp	(hl)
		jr	nc, loc_E024
		di
		ld	hl, loc_E012
		ld	de, 40h	; '@'
		ld	bc, 0Fh
		ldir
		ld	hl, unk_BF80
		ld	de, BUF_BD
		ld	bc, 80h	; 'Ђ'
		ldir
		ld	c, a
		ld	hl, unk_E0A3
		add	hl, bc
		ld	a, (hl)
		push	af
		ld	a, (word_E0B6+1)
		dec	a
		rrca
		ld	e, a
		and	7Fh
		add	a, 0C0h	; 'А'
		ld	d, a
		ld	a, 80h
		and	e
		ld	e, a
		ld	hl, unk_BF80
		ld	a, (byte_E0A2)
		or	a
		ex	de, hl
		call	nz, sub_E093
		pop	af
		ld	bc, PORT_ZX128
		call	unk_40
		ld	a, (byte_E0A2)
		inc	a
		jr	z, loc_E086
		ld	de, unk_BF80
		ld	hl, (word_E0B8)
		ld	bc, 80h	; 'Ђ'
		ex	de, hl
		ldir
loc_E086:
		ld	hl, BUF_BD
		ld	de, unk_BF80
		ld	bc, 80h	; 'Ђ'
		ldir
		xor	a
		ret
sub_E093:
		push	hl
		ld	hl, (word_E0B8)
		push	bc
		push	de
		ld	bc, 80h	; 'Ђ'
		ldir
		pop	hl
		pop	bc
		pop	de
		ret
byte_E0A2:	db 0
unk_E0A3:	db    9
		db  0Bh
		db  0Ch
		db  0Eh
		db  48h	; H
		db  49h	; I
		db  4Ah	; J
		db  4Bh	; K
		db  4Ch	; L
		db  4Dh	; M
		db  4Eh	; N
		db  4Fh	; O
byte_E0AF:	db 0
byte_E0B0:	db 0
byte_E0B1:	db 0
					
byte_E0B2:	db 0
		db    0
		db    0
		db    0
word_E0B6:	dw 2703h
word_E0B8:	dw 8F00h
		db    0
		db    0
word_E0BC:	dw 0DB75h
byte_E0BE:	db 11h
					
byte_E0BF:	db 1
byte_E0C0:	db 5
word_E0C1:	dw 300h
byte_E0C3:	db 11h
		db    1
		db    5
word_E0C6:	dw 0DB75h
byte_E0C8:	db 0
		db    2
		db    1
word_E0CB:	dw 0C00h
byte_E0CD:	db 1
		db    0
		db    0
		db    0
		db    0
		db    9
		db  0Bh
		db  0Ch
		db  0Eh
		db  48h	; H
		db  49h	; I
		db  4Ah	; J
		db  4Bh	; K
		db  4Ch	; L
		db  4Dh	; M
		db  4Eh	; N
		db  4Fh	; O
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  45h	; E
		db  15h
		db  80h	; Ђ
		db    0
		db    0
		db    0
		db  75h	; u
		db 0DBh	; Ы
		db  11h
		db  22h	; "
		db    3
		db    0
		db    2
		db  11h
		db  22h	; "
		db    3
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
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
		push	hl
		push	de
		push	bc
		push	af
		push	bc
		call	sub_E13F
		pop	bc
		ld	hl, FLCUR
		ld	a, (hl)
		ld	(loc_E28E+1), a
		res	7, (hl)
		ld	hl, loc_E28E
		push	hl
		ei
		ld	hl, (NUMCOL)
		ld	a, (BUFESC)
		dec	a
		ld	b, a
		ld	a, c
		jp	m, loc_E25A
		jp	z, loc_E22E
		dec	b
		jr	z, loc_E203
		dec	b
		jr	z, loc_E1F0
		dec	b
		jr	z, loc_E1B6
		dec	b
		jr	z, loc_E1B1
		dec	b
		jr	z, loc_E1AC
		dec	b
		jr	nz, loc_E1E9
		ld	(loc_E28E+1), a
		jr	loc_E1E9
loc_E1AC:
		ld	(CODEPAGE), a
		jr	loc_E1E9
loc_E1B1:
		ld	(ATTRIB), a
		jr	loc_E1E9
loc_E1B6:
		bit	3, a
		jr	nz, loc_E1C1
		ld	(BORDER), a
		out	(0FEh),	a
		jr	loc_E1E9
loc_E1C1:
		and	3
		bit	1, a
		jr	z, loc_E1E5
		push	hl
		rra
		ld	hl, loc_F006
		ld	de, (AD_S64)
		jr	c, loc_E1D8
		ld	hl, sub_E3A8
		ld	de, 02B06h
loc_E1D8:
		ld	(loc_E1E6+1), hl
		ld	(sub_E265+1), hl
		ld	(WD_POS), de
		pop	hl
		jr	loc_E1E9
loc_E1E5:
		ld	c, a
loc_E1E6:
		call	sub_E3A8
loc_E1E9:
		xor	a
loc_E1EA:
		ld	(BUFESC), a
		jp	loc_E28A
loc_E1F0:
		ld	de, (WD_SCR)
		cp	80h
		jr	c, loc_E1FA
		sub	60h
loc_E1FA:
		sub	20h
		cp	e
		jr	c, loc_E200
		xor	a
loc_E200:
		ld	l, a
		jr	loc_E1E9
loc_E203:
		cp	80h
		jr	c, loc_E209
		sub	60h
loc_E209:
		sub	20h
		cp	18h
		jr	c, loc_E211
		ld	a, 17h
loc_E211:
		ld	(NUMSTR), a
		ld	a, 3
loc_E216:
		ld	(BUFESC), a
		ret
loc_E21A:
		ld	a, 2
		jr	loc_E216
loc_E21E:
		ld	a, 4
		jr	loc_E1EA
loc_E222:
		ld	a, 5
		jr	loc_E1EA
loc_E226:
		ld	a, 6
		jr	loc_E1EA
loc_E22A:
		ld	a, 7
		jr	loc_E1EA
loc_E22E:
		cp	80h
		jr	nc, loc_E203
		cp	'Y'
		jr	z, loc_E21A
		push	af
		xor	a
		ld	(BUFESC), a
		pop	af
		cp	'E'
		jr	z, loc_E2AE
		cp	'K'
		jp	z, loc_E35C
		cp	'J'
		jp	z, loc_E342
		cp	'B'
		jr	z, loc_E21E
		cp	'C'
		jr	z, loc_E222
		cp	'S'
		jr	z, loc_E226
		cp	'D'
		jr	z, loc_E22A
loc_E25A:
		ld	c, a
		cp	' '
		jr	c, loc_E2D3
		push	hl
		call	sub_E383
		pop	hl
		ld	c, a
sub_E265:
		call	sub_E3A8
loc_E268:
		inc	l
		ld	a, (WD_SCR)
		dec	a
		cp	l
		jr	nc, loc_E28A
		dec	l
		ld	a, (FLCUR)
		bit	2, a
		jr	nz, loc_E28A
		ld	l, 0
loc_E27A:
		inc	h
loc_E27B:
		ld	a, h
		cp	18h
		jr	c, loc_E28A
		ld	h, 17h
		ld	a, (FLCUR)
		bit	1, a
		call	z, sub_E48B
loc_E28A:
		ld	(NUMCOL), hl
		ret
loc_E28E:
		ld	a, 80h
		ld	(FLCUR), a
		pop	af
		pop	bc
		pop	de
		pop	hl
		ret
loc_E298:
		ld	l, 0
		jr	loc_E28A
loc_E29C:
		ld	a, l
		cp	1
		jr	nc, loc_E2AB
		ld	a, h
		cp	1
		jr	c, loc_E27B
		dec	h
		ld	a, (WD_SCR)
		ld	l, a
loc_E2AB:
		dec	l
		jr	loc_E28A
loc_E2AE:
		ld	hl, SCREEN
		xor	a
		ld	c, 18h
		call	sub_E2C9
		ld	a, (ATTRIB)
		ld	c, 3
		call	sub_E2C9
		ld	a, (BORDER)
		out	(0FEh),	a
loc_E2C4:
		ld	hl, 0
		jr	loc_E28A
sub_E2C9:
		ld	b, 0
loc_E2CB:
		ld	(hl), a
		inc	hl
		djnz	loc_E2CB
		dec	c
		jr	nz, sub_E2C9
		ret
loc_E2D3:
		cp	1
		jr	z, loc_E2C4
		cp	7
		jr	z, loc_E30D
		cp	8
		jr	z, loc_E29C
		cp	0Ah
		jr	z, loc_E27A
		cp	0Ch
		jr	z, loc_E2AE
		cp	0Dh
		jr	z, loc_E298
		cp	0Eh
		jr	z, loc_E326
		cp	0Fh
		jr	z, loc_E334
		cp	14h
		jr	z, loc_E342
		cp	15h
		jp	z, loc_E268
		cp	16h
		jr	z, loc_E35C
		cp	18h
		jr	z, loc_E35A
		cp	1Bh
		jr	z, loc_E320
		cp	1Fh
		jr	z, loc_E2AE
		ret
loc_E30D:
		di
		ld	hl, (SCBEEP)
		ld	a, (BORDER)
_some_beep:
		xor	10h
		out	(0FEh),	a
		ld	b, l
loc_E319:
		djnz	$
		dec	h
		jr	nz, _some_beep
		ei
		ret
loc_E320:
		ld	a, 1
		ld	(BUFESC), a
		ret
loc_E326:
		ld	hl, CODEPAGE
		bit	0, (hl)
		ret	z
		res	1, (hl)
		ld	hl, FLGKBD
		res	0, (hl)
		ret
loc_E334:
		ld	hl, CODEPAGE
		bit	0, (hl)
		ret	z
		set	1, (hl)
		ld	hl, FLGKBD
		set	0, (hl)
		ret
loc_E342:
		ld	l, 0
		push	hl
		ld	a, (WD_SCR)
		ld	d, l
		ld	e, a
		ld	a, 17h
		sub	h
		ld	b, a
		ld	h, 0
loc_E350:
		add	hl, de
		djnz	loc_E350
		ex	de, hl
		pop	hl
		push	hl
		ld	a, 97h
		jr	loc_E366
loc_E35A:
		ld	l, 0
loc_E35C:
		push	hl
		ld	a, (WD_SCR)
		sub	l
		ld	d, 0
		ld	e, a
		ld	a, 0D7h	; 'Ч'
loc_E366:
		ld	(loc_E36C+1), a
		ld	a, (FLCUR)
loc_E36C:
		set	2, a
		set	1, a
		ld	(FLCUR), a
loc_E373:
		push	de
		ld	c, 20h
		call	sub_E265
		pop	de
		dec	de
		ld	a, e
		or	d
		jr	nz, loc_E373
		pop	hl
		jp	loc_E28A
sub_E383:
		ld	a, (CODEPAGE)
		and	7
		jr	nz, loc_E38C
		ld	a, c
		ret
loc_E38C:
		dec	a
		jr	nz, loc_E393
		ld	a, c
		and	7Fh
		ret
loc_E393:
		dec	a
		jr	nz, loc_E39D
		ld	a, c
		and	7Fh
		cp	60h
		jr	loc_E3A4
loc_E39D:
		dec	a
		ld	a, c
		ret	nz
		and	7Fh
		cp	40h
loc_E3A4:
		ret	c
		add	a, 80h
		ret
sub_E3A8:
		ld	a, c
		cp	2
		jr	c, loc_E3C4
		push	hl
		call	sub_E3D6
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
		call	loc_E40B
		pop	hl
		ret
loc_E3C4:
		or	a
		jr	z, loc_E3C9
		ld	a, 0FCh	; 'ь'
loc_E3C9:
		ld	(loc_E41F+1), a
		ld	(loc_E42B+1), a
		ld	(loc_E455+1), a
		ld	(loc_E468+1), a
		ret
sub_E3D6:
		ld	a, l
		srl	a
		srl	a
		sub	l
		neg
		bit	5, a
		push	af
		jr	z, loc_E3E4
		dec	a
loc_E3E4:
		ld	e, a
		ld	a, h
		and	7
		rrca
		rrca
		rrca
		or	e
		ld	e, a
		pop	af
		jr	nz, loc_E3F1
		dec	e
loc_E3F1:
		ld	a, h
		and	18h
		or	0C7h
		inc	a
		ld	d, a
		inc	l
		srl	l
		jr	c, loc_E404
		srl	l
		jr	c, loc_E427
		dec	e
		jr	nc, loc_E450
loc_E404:
		srl	l
		jr	nc, loc_E463
		dec	e
		jr	loc_E480
loc_E40B:
		ld	bc, (ADDRZG)
		ld	l, a
		ld	h, 0
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, bc
		dec	h
		ld	b, 8
loc_E419:
		jr	loc_E42B
		ld	c, 3
loc_E41D:
		ld	a, (de)
		and	c
loc_E41F:
		or	0
		xor	(hl)
		ld	(de), a
		inc	d
		inc	hl
		djnz	loc_E41D
loc_E427:
		ld	a, 4Ch
		jr	loc_E483
loc_E42B:
		ld	c, 0
loc_E42D:
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
		jr	z, loc_E44B
		inc	e
		ld	a, (de)
		and	3Fh
		or	l
		ld	(de), a
		dec	e
loc_E44B:
		inc	d
		pop	hl
		inc	hl
		djnz	loc_E42D
loc_E450:
		ld	a, 39h
		jr	loc_E482
loc_E454:
		ld	a, (hl)
loc_E455:
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
		djnz	loc_E454
loc_E463:
		ld	a, 0
		jr	loc_E482
loc_E467:
		ld	a, (hl)
loc_E468:
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
		djnz	loc_E467
loc_E480:
		ld	a, 10h
loc_E482:
		inc	e
loc_E483:
		ld	(loc_E419+1), a
		ld	a, d
		sub	8
		ld	d, a
		ret
sub_E48B:
		push	hl
		ld	hl, SCREEN
		ld	b, 8
loc_E491:
		push	hl
		push	bc
		call	sub_E4C9
		pop	bc
		pop	hl
		inc	h
		djnz	loc_E491
		ld	hl, SCREEN + 010E0h
		ld	a, 8
loc_E4A0:
		push	hl
		ld	d, h
		ld	e, l
		inc	de
		ld	bc, 1Fh
		ld	(hl), 0
		ldir
		pop	hl
		inc	h
		dec	a
		jr	nz, loc_E4A0
		ld	de, SCREEN + 1800h
		ld	hl, SCREEN + 1820h
		ld	bc, 2E0h
		ldir
		ld	a, (ATTRIB)
		ld	(de), a
		ld	l, e
		ld	h, d
		inc	de
		ld	bc, 1Fh
		ldir
		pop	hl
		ret
sub_E4C9:
		ld	d, h
		ld	e, l
		ld	a, l
		add	a, 20h
		ld	l, a
		call	sub_E4E6
		call	loc_E4D5
loc_E4D5:
		push	de
		ld	de, 700h
		add	hl, de
		pop	de
loc_E4DB:
		ld	bc, 20h	; ' '
		ldir
		ld	d, h
		ld	e, l
		ld	a, e
		sub	20h
		ld	e, a
sub_E4E6:
		ld	bc, 0E0h
		ldir
		ret
		ld	de, 0E0h
		add	hl, de
		pop	bc
		djnz	loc_E4DB+2
		ret
		db 0FDh	; э
		db 0E4h	; д
		db    6
		db    8
		db 0C5h	; Е
		db    6
		db  20h
		db 0E5h	; е
		db  11h
		db  20h
		db    7
		db  19h
_CONIN:
		jp	sub_E581
_CONST:
		jp	sub_E579
sub_E506:
		call	sub_E5BC
		ret	nz
		ld	a, (FLAGS)
		or	a
		ret	m
		ld	hl, KSTAT0
loc_E512:
		bit	7, (hl)
		jr	nz, loc_E51D
		inc	hl
		dec	(hl)
		dec	hl
		jr	nz, loc_E51D
		ld	(hl), 0FFh
loc_E51D:
		ld	a, l
		ld	hl, KSTAT4
		cp	l
		jr	nz, loc_E512
		ld	b, d
		call	sub_E5F7
		ret	nc
		ld	hl, KSTAT0
		cp	(hl)
		jr	z, loc_E56B
		ex	de, hl
		ld	hl, KSTAT4
		cp	(hl)
		jr	z, loc_E56B
		bit	7, (hl)
		jr	nz, loc_E53E
		ex	de, hl
		bit	7, (hl)
		ret	z
loc_E53E:
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
		call	sub_E6A5
		pop	hl
		ld	(hl), a
loc_E555:
		or	a
		ret	z
		ld	c, a
		ld	a, (CODEPAGE)
		and	3
		ld	a, c
		jr	z, loc_E562
		and	7Fh
loc_E562:
		ld	(LASTK), a
		ld	hl, FLAGS
		set	7, (hl)
		ret
loc_E56B:
		inc	hl
		ld	(hl), 5
		inc	hl
		dec	(hl)
		ret	nz
		ld	a, (REPPER)
		ld	(hl), a
		inc	hl
		ld	a, (hl)
		jr	loc_E555
sub_E579:
					
		ld	a, (FLAGS)
		or	a
		ret	z
		ld	a, 1
		ret
sub_E581:
		ei
loc_E582:
		call	sub_E579
		jr	z, loc_E582
		push	hl
		ld	hl, FLAGS
		ld	a, (hl)
		bit	6, a
		jr	z, loc_E5B0
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
		jr	nz, loc_E5A9
		ld	(hl), 0
loc_E5A9:
		ld	a, (hl)
		and	7
		jr	nz, loc_E5B7
		ld	(hl), 0
loc_E5B0:
		res	7, (hl)
		di
		call	sub_E76C
		ei
loc_E5B7:
		pop	hl
		ld	a, (LASTK)
		ret
sub_E5BC:
		ld	l, 2Fh
		ld	de, 0FFFFh
		ld	bc, 0FEFEh
loc_E5C4:
		in	a, (c)
		cpl
		and	3Fh
		jr	z, loc_E5D9
		ld	h, a
		ld	a, l
loc_E5CD:
		inc	d
		ret	nz
loc_E5CF:
		sub	8
		srl	h
		jr	nc, loc_E5CF
		ld	d, e
		ld	e, a
		jr	nz, loc_E5CD
loc_E5D9:
		dec	l
		rlc	b
		jr	c, loc_E5C4
		ld	l, 5Fh
		ld	a, c
		ld	bc,  BUFD2+27Eh
		cp	7Eh
		jr	nz, loc_E5C4
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
sub_E5F7:
		ld	a, e
		cp	58h
		ret	nc
		cp	18h
		ret	z
		cp	27h
		ret	z
		scf
		ret
loc_E603:
		sub	80h
		cp	10h
		jr	nc, loc_E610
		ld	hl, TCDKBD
		ld	e, a
		add	hl, de
		ld	a, (hl)
		ret
loc_E610:
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
loc_E621:
		ld	hl, FLGKBD
		cp	1
		jr	nz, loc_E62E
		ld	a, (hl)
		xor	80h
		ld	(hl), a
		jr	loc_E64C
loc_E62E:
		cp	2
		jr	nz, loc_E63F
		set	0, (hl)
		bit	5, c
		jr	z, loc_E64C
		ld	a, 3
loc_E63A:
		ld	(CODEPAGE), a
		jr	loc_E64C
loc_E63F:
		cp	3
		ret	nz
		res	0, (hl)
		bit	5, c
		jr	z, loc_E64C
		ld	a, 1
		jr	loc_E63A
loc_E64C:
		call	sub_E76C
		xor	a
		ret
loc_E651:
		bit	3, b
		jr	nz, loc_E662
		cp	2Dh
		jr	nz, loc_E65C
		ld	a, 1Eh
		ret
loc_E65C:
		cp	3Dh
		ret	nz
		ld	a, 1Fh
		ret
loc_E662:
		bit	0, c
		jr	nz, loc_E685
loc_E666:
		inc	b
		ret	z
		add	a, 10h
		cp	4Bh
		jr	nz, loc_E671
		ld	a, 3Ah
		ret
loc_E671:
		cp	37h
		jr	nz, loc_E678
		ld	a, 22h
		ret
loc_E678:
		cp	4Dh
		jr	nz, loc_E67F
		ld	a, 2Bh
		ret
loc_E67F:
		cp	3Dh
		ret	nz
		ld	a, 5Eh
		ret
loc_E685:
		cp	3Bh
		jr	nz, loc_E68D
		ld	a, 0F6h	; 'ц'
		jr	loc_E6A3
loc_E68D:
		cp	27h
		jr	nz, loc_E695
		ld	a, 0FCh	; 'ь'
		jr	loc_E6A3
loc_E695:
		cp	2Ch
		jr	nz, loc_E69D
		ld	a, 0E2h	; 'в'
		jr	loc_E718
loc_E69D:
		cp	2Eh
		jr	nz, loc_E666
		ld	a, 0E0h	; 'а'
loc_E6A3:
		jr	loc_E718
sub_E6A5:
		ld	a, (FLGKBD)
		and	9Fh
		ld	c, a
		ld	a, (CODEPAGE)
		and	3
		jr	z, loc_E6C4
		set	5, c
		dec	a
		jr	z, loc_E6C2
		dec	a
		jr	nz, loc_E6C4
		res	5, c
		set	6, c
		set	7, c
		jr	loc_E6C4
loc_E6C2:
		res	0, c
loc_E6C4:
		ld	hl, byte_E77F
		ld	d, 0
		add	hl, de
		ld	a, (hl)
		cp	7Fh
		ret	z
		jp	nc, loc_E603
		cp	20h
		jp	c, loc_E621
		cp	30h
		jr	c, loc_E6E0
		cp	3Ah
		jr	c, loc_E749
		cp	40h
loc_E6E0:
		jp	c, loc_E651
		bit	3, b
		jr	z, loc_E746
		bit	0, c
		jr	nz, loc_E70C
		bit	6, c
		ret	nz
		bit	0, b
		jr	z, loc_E6FB
		bit	7, c
		ret	nz
		cp	5Bh
		ret	nc
		add	a, 20h
		ret
loc_E6FB:
		bit	7, c
		jr	z, loc_E707
loc_E6FF:
		add	a, 20h
		cp	80h
		ret	nz
		ld	a, 7Eh
		ret
loc_E707:
		cp	5Bh
		ret	c
		jr	loc_E6FF
loc_E70C:
		cp	60h
		jr	z, loc_E718
		ld	hl, byte_E7D7
		sub	41h
		ld	e, a
		add	hl, de
		ld	a, (hl)
loc_E718:
					
		bit	6, c
		ret	nz
		bit	0, b
		jr	z, loc_E72B
		bit	7, c
		ret	nz
		cp	60h
		ret	z
		cp	5Ch
		ret	z
		sub	20h
		ret
loc_E72B:
		bit	7, c
		jr	z, loc_E739
		sub	20h
		cp	3Ch
		jr	z, loc_E73D
		cp	40h
		jr	loc_E742
loc_E739:
		cp	5Ch
		jr	nz, loc_E740
loc_E73D:
		ld	a, 7Ch
		ret
loc_E740:
		cp	60h
loc_E742:
		ret	nz
		ld	a, 7Eh
		ret
loc_E746:
		and	1Fh
		ret
loc_E749:
		inc	b
		ret	z
		bit	5, b
		jr	nz, loc_E765
		sub	10h
		cp	22h
		jr	z, loc_E762
		cp	27h
		jr	z, loc_E75F
		cp	20h
		ret	nz
		ld	a, 5Fh
		ret
loc_E75F:
		ld	a, 2Ah
		ret
loc_E762:
		ld	a, 40h
		ret
loc_E765:
		ld	e, a
		ld	hl,  TCDKBD+8
		add	hl, de
		ld	a, (hl)
		ret
sub_E76C:
					
		push	bc
		ld	hl, (KBEEP)
		ld	a, (BORDER)
loc_E773:
		xor	10h
		out	(0FEh),	a
		ld	b, l
loc_E778:
		djnz	$
		dec	h
		jr	nz, loc_E773
		pop	bc
		ret
byte_E77F:	db 42h,	48h, 59h, 36h, 35h, 54h, 47h, 56h, 4Eh,	4Ah, 55h
		db 37h,	34h, 52h, 46h, 43h, 4Dh, 4Bh, 49h, 38h,	33h, 45h
		db 44h,	58h, 0Eh, 4Ch, 4Fh, 39h, 32h, 57h, 53h,	5Ah, 20h
		db 0Dh,	50h, 30h, 31h, 51h, 41h, 0Eh, 8Bh, 83h,	5Bh, 8Ch
		db 8Fh,	89h, 86h, 2Eh, 8Ah, 2Fh, 5Dh, 8Eh, 88h,	85h, 27h
		db 82h,	80h, 76h, 7Ch, 7Fh, 8Dh, 87h, 84h, 81h,	62h, 60h
		db 5Ch,	3Dh, 8,	0FFh, 60h, 0FFh, 90h, 68h, 92h,	7Fh, 94h
		db 93h,	91h, 3,	0FFh, 2Ch, 3Bh,	2Dh, 1Bh, 9, 1,	2
byte_E7D7:	db 0E6h, 0E9h, 0F3h, 0F7h, 0F5h, 0E1h, 0F0h, 0F2h, 0FBh
		db 0EFh, 0ECh, 0E4h, 0F8h, 0F4h, 0FDh, 0FAh, 0EAh, 0EBh
		db 0F9h, 0E5h, 0E7h, 0EDh, 0E3h, 0FEh, 0EEh, 0F1h, 0E8h
		db 5Ch,	0FFh, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
AIM2:		db  35h
AZNG:
		INCBIN "font6x8.chr"
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
CODEPAGE:	db 0
					
ATTRIB:		db 7
BORDER:		db 1
NUMCOL:		db  16h
NUMSTR:		db  17h
ADDRZG:		dw AZNG
BUFMEM:		db    0
BUFESC:		db 0
BUFSP:		dw 0B5BEh
FLCUR:		db 81h
ADDRSYM:	dw 0D0E4h
SCBEEP:		dw 0
MFDCUP:		db 0
COUNMO:		db 89h
DOPINT:
		ret
		db  53h	; S
		db  3Bh	; ;
DATE:		db 0, 0, 0
TIME:		db 0, 0, 0, 0, 0, 0
MOTDEL:		db 4
NP_END:		db    0
WD_POS:		db    6
WD_SCR:		db 2Bh
AD_S64:		dw 4004h
BUF_KB:		db 0D7h, 0Ah, 1, 0Ah, 1, 0Ah, 0, 0, 17h, 74h, 0E3h, 59h
PRN_C:		db 38h
					
KBEEP:		dw 540h
KSTAT0:		db 0FFh, 0, 1Dh, 48h
KSTAT4:		db 0FFh, 0, 21h, 0Dh
LASTK:		db 0Dh
					
REPDEL:		db 23h
REPPER:		db 5
FLGKBD:		db 80h
FLAGS:		db 0
FRAMES:		db 11h
		db  7Ah	; z
		db  0Bh
		db    0
SCANK:		dw 0FF21h
TCDKBD:		db 90h,	91h, 92h, 93h, 94h, 95h, 96h, 97h, 98h,	99h, 2Eh
		db 2Bh,	3, 2Fh,	2Ah, 2Dh
TFNKBD:		DB 'DIR ',0, 0,0,0
			DB 'SAVE ',0,0,0
			DB 'USER ',0,0,0
			DB 'TYPE ',0,0,0
			DB 'STAT',0,0,0,0
TKBDD:		db 0, 0, 0, 0, 0, 13h, 18h, 5, 4, 0
PARDA:		db 3, 1, 5, 0, 50h, 0, 28h, 0, 4, 0Fh, 0, 85h, 1, 7Fh
		db 0, 0C0h, 0, 20h, 0, 4, 0
PARDB:		db 0, 1, 5, 0, 50h, 0, 28h, 0, 4, 0Fh, 0, 85h, 1, 7Fh
		db 0, 0C0h, 0, 20h, 0, 4, 0
STACK_BOTTOM:	db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  38h	; 8
		db  38h	; 8
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db  18h
		db    0
		db    0
		db    0
		db  30h	; 0
		db  30h	; 0
		db 0FCh	; ь
		db  30h	; 0
		db  30h	; 0
		db    0
		db 0FCh	; ь
		db    0
		db    0
		db  8Bh	; ‹
		db 0CBh	; Л
		db 0A8h	; Ё
		db    0
		db    0
		db 0DFh	; Я
		db 0D7h	; Ч
		db 0DFh	; Я
		db 0D7h	; Ч
		db 0FFh
		db 0D7h	; Ч
		db  20h
		db    1
		db  55h	; U
		db  10h
		db 0D3h	; У
		db 0E3h	; г
		db  15h
		db  17h
		db  7Fh	; 
		db 0E2h	; в
		db 0A5h	; Ґ
		db 0E2h	; в
		db  54h	; T
		db    0
		db  30h	; 0
		db  30h	; 0
		db  30h	; 0
		db  3Bh	; ;
		db  0Fh
		db 0B4h	; ґ
_SYSTEM:
		jp	loc_F01B
_LISTST:
		jp	sub_F034
loc_F006:
		jp	loc_F112
		jp	loc_F1B4
		jp	loc_F220
		jp	loc_F205
_PUNCH:
		jp	RESET
_READER:
		jp	RESET
		jp	loc_F0AD	; ; 4x8	print procedures
loc_F01B:
		ld	a, (PRN_C)
		bit	7, a
		ld	a, c
		call	z, sub_F03A
sub_F024:
		push	af
		out	(PORT_PRN_DATA), a
loc_F027:
		call	sub_F034
		jr	z, loc_F027
		pop	af
		out	(PORT_PRN_STROBE), a
		jr	LPT_ST
LPT_ST:
		out	(PORT_PRN_DATA), a
		ret
sub_F034:
					
		in	a, (PORT_PRN_READY)
		cpl
		and	80h
		ret
sub_F03A:
		ld	a, (CODEPAGE)
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
		jr	z, loc_F067
		ret
ENCODE_KOI7RUS:
		call	ENCODE_ASCII
		cp	40h
		jr	loc_F064
ENCODE_ASCII:
					
		ld	a, c
		and	7Fh
		ret
ENCODE_KOI7LAT:
		call	ENCODE_ASCII
		cp	60h
loc_F064:
		ret	c
		add	a, 80h
loc_F067:
		cp	0C0h
		ret	c
		push	de
		ld	d, 0
		ld	c, 20h
		sub	0E0h
		jr	nc, loc_F076
		add	a, c
		jr	loc_F077
loc_F076:
		ld	c, d
loc_F077:
		ld	hl, byte_F08D
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
byte_F08D:	db 0CEh, 0B0h, 0B1h, 0C6h, 0B4h, 0B5h, 0C4h, 0B3h, 0C5h
		db 0B8h, 0B9h, 0BAh, 0BBh, 0BCh, 0BDh, 0BEh, 0BFh, 0CFh
		db 0C0h, 0C1h, 0C2h, 0C3h, 0B6h, 0B2h, 0CCh, 0CBh, 0B7h
		db 0C8h, 0CDh, 0C9h, 0C7h, 0CAh
loc_F0AD:
		ld	a, (hl)		; ; 4x8	print procedures
		inc	a
		ld	(loc_F0BB+1), a
		ld	c, 18h
		ld	hl, SCREEN
loc_F0B7:
		ld	b, 8
loc_F0B9:
		push	hl
		push	bc
loc_F0BB:
		ld	b, 1
		dec	b
		jr	z, loc_F0C7
loc_F0C0:
		ld	a, 20h
		call	sub_F024
		djnz	loc_F0C0
loc_F0C7:
		call	sub_F0DA
		pop	bc
		pop	hl
		ld	de, 20h	; ' '
		add	hl, de
		dec	c
		ret	z
		djnz	loc_F0B9
		ld	de, 700h
		add	hl, de
		jr	loc_F0B7
sub_F0DA:
		call	sub_F106
		dec	de
		ld	c, e
		nop
		ld	bc, 201Eh
loc_F0E3:
		push	de
		ld	c, 8
		ld	de, 100h
loc_F0E9:
		ld	b, 8
		push	hl
loc_F0EC:
		rlc	(hl)
		rla
		add	hl, de
		djnz	loc_F0EC
		call	sub_F024
		pop	hl
		dec	c
		jr	nz, loc_F0E9
		inc	hl
		pop	de
		dec	e
		jr	nz, loc_F0E3
		call	sub_F106
		dec	de
		ld	c, d
		jr	loc_F112
		db 0C9h	; Й
sub_F106:
		ex	(sp), hl
		ld	b, 4
loc_F109:
		ld	a, (hl)
		call	sub_F024
		inc	hl
		djnz	loc_F109
		ex	(sp), hl
		ret
loc_F112:
					
; 4x8 print procedures (a lot of code injection below)
		ld	a, c
		cp	2
		jr	c, loc_F12D
		push	hl
		call	sub_F147
		ld	a, d
		rrca
		rrca
		rrca
		or	0D8h
		ld	h, a
		ld	l, e
		ld	a, (ATTRIB)
		ld	(hl), a
		ld	a, c
		call	loc_F163
		pop	hl
		ret
loc_F12D:
		or	a
		ld	a, 0Fh
		ld	b, 0A1h	; 'Ў'
		jr	z, loc_F137
		cpl
		ld	b, 0B1h	; '±'
loc_F137:
		ld	(loc_F175+1), a
		cpl
		ld	(loc_F18C+1), a
		ld	a, b
		ld	(loc_F183), a
		ld	(loc_F196), a
		xor	a
		ret
sub_F147:
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
		or	0C0h
		ld	d, a
		srl	l
		ld	a, 17h
		jr	c, loc_F15F
		xor	a
loc_F15F:
		ld	(loc_F173+1), a
		ret
loc_F163:
		sub	20h
		push	af
		rra
		ld	l, a
		ld	h, 0
		ld	bc, FONT4X8
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, bc
		pop	af
		ex	af, af'
loc_F173:
		jr	loc_F18C
loc_F175:
		ld	c, 0Fh
		ld	b, 8
loc_F179:
		push	bc
		call	sub_F19F
		rlca
		rlca
		rlca
		rlca
		ld	b, a
		ld	a, (de)
loc_F183:
		and	c
		xor	b
		ld	(de), a
		inc	d
		inc	hl
		pop	bc
		djnz	loc_F179
		ret
loc_F18C:
		ld	c, 0F0h	; 'р'
		ld	b, 8
loc_F190:
		push	bc
		call	sub_F19F
		ld	b, a
		ld	a, (de)
loc_F196:
		and	c
		xor	b
		ld	(de), a
		inc	d
		inc	hl
		pop	bc
		djnz	loc_F190
		ret
sub_F19F:
		ex	af, af'
		bit	0, a
		jr	z, loc_F1A9
		ex	af, af'
		ld	a, (hl)
		and	0Fh
		ret
loc_F1A9:
		ex	af, af'
		ld	a, (hl)
		srl	a
		srl	a
		srl	a
		srl	a
		ret
loc_F1B4:
		ld	l, (hl)
		ld	a, (de)
		ld	h, a
sub_F1B7:
		ld	a, h
		cp	0C0h
		ld	(TIME+2), hl
		ret	nc
		push	hl
		ld	a, l
		and	7
		ld	b, a
		ld	a, h
		and	7
		ld	c, a
		srl	l
		srl	l
		srl	l
		ld	a, h
		and	38h
		rlca
		rlca
		or	l
		ld	l, a
		ld	a, h
		and	0C0h
		rrca
		rrca
		rrca
		or	c
		add	a, 0C0h	; 'А'
		ld	h, a
		ld	a, 1
		inc	b
loc_F1E1:
		rrca
		djnz	loc_F1E1
		ld	b, a
		ld	a, (TIME+1)
		cp	1
		ld	a, b
		jr	z, loc_F1F6
		jr	nc, loc_F1F3
		cpl
		and	(hl)
		jr	loc_F1F7
loc_F1F3:
		xor	(hl)
		jr	loc_F1F7
loc_F1F6:
		or	(hl)
loc_F1F7:
		ld	(hl), a
		ld	a, h
		rra
		rra
		rra
		or	0D8h
		ld	h, a
		ld	a, (ATTRIB)
		ld	(hl), a
		pop	hl
		ret
loc_F205:
		ld	a, (de)
		ld	e, (hl)
		ld	d, a
		ld	hl, (TIME+2)
		call	sub_F1B7
		push	hl
		ld	l, e
		call	sub_F223
		ld	h, d
		call	sub_F223
		pop	hl
		ld	e, h
		ld	h, d
		call	sub_F223
		ld	h, e
		jr	sub_F223
loc_F220:
		ld	l, (hl)
		ld	a, (de)
		ld	h, a
sub_F223:
		push	hl
		push	de
		ld	de, (TIME+2)
		ld	a, l
		sub	e
		ld	e, 1
		jr	nc, loc_F233
		ld	e, 0FFh
		neg
loc_F233:
		ld	c, a
		ld	a, h
		sub	d
		ld	d, 1
		jr	nc, loc_F23E
		ld	d, 0FFh
		neg
loc_F23E:
		ld	b, a
		cp	c
		jr	c, loc_F248
		ld	l, c
		push	de
		xor	a
		ld	e, a
		jr	loc_F250
loc_F248:
		or	c
		jr	z, loc_F275
		ld	l, b
		ld	b, c
		push	de
		ld	d, 0
loc_F250:
		ld	h, b
		ld	a, b
		rra
loc_F253:
		add	a, l
		jr	c, loc_F259
		cp	h
		jr	c, loc_F260
loc_F259:
		sub	h
		ld	c, a
		exx
		pop	bc
		push	bc
		jr	loc_F264
loc_F260:
		ld	c, a
		push	de
		exx
		pop	bc
loc_F264:
		ld	hl, (TIME+2)
		ld	a, b
		add	a, h
		ld	h, a
		ld	a, c
		add	a, l
		ld	l, a
		call	sub_F1B7
		exx
		ld	a, c
		djnz	loc_F253
		pop	de
loc_F275:
		pop	de
		pop	hl
		ret
		db 0D1h, 0D1h, 0E1h, 0C9h, 0CBh, 27h, 0CBh, 27h	; _garbage
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
ALV0:		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FEh, 3Fh, 0FFh,	0C0h, 0, 0, 0, 0, 0, 0
		db 0, 33h
ALV1:		db 0B1h, 33h, 54h, 0, 0Ah, 0, 36h, 0DBh, 3Fh, 0AAh, 0F3h, 0A9h,	0F6h, 39h, 0B8h, 5Ch
		db 0B9h, 5Ch, 0Ah, 17h,	5Ch, 0,	0F7h, 15h, 7Fh,	10h, 0E1h, 15h,	3Bh, 0Fh, 7Fh, 10h
		db 54h,	0FFh, 0B4h, 12h, 0, 3Eh, 0, 18h, 24h, 42h, 7Eh,	42h, 42h, 0, 0,	7Ch
		db 22h,	3Ch
ALV2:		db 22h,	22h, 7Ch, 0, 0,	3Ch, 42h, 40h, 40h, 42h, 3Ch, 0, 0, 7Ch, 22h, 22h
		db 22h,	22h, 7Ch, 0, 0,	7Eh, 20h, 3Ch, 20h, 20h, 7Eh, 0, 0, 7Eh, 20h, 3Ch
		db 20h,	20h, 70h, 0, 0,	3Ch, 42h, 40h, 4Eh, 42h, 3Ch, 0, 0, 42h, 42h, 7Eh
		db 42h,	42h
CSV0:		db 0C7h, 0B5h, 8Fh, 0B3h, 4Dh, 8, 0CBh,	7Ch, 0ACh, 8Eh,	0B3h, 31h, 0D2h, 95h, 94h, 0A4h
		db 1Bh,	44h, 0E0h, 2Dh,	80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h,	80h, 80h, 80h, 80h
CSV1:		db 7Eh,	0, 0, 42h, 66h,	5Ah, 42h, 42h, 42h, 0, 0, 42h, 62h, 52h, 4Ah, 46h
		db 42h,	0, 0, 3Ch, 42h,	42h, 42h, 42h, 3Ch, 0, 0, 7Ch, 22h, 22h, 3Ch, 20h
CSV2:		db 70h,	0, 0, 3Ch, 42h,	42h, 52h, 4Ah, 3Ch, 0, 0, 7Ch, 22h, 22h, 3Ch, 24h
		db 22h,	0, 0, 3Ch, 40h,	3Ch, 2,	42h, 3Ch, 0, 0,	0FEh, 92h, 10h,	10h, 10h
REZ2:		db 38h,	0, 0, 42h, 42h,	42h, 42h, 42h, 3Ch, 0
BUFD1:	EQU $
BUFD2:	EQU $ + 0400H

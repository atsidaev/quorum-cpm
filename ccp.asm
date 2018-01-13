	INCLUDE "defines.inc"

	ORG	CCP_START
;
CBASE:	JP	COMMAND		;execute command processor (ccp).
	JP	CLEARBUF	;entry to empty input buffer before starting ccp.

;
;   Standard cp/m ccp input buffer. Format is (max length),
; (actual length), (char #1), (char #2), (char #3), etc.
;
INBUFF:	DEFB	127		;length of input buffer.
BOOTCMD:
	DEFB	0		;current length of contents. Also the boot command is stored here.
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0
INPOINT:DEFW	INBUFF+5	;input line pointer
NAMEPNT:DEFW	INBUFF+5	;input line pointer used for error message. Points to
;			;start of name in error.
;
;   Routine to print (A) on the console. All registers used.
;
PRINT:	LD	E,A		;setup bdos call.
	LD	C,2
	JP	ENTRY
;
;   Routine to print (A) on the console and to save (BC).
;
PRINTB:	PUSH	BC
	CALL	PRINT
	POP	BC
	RET	
;
;   Routine to send a carriage return, line feed combination
; to the console.
;
CRLF:	LD	A,CR
	CALL	PRINTB
	LD	A,LF
	JR	PRINTB
;
;   Routine to send one space to the console and save (BC).
;
SPACE:	LD	A,' '
	JR	PRINTB
;
;   Routine to print character string pointed to be (BC) on the
; console. It must terminate with a null byte.
;
PLINE:	PUSH	BC
	CALL	CRLF
	POP	HL
PLINE2:	LD	A,(HL)
	OR	A
	RET	Z
	INC	HL
	PUSH	HL
	CALL	PRINT
	POP	HL
	JR	PLINE2
;
;   Routine to reset the disk system.
;
RESDSK:	LD	C,13
	JP	ENTRY
;
;   Routine to select disk (A).
;
DSKSEL:	LD	E,A
	LD	C,14
	JP	ENTRY
;
;   Routine to call bdos and save the return code. The zero
; flag is set on a return of 0ffh.
;
ENTRY1:	CALL	ENTRY
	LD	(RTNCODE),A	;save return code.
	INC	A		;set zero if 0ffh returned.
	RET	
;
;   Routine to open a file. (DE) must point to the FCB.
;
OPEN:	LD	C,15
	JR	ENTRY1
;
;   Routine to open file at (FCB).
;
OPENFCB:XOR	A		;clear the record number byte at fcb+32
	LD	(FCB+32),A
	LD	DE,FCB
	JR	OPEN
;
;   Routine to close a file. (DE) points to FCB.
;
CLOSE:	LD	C,16
	JR	ENTRY1
;
;   Routine to search for the first file with ambigueous name
; (DE).
;
SRCHFST:LD	C,17
	JR	ENTRY1
;
;   Search for the next ambigeous file name.
;
SRCHNXT:LD	C,18
	JR	ENTRY1
;
;   Search for file at (FCB).
;
SRCHFCB:LD	DE,FCB
	JR	SRCHFST
;
;   Routine to delete a file pointed to by (DE).
;
DELETE:	LD	C,19
	JP	ENTRY
;
;   Routine to call the bdos and set the zero flag if a zero
; status is returned.
;
ENTRY2:	CALL	ENTRY
	OR	A		;set zero flag if appropriate.
	RET	
;
;   Routine to read the next record from a sequential file.
; (DE) points to the FCB.
;
RDREC:	LD	C,20
	JR	ENTRY2
;
;   Routine to read file at (FCB).
;
READFCB:LD	DE,FCB
	JR	RDREC
;
;   Routine to write the next record of a sequential file.
; (DE) points to the FCB.
;
WRTREC:	LD	C,21
	JR	ENTRY2
;
;   Routine to create the file pointed to by (DE).
;
CREATE:	LD	C,22
	JR	ENTRY1
;
;   Routine to rename the file pointed to by (DE). Note that
; the new name starts at (DE+16).
;
RENAM:	LD	C,23
	JP	ENTRY
;
;   Get the current user code.
;
GETUSR:	LD	E,0FFH
;
;   Routne to get or set the current user code.
; If (E) is FF then this is a GET, else it is a SET.
;
GETSETUC: LD	C,32
	JP	ENTRY
;
;   Routine to set the current drive byte at (TDRIVE).
;
SETCDRV:CALL	GETUSR		;get user number
	ADD	A,A		;and shift into the upper 4 bits.
	ADD	A,A
	ADD	A,A
	ADD	A,A
	LD	HL,CDRIVE	;now add in the current drive number.
	OR	(HL)
__l1:
	LD	(TDRIVE),A	;and save.
	RET	
;
;   Move currently active drive down to (TDRIVE).
;
MOVECD:	LD	A,(CDRIVE)
	JR __l1
;
;   Routine to convert (A) into upper case ascii. Only letters
; are affected.
;
UPPER:	CP	'a'		;check for letters in the range of 'a' to 'z'.
	RET	C
	CP	'{'
	RET	NC
	AND	5FH		;convert it if found.
	RET	
;
;   Routine to get a line of input. We must check to see if the
; user is in (BATCH) mode. If so, then read the input from file
; ($$$.SUB). At the end, reset to console input.
;
GETINP:	LD	A,(BATCH)	;if =0, then use console input.
	OR	A
	JR	Z,GETINP1
;
;   Use the submit file ($$$.sub) which is prepared by a
; SUBMIT run. It must be on drive (A) and it will be deleted
; if and error occures (like eof).
;
	LD	A,(CDRIVE)	;select drive 0 if need be.
	OR	A
	LD	A,0		;always use drive A for submit.
	CALL	NZ,DSKSEL	;select it if required.
	LD	DE,BATCHFCB
	CALL	OPEN		;look for it.
	JR	Z,GETINP1	;if not there, use normal input.
	LD	A,(BATCHFCB+15)	;get last record number+1.
	DEC	A
	LD	(BATCHFCB+32),A
	LD	DE,BATCHFCB
	CALL	RDREC		;read last record.
	JR	NZ,GETINP1	;quit on end of file.
;
;   Move this record into input buffer.
;
	LD	DE,INBUFF+1
	LD	HL,TBUFF	;data was read into buffer here.
	LD	B,128		;all 128 characters may be used.
	CALL	HL2DE		;(HL) to (DE), (B) bytes.
	LD	HL,BATCHFCB+14
	LD	(HL),0		;zero out the 's2' byte.
	INC	HL		;and decrement the record count.
	DEC	(HL)
	LD	DE,BATCHFCB	;close the batch file now.
	CALL	CLOSE
	JR	Z,GETINP1	;quit on an error.
	LD	A,(CDRIVE)	;re-select previous drive if need be.
	OR	A
	CALL	NZ,DSKSEL	;don't do needless selects.
;
;   Print line just read on console.
;
	LD	HL,INBUFF+2
	CALL	PLINE2
	CALL	CHKCON		;check console, quit on a key.
	JR	Z,GETINP2	;jump if no key is pressed.
;
;   Terminate the submit job on any keyboard input. Delete this
; file such that it is not re-started and jump to normal keyboard
; input section.
;
	CALL	DELBATCH	;delete the batch file.
	JP	CMMND1		;and restart command input.
;
;   Get here for normal keyboard input. Delete the submit file
; incase there was one.
;
GETINP1:CALL	DELBATCH	;delete file ($$$.sub).
	CALL	SETCDRV		;reset active disk.
	LD	C,10		;get line from console device.
	LD	DE,INBUFF
	CALL	ENTRY
	CALL	MOVECD		;reset current drive (again).
;
;   Convert input line to upper case.
;
GETINP2:LD	HL,INBUFF+1
	LD	B,(HL)		;(B)=character counter.
GETINP3:INC	HL
	LD	A,B		;end of the line?
	OR	A
	JR	Z,GETINP4
	LD	A,(HL)		;convert to upper case.
	CALL	UPPER
	LD	(HL),A
	DEC	B		;adjust character count.
	JR	GETINP3
GETINP4:LD	(HL),A		;add trailing null.
	LD	HL,INBUFF+2
	LD	(INPOINT),HL	;reset input line pointer.
	RET	
;
;   Routine to check the console for a key pressed. The zero
; flag is set is none, else the character is returned in (A).
;
CHKCON:	LD	C,11		;check console.
	CALL	ENTRY
	OR	A
	RET	Z		;return if nothing.
	LD	C,1		;else get character.
	CALL	ENTRY
	OR	A		;clear zero flag and return.
	RET	
;
;   Routine to get the currently active drive number.
;
GETDSK:	LD	C,25
	JP	ENTRY
;
;   Set the stabdard dma address.
;
STDDMA:	LD	DE,TBUFF
;
;   Routine to set the dma address to (DE).
;
DMASET:	LD	C,26
	JP	ENTRY
;
;  Delete the batch file created by SUBMIT.
;
DELBATCH: LD	HL,BATCH	;is batch active?
	LD	A,(HL)
	OR	A
	RET	Z
	LD	(HL),0		;yes, de-activate it.
	XOR	A
	CALL	DSKSEL		;select drive 0 for sure.
	LD	DE,BATCHFCB	;and delete this file.
	CALL	DELETE
	LD	A,(CDRIVE)	;reset current drive.
	JP	DSKSEL
;
;   Check to two strings at (PATTRN1) and (PATTRN2). They must be
; the same or we halt....
;
VERIFY:	LD	DE,PATTRN1	;these are the serial number bytes.
	LD	HL,PATTRN2	;ditto, but how could they be different?
	LD	B,6		;6 bytes each.
VERIFY1:LD	A,(DE)
	CP	(HL)
	JP	NZ,HALT		;jump to halt routine.
	INC	DE
	INC	HL
	DJNZ VERIFY1
	RET	
;
;   Print back file name with a '?' to indicate a syntax error.
;
SYNERR:	CALL	CRLF		;end current line.
	LD	HL,(NAMEPNT)	;this points to name in error.
SYNERR1:LD	A,(HL)		;print it until a space or null is found.
	CP	' '
	JR	Z,SYNERR2
	OR	A
	JR	Z,SYNERR2
	PUSH	HL
	CALL	PRINT
	POP	HL
	INC	HL
	JR	SYNERR1
SYNERR2:LD	A,'?'		;add trailing '?'.
	CALL	PRINT
	CALL	CRLF
	CALL	DELBATCH	;delete any batch file.
	JP	CMMND1		;and restart from console input.
;
;   Check character at (DE) for legal command input. Note that the
; zero flag is set if the character is a delimiter.
;
CHECK:	LD	A,(DE)
	OR	A
	RET	Z
	CP	' '		;control characters are not legal here.
	JR	C,SYNERR
	RET	Z		;check for valid delimiter.
	CP	'='
	RET	Z
	CP	'_'
	RET	Z
	CP	'.'
	RET	Z
	CP	':'
	RET	Z
	CP	';'
	RET	Z
	CP	'<'
	RET	Z
	CP	'>'
	RET	Z
	RET	
;
;   Get the next non-blank character from (DE).
;
NONBLANK: LD	A,(DE)
	OR	A		;string ends with a null.
	RET	Z
	CP	' '
	RET	NZ
	INC	DE
	JR	NONBLANK
;
;   Add (HL)=(HL)+(A)
;
ADDHL:	ADD	A,L
	LD	L,A
	RET	NC		;take care of any carry.
	INC	H
	RET	
;
;   Convert the first name in (FCB).
;
CONVFST:LD	A,0
;
;   Format a file name (convert * to '?', etc.). On return,
; (A)=0 is an unambigeous name was specified. Enter with (A) equal to
; the position within the fcb for the name (either 0 or 16).
;
CONVERT:LD	HL,FCB
	CALL	ADDHL
	PUSH	HL
	PUSH	HL
	XOR	A
	LD	(CHGDRV),A	;initialize drive change flag.
	LD	HL,(INPOINT)	;set (HL) as pointer into input line.
	EX	DE,HL
	CALL	NONBLANK	;get next non-blank character.
	LD	(NAMEPNT),DE	;save pointer here for any error message.
	POP	HL
	LD	A,(DE)		;get first character.
	OR	A
	JR	Z,CONVRT1
	SBC	A,'A'-1		;might be a drive name, convert to binary.
	LD	B,A		;and save.
	INC	DE		;check next character for a ':'.
	LD	A,(DE)
	CP	':'
	JR	Z,CONVRT2
	DEC	DE		;nope, move pointer back to the start of the line.
CONVRT1:LD	A,(CDRIVE)
	LD	(HL),A
	JR	CONVRT3
CONVRT2:LD	A,B
	LD	(CHGDRV),A	;set change in drives flag.
	LD	(HL),B
	INC	DE
;
;   Convert the basic file name.
;
CONVRT3:LD	B,08H
CONVRT4:CALL	CHECK
	JR	Z,CONVRT8
	INC	HL
	CP	'*'		;note that an '*' will fill the remaining
	JR	NZ,CONVRT5	;field with '?'.
	LD	(HL),'?'
	JR	CONVRT6
CONVRT5:LD	(HL),A
	INC	DE
CONVRT6: DJNZ CONVRT4
CONVRT7:CALL	CHECK		;get next delimiter.
	JR	Z,GETEXT
	INC	DE
	JR	CONVRT7
CONVRT8:INC	HL		;blank fill the file name.
	LD	(HL),' '
	DJNZ CONVRT8
;
;   Get the extension and convert it.
;
GETEXT:	LD	B,03H
	CP	'.'
	JR	NZ,GETEXT5
	INC	DE
GETEXT1:CALL	CHECK
	JR	Z,GETEXT5
	INC	HL
	CP	'*'
	JR	NZ,GETEXT2
	LD	(HL),'?'
	JR	GETEXT3
GETEXT2:LD	(HL),A
	INC	DE
GETEXT3:DJNZ GETEXT1
GETEXT4:CALL	CHECK
	JR	Z,GETEXT6
	INC	DE
	JR	GETEXT4
GETEXT5:INC	HL
	LD	(HL),' '
	DJNZ GETEXT5
GETEXT6:LD	B,3
GETEXT7:INC	HL
	LD	(HL),0
	DJNZ GETEXT7
	EX	DE,HL
	LD	(INPOINT),HL	;save input line pointer.
	POP	HL
;
;   Check to see if this is an ambigeous file name specification.
; Set the (A) register to non zero if it is.
;
	LD	BC,11		;set name length.
GETEXT8:INC	HL
	LD	A,(HL)
	CP	'?'		;any question marks?
	JR	NZ,GETEXT9
	INC	B		;count them.
GETEXT9:DEC	C
	JR	NZ,GETEXT8
	LD	A,B
	OR	A
	RET	
;
;   CP/M command table. Note commands can be either 3 or 4 characters long.
;
NUMCMDS: EQU	6		;number of commands
CMDTBL:	DEFB	'DIR '
	DEFB	'ERA '
	DEFB	'TYPE'
	DEFB	'SAVE'
	DEFB	'REN '
	DEFB	'USER'
;
;   The following six bytes must agree with those at (PATTRN2)
; or cp/m will HALT. Why?
;
; Quorum: was 0,22,0,0,0,0
PATTRN1:DEFB	0,0,0,0,0,0	;(* serial number bytes *).
;
;   Search the command table for a match with what has just
; been entered. If a match is found, then we jump to the
; proper section. Else jump to (UNKNOWN).
; On return, the (C) register is set to the command number
; that matched (or NUMCMDS+1 if no match).
;
SEARCH:	LD	HL,CMDTBL
	LD	C,0
SEARCH1:LD	A,C
	CP	NUMCMDS		;this commands exists.
	RET	NC
	LD	DE,FCB+1	;check this one.
	LD	B,4		;max command length.
SEARCH2:LD	A,(DE)
	CP	(HL)
	JR	NZ,SEARCH3	;not a match.
	INC	DE
	INC	HL
	DJNZ SEARCH2
	LD	A,(DE)		;allow a 3 character command to match.
	CP	' '
	JR	NZ,SEARCH4
	LD	A,C		;set return register for this command.
	RET	
SEARCH3:INC	HL
	DJNZ SEARCH3
SEARCH4:INC	C
	JR	SEARCH1
;
;   Set the input buffer to empty and then start the command
; processor (ccp).
;
CLEARBUF: XOR	A
	LD	(INBUFF+1),A	;second byte is actual length.
;
;**************************************************************
;*
;*
;* C C P  -   C o n s o l e   C o m m a n d   P r o c e s s o r
;*
;**************************************************************
;*
COMMAND:LD	SP,CCPSTACK	;setup stack area.
	PUSH	BC		;note that (C) should be equal to:
	LD	A,C		;(uuuudddd) where 'uuuu' is the user number
	RRA			;and 'dddd' is the drive number.
	RRA	
	RRA	
	RRA	
	AND	0FH		;isolate the user number.
	LD	E,A
	CALL	GETSETUC	;and set it.
	CALL	RESDSK		;reset the disk system.
	LD	(BATCH),A	;clear batch mode flag.
	POP	BC
	LD	A,C
	AND	0FH		;isolate the drive number.
	LD	(CDRIVE),A	;and save.
	CALL	DSKSEL		;...and select.
	LD	A,(INBUFF+1)
	OR	A		;anything in input buffer already?
	JR	NZ,CMMND2	;yes, we just process it.
;
;   Entry point to get a command line from the console.
;
CMMND1:	LD	SP,CCPSTACK	;set stack straight.
	CALL	CRLF		;start a new line on the screen.
	CALL	GETDSK		;get current drive.
	ADD	A,'A'
	CALL	PRINT		;print current drive.
	LD	A,'>'
	CALL	PRINT		;and add prompt.
	CALL	GETINP		;get line from user.
;
;   Process command line here.
;
CMMND2:	LD	DE,TBUFF
	CALL	DMASET		;set standard dma address.
	CALL	GETDSK
	LD	(CDRIVE),A	;set current drive.
	CALL	CONVFST		;convert name typed in.
	CALL	NZ,SYNERR	;wild cards are not allowed.
	LD	A,(CHGDRV)	;if a change in drives was indicated,
	OR	A		;then treat this as an unknown command
	JP	NZ,UNKNOWN	;which gets executed.
	CALL	SEARCH		;else search command table for a match.
;
;   Note that an unknown command returns
; with (A) pointing to the last address
; in our table which is (UNKNOWN).
;
	LD	HL,CMDADR	;now, look thru our address table for command (A).
	LD	E,A		;set (DE) to command number.
	LD	D,0
	ADD	HL,DE
	ADD	HL,DE		;(HL)=(CMDADR)+2*(command number).
	LD	A,(HL)		;now pick out this address.
	INC	HL
	LD	H,(HL)
	LD	L,A
	JP	(HL)		;now execute it.
;
;   CP/M command address table.
;
CMDADR:	DEFW	DIRECT,ERASE,TYPE,SAVE
	DEFW	RENAME,USER,UNKNOWN
;
;   Halt the system. Reason for this is unknown at present.
;
HALT:	LD	HL,76F3H	;'DI HLT' instructions.
	LD	(CBASE),HL
	LD	HL,CBASE
	JP	(HL)
;
;   Read error while TYPEing a file.
;
RDERROR:LD	BC,RDERR
	JP	PLINE
RDERR:	DEFB	'READ ERROR',0
;
;   Required file was not located.
;
NONE:	LD	BC,NOFILE
	JP	PLINE
NOFILE:	DEFB	'NO FILE',0
;
;   Decode a command of the form 'A>filename number{ filename}.
; Note that a drive specifier is not allowed on the first file
; name. On return, the number is in register (A). Any error
; causes 'filename?' to be printed and the command is aborted.
;
DECODE:	CALL	CONVFST		;convert filename.
	LD	A,(CHGDRV)	;do not allow a drive to be specified.
	OR	A
	JR	NZ,_j_synerr
	LD	HL,FCB+1	;convert number now.
	LD	BC,11		;(B)=sum register, (C)=max digit count.
DECODE1:LD	A,(HL)
	CP	' '		;a space terminates the numeral.
	JR	Z,DECODE3
	INC	HL
	SUB	'0'		;make binary from ascii.
	CP	10		;legal digit?
	JR	NC,_j_synerr
	LD	D,A		;yes, save it in (D).
	LD	A,B		;compute (B)=(B)*10 and check for overflow.
	AND	0E0H
	JR	NZ,_j_synerr
	LD	A,B
	RLCA	
	RLCA	
	RLCA			;(A)=(B)*8
	ADD	A,B		;.......*9
	JR	C,_j_synerr
	ADD	A,B		;.......*10
	JR	C,_j_synerr
	ADD	A,D		;add in new digit now.
DECODE2:JR	C,_j_synerr
	LD	B,A		;and save result.
	DEC	C		;only look at 11 digits.
	JR	NZ,DECODE1
	RET	
DECODE3:LD	A,(HL)		;spaces must follow (why?).
	CP	' '
	JR	NZ,_j_synerr
	INC	HL
DECODE4:DEC	C
	JR	NZ,DECODE3
	LD	A,B		;set (A)=the numeric value entered.
	RET	

;Quorum
_j_synerr:
	JP SYNERR
;
;   Move 3 bytes from (HL) to (DE). Note that there is only
; one reference to this at (A2D5h).
;
MOVE3:	LD	B,3
;
;   Move (B) bytes from (HL) to (DE).
;
HL2DE:	LD	A,(HL)
	LD	(DE),A
	INC	HL
	INC	DE
	DJNZ HL2DE
	RET	
;
;   Compute (HL)=(TBUFF)+(A)+(C) and get the byte that's here.
;
EXTRACT:LD	HL,TBUFF
	ADD	A,C
	CALL	ADDHL
	LD	A,(HL)
	RET	
;
;  Check drive specified. If it means a change, then the new
; drive will be selected. In any case, the drive byte of the
; fcb will be set to null (means use current drive).
;
DSELECT:XOR	A		;null out first byte of fcb.
	LD	(FCB),A
	LD	A,(CHGDRV)	;a drive change indicated?
	OR	A
	RET	Z
	DEC	A		;yes, is it the same as the current drive?
	LD	HL,CDRIVE
	CP	(HL)
	RET	Z
	JP	DSKSEL		;no. Select it then.
;
;   Check the drive selection and reset it to the previous
; drive if it was changed for the preceeding command.
;
RESETDR:LD	A,(CHGDRV)	;drive change indicated?
	OR	A
	RET	Z
	DEC	A		;yes, was it a different drive?
	LD	HL,CDRIVE
	CP	(HL)
	RET	Z
	LD	A,(CDRIVE)	;yes, re-select our old drive.
	JP	DSKSEL
;
;**************************************************************
;*
;*           D I R E C T O R Y   C O M M A N D
;*
;**************************************************************
;
DIRECT:	CALL	CONVFST		;convert file name.
	CALL	DSELECT		;select indicated drive.
	LD	HL,FCB+1	;was any file indicated?
	LD	A,(HL)
	CP	' '
	JR	NZ,DIRECT2
	LD	B,11		;no. Fill field with '?' - same as *.*.
DIRECT1:LD	(HL),'?'
	INC	HL
	DJNZ DIRECT1
DIRECT2:LD	E,0		;set initial cursor position.
	PUSH	DE
	CALL	SRCHFCB		;get first file name.
	CALL	Z,NONE		;none found at all?
DIRECT3:JR	Z,DIRECT9	;terminate if no more names.
	LD	A,(RTNCODE)	;get file's position in segment (0-3).
	RRCA	
	RRCA	
	RRCA	
	AND	60H		;(A)=position*32
	LD	C,A
	LD	A,10
	CALL	EXTRACT		;extract the tenth entry in fcb.
	RLA			;check system file status bit.
	JR	C,DIRECT8	;we don't list them.
	POP	DE
	LD	A,E		;bump name count.
	INC	E
	PUSH	DE
	AND	01H		;at end of line?
	PUSH	AF
	JR	NZ,DIRECT4
	CALL	CRLF		;yes, end this line and start another.
	PUSH	BC
	CALL	GETDSK		;start line with ('A:').
	POP	BC
	ADD	A,'A'
	CALL	PRINTB
	LD	A,':'
	CALL	PRINTB
	JR	DIRECT5
DIRECT4:CALL	SPACE		;add seperator between file names.
	LD	A,':'
	CALL	PRINTB
DIRECT5:CALL	SPACE
	LD	B,1		;'extract' each file name character at a time.
DIRECT6:LD	A,B
	CALL	EXTRACT
	AND	7FH		;strip bit 7 (status bit).
	CP	' '		;are we at the end of the name?
	JR	NZ,DRECT65
	POP	AF		;yes, don't print spaces at the end of a line.
	PUSH	AF
	CP	3
	JR	NZ,DRECT63
	LD	A,9		;first check for no extension.
	CALL	EXTRACT
	AND	7FH
	CP	' '
	JR	Z,DIRECT7	;don't print spaces.
DRECT63:LD	A,' '		;else print them.
DRECT65:CALL	PRINTB
	INC	B		;bump to next character psoition.
	LD	A,B
	CP	12		;end of the name?
	JR	NC,DIRECT7
	CP	9		;nope, starting extension?
	JR	NZ,DIRECT6
	CALL	SPACE		;yes, add seperating space.
	JR	DIRECT6
DIRECT7:POP	AF		;get the next file name.
DIRECT8:CALL	CHKCON		;first check console, quit on anything.
	JR	NZ,DIRECT9
	CALL	SRCHNXT		;get next name.
	JR	DIRECT3		;and continue with our list.
DIRECT9:POP	DE		;restore the stack and return to command level.
	JR __near_getback; // JP GETBACK
;
;**************************************************************
;*
;*                E R A S E   C O M M A N D
;*
;**************************************************************
;
ERASE:	CALL	CONVFST		;convert file name.
	CP	11		;was '*.*' entered?
	JR	NZ,ERASE1
	LD	BC,YESNO	;yes, ask for confirmation.
	CALL	PLINE
	CALL	GETINP
	LD	HL,INBUFF+1
	DEC	(HL)		;must be exactly 'y'.
	JP	NZ,CMMND1
	INC	HL
	LD	A,(HL)
	CP	'Y'
	JP	NZ,CMMND1
	INC	HL
	LD	(INPOINT),HL	;save input line pointer.
ERASE1:	CALL	DSELECT		;select desired disk.
	LD	DE,FCB
	CALL	DELETE		;delete the file.
	INC	A
	CALL	Z,NONE		;not there?
__near_getback:
	JP	GETBACK		;return to command level now.
YESNO:	DEFB	'ALL (Y/N)?',0
;
;**************************************************************
;*
;*            T Y P E   C O M M A N D
;*
;**************************************************************
;
TYPE:	CALL	CONVFST		;convert file name.
	JP	NZ,SYNERR	;wild cards not allowed.
	CALL	DSELECT		;select indicated drive.
	CALL	OPENFCB		;open the file.
	JR	Z,TYPE5		;not there?
	CALL	CRLF		;ok, start a new line on the screen.
	LD	HL,NBYTES	;initialize byte counter.
	LD	(HL),0FFH	;set to read first sector.
TYPE1:	LD	HL,NBYTES
TYPE2:	LD	A,(HL)		;have we written the entire sector?
	CP	128
	JR	C,TYPE3
	PUSH	HL		;yes, read in the next one.
	CALL	READFCB
	POP	HL
	JR	NZ,TYPE4	;end or error?
	XOR	A		;ok, clear byte counter.
	LD	(HL),A
TYPE3:	INC	(HL)		;count this byte.
	LD	HL,TBUFF	;and get the (A)th one from the buffer (TBUFF).
	CALL	ADDHL
	LD	A,(HL)
	CP	CNTRLZ		;end of file mark?
	JR	Z,__near_getback ; JP GETBACK
	CALL	PRINT		;no, print it.
	CALL	CHKCON		;check console, quit if anything ready.
	JR	NZ, __near_getback; JP NZ, GETBACK
	JR	TYPE1
;
;   Get here on an end of file or read error.
;
TYPE4:	DEC	A		;read error?
	JR	Z,__near_getback	; JP Z, GETBACK
	CALL	RDERROR		;yes, print message.
TYPE5:	CALL	RESETDR		;and reset proper drive
	JP	SYNERR		;now print file name with problem.
;
;**************************************************************
;*
;*            S A V E   C O M M A N D
;*
;**************************************************************
;
SAVE:	CALL	DECODE		;get numeric number that follows SAVE.
	PUSH	AF		;save number of pages to write.
	CALL	CONVFST		;convert file name.
	JP	NZ,SYNERR	;wild cards not allowed.
	CALL	DSELECT		;select specified drive.
	LD	DE,FCB		;now delete this file.
	PUSH	DE
	CALL	DELETE
	POP	DE
	CALL	CREATE		;and create it again.
	JR	Z,SAVE3		;can't create?
	XOR	A		;clear record number byte.
	LD	(FCB+32),A
	POP	AF		;convert pages to sectors.
	LD	L,A
	LD	H,0
	ADD	HL,HL		;(HL)=number of sectors to write.
	LD	DE,TBASE	;and we start from here.
SAVE1:	LD	A,H		;done yet?
	OR	L
	JR	Z,SAVE2
	DEC	HL		;nope, count this and compute the start
	PUSH	HL		;of the next 128 byte sector.
	LD	HL,128
	ADD	HL,DE
	PUSH	HL		;save it and set the transfer address.
	CALL	DMASET
	LD	DE,FCB		;write out this sector now.
	CALL	WRTREC
	POP	DE		;reset (DE) to the start of the last sector.
	POP	HL		;restore sector count.
	JR	NZ,SAVE3	;write error?
	JR	SAVE1
;
;   Get here after writing all of the file.
;
SAVE2:	LD	DE,FCB		;now close the file.
	CALL	CLOSE
	INC	A		;did it close ok?
	JR	NZ,SAVE4
;
;   Print out error message (no space).
;
SAVE3:	LD	BC,NOSPACE
	CALL	PLINE
SAVE4:	CALL	STDDMA		;reset the standard dma address.
	JR	__get_getback_2	; JP GETBACK
NOSPACE:DEFB	'NO SPACE',0
;
;**************************************************************
;*
;*           R E N A M E   C O M M A N D
;*
;**************************************************************
;
RENAME:	CALL	CONVFST		;convert first file name.
	JR	NZ,__near_synerr	;	JP NZ, SYNERR	;wild cards not allowed.
	LD	A,(CHGDRV)	;remember any change in drives specified.
	PUSH	AF
	CALL	DSELECT		;and select this drive.
	CALL	SRCHFCB		;is this file present?
	JR	NZ,RENAME6	;yes, print error message.
	LD	HL,FCB		;yes, move this name into second slot.
	LD	DE,FCB+16
	LD	B,16
	CALL	HL2DE
	LD	HL,(INPOINT)	;get input pointer.
	EX	DE,HL
	CALL	NONBLANK	;get next non blank character.
	CP	'='		;only allow an '=' or '_' seperator.
	JR	Z,RENAME1
	CP	'_'
	JR	NZ,RENAME5
RENAME1:EX	DE,HL
	INC	HL		;ok, skip seperator.
	LD	(INPOINT),HL	;save input line pointer.
	CALL	CONVFST		;convert this second file name now.
	JR	NZ,RENAME5	;again, no wild cards.
	POP	AF		;if a drive was specified, then it
	LD	B,A		;must be the same as before.
	LD	HL,CHGDRV
	LD	A,(HL)
	OR	A
	JR	Z,RENAME2
	CP	B
	LD	(HL),B
	JR	NZ,RENAME5	;they were different, error.
RENAME2:LD	(HL),B		;	reset as per the first file specification.
	XOR	A
	LD	(FCB),A		;clear the drive byte of the fcb.
RENAME3:CALL	SRCHFCB		;and go look for second file.
	JR	Z,RENAME4	;doesn't exist?
	LD	DE,FCB
	CALL	RENAM		;ok, rename the file.
__get_getback_2:
	JP	GETBACK
;
;   Process rename errors here.
;
RENAME4:CALL	NONE		;file not there.
	JR	__get_getback_2	; JP GETBACK
RENAME5:CALL	RESETDR		;bad command format.
__near_synerr:
	JP	SYNERR
RENAME6:LD	BC,EXISTS	;destination file already exists.
	CALL	PLINE
	JR	__get_getback_2	; JP GETBACK
EXISTS:	DEFB	'FILE EXISTS',0
;
;**************************************************************
;*
;*             U S E R   C O M M A N D
;*
;**************************************************************
;
USER:	CALL	DECODE		;get numeric value following command.
	CP	16		;legal user number?
	JR	NC,__near_synerr ; JP NC, SYNERR
	LD	E,A		;yes but is there anything else?
	LD	A,(FCB+1)
	CP	' '
	JR	Z,__near_synerr	; JP SYNERR	;yes, that is not allowed.
	CALL	GETSETUC	;ok, set user code.
	JR	__near_getback1	; JP GETBACK1
;
;**************************************************************
;*
;*        T R A N S I A N T   P R O G R A M   C O M M A N D
;*
;**************************************************************
;
UNKNOWN:CALL	VERIFY		;check for valid system (why?).
	LD	A,(FCB+1)	;anything to execute?
	CP	' '
	JR	NZ,UNKWN1
	LD	A,(CHGDRV)	;nope, only a drive change?
	OR	A
	JR	Z,__near_getback1;	JP Z, GETBACK1	;neither???
	DEC	A
	LD	(CDRIVE),A	;ok, store new drive.
; Quorum: following two lines were swapped
	CALL	DSKSEL		;and select this drive.
	CALL	MOVECD		;set (TDRIVE) also.
__near_getback1:
	JP	GETBACK1	;then return.
;
;   Here a file name was typed. Prepare to execute it.
;
UNKWN1:	LD	DE,FCB+9	;an extension specified?
	LD	A,(DE)
	CP	' '
	JR	NZ,__near_synerr	; JP SYNERR ;yes, not allowed.
UNKWN2:	PUSH	DE
	CALL	DSELECT		;select specified drive.
	POP	DE
	LD	HL,COMFILE	;set the extension to 'COM'.
	CALL	MOVE3
	CALL	OPENFCB		;and open this file.
	JP	Z,UNKWN9	;not present?
;
;   Load in the program.
;
	LD	HL,TBASE	;store the program starting here.
UNKWN3:	PUSH	HL
	EX	DE,HL
	CALL	DMASET		;set transfer address.
	LD	DE,FCB		;and read the next record.
	CALL	RDREC
	JR	NZ,UNKWN4	;end of file or read error?
	POP	HL		;nope, bump pointer for next sector.
	LD	DE,128
	ADD	HL,DE
	LD	DE,CBASE	;enough room for the whole file?
	LD	A,L
	SUB	E
	LD	A,H
	SBC	A,D
	JR	NC,UNKWN0	;no, it can't fit.
	JR	UNKWN3
;
;   Get here after finished reading.
;
UNKWN4:	POP	HL
	DEC	A		;normal end of file?
	JR	NZ,UNKWN0
	CALL	RESETDR		;yes, reset previous drive.
	CALL	CONVFST		;convert the first file name that follows
	LD	HL,CHGDRV	;command name.
	PUSH	HL
	LD	A,(HL)		;set drive code in default fcb.
	LD	(FCB),A
	LD	A,16		;put second name 16 bytes later.
	CALL	CONVERT		;convert second file name.
	POP	HL
	LD	A,(HL)		;and set the drive for this second file.
	LD	(FCB+16),A
	XOR	A		;clear record byte in fcb.
	LD	(FCB+32),A
	LD	DE,TFCB		;move it into place at(005Ch).
	LD	HL,FCB
	LD	B,33
	CALL	HL2DE
	LD	HL,INBUFF+2	;now move the remainder of the input
UNKWN5:	LD	A,(HL)		;line down to (0080h). Look for a non blank.
	OR	A		;or a null.
	JR	Z,UNKWN6
	CP	' '
	JR	Z,UNKWN6
	INC	HL
	JR	UNKWN5
;
;   Do the line move now. It ends in a null byte.
;
UNKWN6:	LD	B,0		;keep a character count.
	LD	DE,TBUFF+1	;data gets put here.
UNKWN7:	LD	A,(HL)		;move it now.
	LD	(DE),A
	OR	A
	JR	Z,UNKWN8
	INC	B
	INC	HL
	INC	DE
	JR	UNKWN7
UNKWN8:	LD	A,B		;now store the character count.
	LD	(TBUFF),A
	CALL	CRLF		;clean up the screen.
	CALL	STDDMA		;set standard transfer address.
	CALL	SETCDRV		;reset current drive.
	CALL	TBASE		;and execute the program.
;
;   Transiant programs return here (or reboot).
;
	LD	SP,BATCH	;set stack first off.
	CALL	MOVECD		;move current drive into place (TDRIVE).
	CALL	DSKSEL		;and reselect it.
	JP	CMMND1		;back to comand mode.
;
;   Get here if some error occured.
;
UNKWN9:	CALL	RESETDR		;inproper format.
__near_synerr_2:
	JP	SYNERR
UNKWN0:	LD	BC,BADLOAD	;read error or won't fit.
	CALL	PLINE
	JR	GETBACK
BADLOAD:DEFB	'BAD LOAD',0
COMFILE:DEFB	'COM'		;command file extension.
;
;   Get here to return to command level. We will reset the
; previous active drive and then either return to command
; level directly or print error message and then return.
;
GETBACK:CALL	RESETDR		;reset previous drive.
GETBACK1: CALL	CONVFST		;convert first name in (FCB).
	LD	A,(FCB+1)	;if this was just a drive change request,
	SUB	' '		;make sure it was valid.
	LD	HL,CHGDRV
	OR	(HL)
	JR	NZ,__near_synerr_2	; JP NZ, SYNERR
	JP	CMMND1		;ok, return to command level.
;
;   ccp stack area.
;
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0
CCPSTACK: EQU	$	;end of ccp stack area.
;
;   Batch (or SUBMIT) processing information storage.
;
BATCH:	DEFB	0		;batch mode flag (0=not active).
BATCHFCB: DEFB	0,'$$$     SUB',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
;   File control block setup by the CCP.
;
FCB:	DEFB	0,'           ',0,0,0,0,0,'           ',0,0,0,0,0
RTNCODE:DEFB	0		;status returned from bdos call.
CDRIVE:	DEFB	0		;currently active drive.
CHGDRV:	DEFB	0		;change in drives flag (0=no change).
NBYTES:	DEFW	0		;byte counter used by TYPE.
;
;   Room for expansion?
;
	DEFB	0,0,0,0,0,0,0,0,0,0,0,0,0
;
;   Note that the following six bytes must match those at
; (PATTRN1) or cp/m will HALT. Why?
;
PATTRN2:DEFB	0,0,0,0,0,0	;(* serial number bytes *).
;

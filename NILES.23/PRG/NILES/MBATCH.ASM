cr	=	00Dh
lf	=	00Ah
eof	=	01Ah

	include	D:\SP\ASM\start.inc

menue	DB	"0000"
mz	DW	-1

pgm1	DB	"D:\UTILITYS\BATCH\BBATCH.EXE",0
cmd1	DB	4
	DW	0
	DW	0
	DB	cr

pgm2	DB	80 dup (?)
cmd2	DB	80 dup (?)
	
pgm3	DB	"D:\UTILITYS\BATCH\COMMAND.COM",0
cmd3	DB	cmd3l
	DB	"/E:2000 /C C:\BAT\BATCH\BATCH.BAT"
cmd3l	=	$-cmd3-1
	DB	cr

pgmf	DB	"D:\UTILITYS\BATCH\MBAT1.EXE",0
cmdl	DB	4
	DW	0
	DW	0
	DB	cr

parm	DB	14 dup (?)
file	DB	"C:\BAT\BATCH\BATCH.BAT",0
hand	DW	?
bpoi	DW	?
buff	DB	?

begin:
	set_block last_inst

	exec	pgm1,cmd1,parm			;SystemInit "BBATCH"

	open_handle file,0			;Treiber - Anweisungen ausfÅhren
	mov	hand,AX
Read1:
	mov	bpoi,OFFSET pgm2-1
Read2:
	read_handle hand,buff,1
	jc	E1
	cmp	AX,0
	je	E1
	mov	AL,buff
	cmp	AL,lf
	je	Read2
	mov	BX,bpoi
	inc	BX
	mov	bpoi,BX
	cmp	AL,eof
	je	E1
	cmp	AL,cr
	je	Read3
	mov	[BX],AL
	jmp	Read2
E1:	jmp	Zyk
Read3:
	mov	AL,0
	mov	[BX],AL
	mov	bpoi,OFFSET cmd2
Read4:
	read_handle hand,buff,1
	jc	Zyk
	cmp	AX,0
	je	Zyk
	mov	AL,buff
	cmp	AL,lf
	je	Read4
	mov	BX,bpoi
	inc	BX
	mov	bpoi,BX
	cmp	AL,eof
	je	Zyk
	cmp	AL,cr
	je	Read5
	mov	[BX],AL
	jmp	Read4
Read5:
	mov	AL,cr
	mov	[BX],AL
	mov	AX,OFFSET cmd2+1
	sub	BX,AX
	mov	cmd2,BL

	exec	pgm2,cmd2,parm			;zyklischer Aufruf der TREIBER
	jmp	Read1
	
Zyk:
	mov	WORD PTR cmdl[1],CS
	mov	WORD PTR cmdl[3],OFFSET menue
Zyk1:	
	exec	pgmf,cmdl,parm			;MenÅProgramm "MBAT1" aufrufen

	exec	pgm3,cmd3,parm			;Aufruf "COMMAND /C BATCH.BAT"

	jmp	Zyk1

	include	D:\SP\ASM\end.inc

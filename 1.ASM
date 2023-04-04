DATA SEGMENT;数据段
	; 大写字母对应的单词
	A DB 'Alpha $'
	B DB 'Bravo $'
	C DB 'China $'
	D DB 'Delta $'
	E DB 'Echo $'
	F DB 'Foxtrot $'
	G DB 'Golf $'
	H DB 'Hotel $'
	I DB 'India $'
	J DB 'Juliet $'
	K DB 'Kilo $'
	L DB 'Lima $'
	M DB 'Mary $'
	N DB 'November $'
	O DB 'Oscar $'
	P DB 'Paper $'
	Q DB 'Quebec $'
	R DB 'Research $'
	S DB 'Sierra $'
	T DB 'Tango $'
	U DB 'Uniform $'
	V DB 'Victor $'
	W DB 'Whisky $'
	X DB 'X-ray $'
	Y DB 'Yankee $'
	Z DB 'Zulu $'
	;大写字母
	CAPS DW A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z

	; 小写字母对应的单词
	aa DB 'alpha $'
	bb DB 'bravo $'
	cc DB 'china $'
	ddd DB 'delta $'
	ee DB 'echo $'
	ff DB 'foxtrot $'
	gg DB 'golf $'
	hh DB 'hotel $'
	ii DB 'india $'
	jj DB 'juliet $'
	kk DB 'kilo $'
	ll DB 'lima $'
	mm DB 'mary $'
	nn DB 'november $'
	oo DB 'oscar $'
	pp DB 'paper $'
	qq DB 'quebec $'
	rr DB 'research $'
	sss DB 'sierra $'
	tt DB 'tango $'
	uu DB 'uniform $'
	vv DB 'victor $'
	ww DB 'whisky $'
	xx DB 'x-ray $'
	yy DB 'yankee $'
	zz DB 'zulu $'
	; 小写字母
	LOWS DW aa, bb, cc, ddd, ee, ff, gg, hh, ii, jj, kk, ll, mm, nn, oo, pp, qq, rr, sss, tt, uu, vv, ww, xx, yy, zz

	;数字对应的单词
	NUM0 DB 'Zero $'
	NUM1 DB 'First $'
	NUM2 DB 'Second $'
	NUM3 DB 'Third $'
	NUM4 DB 'Fourth $'
	NUM5 DB 'Fifth $'
	NUM6 DB 'Sixth $'
	NUM7 DB 'Seventh $'
	NUM8 DB 'Eighth $'
	NUM9 DB 'Ninth $'
	;数字
	NUMS DW NUM0, NUM1, NUM2, NUM3, NUM4, NUM5, NUM6, NUM7, NUM8, NUM9

	;个人信息
	MYID DB 'ID: 2100012821', 13, 10, '$'
	MYNAME DB 'NAME: Yin Zhehui', 13, 10, '$'

DATA ENDS
STACK SEGMENT STACK ;堆栈段
	STA DB 50 DUP(?)
	TOP EQU LENGTH STA
STACK ENDS

CODE SEGMENT ;代码段
	ASSUME CS:CODE, DS:DATA, SS:STACK
	BEGIN:
		MOV AX, DATA
		MOV DS, AX ;DS赋初值
		MOV AX, STACK
		MOV SS, AX ;SS赋初值
		MOV AX, TOP
		MOV SP, AX ;SP赋初值

	INPUT:
		; loop使用
		MOV CX, 1
		; 输入
		MOV AH, 07H
		INT 21H

		INC CX
		MOV BL, AL

        ;按照ASCII值的顺序依次判断并转入输出

		; ASCII位于‘0’~‘9’,为数字，不然判断是否esc，输出？
		CMP AL, '0'
		JL QUESTIONMARK
		CMP AL, '9'
		JL PRINTNUM
        JE PRINTNUM
        ;ASCII位于‘A'~'Z',为大写字母,同理
		CMP AL, 'A'
		JL QUESTIONMARK
		CMP AL, 'Z'
		JL PRINTCAPL
        JE PRINTCAPL
		; ASCII位于‘a'～‘z',为小写字母，同理
		CMP AL, 'a'
		JL QUESTIONMARK
		CMP AL, 'z'
		JL PRINTLOWL
        JE PRINTLOWL

		JMP SHORT QUESTIONMARK

	; 输出数字
	PRINTNUM:
		SUB BL, '0'
		SHL BL, 1
		MOV SI, BX
		MOV DX, NUMS[SI]
		JMP SHORT PRINT
	; 输出大写字母
	PRINTCAPL:
		SUB BL, 'A'
		SHL BL, 1
		MOV SI, BX
		MOV DX, CAPS[SI]
		JMP SHORT PRINT
	; 输出小写字母
	PRINTLOWL:
		SUB BL, 'a'
		SHL BL, 1
		MOV SI, BX
		MOV DX, LOWS[SI]
		JMP SHORT PRINT

	PRINT:
		MOV AH, 09H
		INT 21H
		JMP SHORT IFEXIT

	; 判断非数字字母是否ESC，否则输出'？'
	QUESTIONMARK:
		CMP AL, 1BH
		JE EXIT
		MOV DL, '?'
		MOV AH, 02H
		INT 21H

	; ZF用于判定是否继续循环
	; 输入非ESC，loop返回INPUT部分
	IFEXIT:
		CMP AL, 1BH
		LOOPNZ INPUT
	; 输入的是ESC，结束程序
	EXIT:
		MOV DL, 0DH ;输出回车
		MOV AH, 02H
		INT 21H
		MOV DL, 0AH	;输出换行
		MOV AH, 02H
		INT 21H

		;程序结束输出学号与姓名
		MOV DX, OFFSET MYID
		MOV AH, 09H
		INT 21H 

		MOV DX, OFFSET MYNAME
		MOV AH, 09H
		INT 21H

		MOV AX, 4C00H ;带返回码结束，AL=返回码
        INT 21H

CODE ENDS
	END BEGIN ;程序结束

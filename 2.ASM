DATA SEGMENT ;数据段
	MYID DB 'ID: 2100012821', 13, 10, '$'
	MYNAME DB 'NAME: Yin Zhehui', 13, 10, '$'	;个人信息
	BUF	    DB 1024 dup (?)    ;缓冲区
	SUC 	DB 0DH, 0AH, 'Yes! Location: ', '$' ;找到时输出的信息
	FAI		DB 0DH, 0AH, 'No...', 0DH, 0AH, '$' ;没找到时输出的信息
	NUM		DB '000', '$'   ;用于暂存数字
DATA ENDS

STACK SEGMENT STACK	 ;堆栈段
    STA     DB 50 DUP(?)
    TOP     EQU LENGTH STA
STACK ENDS


CODE SEGMENT	;代码段
    ASSUME CS:CODE, DS:DATA, SS:STACK
    BEGIN:  
			MOV AX, DATA
            MOV DS, AX	;为DS赋初值
			MOV AX, DATA
            MOV ES, AX	;为ES赋初值
            MOV AX, STACK
            MOV SS, AX	;为SS赋初值
            MOV AX, TOP
            MOV SP, AX	;为SP赋初值
	INPUT0:    ;输入一个字符串
		MOV BH, 00H
		MOV BX, OFFSET BUF
		MOV DS:[BX], 1000    
		
		MOV DX, BX    ;从键盘读到缓冲区
		MOV AH, 0AH
		INT 21H
		MOV BX, DX
		MOV DL, DS:[BX + 1]    
		

		MOV BX, DX

		MOV DL, 0DH ;输出回车
		MOV AH, 02H
		INT 21H
		MOV DL, 0AH	;输出换行
		MOV AH, 02H
		INT 21H

	INPUT:    
		MOV AH, 01H	 ;输入字符并回显
		INT 21H
		CMP AL, 1BH		;若字符为esc，则退出，否则进入处理
		JZ EXIT

	HANDLE:    ;串操作
		CLD
		MOV DI, OFFSET BUF
		ADD DI, 02H
		MOV CX, BX
		REPNE SCASB ;使用串操作指令进行寻找
		JZ SU  ;找到
		JMP FA ;没找到


	SU:
		MOV	DX,	OFFSET SUC	;找到输出
		MOV AH,	09H
		INT	21H

		MOV SI, BX
		SUB SI, CX;算出位置
		MOV AX,SI
		
		;不断模10,将余数存在num中
		MOV CL, 10D
		MOV SI, 03D    ;记录位数
	MODTEN:;用于输出十进制数
		DIV CL
		DEC SI
		ADD AH, 30h
		MOV DS:[NUM + SI], AH
		MOV AH, 00h
		CMP AL, 0
		JNZ MODTEN
		
		MOV DX, OFFSET NUM
		ADD DX, SI
		MOV AH, 09h
		INT 21H

		
		
		MOV DL, 0DH ;输出回车
		MOV AH, 02H
		INT 21H
		MOV DL, 0AH	;输出换行
		MOV AH, 02H
		INT 21H

		JMP INPUT
	
	FA:
		MOV DX, OFFSET FAI
		MOV AH, 09H
		INT 21H
		JMP INPUT
	


	EXIT:    ;输入esc退出
	
		MOV DL, 0DH ;输出回车
		MOV AH, 02H
		INT 21H
		MOV DL, 0AH	;输出换行
		MOV AH, 02H
		INT 21H

		MOV DX, OFFSET MYID
		MOV AH, 09H
		INT 21H 

		MOV DX, OFFSET MYNAME
		MOV AH, 09H
		INT 21H

		MOV AX, 4C00H	;带返回码结束，AL=返回码
        INT 21H


CODE ENDS
            END BEGIN	;程序结束
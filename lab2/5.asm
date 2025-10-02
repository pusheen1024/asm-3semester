; сегмент стека
stak segment stack 'stack'
db 256 dup (?)
stak ends
; сегмент данных
data segment 'data'
Info db 'Potapkina Margarita, 251$' ; строка с именем и фамилией
NewLine db '',0Dh,0Ah,'$' ; перевод строки
data ends
; сегмент кода
code segment 'code'
assume CS:code,DS:data,SS:stak
; процедура для вывода цифры на экран
PrintDigit proc
	add DL,30h
	push AX
	mov AH,02h
	int 21h
	pop AX
	ret
PrintDigit endp
; процедура для вывода пробела на экран
PrintSpace proc
	push AX
	mov AX,0h
	mov DL,AL
	mov AH,02h
	int 21h
	pop AX
	ret
PrintSpace endp	
; процедура для вывода строки на экран
PrintString proc
	push AX
	mov AH,09h
	int 21h
	pop AX
	ret
PrintString endp
start:
; обязательная инициализация регистра DS
mov AX,data
mov DS,AX
; вывод строки с именем и номером группы
mov DX,offset Info
call PrintString
; вывод перевода строки
mov DX,offset NewLine
call PrintString
; вывод цифры из регистра AX
mov AX,07h
mov DL,AL
call PrintDigit
; вывод пробела
call PrintSpace
; вывод цифры из регистра BX
mov BX,05h
mov DL,BL
call PrintDigit
; вывод перевода строки
mov DX,offset NewLine
call PrintString
; обмен значений регистров AX и BX и выполнение тех же действий
XCHG AX,BX
mov DL,AL
call PrintDigit
call PrintSpace
mov DL,BL
call PrintDigit
;завершение программы
mov AX,4C00h
int 21h
code ends
end start


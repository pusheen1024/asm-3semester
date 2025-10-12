.model small
.stack 100h
.386 ; разрешение использовать 32"=битные регистры
.data
Info db 'Potapkina Margarita, 251',0Dh,0Ah,'$'
.code
; процедура вывода строки на экран
PrintString proc
	push AX
	mov AH,09h
	int 21h
	pop AX
	ret
PrintString endp
; процедура вывода цифры на экран
PrintDigit proc
	push AX
	mov AH,02h
	add DL,30h
	int 21h
	pop AX
	ret
PrintDigit endp
start:
mov AX,@data
mov DS,AX
mov DX,offset Info
call PrintString
mov EAX,65536 ; число
mov EBX,10 ; основание системы счисления
mov CX,0 ; счётчик количества разрядов
; разделение числа на цифры
met:
mov EDX,0
div EBX
push EDX
inc CX
cmp EAX,0
jne met
; вывод числа
print:
pop EDX
call PrintDigit
loop print
mov AX,4C00h
int 21h
end start

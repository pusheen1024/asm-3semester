stak segment stack 'stack'
db 256 dup(?)
stak ends
data segment 'data'
Info db 'Potapkina Margarita, 251',0Dh,0Ah,'$'
data ends
code segment 'code'
assume CS:code,DS:data,SS:stak
; процедура для вывода строки на экран
PrintString proc far
	push AX
	mov AH,09h
	int 21h
	pop AX
	ret
PrintString endp
; процедура для вывода цифры на экран
PrintDigit proc far
	push AX
	mov AH,02h
	add DL,30h
	int 21h
	pop AX
	ret
PrintDigit endp
start:
mov AX,data
mov DS,AX
mov DX,offset Info
call PrintString
mov AX,19937 ; число
mov BX,10 ; основание системы счисления
mov CX,0 ; счётчик количества разрядов
; разделение числа на цифры
met:
mov DX,0 ; очищение регистра DX
div BX
push DX ; запись очередной цифры в стек
inc CX
cmp AX,0
jne met
; вывод числа
print:
pop DX
call PrintDigit
loop print ; цикл отработает столько раз, сколько разрядов в числе
mov AX,4C00h
int 21h
code ends
end start


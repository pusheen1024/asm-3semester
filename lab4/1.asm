.186 
stak segment stack 'stack'
db 256 dup(?)
stak ends

data segment 'data'
NewLine db 0Dh,0Ah,'$' ; символы перевода строки
arr db 20 dup(0) ; массив
res db 4 dup(' '),'$' ; строка для записи числа
data ends

code segment 'code'
assume CS:code,DS:data,SS:stak
; процедура для перевода строки
PrintNL proc
	push AX
	push DX
	mov AH,09h
	mov DX,offset NewLine
	int 21h
	pop DX
	pop AX
	ret
PrintNL endp
; процедура для вывода числа из массива
PrintNumber proc
	pusha
	mov BL,10
	mov DI,2
	met:
	mov AH,0
	div BL
	add AH,30h
	mov res[DI],AH
	dec DI
	cmp AL,0
	jne met
	mov AH,09h
	mov DX,offset res
	int 21h
	popa
	ret
PrintNumber endp
start:
mov AX,data
mov DS,AX
mov CX,10 ; количество итераций
mov BL,2 ; первый элемент
mov SI,0 ; индекс первого элемента
fill: ; заполнение первой половины массива
mov arr[SI],BL
add BL,2
inc SI
loop fill
mov CX,10 ; количество итераций
mov SI,0 ; индекс первого элемента из первой половины
mov DI,10 ; индекс первого элемента из второй половины
mov BL,5 ; коэффициент
fill1: ; заполнение второй половины массива
mov AL,arr[SI]
mul BL
mov arr[DI],AL
inc SI
inc DI
loop fill1
mov CX,20 ; количество итераций
mov SI,0 ; индекс первого элемента
printarr: ; вывод массива
mov AL,arr[SI]
call PrintNumber
inc SI
cmp SI,10
jne m
call PrintNL
m: loop printarr
mov AX,4C00h
int 21h
code ends
end start

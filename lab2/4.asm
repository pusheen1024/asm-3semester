.model tiny ; модель памяти tiny
.code
org 100h
start:
; вывод строки на экран
mov AH,09h
mov DX,offset Info
int 21h
; вывод цифры из регистра AX на экран
mov AX,8h
add AL,30h
mov DL,AL
mov AH,02h
int 21h
; вывод пробела на экран
mov AX,0h
mov DL,AL
mov AH,02h
int 21h
; вывод цифры из регистра BX на экран
mov BX,3h
add BL,30h
mov DL,BL
mov AH,02h
int 21h
; завершение программы
mov AX,4C00h
int 21h
; Строка с именем, фамилией и переводом строки
Info db 'Potapkina Margarita, 251',0Dh,0Ah,'$'
end start

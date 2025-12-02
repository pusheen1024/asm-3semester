.186 
stak segment stack 'stack'
db 256 dup(?)
stak ends

data segment 'data'
mode db ? ; переменная, куда сохраняется текущий режим
data ends

code segment 'code'
assume CS:code,DS:data,SS:stak

; процедура для выставления нового режима
set_mode proc
push AX
mov AH,0Fh
int 10h
mov mode,AL ; получить значение текущего режима
mov AH,00h
mov AL,03
int 10h ; выставить видеорежим с номером 03
mov AH,05h
mov AL,01h
int 10h ; установить активную страницу (1)
pop AX
ret
set_mode endp

; процедура для возврата к оригинальному режиму
ret_mode proc
push AX
mov AH,00h
mov AL,mode
int 10h
pop AX
ret
ret_mode endp

B10DISPLAY proc
pusha
mov AL,41h ; код первого символа (A)
mov AH,0Ah ; цвет первого ряда символов
mov DI,830 ; начальная позиция 5:15, ((5 * 80) + 15) * 2 = 830
mov CX,5 ; количество строк
rows:
  push CX
  mov CX,10 ; количество столбцов
  cols:
    mov ES:word ptr[DI],AX
    add DI,2
  loop cols
  add DI,140 ; (80 - 10) * 2 = 140 - для перехода на следующую строку
  inc AL ; изменить код выводимого символа
  inc AH ; изменить цвет
  pop CX
loop rows
popa
ret
B10DISPLAY endp

start:
mov AX,0b900h ; организовать прямую запись данных в видеопамять
mov ES,AX
call set_mode
call B10DISPLAY
mov AH,10h ; запрос на ввод символа с клавиатуры
int 16h
call ret_mode ; возврат к предыдущему режиму
mov AX,4C00h
int 21h
code ends
end start

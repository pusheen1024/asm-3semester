.186 
stak segment stack 'stack'
db 256 dup(?)
stak ends

data segment 'data'
row db ? ; номер строки
col db ? ; номер столбца
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
int 10h ; выставить текстовый режим с номером 03
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

; процедура для установки курсора в нужную позицию
cursor proc
pusha
mov AH,02h
mov BH,0 ; номер страницы
mov DH,row ; номер строки
mov DL,col ; номер столбца
int 10h
popa
ret
cursor endp

; процедура для очистки экрана
clear proc
pusha
mov AH,06h ; выполнить прокрутку экрана вверх
mov AL,00h
mov CX,0000
mov DX,184Fh
int 10h
popa
ret
clear endp

; процедура для вывода ASCII-символа
print proc
pusha
mov AH,09h
mov BH,0 ; номер страницы
mov CX,1 ; число символов
int 10h			
popa
ret
print endp

start:
call clear
call set_mode
mov AL,41h ; код первого символа (A)
mov BL,0Ah ; цвет первого ряда символов
mov row,5
rows:
  mov col,15
  cols: 
    call cursor
	call print
	inc col
	cmp col,25
  loopne cols
  inc row
  inc AL
  inc BL
  cmp row,10
loopne rows
mov AH,10h ; запрос на ввод символа с клавиатуры
int 16h
call ret_mode ; возврат к предыдущему режиму
mov AX,4C00h
int 21h
code ends
end start

extrn GetStdHandle: proc,
    lstrlenA: proc,
    WriteConsoleA: proc,
    ReadConsoleA: proc,
    ExitProcess: proc

.data
hStdin dq ? ; дескриптор ввода
hStdout dq ? ; дескриптор вывода
; строки пользовательского интерфейса
input_a db 'A = ',0
input_b db 'B = ',0
output_func db 'F(A, B) = 45Ch + A + B = ',0
output_max db 'max(A, B) = ',0
out_of_bounds db 'Number out of range!',0
invalid_char db 'Invalid character!',0
exit db 'Press any key to exit...',0
new_line db 0Dh,0Ah,0
func dq ? ; здесь будет храниться значение функции
max dq ? ; здесь будет храниться максимум
stdin_handle equ -10 ; поток ввода
stdout_handle equ -11 ; поток вывода

.code
; макрос для выравнивания стека
STACKALLOC macro arg
  push R15 ; здесь будет храниться указатель на старый стек
  mov R15,RSP
  sub RSP,8*4 ; место под 4 обязательных аргумента в стеке
  if arg
    sub RSP,8*arg
  endif
  and SPL,0F0h ; выравнивание стека по 16-байтной границе
endm

; макрос для освобождения памяти, выделенной под стек
STACKFREE macro
  mov RSP,R15
  pop R15
endm

; макрос для обнуления пятого аргумента (зарезервирован для внутренних нужд)
NULLARG5 macro
  mov qword ptr[RSP + 32], 0 ; отступаем 32 байта от текущей вершины стека
endm

; процедура вывода строки на экран
PrintString proc uses RAX RCX RDX R8 R9 R10 R11, string: qword
  local bytesWritten: qword
  STACKALLOC 1
  mov RCX,string
  call lstrlenA
  mov RCX,hStdout ; дескриптор потока вывода
  mov RDX,string ; строка для вывода
  mov R8,RAX ; длина строки (вызов lstrlenA записал её в RAX)
  lea R9,bytesWritten ; число записанных байт
  NULLARG5
  call WriteConsoleA
  STACKFREE
  ret 8
PrintString endp

; процедура для вывода перевода строки
PrintNL proc uses RAX
  STACKALLOC 1
  lea RAX,new_line
  push RAX
  call PrintString
  STACKFREE
  ret
PrintNL endp

; процедура ожидания ввода
getChar proc uses RAX RCX RDX R8 R9 R10 R11
  local readStr: byte, bytesRead: dword
  STACKALLOC 0
  lea RAX,exit
  push RAX
  call PrintString
  mov RCX,hStdin
  lea RDX,readStr
  mov R8,1
  lea R9,bytesRead
  NULLARG5
  call ReadConsoleA
  STACKFREE
  ret
getChar endp

; процедура чтения числа с клавиатуры
readNumber proc uses RBX RCX RDX R8 R9
  local readStr[64]: byte, bytesRead: dword
  STACKALLOC 2
  ; считывание строки с числом
  mov RCX,hStdin
  lea RDX,readStr
  mov R8,64
  lea R9,bytesRead
  NULLARG5
  call readConsoleA

  mov RCX,0
  mov ECX,bytesRead ; длина строки с числом
  sub ECX,2 ; убрать символы переноса строки и возврата каретки
  mov RBX,0
  mov R8,1

  loopString:
  dec RCX
  cmp RCX,-1
  je scanningComplete
  mov RAX,0
  mov AL,readStr[RCX]
  cmp AL,'-'
  jne eval
  neg RBX ; число отрицательное
  cmp RCX,0
  je scanningComplete ; минус приемлем, только если это первый символ в числе
  jmp error

  eval: ; является ли символ десятичной цифрой?
  cmp AL,30h
  jl error
  cmp AL,39h
  jg error
  sub RAX,30h
  mul R8
  add RBX,RAX
  mov RAX,10
  mul R8
  mov R8,RAX
  jmp loopString

  error:
  mov R10,1
  stackfree
  ret

  scanningComplete:
  mov R10,0
  mov RAX,RBX
  stackfree
  ret
readNumber endp

; процедура вывода числа
printNumber proc uses RAX RCX RDX R8 R9 R10 R11, number: qword
  local numberStr[22]: byte
  STACKALLOC 1
  mov R8,0
  mov RAX,number
  cmp number,0
  jge met
  ; число отрицательное
  mov numberStr[R8],'-'
  inc R8
  neg RAX

  met:
  mov RBX,10
  mov RCX,0
  getDigits:
  mov RDX,0
  div RBX
  add RDX,30h
  push RDX
  inc RCX
  cmp RAX,0
  jne getDigits

  createString:
  pop RDX
  mov numberStr[R8],DL
  inc R8
  loop createString

  mov numberStr[R8],0
  lea RAX,numberStr
  push RAX
  call PrintString
  STACKFREE
  ret 8
printNumber endp

Start proc
  STACKALLOC 0
  mov RCX,stdout_handle
  call GetStdHandle
  mov hStdout,RAX ; получение дескриптора потока вывода
  mov RCX,stdin_handle
  call GetStdHandle
  mov hStdin,RAX ; получение дескриптора потока ввода

  lea RAX,input_a
  push RAX
  call PrintString
  call ReadNumber
  cmp R10,1
  je error
  cmp RAX,-32768
  jl outOfRange
  cmp RAX,32767
  jg outOfRange
  mov R8,RAX ; число A будет храниться в R8

  lea RAX,input_b
  push RAX
  call PrintString
  call ReadNumber
  cmp R10,1
  je error
  cmp RAX,-32768
  jl outOfRange
  cmp RAX,32767
  jg outOfRange
  mov R9,RAX ; число B будет храниться в R9

  ; поиск максимума из A и B
  cmp R8,R9
  jg Amax
  mov max,R9
  jmp calcF
  Amax:
  mov max,R8

  ; вычисление F(A,B)
  calcF:
  add R8,R9
  add R8,45Ch
  mov func,R8

  lea RAX,output_func
  push RAX
  call PrintString
  push func
  call PrintNumber
  call PrintNL
  lea RAX,output_max
  push RAX
  call PrintString
  push max
  call PrintNumber
  jmp finish

  ; число не умещается в диапазон слова со знаком [-32768;32767)
  outOfRange:
  lea RAX,out_of_bounds
  push RAX
  call PrintString
  jmp finish

  ; в числе содержались некорректные символы
  error:
  lea RAX,invalid_char
  push RAX
  call PrintString

  ; завершение программы
  finish:
  call PrintNL
  call getChar
  mov RCX,0
  call ExitProcess
Start endp
end

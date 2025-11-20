; в коде будут использоваться внешние функции WinAPI
extrn ExitProcess :proc, MessageBoxA :proc

.data
Caption db 'Инфо', 0 ; заголовок окна
Info db 'Потапкина Маргарита, 251', 0 ; строка с именем и фамилией

.code
Start proc
; выравнивание стека в соответствии с соглашением __fastcall (4 аргумента + адрес возврата)
sub RSP,40
; передача параметров для функции MessageBoxA (диалоговое окно)
mov RCX,0
mov RDX,offset Info
mov R8,offset Caption
mov R9,0
call MessageBoxA
; завершение программы
mov RCX,0
call ExitProcess
Start endp
end

cls
TASM.exe /L %1.asm
TLINK.exe /x /t %1.obj
%1

cmp AX,BX
jl vr2 ; условный переход, если R1 < R2
mov DX,BX ; R2 = min(R1, R2)
jmp cont ; безусловный переход в конец
vr2:
mov DX,AX ; R1 = min(R1, R2)
cont:

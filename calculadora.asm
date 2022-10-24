TITLE ANGELO GERALDO PEREIRA JUNIOR RA:21008767

.model small
.stack 100h
.data
conta db 10,'Digite qual operaca_o vai ser realizada( + - * / )',10,': $'
msg1 db 10,'Digite o primeiro numero: $'
msg2 db 10,"Digite o segundo numero: $"
resu db 10,'Resultado: $'
.code

impmsg MACRO FUN,ende
    mov ah,FUN
    lea dx,ende
    int 21h
ENDM

ler macro FUN
    mov ah,FUN
    int 21h
ENDM

main proc
    mov AX,@data
   mov DS,AX
    ; mov AX,@data
    ; mov DS,AX       ;inicializando data
    ; lea DX,conta     ;offset msg1
    ; mov AH,09h      ;comando imprimir buffer msg1
    ; int 21h
    impmsg 09,conta
    ler 01
    mov bl,al
    
    
    cmp bl,'+'
    jz soma
    cmp bl,'-'
    jz subt
    cmp bl,'*'
    jz mult
    cmp bl,'/'
    jz divi


soma:
    impmsg 09,msg1
    ler 01 
    mov ch,al
    impmsg 09,msg2
    ler 01
    mov cl,al
    xor ax,ax
    add ch,cl
    jmp saida
    
    

subt:
    impmsg 09,msg1
    impmsg 09,msg2
    jmp saida

divi:
    impmsg 09,msg1
    impmsg 09,msg2
    jmp saida

mult:
    impmsg 09,msg1
    impmsg 09,msg2
    jmp saida

saida:
    mov AH,4ch
    int 21h

print:
    ;impmsg 09,resu
    ;...
    mov cl,10
    div cl
    mov bx,ax
    mov dl,bl
    or dl,30h
    mov ah,2
    int 21h
    mov dl,bl
    mov dl,30h
    mov ah,2
    int 21h
    jmp saida
;print endp

main endp
end main









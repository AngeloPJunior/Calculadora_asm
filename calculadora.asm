TITLE ANGELO GERALDO PEREIRA JUNIOR RA:21008767

.model small
.stack 100h
.data
menu     DB 10,10,    ' ESCOLHA A CONTA DESEJADA         ',10      
         DB           '----------------------------      ',10
         DB           '|           MENU           |      ',10
         DB           '|                          |      ',10
         DB           '| SOMA: 1                  |      ',10
         DB           '| SUBTRACAO: 2             |      ',10
         DB           '| MULTIPLICACAO: 3         |      ',10
         DB           '| DIVISAO: 4               |      ',10
         DB           '| SAIR: 5                  |      ',10
         DB           ' ---------------------------      ',10
         DB           'SUA ESCOLHA:  $',10
erro DB 10,'RESPOSTA INVALIDA, DIGITE NOVAMENTE '
     DB 10,'SUA ESCOLHA:   $                    '
msg1 DB 10,'DIGITE O PRIMEIRO NUMERO:  $'
msg2 DB 10,10,'DIGITE O SEGUNDO NUMERO:  $'
resu DB 10,'RESULTADO:  $'
quoci DB 10,'QUOCIENTE:  $'
resto DB 10,'RESTO:  $'
error DB 10,'DIVISAO COM ZERO, DIGITE NOVAMENTE',10,'$'
novamente DB 10,'DESEJA FAZER OUTRA OPERACAO? (Y/N)',10
          DB    ':  $'
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

NUM1NUM2 macro
    impmsg 09,msg1
    ler 01 
    mov bl ,al
    and bl,0fh
    impmsg 09,msg2
    ler 01
    mov bh,al
    and bh,0fh
ENDM
    
NOVAMENT macro 
    impmsg 09,novamente
    ler 01
    cmp al,'y'
    JZ menu_1
    jmp saida
ENDM


main proc
    ; mov AX,@data
    ; mov DS,AX       ;inicializando data
    ; lea DX,conta     ;offset msg1
    ; mov AH,09h      ;comando imprimir buffer msg1
    ; int 21h
menu_1:
    xor ax,ax
    xor dx,dx
    xor bx,bx
    mov AX,@data
    mov DS,AX
    impmsg 09,menu
    ler 01
    mov bl,al
    
escolha: 
    cmp bl,'1'
    jz soma

    cmp bl,'2'
    jz subt
    
    cmp bl,'3'
    jz mult_1
    
    cmp bl,'4'
    jz divi_1
    
    cmp bl,'5'
    jz saida_1
    
    impmsg 09,erro
    ler 01
    mov bl,al
    jmp escolha
    
    


soma:
    NUM1NUM2
    add bl,bh
    impmsg 09,resu
    call print
    jmp menu_1
    
mult_1:
    jmp mult
divi_1:
    jmp divi
saida_1:
    jmp saida



subt:
    NUM1NUM2    
    cmp bl,bh
    jl negativo
    sub bl,bh
    impmsg 09,resu
    ; mov ah,02
    ; mov dl,'+'
    ; int 21h
    jmp printt

negativo:
    sub bl,Bh
    neg bl
    impmsg 09,resu
    mov ah,02
    mov dl,'-'
    int 21h

printt:
    call print
    jmp menu_1

divi:
NUM1NUM2
    MOV CX,9
    XOR AX,AX
    MOV AL,BL    ;BL -> AL
    CMP BH,0
    JZ erro1
    XOR BL,BL
    XOR DX,DX
LUP:
    SUB AX,BX
    JNS SINAL
    ADD AX,BX
    MOV DH,0
    JMP TERMINA
SINAL:
    MOV DH,01
TERMINA:
    SHL DL,1
    OR DL,DH
    SHR BX,1
    LOOP LUP
    MOV CH,DL
    MOV CL,AL
    ; mov ah,09
    ; lea dx,MSG4
    ; int 21H

    impmsg 09,quoci
    or ch,30h
    mov ah,02
    mov dl,ch
    int 21h

    impmsg 09,resto
    OR Cl,30H
    MOV AH,02
    MOV DL,Cl
    INT 21H
    JMP menu_1

erro1:
impmsg 09,error
jmp divi




mult:
    NUM1NUM2
    xor cx,cx
    mov CX,4
    mov ah,0

volta_1: 
    ror bh,01
    jc carry
    shl bl,1
    dec cx
    cmp cx,0
    jnz volta_1
    jmp fim_mult
carry:
    add ah,bl
    shl bl,1
    loop volta_1
fim_mult:
    mov bl,ah
    ;and bl,0fh
    impmsg 09,resu
    call print
    jmp menu_1



saida:
    mov AH,4ch
    int 21h

print proc
    xor ax,ax
    mov al,bl
    mov ch,10
    div ch
    mov bl,al
    mov bh,ah
    mov dl,bl
    xor dl,30h
    mov ah,2
    int 21h
    mov dl,bh
    xor dl,30h
    mov ah,2
    int 21h
     ret
 print endp

main endp
end main









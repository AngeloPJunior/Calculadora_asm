TITLE ANGELO GERALDO PEREIRA JUNIOR RA:21008767

.model small
.stack 100h
.data
menu     DB 10,10,    '         CALCULADORA              ',10,10
         DB           ' ESCOLHA A CONTA DESEJADA         ',10      
         DB           '----------------------------      ',10
         DB           '|           MENU           |      ',10
         DB           '|                          |      ',10
         DB           '| SOMA:          1         |      ',10
         DB           '| SUBTRACAO:     2         |      ',10
         DB           '| MULTIPLICACAO: 3         |      ',10
         DB           '| DIVISAO:       4         |      ',10
         DB           '| SAIR:          5         |      ',10
         DB           ' ---------------------------      ',10
         DB           'SUA ESCOLHA:  $',10
erro DB 10,'RESPOSTA INVALIDA, DIGITE NOVAMENTE '
     DB 10,'SUA ESCOLHA:   $                    '
msg1 DB 10,'DIGITE O PRIMEIRO NUMERO:  $'
msg2 DB 10,10,'DIGITE O SEGUNDO NUMERO:  $'
resu DB 10,10,'RESULTADO:  $'
quoci DB 10,10,'QUOCIENTE:  $'
resto DB 10,'RESTO:  $'
error DB 10,'DIVISAO COM ZERO, DIGITE NOVAMENTE',10,'$'
erro2 DB 10,'DIVISOR MAIOR QUE O DIVIDENTO, TENTE OUTRA CONTA',10,'$' 
novamente DB 10,10,'DESEJA FAZER OUTRA OPERACAO? (Y/N)',10
          DB    ':  $'
.code

impmsg MACRO FUN,ende           ;macro criado para imprimir do data
    mov ah,FUN                  ;"FUN" usado o 09 para imprimir o texto e o "ende" sendo o endereco do data desejada
    lea dx,ende
    int 21h
ENDM

ler macro FUN                   ;macro criado para ler um caracter
    mov ah,FUN                  ;"FUN" utilizado o 01 para pegar o caracter digitado
    int 21h                     ;podendo ser numero ou letra
ENDM

NUM1NUM2 macro                  ;macro para ler os dois numeros que serao utilizados na operacao
    impmsg 09,msg1              ;utiliza os dois macros escritos anteriormente
    ler 01                      ;move o primeiro numero para bl e o segundo para bh 
    mov bl ,al                  ;and 0fh para atransformar de codigo ascii para numeral
    and bl,0fh
    impmsg 09,msg2
    ler 01
    mov bh,al
    and bh,0fh
ENDM
    
NOVAMENT proc                   ;funcao criada para no final das operações ver se quer fazer alguma outra conta
    impmsg 09,novamente         ;le o caractere escrito e caso for 'y' (sim) reinicia o programa, caso contrario o finaliza
    ler 01                      ;caso for 'y' ou 'Y' o flag z fica 1 e ativa o JZ e vai para o menu_1(começo)
    cmp al,'y'
    JZ menu_1
    cmp al,'Y'
    JZ menu_1
    call saida
novament endp


main proc
menu_1:
    mov ax,02h                  ;funcao 02h do int 10h para subir a pagina
    int 10h                     ;exec do 10h
    xor ax,ax                   ;limpeza do registrador ax
    xor dx,dx                   ;limpeza do registrador dx
    xor bx,bx                   ;limpeza do registrador bx
    mov ax,@data                ;inicializacao do @data em DS, ax -> ds
    mov DS,ax
    impmsg 09,menu              ;imprime o menu
    ler 01                      ;le o numero representande da operação
    mov bl,al                   ;move a 'operação' para bl
    
escolha:                        ;filtro para ir na operação escolhida, imita 'switch case'  
    cmp bl,'1'                  ;1 = soma, 2 = subtração, 3 = multiplicação, 4 = divisão e 5 para saida
    jnz nao_soma                ;caso não tenha sido escolhido nenhum numero do filtro, aparecera erro e voltara a pedir uma operação      
    call soma                   ;compara bl com os possiveis numeros e caso seja o escolhido irá chamar os procedimentos
    call print                  ;usando o jnz (jump not zero) apos o cmp para pular se nao for o numero comparado
    call NOVAMENT               ;na soma, subtracao e multiplicacao, apos retornar da operacao com o resultado em bl, chama o proceedimento de impressao
                                ;a divisao imprime no proprio procedimento
nao_soma:                       ;no final ha o procedimento para reiniciar o programa
    cmp bl,'2'
    jnz nao_subt                
    call subt                   
    call print                  

    call NOVAMENT

nao_subt:
    cmp bl,'3'
    jnz nao_mult
    call mult
    call print
    call NOVAMENT

nao_mult:    
    cmp bl,'4'
    jnz saidaa
    call divi
    call NOVAMENT

saidaa:    
    cmp bl,'5'
    jnz nada
    call saida

nada:    
    impmsg 09,erro
    ler 01
    mov bl,al
    jmp escolha
    
main endp




soma proc                           ;procedimento da soma, utiliza o macro "num1num2" pegando os dois numeros e salvando em bl e bh
    NUM1NUM2                        ;soma os dois numeros lidos e deixa o resultado em bl
    add bl,bh                       ;printa "resultado: " usando o macro e retorna para main para printar o resultado da conta 
    impmsg 09,resu
    ret
soma endp
    
subt proc                           ;procedimento de subtracao, utiliza o macro para ler os numeros, salvando em bl e bh
    NUM1NUM2                        ;'if' utilizado para ver se bh eh maior que bl
    cmp bl,bh                       ;bh sendo maior que bl, o resultado será negativo e tera que imprimir o "-" assim, pulando para 'negativo'
    jl negativo                     ;ambos os casos acontecera bl - bh, salvando o resultado em bl
    sub bl,bh                       ;caso bh for maior antes de retornar para printar tera um neg para inverter o resultado e imprimir um "-"
    impmsg 09,resu
    ret

negativo:
    sub bl,Bh
    neg bl
    impmsg 09,resu
    mov ah,02
    mov dl,'-'
    int 21h
    ret
subt endp


divi proc
NUM1NUM2
    mov CX,9                        ;contador com valor 9
    xor ax,ax                       ;limpa ax
    mov al,bl                       ;bl -> al
    cmp bh,0                        ;compara de o divisor eh 0
    jz erro1                        ;imprime erro se divisor for 0
    cmp bl,bh                       ;compara se o divisor for maior que o dividendo(resultado teria virgula)
    jl bhmaior                      ;bh maior pede para repetir os numeros
    xor bl,bl                       ;limpa bl
    xor dx,dx                       ;limpa dx
lop:
    sub ax,bx                       ;inicia o lop subtraindo a divisor do dividendo para checar o sinal
    jns sinal                       ;sinal sendo positivo o quociente recebe 1, negativo 0
    add ax,bx
    mov dh,0
    jmp final
sinal:
    mov dh,01
final:
    shl dl,1                        ;desloca dl para esquerda, quociente          
    or dl,dh                        ;dependendo do sinal, eh colocado 0 ou 1 em dl
    shr bx,1                        ;rotaciona bx para direita e volta no loop
    loop lop                        ;repete 9 vzs
    mov bh,dl                       ;quociente para bh
    mov bl,al                       ;resto para bl
    
    impmsg 09,quoci                 ;imprime quociente
    or bh,30h
    mov ah,02
    mov dl,bh
    int 21h

    impmsg 09,resto                 ;imprime resto
    xor bl,30H
    mov ah,02
    mov dl,bl
    INT 21H
    ret

erro1:
    impmsg 09,error
    jmp divi
bhmaior:
    impmsg 09,erro2
    jmp divi

divi endp






mult proc                           
    NUM1NUM2                        ;macro para pegar os dois numeros
    xor cx,cx                       ;zera cx
    mov CX,4                        ;contador 4 em cx
    xor ah,ah                       ;zera ah

volta_1: 
    ror bh,01                       ;rotaciona bh para a direita para conferir se o carry eh 1
    jc carry                        ;flag sendo 1 ira pular para o 'carry'
    shl bl,1                        ;carry sendo 0, bl gira para esquerda assimilando com o processo de multiplicacao
    dec cx                          ;decrementa o contador e compara com 0
    cmp cx,0
    jnz volta_1                     ;nao sendo 0 volta para verificar o proximo bit
    jmp fim_mult                    ;contador chegando ao fim finaliza a mult
carry:
    add ah,bl                       ;carry sendo 1, soma o bl com ah(podendo ja ter rotado) e rotaciona bl para esquerda
    shl bl,1
    loop volta_1                    ;decrementa cx e faz o loop
fim_mult:
    mov bl,ah                       ;resultado final em ah vai para bl e vai para impressao
    impmsg 09,resu
    ret
mult endp



saida proc                          ;finalizacao do programa
    mov AH,4ch
    int 21h
saida endp

print proc                          ;procedimento para printar o resultado 
    xor ax,ax                       ;limpa ax
    mov al,bl                       ;move o resultado para al
    mov ch,10                       ;coloca valor 10 em ch para dividir no resultado
    div ch                          ;apos dividir al em 10, al ficara cm o primeiro digito e ah com o segundo digito da resposta
    mov bl,al                       ;al -> bl
    mov bh,ah                       ;ah -> bh
    mov dl,bl                       ;impressao do primeiro digito
    xor dl,30h                      ;transforma de numeral para codigo ascii
    mov ah,2
    int 21h
    mov dl,bh                       ;impressao do segundo digito
    xor dl,30h                      ;transforma de numeral para codigo ascii
    mov ah,2
    int 21h
    ret
 print endp


end main









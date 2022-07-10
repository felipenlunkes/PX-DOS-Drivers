;;***********************************************************************************
;;
;;
;; Programa de Debug do Sistema Operacional PX-DOS usando interface de Driver 
;; do PX-DOS 0.9.0 e porta Serial COM1
;;
;;
;;
;; Copyright � 2014-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;
;; Usando sintaxe TASM, substituindo o NASM
;;
;; Uso: tasm dbg.asm
;;
;;***********************************************************************************


;;***********************************************************************************

 hexasc proc near ;; Converte WORD para hez ASCII
 ;; AX = valor,
 ;; DS:BX = endere�o da String
 
 ;; Retorna AX. BX Destru�do
 
 push cx 
 push dx
 
 mov dx,4 ;; Inicializar contador de Caracteres
 mov cx,4 ;; Isola os pr�ximos quatro bits
 
 rol ax,cl
 mov cx,ax
 and cx,0fh
 
 add cx,'0' ;; Converte para ASCII
 cmp cx,'9' ;; Est� entre 0-9?
 jbe hexasc2 ;; Sim, pule
 add cx,'A'-'9'-1 

 hexasc2: ;; Guarda o caracter
 
 mov [bx],cl
 inc bx ;; Incrementar ponteiro
 
 dec dx ;; Conta os caracteres convertidos
 
 jnz hexasc2 ;; Loop, n�o 4 ainda
 
 pop dx
 pop cx
 
 ret ;; Retorna a quem o chamou
 
 hexasc endp
 
;;***********************************************************************************
 
iniciar_serial proc  ;; Esse m�todo � usado para inicializar uma Porta Serial


    mov ah, 0               ; Move o valor 0 para o registrador ah 
	                        ; A fun��o 0 � usada para inicializar a Porta Serial COM1
    mov al, 0e3h            ; Par�metros da porta serial
    mov dx, 0               ; N�mero da porta (COM 1) - Porta Serial 1
    int 14h                ; Inicializar porta - Ativa a porta para receber e enviar dados
	
	ret

iniciar_serial endp
	
;;************************************************************************
	
transferir proc  ;; Esse m�todo � usado para transferir dados pela Porta Serial aberta

lodsb         ;; Carrega o pr�ximo caractere � ser enviado

or al, al     ;; Compara o caractere com o fim da mensagem
jz .pronto    ;; Se igual ao fim, pula para .pronto

mov ah, 1h   ;; Fun��o de envio de caractere do BIOS por Porta Serial
int 14h     ;; Chama o BIOS e executa a a��o 

jmp transferir ;; Se n�o tiver acabado, volta � fun��o e carrega o pr�ximo caractere


.pronto: ;; Se tiver acabado...

ret      ;; Retorna a fun��o que o chamou


transferir endp	
	
;;***********************************************************************************

paraString proc


        pusha
        mov cx, 0
        mov bx, 10
        mov di, offset tmp
		
.empurrar:

        mov dx, 0
        div bx
        inc cx
        push dx
        test ax,ax
        jnz .empurrar
		
.puxar:
        pop dx
        add dl, '0'
        mov [di], dl
		inc di
        dec cx
        jnz .puxar

        mov [di], 0
        popa
        mov ax, offset tmp
		
		ret
		
        tmp db ?

paraString endp 
;;************************************************************************
;;
;; "Arena.inc" - Suporte a transfer�ncia de dados via Porta Serial
;;                 para o Driver Arena� do PX-DOS 
;;
;;           Copyright (C) 2016 Felipe Miguel Nery Lunkes
;;
;;************************************************************************

section .text

;;************************************************************************

iniciar_serial:  ;; Esse m�todo � usado para inicializar uma Porta Serial


    mov ah, 0               ; Move o valor 0 para o registrador ah 
	                        ; A fun��o 0 � usada para inicializar a Porta Serial COM1
    mov al, 0xe3            ; Par�metros da porta serial
    mov dx, 0               ; N�mero da porta (COM 1) - Porta Serial 1
    int 0x14                ; Inicializar porta - Ativa a porta para receber e enviar dados
	
	ret
	
;;************************************************************************
	
transferir:  ;; Esse m�todo � usado para transferir dados pela Porta Serial aberta

lodsb         ;; Carrega o pr�ximo caractere � ser enviado

or al, al     ;; Compara o caractere com o fim da mensagem
jz .pronto    ;; Se igual ao fim, pula para .pronto

mov ah, 0x1   ;; Fun��o de envio de caractere do BIOS por Porta Serial
int 0x14      ;; Chama o BIOS e executa a a��o 

jmp transferir ;; Se n�o tiver acabado, volta � fun��o e carrega o pr�ximo caractere


.pronto: ;; Se tiver acabado...

ret      ;; Retorna a fun��o que o chamou

	
;;************************************************************************

receber: ;; Recebe os dados enviados pela Porta Serial, em resposta

	mov ah, 2 ;; Define fun��o 2 - Obter cracteres
	mov dx, 0 ;; Define Porta Serial 0 (COM1)
	
	int 0x14  ;; Chama o BIOS
	
	cmp al, '$' ;; Compara a resposta com '$'
	            ;; Se for igual, significa o fim da mensagem
	je .pronto  ;; Se for igual, vai at� .pronto, para terminar
	
	mov [recebido + 1] , al ;; Se n�o, joga o valor para dentro da vari�vel
	
	jmp receber ;; Volta a executar para receber o pr�ximo caractere


	.pronto:
	
	ret ;; Retorna a fun��o que o chamou
	
;;************************************************************************
	
recebido times 64 db 0 ;; Vari�vel em mem�ria de tamanho 64

dw "Arena",0
MsgInc db "Modulo de Driver Arena(R). Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes",0
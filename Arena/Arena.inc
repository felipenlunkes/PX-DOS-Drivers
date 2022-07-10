;;************************************************************************
;;
;; "Arena.inc" - Suporte a transferência de dados via Porta Serial
;;                 para o Driver Arena® do PX-DOS 
;;
;;           Copyright (C) 2016 Felipe Miguel Nery Lunkes
;;
;;************************************************************************

section .text

;;************************************************************************

iniciar_serial:  ;; Esse método é usado para inicializar uma Porta Serial


    mov ah, 0               ; Move o valor 0 para o registrador ah 
	                        ; A função 0 é usada para inicializar a Porta Serial COM1
    mov al, 0xe3            ; Parâmetros da porta serial
    mov dx, 0               ; Número da porta (COM 1) - Porta Serial 1
    int 0x14                ; Inicializar porta - Ativa a porta para receber e enviar dados
	
	ret
	
;;************************************************************************
	
transferir:  ;; Esse método é usado para transferir dados pela Porta Serial aberta

lodsb         ;; Carrega o próximo caractere à ser enviado

or al, al     ;; Compara o caractere com o fim da mensagem
jz .pronto    ;; Se igual ao fim, pula para .pronto

mov ah, 0x1   ;; Função de envio de caractere do BIOS por Porta Serial
int 0x14      ;; Chama o BIOS e executa a ação 

jmp transferir ;; Se não tiver acabado, volta à função e carrega o próximo caractere


.pronto: ;; Se tiver acabado...

ret      ;; Retorna a função que o chamou

	
;;************************************************************************

receber: ;; Recebe os dados enviados pela Porta Serial, em resposta

	mov ah, 2 ;; Define função 2 - Obter cracteres
	mov dx, 0 ;; Define Porta Serial 0 (COM1)
	
	int 0x14  ;; Chama o BIOS
	
	cmp al, '$' ;; Compara a resposta com '$'
	            ;; Se for igual, significa o fim da mensagem
	je .pronto  ;; Se for igual, vai até .pronto, para terminar
	
	mov [recebido + 1] , al ;; Se não, joga o valor para dentro da variável
	
	jmp receber ;; Volta a executar para receber o próximo caractere


	.pronto:
	
	ret ;; Retorna a função que o chamou
	
;;************************************************************************
	
recebido times 64 db 0 ;; Variável em memória de tamanho 64

dw "Arena",0
MsgInc db "Modulo de Driver Arena(R). Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes",0
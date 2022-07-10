;;********************************************************************************************
;;
;;
;;           @@@@    @@@@       @@@@@@@       @@@@           
;;           @@@@    @@@@     @@@@   @@@@     @@@@
;;           @@@@    @@@@     @@@@   @@@@     @@@@
;;           @@@@    @@@@     @@@@   @@@@     @@@@ 
;;           @@@@@@@@@@@@     @@@@@@@@@@@     @@@@ 
;;           @@@@@@@@@@@@     @@@@   @@@@     @@@@
;;           @@@@    @@@@     @@@@   @@@@     @@@@
;;           @@@@    @@@@     @@@@   @@@@     @@@@ 
;;           @@@@    @@@@     @@@@   @@@@     @@@@@@@@@@
;;           @@@@    @@@@     @@@@   @@@@     @@@@@@@@@@
;;
;;        HAL - Camada de Abstração de Hardware do PX-DOS  
;;
;; Este módulo inclui todos os serviços essenciais e drivers de dispositivos
;; removiveis em um unico driver carregavel, durante o processo de inicialização.
;;
;;
;;
;; Este driver ajudará o sistema a se "comportar" e interagir de forma correta nos diversos
;; dispositivos removíveis e arquiteturas x86 genéricas suportadas.
;;
;;
;;
;; Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;; A distribuição, reprodução total ou parcial de qualquer trecho do código
;; é proibida e passível de punição legal. O seu uso em formato binário é permitido
;; apenas se cumpridas todas as obrigações legais e se respeitando os direitos
;; autorais referentes a seu autor, Felipe Miguel Nery Lunkes.
;;
;;********************************************************************************************
;;
;;
;;                     Arquivo de Controle de Portas Seriais
;;
;;          Este arquivo contém funções complementares de acesso a Portas Seriais
;;                                 
;;
;;
;;**************************************************************************************

[BITS 16]

%macro paraSerial 1+

     section .data
	 
 %%mensagem:
 
     db %1,0
	 
     section .text 
	 
     mov si,%%mensagem
	 
     call transferir
	 
 %endmacro

.hal

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

jc near .erro

jmp transferir ;; Se não tiver acabado, volta à função e carrega o próximo caractere


.pronto: ;; Se tiver acabado...

ret      ;; Retorna a função que o chamou

.erro:

print 10,13,"Impossivel estabelecer conexao com porta serial... [Pulando]",10,13,0

ret
	
;;************************************************************************

receber: ;; Recebe os dados enviados pela Porta Serial, em resposta

	mov ah, 2 ;; Define função 2 - Obter cracteres
	mov dx, 0 ;; Define Porta Serial 0 (COM1)
	
	int 0x14  ;; Chama o BIOS
	
	jc near .erro
	
	cmp al, '$' ;; Compara a resposta com '$'
	            ;; Se for igual, significa o fim da mensagem
	je .pronto  ;; Se for igual, vai até .pronto, para terminar
	
	mov [recebido + 1] , al ;; Se não, joga o valor para dentro da variável
	
	jmp receber ;; Volta a executar para receber o próximo caractere


	.pronto:
	
	ret ;; Retorna a função que o chamou
	
	.erro:
	
	print 10,13,"Impossivel estabelecer conexao com porta serial... [Pulando]",10,13,0

    ret

;;************************************************************************

.dados
	
recebido times 64 db 0 ;; Variável em memória de tamanho 64


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
;;          Este arquivo contém funções importantes de Debug para a HAL
;;                                 
;;
;;
;;**************************************************************************************

interrupcaoHAL equ 69h ;; Chama a HAL para abertura da Porta Serial
SEGMENTO equ 32768

HAL_Serial: ;; Função inicio


    ;; call chamar_HAL ;; Chama a camada de Abstração de Hardware do PX-DOS, a solicitando
	                   ;; a abertura da porta serial. Posso fazer isso aqui, mas já fiz
					   ;; a HAL, deu trabalho, é mais seguro, mais fácil e a... é isso aí.


					   
    call iniciar_serial ;; Inicia a Porta Serial COM1
   
   
    mov si, msgInicio ;; Move para si o conteúdo da variável msgInicio, criada lá no final.
    

    call transferir ;; Chama o método para transferir a mensagem
	
	
	mov si, msgEspaco ;; A mesma coisa..
	
	
	call transferir

;;****************Separando as mensagens***********
	
	mov si, msgServicos
	
	call transferir
	
	mov si, msgEspaco ;; A mesma coisa..
	
	
	call transferir

;;****************Separando as mensagens***********

	
	mov si, msgPorta
	
	call transferir
	
	mov si, msgEspaco ;; A mesma coisa..
	
;;****************Separando as mensagens***********

	
	call transferir
	
	mov si, msgSobre
	
	
	call transferir
	
	mov si, msgEspaco
	
	
	call transferir

;;****************Separando as mensagens***********

	
	mov si, msgDebug
	
	call transferir
	
	mov si, msgEspaco
	
	
	call transferir
	
;;****************Separando as mensagens***********

	
	call obterProcessador ;; Chama um método que identifica o processador

	
	mov si, msgEspaco
	
	
	call transferir
	

;;****************Separando as mensagens***********
	
	call memoria ;; Chama um método para identificar quantos kbytes de RAM estão disponíveis
	             ;; Isso mesmo, Kbytes, visto que é um sistema DOS 16 Bits e só suporta,
				 ;; no máximo, 1 MB de RAM... É culpa do procesador...
	
	mov si, msgEspaco

;;****************Separando as mensagens***********
	
ret
			
;;************************************************************************
		

obterProcessador:

call BANDEIRA_Serial ;; Realiza a verificação e formatação do resultado 
                     ;; para o padrão serial
					 
call iniciar_serial

    mov si, .msgProcessador
	call transferir
	
call iniciar_serial
	
	mov si, produtoSerial
	call transferir

call iniciar_serial

	
	ret ;; Retorna ao método que o chamou

.dados
	
	.msgProcessador: db "Processador principal instalado atualmente: [",0
	
;;************************************************************************	

.hal

memoria:


call iniciar_serial

mov si, .msgMemoria

call transferir

;;****************Separando as mensagens***********

call iniciar_serial

mov ax, 0
int 12h  ;; Chama o BIOS para descobrir quanta memória está disponível

call paraString

mov [memoria], ax
mov si, [memoria]

call transferir

;;****************Separando as mensagens***********


call iniciar_serial

mov si, .msgKbytes
call transferir

;;****************Separando as mensagens***********

call iniciar_serial

mov si, msgEspaco
call transferir

;;****************Separando as mensagens***********

call iniciar_serial

mov si, msgEspaco
call transferir

ret ;; Retorna ao método que o chamou

;; Criando variáveis 
;; Variáveis com . são variáveis locais, com acesso apenas ao método em que foram
;; criadas.

.dados

.msgMemoria db 'Memoria RAM total instalada: ',0 
.tamanhoMemoria dw 29
.tamanhoTotal dw 3
.msgKbytes db ' Kbytes. ',0
.tamanhoKbytes dw 8
.memoria db 0

;;************************************************************************

.hal

chamar_HAL:

mov ah, 5h ;; Função de Portas Seriais
mov bh, 1 ;; COM1

int interrupcaoHAL

ret

;;************************************************************************	

.dados


    msgInicio db 'Camada de Abstracao do PX-DOS(R) (HAL) versao 0.9.0. Copyright (C) 2016 Felipe Miguel Nery Lunkes. Todos os direitos reservados.',0
	
	msgServicos db 'Iniciando servicos de Debug via Porta Serial para o PX-DOS(R)...',0
	
	msgPorta db 'Estabelecendo comunicacao com a Porta Serial COM1...',0
	
	msgSobre db 'Sucesso. A Porta Serial pode ser utilizada pelo sistema.',0
	
	msgDebug db 'Iniciando Debug da HAL pela Porta Serial COM1 aberta...',0
	
	msgEspaco db '                                                                                                                                      ',0


dispositivo: dw "COM1    ",0 ;; Especifica ao sistema que o driver usará a porta "COM1"
tipo: dw 7h


;; Tá meio triste aqui


__BSS__

;; Tão vazio aqui...
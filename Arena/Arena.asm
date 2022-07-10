;;************************************************************************
;;
;; Driver de Porta Serial PXCOM para PX-DOS 1.1.r2 "Arena"
;;
;;
;; Sistema Operacional PX-DOS 0.9.0
;;
;;
;; Este driver é protegido por direitos autorais, assim como 
;; o Sistema Operacional PX-DOS e as bibliotecas utilizadas.
;;
;; O Sistema Operacional PX-DOS é de propriedade de 
;; Felipe Miguel Nery Lunkes
;;
;; Este driver de dispositivo é propriedade de
;; Felipe Miguel Nery Lunkes
;;
;;
;; Punições legais poderão ser feitas caso esse(s) arquivos
;; sejam copiados, distribuídos, xerocados, recompilados sem
;; as informações legais e créditos originais e impressos.
;; Esse driver é protegido com licenças proprietárias, ou seja,  
;; todo o conteúdo aqui presente é fechado e restrito às pessoas
;; autorizadas. A distribuição dos códigos fonte é proibida,
;; e a distruibuição ou utilização em forma binária em outros
;; sistemas operacionais que não são o PX-DOS será autorizada
;; apenas com a autorização por escrito do desenvolvedor.
;;
;;
;; Copyright © 2014-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;************************************************************************
;;
;;
;;
;; Este driver é usado para iniciar a posta serial, ou seja, pode ser usado, com alguns
;; acréscimos, para imprimir algo em impressoras serias (USB não). No momento está
;; sendo usado para testar o sistema. Quando ele é carregado, ele gera um relatório
;; que contém informações relativas a memória RAM total durante o carregamento do
;; sistema, o processador instalado e algumas informações úteis. Logo após ele
;; o envia para um computador Linux conectado ao computador que roda o PX-DOS.
;; Lá, o conteúdo do relatório poderá ser analisado.
;;
;; Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes
;;
;;
;;************************************************************************

%include "C:\Dev\ASM\Driver\driver.s"

mov ax, cs ;; Essa instrução move o conteúdo do registrador cs para o ax.
           ;; Aqui movemos o endereço da memória em que o código do
		   ;; driver foi carreado para ax.
		   ;; O endereço é como 7000h.
mov bx, ax ;; Copiamos o endereço em ax para bx.
mov es, ax ;; A mesma coisa...
mov fs, ax ;; A mesma coisa...
mov gs, ax ;; A mesma coisa...


jmp INICIO ;; Pula para inicio, uma função. Similar a inicio(); em Java ou C

;;************************************************************************

%include "Arena.inc" ;; Inclui o arquivo que será possui as funções de envio
                     ;; e recebimento de dados.


%include "C:\Dev\ASM\video.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************************

section .text

INICIO: ;; Função inicio

   print 10,13,"Iniciando o Arena...",0
					
    call iniciar_serial ;; Inicia a Porta Serial COM1
   
    mov si, msgInicio ;; Move para si o conteúdo da variável msgInicio, criada lá no final.

    call transferir ;; Chama o método para transferir a mensagem
	
	call iniciar_serial
	
	mov si, msgEspaco ;; A mesma coisa..

	call transferir
	
	call iniciar_serial
	
	mov si, msgServicos
	
	call transferir
	
	mov si, msgEspaco ;; A mesma coisa..
	
	print " Passou por aqui.",0
	
	call transferir
	
	mov si, msgPorta
	
	call transferir
	
	mov si, msgEspaco ;; A mesma coisa..
	
	
	call transferir
	
	mov si, msgSobre
	
	
	call transferir
	
	mov si, msgEspaco
	
	
	call transferir
	
	mov si, msgDebug
	
	call transferir
	
	print " Passou por aqui 2",0
	
	call obterProcessador ;; Chama um método que identifica o processador

	
	mov si, msgEspaco
	
	
	call transferir
	
	mov si, Sistema
    call transferir

    mov ah, 01h
	mov bx, 03h

	int 90h

	mov si, ax
	call transferir

	print " Passou por aqui 3",0
	
	mov si, Ponto
	call transferir

	mov ah, 01h
	mov bx, 03h

	int 90h

	mov si, bx
	call transferir

	mov si, Ponto
	call transferir

	mov ah, 01h
	mov bx, 03h

	int 90h

	mov si, cx
	call transferir

	print " Passou por aqui 4",0
	
	mov si, Arquitetura
	call transferir

	mov si, Porta
	call transferir

	
	
	call memoria ;; Chama um método para identificar quantos kbytes de RAM estão disponíveis
	             ;; Isso mesmo, Kbytes, visto que é um sistema DOS 16 Bits e só suporta,
				 ;; no máximo, 1 MB de RAM... É culpa do procesador...
	
	
	
	mov si, msgEspaco

	jmp fim ;; Pula para o Fim do Driver, em que ele é descarregado e devolve
	        ;; o controle ao sistema.
			
SOBRE: ;; Será exibido pelo comando exibir do PX-DOS

msg: db 10,13,10,13,"Driver de Porta Serial e Depuracao do PX-DOS",10,13
     db "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes",10,13,10,13,0
			
;;************************************************************************
			
INTE:

;; Não existe interrupção
			
;;************************************************************************

obterProcessador:

    mov eax, 0
	cpuid
	
	mov [processador], ebx
	mov [processador + 4], edx
	mov [processador + 8], ecx 	
	
	mov si, processador
	
	
	call transferir
	
	ret ;; Retorna ao método que o chamou

;;************************************************************************	



memoria:


mov si, .msgMemoria


call transferir

mov ax, 0
int 12h  ;; Chama o BIOS para descobrir quanta memória está disponível

call paraString

mov [memoria], ax
mov si, [memoria]



call transferir

mov si, .msgKbytes


call transferir

ret ;; Retorna ao método que o chamou

;; Criando variáveis 
;; Variáveis com . são variáveis locais, com acesso apenas ao método em que foram
;; criadas.

section .data

.msgMemoria db 'Memoria RAM total instalada: ',0 
.tamanhoMemoria dw 29
.tamanhoTotal dw 3
.msgKbytes db ' Kbytes.',0
.tamanhoKbytes dw 8
.memoria db 0



;;************************************************************************
	
	section .text
	
fim: ;; Essa função é responsável por descarregar o driver da memória
     ;; e retornar o controle para o PX-DOS.

	

    mov ah, 05h ;; Define função 05h, de término de driver
	int 90h     ;; Chama o PX-DOS (Kernel) para descarregar o driver e retorna
                ;; o controle ao Kernel. Essa interrupção (int 90h) só tem no PX-DOS.
                ;; Inventei esse número! kkk Isso os programas em Java e C fazem, mas 
                ;; você não fica sabendo. Até pra imprimir string... Na verdade eles 
                ;; pedem ao sistema que imprimam pra eles...			

;;************************************************************************
	

	
    msgInicio db 'Arena(R) versao 1.1.r2',0
	
	msgServicos db 'Iniciando servicos do Arena(R) para PX-DOS...',0
	
	msgPorta db 'Estabelecendo comunicacao com a Porta Serial COM1...',0
	
	msgSobre db 'Driver de Porta Serial Arena(R) instalado.',0
	
	msgDebug db 'Iniciando Debug do Arena(R) via Porta Serial COM1...',0
	
	msgEspaco db '                                                                          ',0
	
	processador times 13 db 0
	tamanhoProcessador dw 13

;;************************************************************************




bannerPXDOS db "Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes",0
bannerNT db "Copyright © 2014-2016 Felipe Miguel Nery Lunkes",0
DriverNome db "Driver de Porta Serial para PX-DOS",0
Sistema db 'PX-DOS',0
Arquitetura db 'X86 16 Bits',0
Porta db 'COM1',0
Ponto db '.',0
;;************************************************************************
;;
;;
;; Sistema Operacional PX-DOS, PX-DOS, PX-DOS 0.1.1 ou qualquer termo
;; derivado de PX-DOS é marca registrada de Felipe Miguel Nery Lunkes.
;;
;; Copyright (C) 2014,2016 Felipe Miguel Nery Lunkes
;; Copyright © 2014,2016 Felipe Miguel Nery Lunkes
;;
;;
;;************************************************************************


section .data

.dispositivo: dw "COM1",0 ;; Especifica ao sistema que o driver usará a porta "COM1"
.nomeDriver: db "Arena",0   ;; Nome do Driver
.hal: db "\DRIVERS\HAL.SIS",0 ;; Nome da HAL

section .bss

COM1 equ 0xe3
SEGMENTO equ 32768
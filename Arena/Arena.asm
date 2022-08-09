;;************************************************************************
;;
;; Driver de Porta Serial PXCOM para PX-DOS 1.1.r2 "Arena"
;;
;;/*********************************************************************/
;;/*                                                                   */
;;/*                                                                   */
;;/*                                                                   */
;;/*                                                                   */
;;/*   #$$%%@!#$%                                                      */
;;/*   !!@#!$!$!$         Sistema Operacional PX-DOS                   */
;;/*   !@@#   #$%                                                      */
;;/*   #$$%   &*$                                                      */
;;/*   $#%@   @#&                                                      */
;;/*   #%$&*(@*@&                                                      */
;;/*   @#$@$#@$%$       2013-2022 (c) Felipe Miguel Nery Lunkes        */
;;/*   $%&*                Todos os direitos reservados                */
;;/*   @#&*                                                            */
;;/*   @&*%       Esse software se baseia em códigos disponíveis       */
;;/*   #&*@                     em domínio público                     */
;;/*                                                                   */
;;/*                                                                   */
;;/*********************************************************************/
;;/*
;;
;; Copyright (c) 2013-2022, Felipe Miguel Nery Lunkes
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;; * Redistributions of source code must retain the above copyright notice, this
;;   list of conditions and the following disclaimer.
;;
;; * Redistributions in binary form must reproduce the above copyright notice,
;;   this list of conditions and the following disclaimer in the documentation
;;   and/or other materials provided with the distribution.
;;
;; * Neither the name of the copyright holder nor the names of its
;;   contributors may be used to endorse or promote products derived from
;;   this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;; */
;;
;;
;;
;; Este driver � usado para iniciar a posta serial, ou seja, pode ser usado, com alguns
;; acr�scimos, para imprimir algo em impressoras serias (USB n�o). No momento est�
;; sendo usado para testar o sistema. Quando ele � carregado, ele gera um relat�rio
;; que cont�m informa��es relativas a mem�ria RAM total durante o carregamento do
;; sistema, o processador instalado e algumas informa��es �teis. Logo ap�s ele
;; o envia para um computador Linux conectado ao computador que roda o PX-DOS.
;; L�, o conte�do do relat�rio poder� ser analisado.
;;
;; Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes
;;
;;
;;************************************************************************

%include "C:\Dev\ASM\Driver\driver.s"

mov ax, cs ;; Essa instru��o move o conte�do do registrador cs para o ax.
           ;; Aqui movemos o endere�o da mem�ria em que o c�digo do
		   ;; driver foi carreado para ax.
		   ;; O endere�o � como 7000h.
mov bx, ax ;; Copiamos o endere�o em ax para bx.
mov es, ax ;; A mesma coisa...
mov fs, ax ;; A mesma coisa...
mov gs, ax ;; A mesma coisa...


jmp INICIO ;; Pula para inicio, uma fun��o. Similar a inicio(); em Java ou C

;;************************************************************************

%include "Arena.inc" ;; Inclui o arquivo que ser� possui as fun��es de envio
                     ;; e recebimento de dados.


%include "C:\Dev\ASM\video.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************************

section .text

INICIO: ;; Fun��o inicio

   print 10,13,"Iniciando o Arena...",0
					
    call iniciar_serial ;; Inicia a Porta Serial COM1
   
    mov si, msgInicio ;; Move para si o conte�do da vari�vel msgInicio, criada l� no final.

    call transferir ;; Chama o m�todo para transferir a mensagem
	
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
	
	call obterProcessador ;; Chama um m�todo que identifica o processador

	
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

	
	
	call memoria ;; Chama um m�todo para identificar quantos kbytes de RAM est�o dispon�veis
	             ;; Isso mesmo, Kbytes, visto que � um sistema DOS 16 Bits e s� suporta,
				 ;; no m�ximo, 1 MB de RAM... � culpa do procesador...
	
	
	
	mov si, msgEspaco

	jmp fim ;; Pula para o Fim do Driver, em que ele � descarregado e devolve
	        ;; o controle ao sistema.
			
SOBRE: ;; Ser� exibido pelo comando exibir do PX-DOS

msg: db 10,13,10,13,"Driver de Porta Serial e Depuracao do PX-DOS",10,13
     db "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes",10,13,10,13,0
			
;;************************************************************************
			
INTE:

;; N�o existe interrup��o
			
;;************************************************************************

obterProcessador:

    mov eax, 0
	cpuid
	
	mov [processador], ebx
	mov [processador + 4], edx
	mov [processador + 8], ecx 	
	
	mov si, processador
	
	
	call transferir
	
	ret ;; Retorna ao m�todo que o chamou

;;************************************************************************	



memoria:


mov si, .msgMemoria


call transferir

mov ax, 0
int 12h  ;; Chama o BIOS para descobrir quanta mem�ria est� dispon�vel

call paraString

mov [memoria], ax
mov si, [memoria]



call transferir

mov si, .msgKbytes


call transferir

ret ;; Retorna ao m�todo que o chamou

;; Criando vari�veis 
;; Vari�veis com . s�o vari�veis locais, com acesso apenas ao m�todo em que foram
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
	
fim: ;; Essa fun��o � respons�vel por descarregar o driver da mem�ria
     ;; e retornar o controle para o PX-DOS.

	

    mov ah, 05h ;; Define fun��o 05h, de t�rmino de driver
	int 90h     ;; Chama o PX-DOS (Kernel) para descarregar o driver e retorna
                ;; o controle ao Kernel. Essa interrup��o (int 90h) s� tem no PX-DOS.
                ;; Inventei esse n�mero! kkk Isso os programas em Java e C fazem, mas 
                ;; voc� n�o fica sabendo. At� pra imprimir string... Na verdade eles 
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
bannerNT db "Copyright � 2014-2016 Felipe Miguel Nery Lunkes",0
DriverNome db "Driver de Porta Serial para PX-DOS",0
Sistema db 'PX-DOS',0
Arquitetura db 'X86 16 Bits',0
Porta db 'COM1',0
Ponto db '.',0
;;************************************************************************
;;
;;
;; Sistema Operacional PX-DOS, PX-DOS, PX-DOS 0.1.1 ou qualquer termo
;; derivado de PX-DOS � marca registrada de Felipe Miguel Nery Lunkes.
;;
;; Copyright (C) 2014,2016 Felipe Miguel Nery Lunkes
;; Copyright � 2014,2016 Felipe Miguel Nery Lunkes
;;
;;
;;************************************************************************


section .data

.dispositivo: dw "COM1",0 ;; Especifica ao sistema que o driver usar� a porta "COM1"
.nomeDriver: db "Arena",0   ;; Nome do Driver
.hal: db "\DRIVERS\HAL.SIS",0 ;; Nome da HAL

section .bss

COM1 equ 0xe3
SEGMENTO equ 32768
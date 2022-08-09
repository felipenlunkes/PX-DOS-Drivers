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
;;        HAL - Camada de Abstra��o de Hardware do PX-DOS  
;;
;; Este m�dulo inclui todos os servi�os essenciais e drivers de dispositivos
;; removiveis em um unico driver carregavel, durante o processo de inicializa��o.
;;
;;
;;
;; Este driver ajudar� o sistema a se "comportar" e interagir de forma correta nos diversos
;; dispositivos remov�veis e arquiteturas x86 gen�ricas suportadas.
;;
;;
;;
;; Copyright � 2013-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
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
;;********************************************************************************************
;;
;;
;;                     Arquivo de Controle de Portas Seriais
;;
;;          Este arquivo cont�m fun��es importantes de Debug para a HAL
;;                                 
;;
;;
;;**************************************************************************************

interrupcaoHAL equ 69h ;; Chama a HAL para abertura da Porta Serial
SEGMENTO equ 32768

HAL_Serial: ;; Fun��o inicio


    ;; call chamar_HAL ;; Chama a camada de Abstra��o de Hardware do PX-DOS, a solicitando
	                   ;; a abertura da porta serial. Posso fazer isso aqui, mas j� fiz
					   ;; a HAL, deu trabalho, � mais seguro, mais f�cil e a... � isso a�.


					   
    call iniciar_serial ;; Inicia a Porta Serial COM1
   
   
    mov si, msgInicio ;; Move para si o conte�do da vari�vel msgInicio, criada l� no final.
    

    call transferir ;; Chama o m�todo para transferir a mensagem
	
	
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

	
	call obterProcessador ;; Chama um m�todo que identifica o processador

	
	mov si, msgEspaco
	
	
	call transferir
	

;;****************Separando as mensagens***********
	
	call memoria ;; Chama um m�todo para identificar quantos kbytes de RAM est�o dispon�veis
	             ;; Isso mesmo, Kbytes, visto que � um sistema DOS 16 Bits e s� suporta,
				 ;; no m�ximo, 1 MB de RAM... � culpa do procesador...
	
	mov si, msgEspaco

;;****************Separando as mensagens***********
	
ret
			
;;************************************************************************
		

obterProcessador:

call BANDEIRA_Serial ;; Realiza a verifica��o e formata��o do resultado 
                     ;; para o padr�o serial
					 
call iniciar_serial

    mov si, .msgProcessador
	call transferir
	
call iniciar_serial
	
	mov si, produtoSerial
	call transferir

call iniciar_serial

	
	ret ;; Retorna ao m�todo que o chamou

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
int 12h  ;; Chama o BIOS para descobrir quanta mem�ria est� dispon�vel

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

ret ;; Retorna ao m�todo que o chamou

;; Criando vari�veis 
;; Vari�veis com . s�o vari�veis locais, com acesso apenas ao m�todo em que foram
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

mov ah, 5h ;; Fun��o de Portas Seriais
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


dispositivo: dw "COM1    ",0 ;; Especifica ao sistema que o driver usar� a porta "COM1"
tipo: dw 7h


;; T� meio triste aqui


__BSS__

;; T�o vazio aqui...
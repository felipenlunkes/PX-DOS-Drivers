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

NUM_VER EQU 0
NUM_SUBVER EQU 9

%ifdef COMPLETA

%define COM1
%define IMPRESSORA
%define BIBLIOTECAS
%define FELIPE
%define OFICIAL
%define ORIGINAL
%define FINAL
%define V86
%define PROCINFO

%endif

;;***************************

%ifdef MINIMA

%ifdef COM1
%undef COM1
%endif

%ifdef IMPRESSORA
%undef IMPRESSORA
%endif

%ifdef BIBLIOTECAS
%undef BIBLIOTECAS
%endif

%ifdef V86
%undef V86
%endif

%define PROCINFO

%endif

;;***************************

%ifdef BASICA


%ifdef COM1
%undef COM1
%endif

%ifdef IMPRESSORA
%undef IMPRESSORA
%endif

%ifdef BIBLIOTECAS
%undef BIBLIOTECAS
%endif

%ifdef PROCINFO
%undef PROCINFO
%endif


%endif

;;***************************

%ifdef PENTIUM

cpu 586

%endif

;;***************************

%ifdef I186

%undef PROCESSADOR_VER
%undef SERIALIZAR

cpu 186

%endif

;;***************************

%ifdef DEBUG

%warning "Iniciando a compilacao da HAL para o PX-DOS versao 0.9.0"

%endif

;;*********************************************************************************


[BITS 16] ;; O c�digo gerado dever� ser 16 Bits, apenas

;; A seguir um mapa de mem�ria ser� gerado para exibir os offsets 
;; dos s�mbolos internos

[map symbols sections brief segments Driver\simbolos.txt] ;; Criar mapa de s�mbolos em um
                                                          ;; arquivo de texto comum.

cpu 8086  ;; No in�cio, usar modo de c�digo legado Intel 8086

org 0     ;; O driver para PX-DOS dever� sempre come�ar no offset 0

%include "HAL\cabecalho.asm" ;; Aqui est� o cabe�alho do Driver e Controle de Registradores

cpu 186


%define .hal [section .text align=16 vstart=0h] ;; Se��o de Texto
%define __BSS__ [section .bss align=16] ;; Se��o de Dados n�o inicializados leitura-escrita
%define .dados [section .data align=16] ;; Se��o de Dados inicializados e leitura-escrita
%define .rdados [section .rdata align=8 vstart=200h]  ;; Se��o de dados somente leitura 
                                                      ;; n�o inicializados
%define .krnl [section .data] ;; Inst�ncia da Se��o de Dados a ser usada para armazenar
                              ;; dados e estruturas que ser�o utilizadas para a comunica��o
							  ;; entre a HAL e o Kernel do PX-DOS
%define .comen [section .comment align=16 vstart=600h] ;; Se��o .comment
%define .inf [section .info align=8 vstart=900h] ;; Se��o de Informa��es do Arquivo




jmp __DRIVER_INIT__


;;**************************************************************************************

%include "HAL\uniao.asm"

%include "C:\Dev\ASM\tempo.s"
%include "Simbolos\estruturas.asm"
%include "Simbolos\simbolos.asm"

cpu 286

;;**************************************************************************************

.hal ;; Define segmento de texto aqui

__DRIVER_INIT__:

jmp __INICIAR

;;**************************************************************************************

FIM:

call __DRIVER_FIM__

;;**************************************************************************************

INTE: ;; Instala uma interrup��o que pode ser chamada pelo sistema sempre que necess�rio.
      ;; Esta interrup��o tamb�m pode ser chamada pelos programas para reiniciar a HAL,
	  ;; para que atualize os dispositivos instalados e forne�a informa��es atualizadas.
	  ;; No caso, basta chamar a interrup��o 69h, em assembly. Tamb�m pode ser chamada
	  ;; por programas em C, ou em qualquer outra linguagem.

or ax, ax
mov es, ax

cli
mov	[es:0x69*4], word int_prog
mov [es:0x69*4+2], cs
sti

nop

ret

int_prog:

pusha 

jmp __DRIVER_INIT__

popa

iret


.dados ;; Segmento de Dados




;;**************************************************************************************

.hal

dadosPrincipal equ ($$-__DRIVER_INIT__)

;;**************************************************************************************

;; Cabe�alho Final do Driver - Este cabe�alho traz informa��es importantes
;; sobre o tipo do Driver, que tamb�m � analisado pelo Kernel no in�cio da
;; execu��o do Driver.

;;**************************************************************************************

.rdados ;; Dados somente leitura na estrutura da HAL

SIS_REQ: db "0.9.0",0

.comen

BUILD: db "PXDOS.Xandar@"

.inf ;; Se��o de informa��es do arquivo � ser gerado

SEP: times 1 db ' Informacoes relativas a este driver (HAL.SIS): '

%ifdef COMPLETA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", completa e liberada como oficial.",0

%endif

%endif

%ifdef MINIMA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", minima e liberada como oficial.",0

%endif

%endif


%ifdef BASICA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", basica e liberada como oficial.",0

%endif

%endif

;;*************************************************************

%ifdef COMPLETA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", completa e liberada como Release Candidate (Testes).",0

%endif

%endif

%ifdef MINIMA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", minima e liberada como Release Candidate (Testes).",0

%endif

%endif


%ifdef BASICA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", basica e liberada como Release Candidate (Testes).",0

%endif

%endif

APM db "PX-DOS(R) Driver APM versao 1.0",0


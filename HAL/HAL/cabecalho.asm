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
;;                               Arquivo de Cabe�alho
;;
;;  Este arquivo cont�m a assinatura de driver e assinaturas importantes 
;;                                 
;;
;;
;;**************************************************************************************


%ifdef DEBUG

%warning "Incluindo arquivo de cabecalho de Drivers para PX-DOS(R)"

%endif

;;***********************************************************
;;
;; Cabe�alho de Driver para PX-DOS 0.9.0 ou superior
;;
;;
;;
;;
;;
;;
;;***********************************************************

[BITS 16]      ;; Define que o c�digo gerado dever� ser 16 Bits

org 0h          ;; Define o Offset para 0 (0h)

;-----------------------------------------------+
;         DWORD - Assinatura do Driver          | 1 word
;                      PX                       | 
;-----------------------------------------------+
;            Tipo do Dispositivo                ; 1 word
;                                               ;
; 1h - Dispositivo de caracter (V�deo...)       ;
; 2h - M�dias de armazenamento de massa (HD, CD);
; 3h - M�dias de armazenamento (Disquete)       ;
; 4h - Rel�gio                                  ;
; 5h - Rede e acesso a perif�ricos              ;
; 6h - Configura��o                             ;
; 7h - Porta Serial COM                         ;
; 8h - Reservado ao Sistema                     ;
; 9h - Subsistema PX-DOS                        ;
; 10 - Porta Serial COM2                        ;
; 12 - Porta Paralela LPT1                      ;
; 12 - USB                                      ;
;-----------------------------------------------+
;            N�mero da interrup��o              ; 1 word
;          implementada pelo Driver             ;
;-----------------------------------------------+
;     Tipo de Driver e Dispositivo associado    ; 11 bytes
;                                               ;
; Deve conter at� letras, mais at� oito espacos,;
;         formando 11 bytes no total.           ;
;                                               ;
;   Pode ser (n�o se resumindo apenas a):       ;
;                                               ;
; "DEV        " - Dispositivo                   ;
; "ARMAZENAMEN" - Armazenamento                 ;
; "IO         " - Entrada e Sa�da               ;
; "REDE       " - Redes diversas                ;
; "RELOGIO    " - Relogio                       ;
;                                               ;
; Estes s�o nomes padr�o. Nomes customizados    ;
; podem ser utilizados.                         ;
;-----------------------------------------------+
;  Ponteiro para o ponto de entrada do Driver   ; 1 word
;-----------------------------------------------+
;     Ponteiro para a Interrup��o do Driver     ; 1 word
;-----------------------------------------------+
;  Vers�o do Sistema Requerida para a execu��o  ; 1 byte
;-----------------------------------------------;
;Subvers�o do Sistema Requerida para a execu��o ; 1 byte
;-----------------------------------------------;

Driver: ;; In�cio do Cabe�alho, que dever� estar presente no in�cio do arquivo
        ;; execut�vel.

.assinatura: dw "PX"           ;; A declara��o da assinatura deve estar aqui, no in�cio.
.tipo: dw 8h                   ;; Tipo do Driver
.numero: dw 0                  ;; N�mero da interrup��o implementada pelo Driver
.nome_driver: db "HAL        " ;; Tipo de fun��o v�lida a ser exercida pelo Driver   	
.estrategia: dw INICIO         ;; Ponto de Entrada para o in�cio
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrup��o     
.versao: dw 0                  ;; Vers�o Maior do sistema requerida
.subversao: dw 9               ;; Vers�o Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declara��es, o driver foi desenvolvido para a
                               ;; vers�o 0.9.0 do PX-DOS ou superiores 
			
;; Fim do cabe�alho

push sp
push ss
push bp
push cs
push ds

mov ax, cs
mov es, ax
mov gs, ax
mov fs, ax

xor ax, ax


jmp INICIO ;; C�digo usado durante a execu��o do Driver

;;**************************************************************************************


INICIO:

cpu 8086

mov ax, cs ;; Controle de registradores
mov bx, ax
mov cx, ax
mov dx, ax
mov es, ax
mov fs, ax
mov gs, ax

push sp ;; Puxar SP para a pilha
push bp ;; Puxar BP para a pilha
push ss ;; Puxar SS para a pilha

;;**************************************************************************************
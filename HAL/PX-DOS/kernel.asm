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
;;                             Arquivo de Servi�os do Kernel
;;
;;  Este arquivo cont�m o m�dulo para in�cio dos servi�os de utilidades do Kernel do PX-DOS
;;
;;**************************************************************************************

%include "C:\Dev\ASM\mem.s"

.hal

__DRIVER_FIM__:

pop ss
pop bp
pop sp

mov ah, 05h    ;; Define fun��o de t�rmino de Driver
mov bx, 02h    ;; Dever� permanecer na mem�ria
mov al, 01h    ;; Driver residente
int 90h        ;; Chama o PX-DOS e pede a finaliza��o do Driver

;;**************************************************************************************

__Driver_Info__:


mov ax, cs

call paraString

mov bx, ax

push bx

mov ax, ds

call paraString

mov cx, ax

push cx

pop cx
pop bx
push cx

mov si, bx
push bx


pop cx

mov si, cx


ret

;;**************************************************************************************

__OBTER_VERSAO__:

mov ah, 01h
mov bx, 03h
int 90h


push cx
push bx
push ax

print "Versao Reportada: ",0

mov si, ax
call escrever

mov si, ponto
call escrever

pop bx

mov si, bx
call escrever

mov si, ponto
call escrever

pop cx

mov si, cx
call escrever

ret


;;**************************************************************************************

.krnl

ponto db '.',0


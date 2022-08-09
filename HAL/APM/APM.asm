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
;;                       Rotinas de comunica��o com fun��es APM
;;
;;  Este arquivo cont�m rotinas de comunica��o e protocolos APM respons�veis pelo
;; controle energ�tico do computador
;;                                 
;;
;;
;;**************************************************************************************

HAL_Iniciar_APM:

checar_instalacao: ;; Ser� realizada uma chamada para a checagem de instala��o

mov ah, 53h            ;; Uma fun��o APM
mov al, 00h            ;; Comando de checagem de instala��o
xor bx, bx             ;; ID do dispositivo (APM BIOS)
int 15h                ;; Chama a fun��o APM
jc APM_ERRO_INSTALACAO ;; Caso ocorra erro, chama manipulador espec�fico

desconectar_interfaces: ;; Desconecta interfaces anteriores

mov ah, 53h               ;; Uma fun��o APM
mov al, 04h               ;; Comando de desconex�o de interface
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a fun��o APM
jc APM_ERRO_DESCONEXAO    ;; Caso ocorra erro, chama manipulador espec�fico
 
conectar_interface: ;; Conecta a uma interface APM para o gerenciamento

mov ah, 53h               ;; Uma fun��o APM
mov al, 01h               ;; N�mero da interface (Modo Real)
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a fun��o APM
jc APM_ERRO_CONEXAO       ;; Caso ocorra erro, chama manipulador espec�fico
 
ativar_gerenciamento: ;; Ser� habilitado o gerenciamento energ�tico para todos 
                       ;; os dispositivos

mov ah, 53h                ;; Uma fun��o APM
mov al, 08h                ;; Estado de gerenciamento
mov bx, 0001h              ;; Dispositivo
mov cx, 0001h              ;; Gerenciamento habilitado
int 15h                    ;; Chama a fun��o APM
jc APM_ERRO_GERENCIAMENTO  ;; Caso ocorra erro, chama manipulador espec�fico

HAL_APM_FIM:

ret

;;**************************************************************************************
;;
;;                           Erros durante as opera��es APM                                 
;;
;;**************************************************************************************

APM_ERRO_INSTALACAO:

;; Futuramente, o sistema ser� informado

jmp HAL_APM_FIM

APM_ERRO_CONEXAO:

;; Futuramente, o sistema ser� informado

jmp ativar_gerenciamento

APM_ERRO_GERENCIAMENTO:

;; Futuramente, o sistema ser� informado

ret


APM_ERRO_DESCONEXAO:

cmp ah, 03h               
jmp ativar_gerenciamento    ;; Erro APM, quando o c�digo de erro � 3, indicando que
                            ;; nenhuma interface foi conectada
 

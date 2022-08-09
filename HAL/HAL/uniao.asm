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
;;                                 Arquivo de Uni�o
;;
;;  Este arquivo reune todos os outros arquivos fonte, formando uma liga��o entre
;;              os m�dulos da HAL, unificando assim o bin�rio final                 
;;
;;
;;**************************************************************************************

[BITS 16]

cpu 386 ;; Aqui precisarei de uma CPU 386 no m�nimo


;;***************************************************************************************


;;*****Inclus�o do restante dos arquivos*******

%include "Video\video.asm"
%include "APM\APM.asm"
%include "HAL\licenca.asm"
%include "Video\splash.asm"
%include "Mem\memx86.asm"
%include "Processador\procx86.asm"
%include "PX-DOS\kernel.asm"
%include "Int\Int.asm"
%include "Ver\ver.asm"


;;**************Condicional********************

%ifdef IMPRESSORA

%include "Impressora\impressora.asm"

%endif

;;**************Condicional********************

%ifdef COM1

%include "Serial\Arena.inc" ;; Inclui o arquivo que ser� possui as fun��es de envio
                            ;; e recebimento de dados.
%include "Serial\serial.asm"

					 
%endif

;;***************************************************************************************

.hal ;; = section .text

;;***************************************************************************************

__INICIAR: ;; Procedimento principal para a execu��o do c�digo da HAL

;;******Chama as fun��es obtidas dos arquivos*******

call INTE ;; Realiza a instala��o da interrup��o

call VERIFICAR_VERSAO_PXDOS ;; Verificar� se a vers�o do sistema � suportada ou n�o

call splash ;; Cria a entrada gr�fica do Driver, apenas, em verifica��o de vers�o 
            ;; suportada

%ifdef PROCINFO

call HAL_Iniciar_APM ;; Realiza a instala��o e checagem do Driver APM

call VERIFICAR_X86 ;; Chama a m�dulo de verifica��o de fun��es do processador

%endif

call INTERRUPCAO ;; Substitui a interrup��o primitiva instalada anteriormente para uma
                 ;; com manipulador

%ifndef PROCINFO

call BANDEIRA ;; Verifica e retorna a Bandeira do processador principal instalado

%endif

;;***************************************************************************************
;;
;; � partir de agora, as fun��es ser�o chamadas apenas se a configura��o da HAL permitir.
;;
;; Ou seja, apenas se os Macros estiverem definidos durante a compila��o, para a 
;; distin��o de configura��o.
;;
;;;;***************************************************************************************

;;**************Condicional********************

%ifdef IMPRESSORA

call VERIFICAR_IMPRESSORA ;; Verifica, instala e inicia uma impressora

%endif

;;**************Condicional********************

%ifdef COM1

call HAL_Serial ;; Realiza um DEBUG sobre a COM1

%endif

;;***************************************************************************************
;;
;; Novamente, fun��es internas globais, para ambas as plataformas
;;
;;
;;;;***************************************************************************************

call VERIFICAR_MEMORIA ;; Chama o m�dulo de verifica��o de Mem�ria RAM

;;***************************************************************************************

;;**********Pula para o fim do Driver**********

jmp __DRIVER_FIM__ ;; "Finaliza", temporariamente, a HAL. Devolve o controle ao sistema

;;**************************************************************************************

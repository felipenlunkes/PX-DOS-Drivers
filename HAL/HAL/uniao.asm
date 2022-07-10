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
;; A distribui��o, reprodu��o total ou parcial de qualquer trecho do c�digo
;; � proibida e pass�vel de puni��o legal. O seu uso em formato bin�rio � permitido
;; apenas se cumpridas todas as obriga��es legais e se respeitando os direitos
;; autorais referentes a seu autor, Felipe Miguel Nery Lunkes.
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

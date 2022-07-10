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
;;                                 Arquivo de União
;;
;;  Este arquivo reune todos os outros arquivos fonte, formando uma ligação entre
;;              os módulos da HAL, unificando assim o binário final                 
;;
;;
;;**************************************************************************************

[BITS 16]

cpu 386 ;; Aqui precisarei de uma CPU 386 no mínimo


;;***************************************************************************************


;;*****Inclusão do restante dos arquivos*******

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

%include "Serial\Arena.inc" ;; Inclui o arquivo que será possui as funções de envio
                            ;; e recebimento de dados.
%include "Serial\serial.asm"

					 
%endif

;;***************************************************************************************

.hal ;; = section .text

;;***************************************************************************************

__INICIAR: ;; Procedimento principal para a execução do código da HAL

;;******Chama as funções obtidas dos arquivos*******

call INTE ;; Realiza a instalação da interrupção

call VERIFICAR_VERSAO_PXDOS ;; Verificará se a versão do sistema é suportada ou não

call splash ;; Cria a entrada gráfica do Driver, apenas, em verificação de versão 
            ;; suportada

%ifdef PROCINFO

call HAL_Iniciar_APM ;; Realiza a instalação e checagem do Driver APM

call VERIFICAR_X86 ;; Chama a módulo de verificação de funções do processador

%endif

call INTERRUPCAO ;; Substitui a interrupção primitiva instalada anteriormente para uma
                 ;; com manipulador

%ifndef PROCINFO

call BANDEIRA ;; Verifica e retorna a Bandeira do processador principal instalado

%endif

;;***************************************************************************************
;;
;; À partir de agora, as funções serão chamadas apenas se a configuração da HAL permitir.
;;
;; Ou seja, apenas se os Macros estiverem definidos durante a compilação, para a 
;; distinção de configuração.
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
;; Novamente, funções internas globais, para ambas as plataformas
;;
;;
;;;;***************************************************************************************

call VERIFICAR_MEMORIA ;; Chama o módulo de verificação de Memória RAM

;;***************************************************************************************

;;**********Pula para o fim do Driver**********

jmp __DRIVER_FIM__ ;; "Finaliza", temporariamente, a HAL. Devolve o controle ao sistema

;;**************************************************************************************

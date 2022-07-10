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

%include "Int\Int.inc" ;; Inclui fun��es de cria��o de interrup��o
%include "Int\x86.inc" ;; Inclui a fun��o principal de interrup��o da HAL

%ifdef V86 ;; Se estiver definido a fun��o de Modo Virtual 8086...

%include "Int\x86_x64.inc" ;; Inclui fun��o de modo virtual, etc...

%endif

%include "Int\real.inc" ;; Fun��es para modo real (uso em outros Driver v86 ou Unreal)
%include "Int\salvar.inc" ;; Fun��es de salvamento (para uso de Unreal ou x86)

.hal

;;********************************************************************************************

INTERRUPCAO:

call Criar_Interrupcao ;; Chama principal fun��o para criar Interrup��o de Software

%ifdef V86 ;; Se estiver definido a fun��o de Modo Virtual 8086...

call INICIO_VM ;; Inicia a m�quina virtual x86

%endif 

ret

;;********************************************************************************************



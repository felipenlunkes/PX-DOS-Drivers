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

%include "Int\Int.inc" ;; Inclui funções de criação de interrupção
%include "Int\x86.inc" ;; Inclui a função principal de interrupção da HAL

%ifdef V86 ;; Se estiver definido a função de Modo Virtual 8086...

%include "Int\x86_x64.inc" ;; Inclui função de modo virtual, etc...

%endif

%include "Int\real.inc" ;; Funções para modo real (uso em outros Driver v86 ou Unreal)
%include "Int\salvar.inc" ;; Funções de salvamento (para uso de Unreal ou x86)

.hal

;;********************************************************************************************

INTERRUPCAO:

call Criar_Interrupcao ;; Chama principal função para criar Interrupção de Software

%ifdef V86 ;; Se estiver definido a função de Modo Virtual 8086...

call INICIO_VM ;; Inicia a máquina virtual x86

%endif 

ret

;;********************************************************************************************



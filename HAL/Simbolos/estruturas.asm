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
;;        HAL - Camada de Abstra??o de Hardware do PX-DOS  
;;
;; Este m?dulo inclui todos os servi?os essenciais e drivers de dispositivos
;; removiveis em um unico driver carregavel, durante o processo de inicializa??o.
;;
;;
;;
;; Este driver ajudar? o sistema a se "comportar" e interagir de forma correta nos diversos
;; dispositivos remov?veis e arquiteturas x86 gen?ricas suportadas.
;;
;;
;;
;; Copyright ? 2013-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;; A distribui??o, reprodu??o total ou parcial de qualquer trecho do c?digo
;; ? proibida e pass?vel de puni??o legal. O seu uso em formato bin?rio ? permitido
;; apenas se cumpridas todas as obriga??es legais e se respeitando os direitos
;; autorais referentes a seu autor, Felipe Miguel Nery Lunkes.
;;
;;********************************************************************************************


 [BITS 16]


;; Estruturas para salvamento de valores

struc Hardware

procx86: resd 13
memx86: resd 13
serialx86: resw 13
Arenax86: resw 13

endstruc

;;**************************************************************************************
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
;;                               Arquivo de S�mbolos
;;
;;  Este arquivo cont�m s�mbolos em mem�ria utilizados por outros m�dulos do Driver
;;                                 
;;
;;
;;**************************************************************************************

;; Simbolos, que devem ser usados para indicar ao m�dulo de envio serial aonde as informa��es
;; foram armazenadas

__BSS__

proc equ 200h
mem equ 800h

.dados

asterisco db "*",0
interrogacao db "?",0
FAT db "????????.???",0

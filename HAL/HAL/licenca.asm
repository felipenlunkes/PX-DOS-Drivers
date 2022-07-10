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
;;                             Arquivo de Licenças
;;
;;  Este arquivo contém as informações de licença do driver, que ficam armazenadas
;;                                 internamente.
;;
;;
;;**************************************************************************************

 [BITS 16]
 

.dados

%ifdef OFICIAL

OFICIAL_MSG db "Software final de liberacao oficial.",0

%else

OFICIAL_MSG db "Versao de Testes. Cuidado! Este Software pode apresentar instabilidades durante a sua execucao. Use por sua conta e risco.",0

%endif

.dados

SISOP db "Designado para PX-DOS(R) 0.9.0",0

SISOPAUT db "Camada de Abstracao de Hardware para PX-DOS(R).",0

copyrightNT db "Copyright © 2013-2016 Felipe Miguel Nery Lunkes. Todos os direitos reservados.",0

Descricao db "Descricao: Esconde as diferencas entre diversos sistemas computacionais, dispositivos e interfaces em arquiteturas x86.",0


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
;;                                 Arquivo de Vídeo
;;
;;    Este arquivo reune definições de controle de resolução e cores da tela
;;                                           
;;
;;
;;**************************************************************************************

.hal

%include "C:\Dev\ASM\video.s"

HD: ;; Este modo de vídeo não deve ser usado, por enquanto...

mov ax, 4F02h
mov bx, 107h
int 10h

jc near Falha_Video

ret

;;**************************************************************************************

Alta_definicao: ;; Muda a resolução da tela


mov ah, 13h
mov al, 6h
int 10h

jc near Falha_Video

ret

;;**************************************************************************************

Falha_Video:

print 10,13,"Falha ao definir configuracoes de video.",10,13,0

ret

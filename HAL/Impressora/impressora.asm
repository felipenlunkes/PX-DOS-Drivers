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


;;**************************************************************************************

.hal

VERIFICAR_IMPRESSORA:

print "# Procurando e instalando impressoras...",0

mov ah, 01h
mov dx, 00h
int 17h

jc near falha_impressora

mov ah, 01h
mov dx, 01h
int 17h

jc near falha_impressora

mov ah, 01h
mov dx, 02h
int 17h

jc near falha_impressora

mov ah, 01h
mov dx, 03h
int 17h

jc near falha_impressora

print " [Sucesso]",10,13,0

ret

;;**************************************************************************************

falha_impressora:

print " [Falha]",10,13,0

ret

;;**************************************************************************************
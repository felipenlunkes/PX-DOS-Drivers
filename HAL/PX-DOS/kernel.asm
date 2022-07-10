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
;;                             Arquivo de Serviços do Kernel
;;
;;  Este arquivo contém o módulo para início dos serviços de utilidades do Kernel do PX-DOS
;;
;;**************************************************************************************

%include "C:\Dev\ASM\mem.s"

.hal

__DRIVER_FIM__:

pop ss
pop bp
pop sp

mov ah, 05h    ;; Define função de término de Driver
mov bx, 02h    ;; Deverá permanecer na memória
mov al, 01h    ;; Driver residente
int 90h        ;; Chama o PX-DOS e pede a finalização do Driver

;;**************************************************************************************

__Driver_Info__:


mov ax, cs

call paraString

mov bx, ax

push bx

mov ax, ds

call paraString

mov cx, ax

push cx

pop cx
pop bx
push cx

mov si, bx
push bx


pop cx

mov si, cx


ret

;;**************************************************************************************

__OBTER_VERSAO__:

mov ah, 01h
mov bx, 03h
int 90h


push cx
push bx
push ax

print "Versao Reportada: ",0

mov si, ax
call escrever

mov si, ponto
call escrever

pop bx

mov si, bx
call escrever

mov si, ponto
call escrever

pop cx

mov si, cx
call escrever

ret


;;**************************************************************************************

.krnl

ponto db '.',0


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
;;                             Arquivo de Servi�os do Kernel
;;
;;  Este arquivo cont�m o m�dulo para in�cio dos servi�os de utilidades do Kernel do PX-DOS
;;
;;**************************************************************************************

%include "C:\Dev\ASM\mem.s"

.hal

__DRIVER_FIM__:

pop ss
pop bp
pop sp

mov ah, 05h    ;; Define fun��o de t�rmino de Driver
mov bx, 02h    ;; Dever� permanecer na mem�ria
mov al, 01h    ;; Driver residente
int 90h        ;; Chama o PX-DOS e pede a finaliza��o do Driver

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


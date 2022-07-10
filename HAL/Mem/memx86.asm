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
;;                        Arquivo de Gerenciamento de Memória
;;
;;  Este arquivo contém o módulo para gerenciamento e descobrimento de memória 
;;
;;**************************************************************************************
 
 [BITS 16]

.hal
 
%include "C:\Dev\ASM\pxdos.s"

;;**************************************************************************************

VERIFICAR_MEMORIA:

xor ax, ax
xor bx, bx
xor cx, cx

print "# Memoria RAM total disponivel encontrada: ",0

    pusha
	mov al,18h
	out 70h,al
	in al,71h
	mov ah,al
	mov al,17h
	out 70h,al
	in al,71h
	
	add ax,1024
	
	call paraString

mov si, ax
call escrever

mov [memoria_global], ax

print " Kbytes.",0	

mov ah, 05h
mov bx, 02h
mov al, 01h
int 90h


;;**************************************************************************************

.erro:

print " [Falha na Memoria Extendida]",0

;;**************************************************************************************

.krnl

memoria_global times 5 db 0

;;***********************************************************************************
;;
;;
;; Programa de Debug do Sistema Operacional PX-DOS usando interface de Driver 
;; do PX-DOS 0.9.0 e porta Serial COM1
;;
;;
;;
;; Copyright © 2014-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;
;; Usando sintaxe TASM, substituindo o NASM
;;
;; Uso: tasm dbg.asm
;;
;;***********************************************************************************

;;***********************************************************************************
	
BANDEIRA_Serial proc
	
    mov eax,80000002h	
	cpuid
	
	mov di, offset produtoSerial		
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000003h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000004h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	mov si, offset produtoSerial		
	mov cx,48
	
loop_CPUSerial:	

    lodsb
	cmp al,' '
	jae imprimir_CPUSerial
	mov al,'_'
	
imprimir_CPUSerial:	

    mov [si-1],al
	loop loop_CPUSerial

	
	call iniciar_serial
	
	mov si, offset prodmsg
	call transferir

	ret
	
BANDEIRA_SERIAL endp	

prodmsg	db "# Nome do Processador: ["
produtoSerial	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,0	

;;***********************************************************************************

MEMORIA proc

xor ax, ax
xor bx, bx
xor cx, cx

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

	call iniciar_serial
	
mov si, ax
call transferir

ret

MEMORIA endp

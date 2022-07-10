;;*********************************************************************
;;
;; Subsistema Sierra� para PX-DOS� 0.9.0+
;;
;;
;; Subsistema que detecta  e monitora todos os drives de armazenamento
;; conectados ao computador e controla os fluxos de entrada e sa�da
;; de cada dispositivo em especial. O Subsistema � carregado como
;; um Driver comum e ent�o � corrigido em tempo de execu��o e cria
;; a estrutura de comunica��o de subsistema.
;;
;; Copyright � 2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;
;;*********************************************************************


[BITS 16]      ;; Define que o c�digo gerado dever� ser 16 Bits

org 0          ;; Define o Offset para 0 (0h)

;-----------------------------------------------+
;         DWORD - Assinatura do Driver          | 1 word
;                      PX                       | 
;-----------------------------------------------+
;            Tipo do Dispositivo                ; 1 word
;                                               ;
; 1h - Dispositivo de caracter (V�deo...)       ;
; 2h - M�dias de armazenamento de massa (HD, CD);
; 3h - M�dias de armazenamento (Disquete)       ;
; 4h - Rel�gio                                  ;
; 5h - Rede e acesso a perif�ricos              ;
; 6h - Configura��o                             ;
; 7h - Porta Serial COM                         ;
; 8h - Reservado ao Sistema                     ;
; 9h - Subsistema PX-DOS                        ;
; 10 - Porta Serial COM2                        ;
; 12 - Porta Paralela LPT1                      ;
; 12 - USB                                      ;
;-----------------------------------------------+
;            N�mero da interrup��o              ; 1 word
;          implementada pelo Driver             ;
;-----------------------------------------------+
;     Tipo de Driver e Dispositivo associado    ; 11 bytes
;                                               ;
; Deve conter at� letras, mais at� oito espacos,;
;         formando 11 bytes no total.           ;
;                                               ;
;   Pode ser (n�o se resumindo apenas a):       ;
;                                               ;
; "DEV        " - Dispositivo                   ;
; "ARMAZENAMEN" - Armazenamento                 ;
; "IO         " - Entrada e Sa�da               ;
; "REDE       " - Redes diversas                ;
; "RELOGIO    " - Relogio                       ;
;                                               ;
; Estes s�o nomes padr�o. Nomes customizados    ;
; podem ser utilizados.                         ;
;-----------------------------------------------+
;  Ponteiro para o ponto de entrada do Driver   ; 1 word
;-----------------------------------------------+
;     Ponteiro para a Interrup��o do Driver     ; 1 word
;-----------------------------------------------+
;  Vers�o do Sistema Requerida para a execu��o  ; 1 byte
;-----------------------------------------------;
;Subvers�o do Sistema Requerida para a execu��o ; 1 byte
;-----------------------------------------------;

Driver:

.assinatura: dw "PX"           ;; A declara��o da assinatura deve estar aqui, no in�cio.
.tipo: dw 9                    ;; Tipo do Driver (9h = Subsistema)
.numero: dw 0
.tipo_driver: db "SIERRA     " ;; Tipo de fun��o v�lida a ser exercida pelo   
                               ;; Driver  			
.estrategia: dw INICIO         ;; Ponto de Entrada para o in�cio
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrup��o     
.versao: dw 0                  ;; Vers�o Maior do sistema requerida
.subversao: dw 9               ;; Vers�o Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declara��es, o driver foi desenvolvido para a
                               ;; vers�o 0.9.0 do PX-DOS ou superiores 				   

push sp
push ss
push bp
push cs
push ds

mov ax, cs
mov es, ax
mov gs, ax
mov fs, ax

xor ax, ax


jmp INICIO

;;**********************************************************

;; Macros

%macro escrever 1+

     section .data  
	 
 %%string:
 
     db %1,'$'
     section .text    
  
     mov ah, 03h
     mov dx,%%string
     int 90h
	 
 %endmacro
 
 %macro limpar 0
 
 xor ax, ax
 xor bx, bx
 xor cx, cx
 xor dx, dx
 xor di, di
 xor si, si
 
 %endmacro
 
 %macro segmento 1+
 
 mov ax, %1
 mov cs, ax
 mov ds, ax
 mov es, ax
 mov fs, ax
 mov gs, ax
 
 
 %endmacro

 %macro limpar_mem 2+
 
 mov si, %1
 mov dx, %2
 
 call limpar_memoria
 
 %endmacro
 
 %macro marcar_mem 2+
 
 mov si, %1
 mov dx, %2
 
 call marcar_memoria
 
 %endmacro
 
 %macro A20 0
 
 call ativar_A20
 
 %endmacro
 
 %macro descompac 0

 
 .subsisnome: db 'SIERRA     ',0
 .versao_subsis: db 0
 .subver_subsis: db 9
 .tamanho: db TAMANHOSUBSIS
 .interface: db 0h
  
 %endmacro
 
;; Inclus�es
 
%include "C:\Dev\ASM\mem.s"

;; Segmentos

%define .texto [section .text align=16]
%define .dados [section .data]
%define .dni [section .bss]
%define .comem [section .comment align=16 vstart=260h]
%define .info [section .info align=16]
%define .rdata [section .rdata]

;; Defini��es

%define soma (a+b)
%define absoluto (base+off)

 
;;**********************************************************
 
INICIO: ;; Ponto de entrada de c�digo

mov ax, cs
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

;; Agora mudaremos o endere�o de carregamento do Subsistema, onde o endere�o
;; atual foi definido pelo sistema. Agora, o Subsistema ir� para um local definido

mov di, 2000h
mov cx, 0xC00
repnz

movsw


jmp near Setup


jmp Setup

;;**********************************************************

Setup:

limpar_mem 32000 , 32768 ;; Limpar a �rea de mem�ria

marcar_mem 32000 , 32768 ;; Marcar para uso

;; Abaixo, trecho de c�digo para identificar o ponto de entrada do Kernel

 ;mov bx, IdentidadeKernel
 ;call hexasc
 
 ;mov ah, 3h ;; Mostra a mensagem de entrada do Driver
 
 ;mov dx, Identidade
 ;int 90h
 

 limpar_mem Identidade, IdentidadeKernel ;; Matar os s�mbolos
 marcar_mem Identidade, IdentidadeKernel ;; Marcar para uso
 
 A20 ;; Ativar o A20
 
jmp VERIFICAR_DISQUETES

jmp FIM

;;**************************************************************************

VERIFICAR_DISQUETES:

 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 00h 
 
 int 13h

 jc .erro
 
 escrever 10,13,'Disco A: [OK] - '
 
 jmp .verb
 
 .erro:
 
 escrever 10,13,'Disco A: [Ausente] - '
  
  jmp .verb
  
  .verb:
  
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 01h 
 
 int 13h
 
 jc .erroB
 
 escrever 'Disco B: [OK] - ',0
 
 jmp VERIFICAR_DISCOS
 
 .erroB:
 
 escrever 'Disco B: [Ausente] - ',0

 jmp VERIFICAR_DISCOS
 
;;**************************************************************************

VERIFICAR_DISCOS:

 
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 80h 
 
 int 13h

 jc .erroc
 
 escrever 'Disco C: [OK] - '
 
 jmp .verd
 
 .erroc:
 
 escrever 'Disco C: [Ausente] - '
  
  jmp .verd
  
  .verd:
  
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 81h 
 
 int 13h
 
 jc .erroD
 
 escrever 'Disco D: [OK]',0
 
 jmp Continuar
 
 .erroD:
 
 escrever 'Disco D: [Ausente]',0

 jmp Continuar
 
;;**************************************************************************

Continuar:



jmp FIM

;;**************************************************************************

INTE:


;;**************************************************************************

hexasc:

 ;; AX = valor,
 ;; DS:BX = endere�o da String
 
 ;; Retorna AX
 ;; BX Destru�do
 
 push cx 
 push dx
 
 mov dx,4 ;; Inicializar contador de Caracteres
 mov cx,4 ;; Isola os pr�ximos quatro bits
 
 rol ax,cl

 mov cx,ax
 and cx,0fh
 
 add cx,'0' ;; Converte para ASCII
 cmp cx,'9' ;; Est� entre 0-9?
 
 jbe hexasc2 ;; Sim, pule
 
 add cx,'A'-'9'-1 

 hexasc2: ;; Guarda o caracter
 
 mov [bx],cl
 inc bx ;; Incrementar ponteiro
 
 dec dx ;; Conta os caracteres convertidos
 
 jnz hexasc2 ;; Loop, n�o chegou a 4 ainda
 
 pop dx
 pop cx
 
 ret ;; Retorna a quem o chamou
 

;;**************************************************************************
 
FIM:

mov ah, 05h
mov bx, 1h
mov cx, 2h
int 90h

pop ax
pop ax
pop ax
 
 Identidade      db 10,13,10,13
                  db 'Driver Sierra(R) para PX-DOS(R) versao 1.0.5.149.5'
                  db 10,13
                  db 'O Cabecalho do Driver esta em: '
	   
 IdentidadeKernel db 'XXXX:0000','$' 
 
 TAMANHOSUBSIS equ $-($-$$)
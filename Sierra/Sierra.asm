;;*********************************************************************
;;
;; Subsistema Sierra® para PX-DOS® 0.9.0+
;;
;;
;; Subsistema que detecta  e monitora todos os drives de armazenamento
;; conectados ao computador e controla os fluxos de entrada e saída
;; de cada dispositivo em especial. O Subsistema é carregado como
;; um Driver comum e então é corrigido em tempo de execução e cria
;; a estrutura de comunicação de subsistema.
;;
;; Copyright © 2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;
;;*********************************************************************


[BITS 16]      ;; Define que o código gerado deverá ser 16 Bits

org 0          ;; Define o Offset para 0 (0h)

;-----------------------------------------------+
;         DWORD - Assinatura do Driver          | 1 word
;                      PX                       | 
;-----------------------------------------------+
;            Tipo do Dispositivo                ; 1 word
;                                               ;
; 1h - Dispositivo de caracter (Vídeo...)       ;
; 2h - Mídias de armazenamento de massa (HD, CD);
; 3h - Mídias de armazenamento (Disquete)       ;
; 4h - Relógio                                  ;
; 5h - Rede e acesso a periféricos              ;
; 6h - Configuração                             ;
; 7h - Porta Serial COM                         ;
; 8h - Reservado ao Sistema                     ;
; 9h - Subsistema PX-DOS                        ;
; 10 - Porta Serial COM2                        ;
; 12 - Porta Paralela LPT1                      ;
; 12 - USB                                      ;
;-----------------------------------------------+
;            Número da interrupção              ; 1 word
;          implementada pelo Driver             ;
;-----------------------------------------------+
;     Tipo de Driver e Dispositivo associado    ; 11 bytes
;                                               ;
; Deve conter até letras, mais até oito espacos,;
;         formando 11 bytes no total.           ;
;                                               ;
;   Pode ser (não se resumindo apenas a):       ;
;                                               ;
; "DEV        " - Dispositivo                   ;
; "ARMAZENAMEN" - Armazenamento                 ;
; "IO         " - Entrada e Saída               ;
; "REDE       " - Redes diversas                ;
; "RELOGIO    " - Relogio                       ;
;                                               ;
; Estes são nomes padrão. Nomes customizados    ;
; podem ser utilizados.                         ;
;-----------------------------------------------+
;  Ponteiro para o ponto de entrada do Driver   ; 1 word
;-----------------------------------------------+
;     Ponteiro para a Interrupção do Driver     ; 1 word
;-----------------------------------------------+
;  Versão do Sistema Requerida para a execução  ; 1 byte
;-----------------------------------------------;
;Subversão do Sistema Requerida para a execução ; 1 byte
;-----------------------------------------------;

Driver:

.assinatura: dw "PX"           ;; A declaração da assinatura deve estar aqui, no início.
.tipo: dw 9                    ;; Tipo do Driver (9h = Subsistema)
.numero: dw 0
.tipo_driver: db "SIERRA     " ;; Tipo de função válida a ser exercida pelo   
                               ;; Driver  			
.estrategia: dw INICIO         ;; Ponto de Entrada para o início
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrupção     
.versao: dw 0                  ;; Versão Maior do sistema requerida
.subversao: dw 9               ;; Versão Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declarações, o driver foi desenvolvido para a
                               ;; versão 0.9.0 do PX-DOS ou superiores 				   

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
 
;; Inclusões
 
%include "C:\Dev\ASM\mem.s"

;; Segmentos

%define .texto [section .text align=16]
%define .dados [section .data]
%define .dni [section .bss]
%define .comem [section .comment align=16 vstart=260h]
%define .info [section .info align=16]
%define .rdata [section .rdata]

;; Definições

%define soma (a+b)
%define absoluto (base+off)

 
;;**********************************************************
 
INICIO: ;; Ponto de entrada de código

mov ax, cs
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

;; Agora mudaremos o endereço de carregamento do Subsistema, onde o endereço
;; atual foi definido pelo sistema. Agora, o Subsistema irá para um local definido

mov di, 2000h
mov cx, 0xC00
repnz

movsw


jmp near Setup


jmp Setup

;;**********************************************************

Setup:

limpar_mem 32000 , 32768 ;; Limpar a área de memória

marcar_mem 32000 , 32768 ;; Marcar para uso

;; Abaixo, trecho de código para identificar o ponto de entrada do Kernel

 ;mov bx, IdentidadeKernel
 ;call hexasc
 
 ;mov ah, 3h ;; Mostra a mensagem de entrada do Driver
 
 ;mov dx, Identidade
 ;int 90h
 

 limpar_mem Identidade, IdentidadeKernel ;; Matar os símbolos
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
 ;; DS:BX = endereço da String
 
 ;; Retorna AX
 ;; BX Destruído
 
 push cx 
 push dx
 
 mov dx,4 ;; Inicializar contador de Caracteres
 mov cx,4 ;; Isola os próximos quatro bits
 
 rol ax,cl

 mov cx,ax
 and cx,0fh
 
 add cx,'0' ;; Converte para ASCII
 cmp cx,'9' ;; Está entre 0-9?
 
 jbe hexasc2 ;; Sim, pule
 
 add cx,'A'-'9'-1 

 hexasc2: ;; Guarda o caracter
 
 mov [bx],cl
 inc bx ;; Incrementar ponteiro
 
 dec dx ;; Conta os caracteres convertidos
 
 jnz hexasc2 ;; Loop, não chegou a 4 ainda
 
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
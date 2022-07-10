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

include cbclho.asm ;; Inclui o cabeçalho do Driver

include estrat.asm ;; Inclui a estratégia do Driver
 
.586

 
;;***********************************************************************************
;;
;; 
;; Função inicial ( código 0) do Driver de Debug
;; 
;; 
;;*********************************************************************************** 
 
;;***********************************************************************************
 
 Init proc near ;; Função 0 - Inicializa todas as estruturas
 
 push es
 push di
 
 mov ax,cs ;; Converte o endereço para ASCII
 
 mov bx,offset Identidade_Memoria
 call hexasc
 
 mov ah,9 ;; Mostra a mensagem de entrada do Driver
 
 mov dx,offset Identidade
 int 21h
 
 pop di 
 pop es
 
 ;; Define endereços de memória livre

 mov word ptr es:[di+14],offset Init
 mov word ptr es:[di+16],cs
 xor ax,ax ;; Status de retorno
 

 call iniciar_serial
 
mov si, offset msgInicio
call transferir

mov si, offset msgInterface
call transferir

mov si, offset msgCopyright
call transferir

mov si, offset msgDireitos
call transferir

call BANDEIRA_SERIAL


jmp FIM

 Init endp
 
 
;;*********************************************************************************** 
 
 
 
 
 
include funcoes.asm  ;; Inclui as funções chamadas para I/O
include simbolos.asm ;; Inclui as mensagens e símbolos
include hrdw.asm     ;; Inclui as funções de detecção do Hardware
include kernel.asm   ;; Inclui as funções que interagem com o Kernel

  
 Intr endp
 
 _TEXT ends

  end	
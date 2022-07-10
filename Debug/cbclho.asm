;;***********************************************************************************
;;
;;
;; Programa de Debug do Sistema Operacional PX-DOS usando interface de Driver 
;; do PX-DOS 0.9.0 e porta Serial COM1
;;
;;
;;
;; Copyright � 2014-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;
;; Usando sintaxe TASM, substituindo o NASM
;;
;; Uso: tasm dbg.asm
;;
;;***********************************************************************************

name PXDBG
page 55,132
title Driver de Debug de Kernel do PX-DOS

;;***********************************************************************************

 _TEXT segment word public 'CODE'
 
 assume cs:_TEXT,ds:_TEXT,es:NOTHING
 
 org 0 ;; Todo Driver deve come�ar em 0h
 
;;***********************************************************************************
 
 MaxCmd equ 3
 
 cr equ 0dh 
 
 lf equ 0ah
 
 eom equ '$' 

;;***********************************************************************************
 
 Cabecalho: ;; Cabe�alho do Driver de Dispositivo

dw "XP"          ;; A declara��o da assinatura (estranho, mas no TASM, ao contr�rio)
dw 9h            ;; Tipo do Driver
dw 0             ;; N�mero da Interrup��o do Driver
db "DEBUG      " ;; Tipo de fun��o v�lida a ser exercida pelo   
                 ;; Driver  			
dw Estrategia    ;; Ponto de Entrada para o in�cio
dw Intr          ;; Ponto de Entrada para a Interrup��o     
dw 0             ;; Vers�o Maior do sistema requerida
dw 9             ;; Vers�o Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declara��es, o driver foi desenvolvido para a
                               ;; vers�o 0.9.0 do PX-DOS ou superiores 
 
 jmp Estrategia
 
 ;;***********************************************************************************
 
 Tabela_de_Requerimento dd ? 

;;***********************************************************************************
 
 Tabela_de_Acoes: 
 
 dw Init ; 0 = Inicializa o Driver

;;*********************************************************************************** 
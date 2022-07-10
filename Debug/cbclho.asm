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

name PXDBG
page 55,132
title Driver de Debug de Kernel do PX-DOS

;;***********************************************************************************

 _TEXT segment word public 'CODE'
 
 assume cs:_TEXT,ds:_TEXT,es:NOTHING
 
 org 0 ;; Todo Driver deve começar em 0h
 
;;***********************************************************************************
 
 MaxCmd equ 3
 
 cr equ 0dh 
 
 lf equ 0ah
 
 eom equ '$' 

;;***********************************************************************************
 
 Cabecalho: ;; Cabeçalho do Driver de Dispositivo

dw "XP"          ;; A declaração da assinatura (estranho, mas no TASM, ao contrário)
dw 9h            ;; Tipo do Driver
dw 0             ;; Número da Interrupção do Driver
db "DEBUG      " ;; Tipo de função válida a ser exercida pelo   
                 ;; Driver  			
dw Estrategia    ;; Ponto de Entrada para o início
dw Intr          ;; Ponto de Entrada para a Interrupção     
dw 0             ;; Versão Maior do sistema requerida
dw 9             ;; Versão Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declarações, o driver foi desenvolvido para a
                               ;; versão 0.9.0 do PX-DOS ou superiores 
 
 jmp Estrategia
 
 ;;***********************************************************************************
 
 Tabela_de_Requerimento dd ? 

;;***********************************************************************************
 
 Tabela_de_Acoes: 
 
 dw Init ; 0 = Inicializa o Driver

;;*********************************************************************************** 
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

 Identidade db 0dh,0ah,0ah
 db 'Driver de Debug para PX-DOS - Modelo de Testes'
 db 0dh,0ah
 db 'O Cabecalho do Driver esta em: '
 Identidade_Memoria db 'XXXX:0000'
 db 0dh,0ah,'$'
 
msgInicio db "  Driver de Debug para PX-DOS versao 0.0.1 Beta 1  ",0
msgInterface db "  Utilizando interface de Driver PX-DOS 0.9.0  ",0
msgCopyright db "  Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes.  ",0
msgDireitos db "  Todos os direitos reservados.  ",0
memoria_msg db "  Memoria RAM total instalada: ",0
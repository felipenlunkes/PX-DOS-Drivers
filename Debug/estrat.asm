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
 
Estrategia proc far
 
mov bx, 0h
xor bx, bx
xor ax, ax


 mov word ptr cs:[Tabela_de_Requerimento],bx

jmp Intr

 Estrategia endp

;;***********************************************************************************
 
 Intr proc far 
 
 push ax 
 push bx
 push cx
 push dx
 push ds
 push es
 push di
 push si
 push bp
 push cs 
 pop ds 
 

 xor bh,bh
 
 cmp bx,MaxCmd 
 jle Intr1 ;; Pula se o código estiver dentro dos limites
 
 call Erro ;; Define o bit de erro
 jmp Intr2

;;***********************************************************************************
 
 Intr1: 
 
 shl bx,1 ;; Cria o índice na tabela que será chamado
 
 call word ptr [bx+Tabela_de_Acoes] ;; Chama a Função
 
 les di,[Tabela_de_Requerimento] ; ES:DI = Endereço da tabela de requerimento

;;***********************************************************************************
 
 Intr2: 
 
 or ax, 0100h ;; Bit de Feito
 mov es:[di+3], ax ;; Guardar Status na tabela
 
 pop bp 
 pop si
 pop di
 pop es
 pop ds
 pop dx
 pop cx
 pop bx
 pop ax
 
 
 mov ah, 05h ;; Voltar ao sistema
 mov bx, 1
 int 90h

;;*********************************************************************************** 


 Erro proc near ;; Comando Incorreto
 
 mov ax, 8003h ;; Código incorreto no bit de erro
 ret
 
 endp

;;***********************************************************************************
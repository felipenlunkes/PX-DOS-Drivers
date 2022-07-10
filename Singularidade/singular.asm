;;*****************************************************************
;;
;;        _______
;;       /   ___/          Todos os direitos reservados
;;       |   |__       © 2014-2016 Felipe Miguel Nery Lunkes
;;       \___   \
;;        __/   /
;;       |_____/ Singularidade® - Driver para PX-DOS(R)(R) 0.9.0 ou superior
;;
;;
;;
;;*****************************************************************

[BITS 16]      ;; Define que o código gerado deverá ser 16 Bits

org 0          ;; Define o Offset para 0 (0h)

;; Aviso! Altere o código abaixo para enquadrar a função de seu Driver

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
.tipo: dw 6h                   ;; Tipo do Driver
.numero: dw 0                  ;; Número da Interrupção
.tipo_driver: db "SINGULAR   " ;; Tipo de função válida a ser exercida pelo   
                               ;; Driver  			
.estrategia: dw INICIO         ;; Ponto de Entrada para o início
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrupção     
.versao: dw 0                  ;; Versão Maior do sistema requerida
.subversao: dw 9               ;; Versão Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declarações, o driver foi desenvolvido para a
                               ;; versão 0.9.0 do PX-DOS(R) ou superiores 
			

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



;;*****************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              Ponto de Entrada
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


INICIO:	

 
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
;;                               Arquivo de Cabeçalho
;;
;;  Este arquivo contém a assinatura de driver e assinaturas importantes 
;;                                 
;;
;;
;;**************************************************************************************


%ifdef DEBUG

%warning "Incluindo arquivo de cabecalho de Drivers para PX-DOS(R)"

%endif

;;***********************************************************
;;
;; Cabeçalho de Driver para PX-DOS 0.9.0 ou superior
;;
;;
;;
;;
;;
;;
;;***********************************************************

[BITS 16]      ;; Define que o código gerado deverá ser 16 Bits

org 0h          ;; Define o Offset para 0 (0h)

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

Driver: ;; Início do Cabeçalho, que deverá estar presente no início do arquivo
        ;; executável.

.assinatura: dw "PX"           ;; A declaração da assinatura deve estar aqui, no início.
.tipo: dw 8h                   ;; Tipo do Driver
.numero: dw 0                  ;; Número da interrupção implementada pelo Driver
.nome_driver: db "HAL        " ;; Tipo de função válida a ser exercida pelo Driver   	
.estrategia: dw INICIO         ;; Ponto de Entrada para o início
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrupção     
.versao: dw 0                  ;; Versão Maior do sistema requerida
.subversao: dw 9               ;; Versão Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declarações, o driver foi desenvolvido para a
                               ;; versão 0.9.0 do PX-DOS ou superiores 
			
;; Fim do cabeçalho

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


jmp INICIO ;; Código usado durante a execução do Driver

;;**************************************************************************************


INICIO:

cpu 8086

mov ax, cs ;; Controle de registradores
mov bx, ax
mov cx, ax
mov dx, ax
mov es, ax
mov fs, ax
mov gs, ax

push sp ;; Puxar SP para a pilha
push bp ;; Puxar BP para a pilha
push ss ;; Puxar SS para a pilha

;;**************************************************************************************
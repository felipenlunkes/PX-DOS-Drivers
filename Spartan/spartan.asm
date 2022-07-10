;;*****************************************************************
;;
;;        _______
;;       /   ___/          Todos os direitos reservados
;;       |   |__       � 2014-2016 Felipe Miguel Nery Lunkes
;;       \___   \
;;        __/   /
;;       |_____/ Spartan� - Driver para PX-DOS(R)(R) 0.9.0 ou superior
;;
;;
;; Modo Real -> Modo Protegido -> Modo Big Real
;;
;; Permite o endere�amento total da Mem�ria RAM, com um
;; limite de 4GB, al�m de instru��es de 32-Bits. Tamb�m
;; permite o uso de fun��es exclusivas do modo protegido
;; no Modo Real, sobre o DOS.
;;
;;
;; ! N�o se esque�a, Felipe burro, de alterar o cabe�alho do Driver!
;; Nome do Dispositivo: 'PROC    '
;; Tipo: Reservado 2
;;
;;*****************************************************************

[BITS 16]      ;; Define que o c�digo gerado dever� ser 16 Bits

org 0          ;; Define o Offset para 0 (0h)

;; Aviso! Altere o c�digo abaixo para enquadrar a fun��o de seu Driver

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
.tipo: dw 6h                   ;; Tipo do Driver
.numero: dw 0                  ;; N�mero da Interrup��o
.tipo_driver: db "SPARTAN    " ;; Tipo de fun��o v�lida a ser exercida pelo   
                               ;; Driver  			
.estrategia: dw INICIO         ;; Ponto de Entrada para o in�cio
.interrupcao: dw INTE          ;; Ponto de Entrada para a Interrup��o     
.versao: dw 0                  ;; Vers�o Maior do sistema requerida
.subversao: dw 9               ;; Vers�o Menor do sistema requerida - Sendo assim, juntando
                               ;; as duas declara��es, o driver foi desenvolvido para a
                               ;; vers�o 0.9.0 do PX-DOS(R) ou superiores 
			

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

    call INTE ; Instala a interrup��o
	
    xor ebx, ebx
	mov bx, ds                       ; BX= segmento
	shl ebx, 4                       ; BX= "linear" 
	mov eax, ebx
	mov [gdt2 + 2], ax               ; Definir endere�os de 32-Bits no segmento de base
	mov [gdt3 + 2], ax
	mov [gdt4 + 2], ax               ; Definir endere�os de 16-Bits no segmento de base
	mov [gdt5 + 2], ax
	shr eax,16
	mov [gdt2 + 4], al
	mov [gdt3 + 4], al
	mov [gdt4 + 4], al
	mov [gdt5 + 4], al

	mov [gdt2 + 7], ah
	mov [gdt3 + 7], ah
	mov [gdt4 + 7], ah
	mov [gdt5 + 7], ah

; Agora possui uma GDT v�lida para ser utilizada.
; A GDT possui um limite fixado:
; Descriptores * 8 - 1
; Este c�digo usa 5 descritores (null, linear, code, data, real-mode),
; Ent�o o limite � 39. 
;

    lea eax, [gdt + ebx]             ; EAX= Endere�o f�sico da GDT
    mov [gdtr + 2], eax

	cli

	xor ax, ax
	mov es, ax
	mov edx, [es:0x0D * 4]		; Vetor int 0Dh -> EDX
	mov [es:0x0D * 4 + 2], cs
	lea ax, [Manipulador_Interrupcao]
	mov [es:0x0D * 4], ax
	
	
	
	
; Tentando usar endere�os 32-Bits. Dependendo da CPU, isso ir� causar uma
; interrup��o 0Dh.
; Caso '!' apare�a no canto superior direito na tela, um agente de modo 
; unreal j� foi executado, sendo
; que o c�digo abaixo p�de ser executado. Na primeira vez que um agente 
; como este for executado, o c�digo abaixo ir� gerar uma interrup��o 0Dh,
; sendo que o '!' n�o ser� exibido.
; Para n�o gerar travamentos, sendo que a interrup��o 0Dh
; � uma esp�cie de General Protection Fault,
; uma interrup��o substitutiva foi instalada em seu lugar, que ir� receber
; a mensagem do processador
; e simplesmente ignor�-la.

	mov ebx, 0xB8089       ; 0xB8089 deixa uma marca verde, muito interessante...			
	mov byte [es:ebx], '!' ; Caso '!' apare�a na tela, um agente j� foi utilizado.
	                       ; Caso n�o tenha aparecido, por enquanto essa fun��o �
						   ; ilegal, indicando que nenhum extensor foi instalado

	mov ax, cs
	mov [CS_Modo_Real], ax
	lea ax, [Va_Para_Modo_Real]
	mov [IP_Modo_Real], ax
	
;
; Para testar o codigo, iremos acessar a mem�ria de v�deo, em B800:0000
; (hex).
;

	mov ax, cs
	mov es, ax
;
; Carregar a GDT com o endere�o base e o limite
;

	lgdt [gdtr] ; Carregar GDT!
	
;
; Chavear para o modo protegido com o uso do registrador CR0.

	mov eax, cr0
	or al, 1
	mov cr0, eax

;
; Agora o processador est� no modo protegido 32-Bits
;
 
   
        mov cx, 38
        cld
        rep movsb
;
; Agora o c�digo anterior n�o roda neste modo. N�o � s� alterar o bit PE do CR0.
;
; Agora vamos fazer um far jmp. Isso ir� recarregar o CS, trocando as instru��es de modo real
; para modo protegido.

;
;

	jmp Seletor_Codigo:Va_Modo_Protegido          ; Pular para o modo protegido
	
;
; Manipulador da interrup��o 0Dh em modo real:
;

;;*****************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    Manipulador de Interrup��o 0Dh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Manipulador_Interrupcao:	

    mov ax, 0xB800
	mov fs, ax
	
	pop ax				; Ponteiro de IP...
	add ax, 5			
	push ax
	
	iret

	
;;*****************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    Manipulador da Interrup��o 69h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Manipulador_69h: 

   jmp INICIO	

    pop ax				; Ponteiro de IP...
	add ax, 5			
	push ax
	
	iret
	
;;*****************************************************************

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     Alerta Felipe!  Agora o processador est� em modo protegido
;               Isso quer dizer: n�o fa�a burrada!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

[BITS 32]

Va_Modo_Protegido:

;
; Agora estamos em modo protegido. Tirando CS, todos os registradores de segmento
; cont�m c�digo 16-Bits. 
;
; Agora existe um problema: Os endere�os continuam sendo de 16-Bits,
; enquanto as instru��es s�o 32-Bits. rep movsb usado ir� ler DS:ESI 
; e escrever em ES:EDI. 
;
        xor edi, edi
        xor esi, esi
        mov ecx, 46
        cld
        rep movsb

; Pronto! E funciona!
;
; Para ativar completamente o endere�amento em modo real, precisamos colocar
; os seletores de modo nos registradores DS e SS:
;

	mov ax, Seletor_Dados
	mov ds, ax
	mov ss, ax
	
	
; No modo real, a mem�ria de v�deo em texto � B800:0000
; No modo flat linear. � 000B8000.

;
;
	mov ax, Seletor_Linear
	mov es, ax

	
	cld
	rep movsb
;
; OK, agora devemos voltar ao modo real porque n�...
;; O DOS roda em modo real! Anta!
;

	jmp Seletor_Codigo_Real:Va_Para_16
	
;;*****************************************************************
	
	
[BITS 16]

Va_Para_16:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Agora estamos em modo protegido 16-Bits!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Vamos concertar isso agora...
;


	mov ax, Seletor_Dados_Real
	mov ss, ax
	mov ds, ax			
;
; Para voltar ao modo real, devemos reverter o processo para entrar no modo protegido.
; Devemos zerar o bit PE de CR0.
;

	mov eax, cr0
	and al, 0xFE
	mov cr0, eax
;
; Agora colocando o valor de CS de modo real de volta em CS. Estas instru��es 
; podem alterar CS:

;       jmp (far)       retf            iret		
;
; jmp (far) funciona:
;
	jmp far [IP_Modo_Real]

;;*****************************************************************
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Voltando para o Modo Real 16-Bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[BITS 16]


Va_Para_Modo_Real:	
;
; Pronto! O modo UNREAL(ou "flat real",
; "big real", etc.) esta ativado. Isso � muito �til, pois o sistema 
; pode carregar aplicativos na mem�ria convencional e o mover para a mem�ria extendida.

;
; � poss�vel recarregar os registradores de segmento
; do modo real, significando que � poss�vel utilizar endere�os de 16 Bits.
;
	xor ax, ax
	mov es, ax
	
	cld

	a32				; Mesmo que 'db 0x67'
	rep movsb
;
; Antes de voltar, colocar os valores compat�veis de modo real nos registros de segmento
;
	mov ax, cs
	mov ds, ax
	mov ss, ax
	mov ax, cs
	mov es, ax

	mov di, 80      
	mov cx, 56
	cld
	rep movsb
;
; Restaurar o vetor da INT 0D
;
	xor ax, ax
	mov es, ax
	mov [es:0x0D * 4], edx		; EDX -> INT 0x0D 
;
; Aqui j� n�o � modo protegido. J� � seguro habilitar as interrup��es
;
	sti
;
; Voltar para o PX-DOS(R)(R)
;

    mov ebx,0xB809A			
	mov byte [es:ebx], '!'
	
	mov ah, 05h
	mov bx, 1h
	int 90h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        Sobre o Driver para PX-DOS(R)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
SOBRE:

mov dx, .msg
mov ah, 03h
int 90h

mov ah, 02h
int 90h	

.msg db 10,13,"Spartan para PX-DOS(R) versao 0.9.0",10,13
     db "Driver de Modo Big Real para PX-DOS(R) 0.9.0 ou superior.",10,13,10,13
	 db "Aviso! Requer 386 ou mais recente.",10,13,10,13
	 db "Copyright (C) 2016 Felipe Miguel Nery Lunkes",10,13
	 db "Todos os direitos reservados.",10,13,0


	
;;*****************************************************************
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Instalador da Interrup��o do Driver chmada pelo Kernel ou Ponto de Entrada
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	INTE: ;; Vetor de Interrup��o que dever� ser usado em caso de Driver
	
	xor ax, ax
	mov es, ax
	mov edx, [es:0x69 * 4]		; Vetor int 69h -> EDX
	mov [es:0x69 * 4 + 2], cs
	lea ax, [Manipulador_69h]
	mov [es:0x69 * 4], ax
	
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IP_Modo_Real:

        dw 0

CS_Modo_Real:

	dw 0

	
gdtr:	dw fim_gdt - gdt - 1	; Limite GDT
	    dd gdt     
	; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Tabela de Descritores Global (global descriptor table (GDT))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Descriptor NULL

gdt:	

    dw 0			; limite 15:0
	dw 0			; base 15:0
	db 0			; base 23:16
	db 0			; tipo
	db 0			; limite 19:16, flags
	db 0			; base 31:24

; Descritor de Segmento Linear Data

Seletor_Linear	equ	$-gdt

	dw 0xFFFF		; limite 0xFFFFF
	dw 0			; base 0
	db 0
	db 0x92			; presente, anel 0, data, expand-up, escrita
    db 0xCF         ; granularidade, 32-bit
	db 0

; Descriptor de Segmento de C�digo

Seletor_Codigo	equ	$-gdt

gdt2:  

    dw 0xFFFF       ; limite 0xFFFFF
	dw 0			; (A base ser� definida mais pra frente)
	db 0
	db 0x9A			; presente, anel 0, c�digo, non-conforming, leitura
    db 0xCF         ; granularidade, 32-bit
	db 0

; Descriptor de Segmento de Dados

Seletor_Dados	equ	$-gdt

gdt3:   

    dw 0xFFFF       ; limite 0xFFFFF
	dw 0			; (A base ser� definida a seguir)
	db 0
	db 0x92			; presente, anel 0, dados, expand-up, escrita
    db 0xCF         ; granularidade, 32-bit
	db 0

; O descritor de segmento de c�digo apropriada para o Modo Real

; (16-bit, granularidade, limite=0xFFFF)

Seletor_Codigo_Real	equ	$-gdt

gdt4:   

    dw 0xFFFF
	dw 0			; (A base ser� definida a seguir)
	db 0
	db 0x9A			; presente, anel 0, c�digo, non-conforming, escrita
	db 0			; granularidade, 16-bit
	db 0

; O descritor de segmento de dados apropriada para o Modo Real
; (16-bit, granularidade, limite=0xFFFF)

Seletor_Dados_Real	equ	$-gdt

gdt5:   dw 0xFFFF
	dw 0			; (A base ser� definida a seguir)
	db 0
	db 0x92			; presente, anel 0, dados, expand-up, escrita
	db 0			; granularidade, 16-bit
	db 0

fim_gdt:

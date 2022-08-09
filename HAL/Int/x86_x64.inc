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
;;        HAL - Camada de Abstra��o de Hardware do PX-DOS  
;;
;; Este m�dulo inclui todos os servi�os essenciais e drivers de dispositivos
;; removiveis em um unico driver carregavel, durante o processo de inicializa��o.
;;
;;
;;
;; Este driver ajudar� o sistema a se "comportar" e interagir de forma correta nos diversos
;; dispositivos remov�veis e arquiteturas x86 gen�ricas suportadas.
;;
;;
;;
;; Copyright � 2013-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;;/*********************************************************************/
;;/*                                                                   */
;;/*                                                                   */
;;/*                                                                   */
;;/*                                                                   */
;;/*   #$$%%@!#$%                                                      */
;;/*   !!@#!$!$!$         Sistema Operacional PX-DOS                   */
;;/*   !@@#   #$%                                                      */
;;/*   #$$%   &*$                                                      */
;;/*   $#%@   @#&                                                      */
;;/*   #%$&*(@*@&                                                      */
;;/*   @#$@$#@$%$       2013-2022 (c) Felipe Miguel Nery Lunkes        */
;;/*   $%&*                Todos os direitos reservados                */
;;/*   @#&*                                                            */
;;/*   @&*%       Esse software se baseia em códigos disponíveis       */
;;/*   #&*@                     em domínio público                     */
;;/*                                                                   */
;;/*                                                                   */
;;/*********************************************************************/
;;/*
;;
;; Copyright (c) 2013-2022, Felipe Miguel Nery Lunkes
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;; * Redistributions of source code must retain the above copyright notice, this
;;   list of conditions and the following disclaimer.
;;
;; * Redistributions in binary form must reproduce the above copyright notice,
;;   this list of conditions and the following disclaimer in the documentation
;;   and/or other materials provided with the distribution.
;;
;; * Neither the name of the copyright holder nor the names of its
;;   contributors may be used to endorse or promote products derived from
;;   this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;; */
;;
;;********************************************************************************************

.hal


INICIO_VM: ;; Inicia a m�quina virtual x86	

    smsw ax
	
	test al, 1		; Ver PE bit de MSW (CR0)
	je INICIO_VM_CONTINUAR
	
	mov ax, 05h		; Sair para o PX-DOS
	mov bx, 01h     ; Com c�digo de erro 1
	int 90h

; Definir base e descritores de c�digo para CS<<4/DS<<4 (CS=DS)

INICIO_VM_CONTINUAR:
	
    xor ebx, ebx
	
	mov bx, cs		; BX= segmento
	shl ebx, 4		; EBX= endere�o linear para o segmento base
	mov eax, ebx
	
	mov [gdt1 + 2], ax
	mov [gdt2 + 2], ax
	mov [gdt3 + 2], ax
	shr eax,16
	mov [gdt1 + 4], al
	mov [gdt2 + 4], al
	mov [gdt3 + 4], al
	mov [gdt1 + 7], ah
	mov [gdt2 + 7], ah
	mov [gdt3 + 7], ah
	
; Apontar gdtr para a gdt, e idtr para idt

	add ebx,gdt		; EBX= Endere�o linear da gdt
	mov [gdtr + 2], ebx
	
	add ebx,idt - gdt	; EBX= Endere�o linear da idt
	mov [idtr + 2], ebx
	
; Desativar interrup��es

	cli
	
; Carregar gdt e idt para entrar em modo protegido

	lgdt [gdtr]
	lidt [idtr]
	
; Salvar CS de modo real em BP

	mov bp,cs
	
; Ir para modo protegido ao alterar bit PE de cr0

	mov eax, cr0
	or al,1
	mov cr0, eax
	
	jmp SELETOR_CODIGO_SIS:Ir_Para_Protegido
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Modo Protegido 32-Bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[BITS 32]

Ir_Para_Protegido:	

    mov ax, SELETOR_DADOS_SIS
	mov ds, ax		; Agora n�o temos segmentos: apenas SELETORES
	mov ss, ax
	nop
	mov es, ax
	mov fs, ax
	mov gs, ax
	
; Diga Ol�!

	lea esi, [ola_msg]
	call escrever_string
	
; Tentar uma interrup��o

	int 20h
	
; Voltar para modo 16 Bits

	jmp SELETOR_CODIGO_REAL:Ir_Para_Real
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Rotina de sa�da de caracteres
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

escreverChar:	


    push gs
	push ecx
	push ebx
	push eax
	
		mov ax, SELETOR_LINEAR
		mov gs, ax
		
; (Y * 80 + X) * 2 --> EAX

		movzx eax, byte [CsrY]
		mov cl, 80
		mul cl
		add al, [CsrX]
		adc ah, 0
		shl eax, 1
		
; EAX + 0xB8000 --> EBX; Guardar Char

		lea ebx, [eax + 0xB8000]
		pop eax
		push eax
		mov [gs:ebx], al
		
; Avan�as Cursor

		mov cx, [CsrX]
		inc cl
		cmp cl, 80	; Cursor na direita?
		
		jb escreverChar2
		
		xor cl, cl	; Sim, indo para a esquerda
		inc ch		; E descendo uma linha
		cmp ch, 25	; Cursor foa da tela?
		
		jb escreverChar2
		
		xor ch,ch	; Pular de volta
		
escreverChar2:		

    mov [CsrX], cx
	pop eax
	pop ebx
	pop ecx
	pop gs
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Rotina de sa�da de Strings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

escrever_string:	
    push esi
	push eax
	cld
	jmp escrever_string2
	
escrever_string1:	

	call escreverChar

escrever_string2:		

    lodsb
	or al, al
	jne escrever_string1
	pop eax
	pop esi
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Manipulador para interrup��es
;;	Exibe: "Interrup��o desconhecida"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int_desconhecida:	

    cli
	lea esi, [int_desconhecida_msg]
	call escrever_string
	jmp $
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Manipulador para INT 0x20
;	Exibe a mensagem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

interrupcao_20h:	
        
		push esi
		lea esi, [interrupcao_20h_msg]
		call escrever_string
	pop esi
	iret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Modo Protegido 16 Bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[BITS 16]
; Voltar para a pilha de 16 Bits

Ir_Para_Real:	

    mov ax, SELETOR_DADOS_REAL
	mov ds, ax
	mov ss, ax
	nop
	
; Puxar CS:IP de modo real

	lea bx, [Ir_Para_Real16]
	push bp
	push bx
	
; Voltar ao Modo Real

		mov eax, cr0
		and al, 0xFE
		mov cr0, eax
		retf		; Pula para Ir_Para_Real16
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Modo Real 16 Bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Restaurar valores dos registradores de segmento

Ir_Para_Real16:	
    
	mov ax, cs
	mov ds, ax
	mov ss, ax
	nop
	mov es, ax
	mov fs, ax
	mov gs, ax
	
; Apontar para a idt de Modo Real

	lidt [ridtr]
	
; Habilitar interrup��es

	sti

	ret
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Dados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


CsrX:	db 0
CsrY:	db 0

ola_msg:	db "", 0

int_desconhecida_msg:
	db " Interrupcao desconhecida!", 0

interrupcao_20h_msg:
	db "", 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	16-bit/32-bit - endere�o limite linear
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gdtr:	dw gdt_fim - gdt - 1	; limite GDT
	dd gdt			; linear, endere�o f�sico de GDT

idtr:	dw idt_fim - idt - 1	; limite IDT
	dd idt			; linear, endere�o f�sico de IDT

; Uma IDTR 'apropriada' para modo real

ridtr:	dw 0xFFFF		; limite=0xFFFF
	dd 0			; base=0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Tabela de Descritores Global (GDT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; descritor nulo

gdt:	dw 0			; limite 15:0
	dw 0			; base 15:0
	db 0			; base 23:16
	db 0			; tipo
	db 0			; limite 19:16, flags
	db 0			; base 31:24
	
; descritor de dados linear

SELETOR_LINEAR	equ	$-gdt
	dw 0xFFFF		; limite 0xFFFFF
	dw 0			; base 0
	db 0
	db 0x92			; presente, ring 0, data, expand-up, writable
	db 0xCF			; page-granular, 32-bit
	db 0
; descritor de c�digo

SELETOR_CODIGO_SIS	equ	$-gdt
gdt1:	dw 0xFFFF
	dw 0			
	db 0
	db 0x9A			; presente, ring 0, code, non-conforming, readable
	db 0xCF
	db 0
; descritor de dados

SELETOR_DADOS_SIS	equ	$-gdt
gdt2:	dw 0xFFFF
	dw 0			
	db 0
	db 0x92			; presente, ring 0, data, expand-up, writable
	db 0xCF
	db 0
	
; descritor de segmento de c�digo 'apropriado' para modo real

; (16-bit, limite=0xFFFF)

SELETOR_CODIGO_REAL	equ	$-gdt
gdt3:	dw 0xFFFF
	dw 0			
	db 0
	db 0x9A			; presente, ring 0, code, non-conforming, readable
	db 0			; byte-granular, 16-bit
	db 0
	
; descritor de segmento de dados 'apropriado' para modo real

; (16-bit, limite=0xFFFF)

SELETOR_DADOS_REAL	equ	$-gdt
gdt4:	dw 0xFFFF
	dw 0			
	db 0
	db 0x92			; presente, ring 0, data, expand-up, writable
	db 0			; byte-granular, 16-bit
	db 0
gdt_fim:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Tabela de Descritores de Interrup��o (IDT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 32 interrup��es reservadas:

idt:	dw int_desconhecida		; ponto de entrada 15:0
	dw SELETOR_CODIGO_SIS		; seletor
	db 0			
	db 0x8E			; tipp (32-bit Ring 0 interrupt gate)
	dw 0			; ponto de entrada 31:16 (XXX - int_desconhecida >> 16)

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0

	dw int_desconhecida
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0
	
; Interrup��o do Usu�rio

	dw interrupcao_20h
	dw SELETOR_CODIGO_SIS
	db 0
	db 0x8E
	dw 0
	
idt_fim:
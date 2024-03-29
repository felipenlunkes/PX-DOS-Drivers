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
;;
;;                        M�dulo de Gerenciamento de Processador
;;
;;  Este arquivo cont�m fun��es necess�rias para verificar recursos do processador,
;;     ativ�-los e torn�-los dispon�veis aos programas e ao Sistema Operacional
;;
;;
;;**************************************************************************************
 
 [BITS 16]

.hal
 
cpu 586
 
;; Este m�dulo possui todas as instru��es de verifica��o de processador
;; do Driver Auxiliar de arquitetura para o PX-DOS.


;;**************************************************************************************

Ativar_A20: ;; Ativa a linha A20


        cli
 
        call    aguardarA20
        mov     al,0xAD
        out     0x64,al
 
        call    aguardarA20
        mov     al,0xD0
        out     0x64,al
 
        call    aguardarA20_2
        in      al,0x60
        push    eax
 
        call    aguardarA20
        mov     al,0xD1
        out     0x64,al
 
        call    aguardarA20
        pop     eax
        or      al,2
        out     0x60,al
 
        call    aguardarA20
        mov     al,0xAE
        out     0x64,al
 
        call    aguardarA20
        sti
		
		; print 10,13,"## A20 habilitado.",0
		
		jc near .nao
		
        ret
 
 .nao:

print "!! A20 nao habilitado.",0

ret
		
		
aguardarA20:

        in      al,0x64
        test    al,2
        jnz     aguardarA20
        ret
 
 
aguardarA20_2:

        in      al,0x64
        test    al,1
        jz      aguardarA20_2
        ret


;;**************************************************************************************
		
VERIFICAR_X86:

print 10,13,0

; print 10,13,"-> Verificando suporte do processador para o sistema...",0

mov ax, 6
call delay

pushfd   
              
pop eax                
mov ebx, eax    
        
xor eax, 00200000h      ; Ativa o bit 21

push eax   
           
popfd                   ; Devolver valores da pilha aos registradores

pushfd 
                
pop eax   
             
cmp eax, ebx
jnz @CPUID_SUPORTADO    ; Suporta esta fun��o
	
print 10,13,"!! Desculpe, mas seu processador nao pode ser identificado.",0
print 10,13,"!! Este processador nao e suportado completamente pelo sistema.",10,13,0

ret
 
;;************************************************************************************** 
 
@CPUID_SUPORTADO:

call Ativar_A20

; print " -> Este processador suporta a instrucao CPUID corretamente.",0

         mov eax,0
         CPUID     
		 
         mov [edi+0],eax 
		 
         add edi,4
		 
         mov [edi+0],ebx
		 
         mov [edi+4],edx
		 
         mov [edi+8],ecx
		 
         mov [edi+12],byte 0       

         add edi,16

 ;; Checagem de MMX

         mov EAX,1
		 
         CPUID
		 
         mov ebx,edx
		 
         and ebx,0x800000
		 
         shr ebx,23
		 
         mov [edi+0],bl            ;; MMX Suportado?
		 
		 
         ; print 10,13,"-> Este processador suporta instrucoes MMX.",0
		 
         add edi,1

 ;; Checar 3DNow!

         mov [edi+0],byte 0
		 
         mov eax, 0x80000001       ;; Nivel Extendido 1
		 
         CPUID
		 
         test edx, 0x80000000
		 
         jz @sem_3DNOW
		 
         mov [edi+0],byte 1        ;; 3DNOW! Suportado
		 

		 print 10,13,"-> O Processador atual possui tecnologia 3DNow!, da AMD.",10,13,0
		 
		 call BANDEIRA
		 
		 ret
		 
         @sem_3DNOW:
		 
		; print 10,13,"-> O Processador atual nao possui tecnologia 3DNow!, da AMD.",10,13,0
		  
         add edi,1

         mov eax, 0x80000000
		 
         CPUID
		 
         mov [edi+0],eax
		
        call BANDEIRA
		
		ret

;;**************************************************************************************		
BANDEIRA:

    mov eax,80000002h	
	cpuid
	
	mov di,produto		
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000003h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000004h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	mov si,produto		
	mov cx,48
	
loop_CPU:	

    lodsb
	cmp al,' '
	jae imprimir_CPU
	mov al,'_'
	
imprimir_CPU:	

    mov [si-1],al
	loop loop_CPU

	mov dx,prodmsg		
	mov ah, 3h
	int 90h

		
mov eax, 0x0
cpuid

mov [ processador_global ], ebx
mov [ processador_global + 4 ], edx
mov [ processador_global + 8 ], ecx

; print 10,13,"## Marca do Processador principal atualmente instalado: ", 0

; mov si, processador_global
; call escrever




xor ax, ax

mov ax, 200h
mov bx, processador_global

mov [200h], bx


ret

;;***************Separando m�todos chamados por v�rias �reas***********

%ifdef COM1
	
BANDEIRA_Serial:
	
    mov eax,80000002h	
	cpuid
	
	mov di,produtoSerial		
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000003h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000004h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	mov si,produtoSerial		
	mov cx,48
	
loop_CPUSerial:	

    lodsb
	cmp al,' '
	jae imprimir_CPUSerial
	mov al,'_'
	
imprimir_CPUSerial:	

    mov [si-1],al
	loop loop_CPUSerial


	ret

%endif
	
;;**************************************************************************************


.dados

processador_global times 13 db 0

prodmsg	db "# Nome do Processador: ["

produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,"$"

%ifdef COM1

produtoSerial	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,0

%endif 
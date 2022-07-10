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

NUM_VER EQU 0
NUM_SUBVER EQU 9

%ifdef COMPLETA

%define COM1
%define IMPRESSORA
%define BIBLIOTECAS
%define FELIPE
%define OFICIAL
%define ORIGINAL
%define FINAL
%define V86
%define PROCINFO

%endif

;;***************************

%ifdef MINIMA

%ifdef COM1
%undef COM1
%endif

%ifdef IMPRESSORA
%undef IMPRESSORA
%endif

%ifdef BIBLIOTECAS
%undef BIBLIOTECAS
%endif

%ifdef V86
%undef V86
%endif

%define PROCINFO

%endif

;;***************************

%ifdef BASICA


%ifdef COM1
%undef COM1
%endif

%ifdef IMPRESSORA
%undef IMPRESSORA
%endif

%ifdef BIBLIOTECAS
%undef BIBLIOTECAS
%endif

%ifdef PROCINFO
%undef PROCINFO
%endif


%endif

;;***************************

%ifdef PENTIUM

cpu 586

%endif

;;***************************

%ifdef I186

%undef PROCESSADOR_VER
%undef SERIALIZAR

cpu 186

%endif

;;***************************

%ifdef DEBUG

%warning "Iniciando a compilacao da HAL para o PX-DOS versao 0.9.0"

%endif

;;*********************************************************************************


[BITS 16] ;; O código gerado deverá ser 16 Bits, apenas

;; A seguir um mapa de memória será gerado para exibir os offsets 
;; dos símbolos internos

[map symbols sections brief segments Driver\simbolos.txt] ;; Criar mapa de símbolos em um
                                                          ;; arquivo de texto comum.

cpu 8086  ;; No início, usar modo de código legado Intel 8086

org 0     ;; O driver para PX-DOS deverá sempre começar no offset 0

%include "HAL\cabecalho.asm" ;; Aqui está o cabeçalho do Driver e Controle de Registradores

cpu 186


%define .hal [section .text align=16 vstart=0h] ;; Seção de Texto
%define __BSS__ [section .bss align=16] ;; Seção de Dados não inicializados leitura-escrita
%define .dados [section .data align=16] ;; Seção de Dados inicializados e leitura-escrita
%define .rdados [section .rdata align=8 vstart=200h]  ;; Seção de dados somente leitura 
                                                      ;; não inicializados
%define .krnl [section .data] ;; Instância da Seção de Dados a ser usada para armazenar
                              ;; dados e estruturas que serão utilizadas para a comunicação
							  ;; entre a HAL e o Kernel do PX-DOS
%define .comen [section .comment align=16 vstart=600h] ;; Seção .comment
%define .inf [section .info align=8 vstart=900h] ;; Seção de Informações do Arquivo




jmp __DRIVER_INIT__


;;**************************************************************************************

%include "HAL\uniao.asm"

%include "C:\Dev\ASM\tempo.s"
%include "Simbolos\estruturas.asm"
%include "Simbolos\simbolos.asm"

cpu 286

;;**************************************************************************************

.hal ;; Define segmento de texto aqui

__DRIVER_INIT__:

jmp __INICIAR

;;**************************************************************************************

FIM:

call __DRIVER_FIM__

;;**************************************************************************************

INTE: ;; Instala uma interrupção que pode ser chamada pelo sistema sempre que necessário.
      ;; Esta interrupção também pode ser chamada pelos programas para reiniciar a HAL,
	  ;; para que atualize os dispositivos instalados e forneça informações atualizadas.
	  ;; No caso, basta chamar a interrupção 69h, em assembly. Também pode ser chamada
	  ;; por programas em C, ou em qualquer outra linguagem.

or ax, ax
mov es, ax

cli
mov	[es:0x69*4], word int_prog
mov [es:0x69*4+2], cs
sti

nop

ret

int_prog:

pusha 

jmp __DRIVER_INIT__

popa

iret


.dados ;; Segmento de Dados




;;**************************************************************************************

.hal

dadosPrincipal equ ($$-__DRIVER_INIT__)

;;**************************************************************************************

;; Cabeçalho Final do Driver - Este cabeçalho traz informações importantes
;; sobre o tipo do Driver, que também é analisado pelo Kernel no início da
;; execução do Driver.

;;**************************************************************************************

.rdados ;; Dados somente leitura na estrutura da HAL

SIS_REQ: db "0.9.0",0

.comen

BUILD: db "PXDOS.Xandar@"

.inf ;; Seção de informações do arquivo à ser gerado

SEP: times 1 db ' Informacoes relativas a este driver (HAL.SIS): '

%ifdef COMPLETA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", completa e liberada como oficial.",0

%endif

%endif

%ifdef MINIMA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", minima e liberada como oficial.",0

%endif

%endif


%ifdef BASICA

%ifdef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", basica e liberada como oficial.",0

%endif

%endif

;;*************************************************************

%ifdef COMPLETA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", completa e liberada como Release Candidate (Testes).",0

%endif

%endif

%ifdef MINIMA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", minima e liberada como Release Candidate (Testes).",0

%endif

%endif


%ifdef BASICA

%ifndef OFICIAL

assinaturafinal db "HAL compilada em ", __DATE__, " as ", __TIME__, ", basica e liberada como Release Candidate (Testes).",0

%endif

%endif

APM db "PX-DOS(R) Driver APM versao 1.0",0


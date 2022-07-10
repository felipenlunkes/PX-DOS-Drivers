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
;; A distribui��o, reprodu��o total ou parcial de qualquer trecho do c�digo
;; � proibida e pass�vel de puni��o legal. O seu uso em formato bin�rio � permitido
;; apenas se cumpridas todas as obriga��es legais e se respeitando os direitos
;; autorais referentes a seu autor, Felipe Miguel Nery Lunkes.
;;
;;********************************************************************************************


VERIFICAR_VERSAO_PXDOS:

mov ah, 13h
int 90h

cmp ax, NUM_VER
je near VERCORRETA

jc VerNula

jmp VERSAO_INCORRETA


;;********************************************************************************************

VERCORRETA:

jmp SUBVER

;;********************************************************************************************

SUBVER:

mov ah, 13h
int 90h

cmp bx, NUM_SUBVER
je near SUBVERCORRETA

jc SubNula

jmp VERSAO_INCORRETA

;;********************************************************************************************

SUBVERCORRETA:

ret

;;********************************************************************************************

VERSAO_INCORRETA:

print 10,13,10,13,"Versao incorreta do PX-DOS(R)",10,13,10,13,0
print "A versao do Sistema nao e suportada ou nao pode ser obtida.",10,13,0
print "A HAL nao e compativel com o sistema atualmente em execucao.",10,13,10,13,0
print "Procure a versao adequada da HAL para a versao correta de seu sistema.",10,13,0
print "O sistema podera apresentar problemas de estabilidade, execucao e nao ira",10,13,0
print "reconhecer dispositivos fora do padrao IBM PC. Procure a versao correta.",10,13,10,13,0

call __DRIVER_FIM__

;;********************************************************************************************

SubNula:

print 10,13,"Impossivel obter a subversao do PX-DOS(R)!",10,13,0

jmp VERSAO_INCORRETA

;;********************************************************************************************

VerNula:

print 10,13,"Impossivel obter a versao do PX-DOS(R)!",10,13,0

jmp VERSAO_INCORRETA

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
;;
;;                       Rotinas de comunica��o com fun��es APM
;;
;;  Este arquivo cont�m rotinas de comunica��o e protocolos APM respons�veis pelo
;; controle energ�tico do computador
;;                                 
;;
;;
;;**************************************************************************************

HAL_Iniciar_APM:

checar_instalacao: ;; Ser� realizada uma chamada para a checagem de instala��o

mov ah, 53h            ;; Uma fun��o APM
mov al, 00h            ;; Comando de checagem de instala��o
xor bx, bx             ;; ID do dispositivo (APM BIOS)
int 15h                ;; Chama a fun��o APM
jc APM_ERRO_INSTALACAO ;; Caso ocorra erro, chama manipulador espec�fico

desconectar_interfaces: ;; Desconecta interfaces anteriores

mov ah, 53h               ;; Uma fun��o APM
mov al, 04h               ;; Comando de desconex�o de interface
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a fun��o APM
jc APM_ERRO_DESCONEXAO    ;; Caso ocorra erro, chama manipulador espec�fico
 
conectar_interface: ;; Conecta a uma interface APM para o gerenciamento

mov ah, 53h               ;; Uma fun��o APM
mov al, 01h               ;; N�mero da interface (Modo Real)
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a fun��o APM
jc APM_ERRO_CONEXAO       ;; Caso ocorra erro, chama manipulador espec�fico
 
ativar_gerenciamento: ;; Ser� habilitado o gerenciamento energ�tico para todos 
                       ;; os dispositivos

mov ah, 53h                ;; Uma fun��o APM
mov al, 08h                ;; Estado de gerenciamento
mov bx, 0001h              ;; Dispositivo
mov cx, 0001h              ;; Gerenciamento habilitado
int 15h                    ;; Chama a fun��o APM
jc APM_ERRO_GERENCIAMENTO  ;; Caso ocorra erro, chama manipulador espec�fico

HAL_APM_FIM:

ret

;;**************************************************************************************
;;
;;                           Erros durante as opera��es APM                                 
;;
;;**************************************************************************************

APM_ERRO_INSTALACAO:

;; Futuramente, o sistema ser� informado

jmp HAL_APM_FIM

APM_ERRO_CONEXAO:

;; Futuramente, o sistema ser� informado

jmp ativar_gerenciamento

APM_ERRO_GERENCIAMENTO:

;; Futuramente, o sistema ser� informado

ret


APM_ERRO_DESCONEXAO:

cmp ah, 03h               
jmp ativar_gerenciamento    ;; Erro APM, quando o c�digo de erro � 3, indicando que
                            ;; nenhuma interface foi conectada
 

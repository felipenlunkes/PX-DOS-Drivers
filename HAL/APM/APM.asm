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
;;                       Rotinas de comunicação com funções APM
;;
;;  Este arquivo contém rotinas de comunicação e protocolos APM responsáveis pelo
;; controle energético do computador
;;                                 
;;
;;
;;**************************************************************************************

HAL_Iniciar_APM:

checar_instalacao: ;; Será realizada uma chamada para a checagem de instalação

mov ah, 53h            ;; Uma função APM
mov al, 00h            ;; Comando de checagem de instalação
xor bx, bx             ;; ID do dispositivo (APM BIOS)
int 15h                ;; Chama a função APM
jc APM_ERRO_INSTALACAO ;; Caso ocorra erro, chama manipulador específico

desconectar_interfaces: ;; Desconecta interfaces anteriores

mov ah, 53h               ;; Uma função APM
mov al, 04h               ;; Comando de desconexão de interface
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a função APM
jc APM_ERRO_DESCONEXAO    ;; Caso ocorra erro, chama manipulador específico
 
conectar_interface: ;; Conecta a uma interface APM para o gerenciamento

mov ah, 53h               ;; Uma função APM
mov al, 01h               ;; Número da interface (Modo Real)
xor bx, bx                ;; ID do dispositivo (APM BIOS)
int 15h                   ;; Chama a função APM
jc APM_ERRO_CONEXAO       ;; Caso ocorra erro, chama manipulador específico
 
ativar_gerenciamento: ;; Será habilitado o gerenciamento energético para todos 
                       ;; os dispositivos

mov ah, 53h                ;; Uma função APM
mov al, 08h                ;; Estado de gerenciamento
mov bx, 0001h              ;; Dispositivo
mov cx, 0001h              ;; Gerenciamento habilitado
int 15h                    ;; Chama a função APM
jc APM_ERRO_GERENCIAMENTO  ;; Caso ocorra erro, chama manipulador específico

HAL_APM_FIM:

ret

;;**************************************************************************************
;;
;;                           Erros durante as operações APM                                 
;;
;;**************************************************************************************

APM_ERRO_INSTALACAO:

;; Futuramente, o sistema será informado

jmp HAL_APM_FIM

APM_ERRO_CONEXAO:

;; Futuramente, o sistema será informado

jmp ativar_gerenciamento

APM_ERRO_GERENCIAMENTO:

;; Futuramente, o sistema será informado

ret


APM_ERRO_DESCONEXAO:

cmp ah, 03h               
jmp ativar_gerenciamento    ;; Erro APM, quando o código de erro é 3, indicando que
                            ;; nenhuma interface foi conectada
 

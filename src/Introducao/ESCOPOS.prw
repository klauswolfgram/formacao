#include 'totvs.ch'

/*/
FUNCTION: ESCOPO DAS FUNCOES DESENVOLVIDAS PELA EQUIPE DE DESENVOLVIMENTO TOTVS
MAIN FUNCTION: ESCOPO PARA FUNCOES PRINCIPAIS QUE PODEM SER ACIONADAS A PARTIR DA JANELA DE PARAMETROS INICIAIS
                DO SMARTCLIENT (USADA NA CONSTRUCAO DE FUNCOES ASSOCIADAS A MODULOS, EX: SIGAFAT)
USER FUNCTION: ESCOPO DE FUNCOES DESENVOLVIDAS POR DESENVOLVEDORES DE FORA DA EQUIPE OFICIAL DA TOTVS.
                COMO ALTERNATIVA É POSSIVEL DECLARAR COMO ESCOPO FUNCTION COM "U_" ANTES DO NOME 
                EX.: USER FUNCTION TESTE == FUNCTION U_TESTE
STATIC FUNCTION: ESCOPO DESTINADO A FUNCOES DE USO AUXILIAR PARA DEMAIS FUNCOES ESCRITAS NO MESMO
                ARQUIVO DE CODIGO FONTE.                               

/*/

/*/{Protheus.doc} ESCOPOS
    FUNCAO PRINCIPAL DO PROGRAMA
    @type  User Function
    @author Klaus Wolfgram
    @since 07/06/2023
    @version 1.0
    @history 07/06/2023, Klaus Wolfgram, Construcao inicial do programa
    /*/
Function U_ESCOPOS
    mostralog()
Return 

/*/{Protheus.doc} mostralog
   Funcao auxiliar para gravacao de logs
    @type  Static Function
    /*/
Static Function mostralog()
    Conout('Log teste')
Return 

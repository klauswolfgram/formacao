#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_APMVC003
    Programa de manutencao de contratos.
    @type  Function
    @author Klaus Wolfgram
    @since 10/06/2023
    @version 1.0
    @history 10/06/2023, Klaus Wolfgram, Construcao inicial do programa
    /*/
Function U_APMVC003

    Private aRotina := menudef()
    Private oBrowse := fwMBrowse():new()

    oBrowse:setAlias("Z53")
    oBrowse:setDescription("Medicoes de contratos")
    oBrowse:setExecuteDef(4)
    oBrowse:setUseFilter(.T.)
    oBrowse:addLegend("LEFT(Z53_NUMERO,1) == 'C' ","YELLOW","Compras"         ,'1',.T.)
    oBrowse:addLegend("LEFT(Z53_NUMERO,1) == 'F' ","ORANGE","Faturamento"     ,'1',.T.)
    oBrowse:addLegend("LEFT(Z53_NUMERO,1) == 'S' ","GRAY"  ,"Sem Integracao"  ,'1',.T.)
    oBrowse:addLegend("Z53_STATUS == 'P'"         ,"GREEN" ,"Pendente"        ,'2',.T.)
    oBrowse:addLegend("Z53_STATUS == 'E'"         ,"RED"   ,"Encerrada"       ,'2',.T.)   
    oBrowse:activate()
    
Return 

Static Function menudef

    Local aRotina[0]

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'          OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.APMVC003'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.APMVC003'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.APMVC003'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.APMVC003'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.APMVC003'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.APMVC003'  OPERATION 9 ACCESS 0    

return aRotina

Static Function viewdef

    Local oView
    Local oModel
    Local oStrcZ53M
    Local oStrcZ53D

    oStrcZ53M       := fwFormStruct(2,'Z53',{|cCampo|       cCampo $ 'Z53_NUMMED,Z53_NUMERO,Z53_EMISSAO'})
    oStrcZ53D       := fwFormStruct(2,'Z53',{|cCampo| .not. cCampo $ 'Z53_NUMMED,Z53_NUMERO,Z53_EMISSAO'})

    oModel          := fwLoadModel('APMVC003')
    oView           := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z53MASTER',oStrcZ53M,'Z53MASTER')
    oView:addGrid( 'Z53DETAIL',oStrcZ53D,'Z53DETAIL')
    oView:addIncrementView('Z53DETAIL','Z53_ITEM')
    oView:createHorizontalBox('BOXZ53M',20)
    oView:createHorizontalBox('BOXZ53D',80)
    oView:setOwnerView('Z53MASTER','BOXZ53M')  
    oView:setOwnerView('Z53DETAIL','BOXZ53D')  

return oView


Static Function modeldef

    Local oStrcZ53M
    Local oStrcZ53D
    Local bModelPre := {|oModel| modelPre(oModel)}
    Local bModelPos := {|oModel| modelPos(oModel)}
    Local bModelCom := {|oModel| modelCom(oModel)}
    Local bModelCan := {|oModel| modelCan(oModel)}
    Local bFieldPre := {|oFieldModel, cAction, cIDField, xValue| fModelPre(oFieldModel, cAction, cIDField, xValue) }
    Local bFieldPos := {|oFieldModel| fModelPos(oFieldModel) }
    Local bFieldLoad:= {|oFieldModel, lCopy| fModelLoad(oFieldModel, lCopy)}
    Local bLinePre  := {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| gLinePre(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}
    Local bLinePos  := {|oGridModel, nLine|  gLinePos(oGridModel,nLine)}
    Local bGridPre  := {|oGridModel, nLine, cAction | gGridPre(oGridModel, nLine, cAction)}
    Local bGridPos  := {|oGridModel| gGridPos(oGridModel)}
    Local bGridLoad := {|oGridModel, lCopy| gGridLoad(oGridModel,lCopy)}
    Local oModel

    oStrcZ53M       := fwFormStruct(1,'Z53',{|cCampo|       cCampo $ 'Z53_NUMMED,Z53_NUMERO,Z53_EMISSAO'})
    oStrcZ53D       := fwFormStruct(1,'Z53',{|cCampo| .not. cCampo $ 'Z53_NUMMED,Z53_NUMERO,Z53_EMISSAO'})

    //-- Novo gatilho para gerar codigo do tipo de contrato
	aStrTrigger 	:= fwStruTrigger(   'Z53_NUMERO'    ,; //-- Campo que dispara o gatilho
                                        'Z53_NUMMED'    ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'U_APMVC03A()'  ,; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '001')             //-- Sequencia de execução do gatilho

    oStrcZ53M:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])     

    //-- Novo gatilho para gerar codigo do tipo de contrato
	aStrTrigger 	:= fwStruTrigger(   'Z53_QTD'       ,; //-- Campo que dispara o gatilho
                                        'Z53_VALOR'     ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'U_APMVC03B()'  ,; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '001')             //-- Sequencia de execução do gatilho

    oStrcZ53D:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])         

    oModel          := mpFormModel():new('MODEL_APMVC003',bModelPre,bModelPos,bModelCom,bModelCan)
    
    oModel:addFields('Z53MASTER',,oStrcZ53M,bFieldPre,bFieldPos,bFieldload)
    oModel:setDescription('Medicoes de Contratos')
    oModel:setPrimaryKey({'Z53_FILIAL','Z53_NUMERO', 'Z53_NUMMED', 'Z53_ITEM'})

    oModel:addGrid('Z53DETAIL','Z53MASTER',oStrcZ53D,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
    oModel:setRelation('Z53DETAIL',{{'Z53_FILIAL','xFilial("Z53")'},{'Z53_NUMERO','Z53_NUMERO'},{'Z53_NUMMED','Z53_NUMMED'}},Z53->(indexKey(1)))
    oModel:getModel('Z53DETAIL'):setUniqueLine({'Z53_ITEM'})
    oModel:setOptional('Z53DETAIL',.T.)

return oModel

//-- Pre validacao do modelo
Static Function modelPre(oModel)

    Local lValid := .T.

return lValid

//-- Validado de dados, equivalente ao "TUDOOK"
Static Function modelPos(oModel)

    Local lValid := .T.

return lValid

//-- Funcao acionada para execucao do commit dos dados
Static Function modelCom(oModel)

    Local lCommit := fwFormCommit(oModel)

return lCommit

//-- Funcao acionada para cancelamento da edicao de dados
Static Function modelCan(oModel)

    Local lCancel := fwFormCancel(oModel)

return lCancel

//-- Pre validacao do modelo
Static Function fModelPre(oFieldModel, cAction, cIDField, xValue)

    Local lValid := .T.

    DO CASE 

        CASE cAction == 'ISENABLE'
        
        CASE cAction == 'CANSETVALUE'

        CASE cACtion == 'SETVALUE'

    END CASE 

return lValid

//-- Validacao do modelo, equivalente ao "TUDOOK"
Static Function fModelPos(oFieldModel)

    Local lValid := .T.

return lValid

//-- bloco de codigo acionado para o carregamento dos dados
Static Function fModelLoad(oFieldModel, lCopy)

    Local aLoad := formLoadField(oFieldModel, lCopy)

return aLoad

//-- Pre validacao de linha
Static Function gLinePre(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)

    Local lValid := .T.

    DO CASE 

        CASE cACtion == 'CANSETVALUE'

        CASE cAction == 'SETVALUE'

        CASE cAction == 'DELETE'

        CASE cAction == 'UNDELETE'        

    END CASE

return lValid

//-- Validacao de linha, equivalente ao "LINHAOK"
Static Function gLinePos(oGridModel,nLine)

    Local lValid := .T.

return lValid    

//-- Pre validacao do modelo de dados
Static Function gGridPre(oGridModel, nLine, cAction, cIdField)

    Local lValid := .T.

    DO CASE 

        CASE cAction == 'ISENABLE'

        CASE cAction == 'ADDLINE'

        CASE cAction == 'CANSETVALUE'

        CASE cAction == 'SETVALUE'

        CASE cAction == 'DELETE'

        CASE cAction == 'UNDELETE'

    END CASE    

return lValid

//-- Validacao do modelo, equivalente ao TudoOk
Static Function gGridPos(oGridModel)

    Local lValid := .T.

return lValid    

//-- Bloco de codigo acionado para o carregamento dos dados do modelo
Static Function gGridLoad(oGridModel,lCopy)

    Local aLoad := formLoadGrid(oGridModel,lCopy)

return aLoad    

Function U_APMVC03A

    Local cNumero   := ''
    Local cNumMed   := ''
    Local cAliasSQL := getNextAlias()
    Local oModel    := fwModelActive()

    IF .not. cValToChar(oModel:getOperation()) $ '3/9'
        return oModel:getModel('Z53MASTER'):getValue('Z53_NUMMED')
    EndIF    

    cNumero          := oModel:getModel('Z53MASTER'):getValue('Z53_NUMERO')

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z53_NUMMED),'00') Z53_NUMMED
        FROM %table:Z53% Z53
        WHERE Z53.%notdel%
        AND Z53_FILIAL = %exp:xFilial('Z53')%
        AND Z53_NUMERO = %exp:cNumero%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNumMed := alltrim(Z53_NUMMED)}),dbCloseArea())

    cNumMed := if(cNumMed == '00',strzero(1,tamSX3('Z53_NUMMED')[1]),soma1(cNumMed))

return cNumMed

Function U_APMVC03B

    Local cAliasSQL := getNextAlias()
    Local cNumero   := fwFldGet('Z53_NUMERO')
    Local cCodPrd   := fwFldGet('Z53_CODPRD')
    Local nQtd      := fwFldGet('Z53_QTD'   )
    Local nVlrUnit  := 0
    Local nValor    := 0    

    BeginSQL alias cAliasSQL
        SELECT * FROM %table:Z52% Z52
        WHERE Z52.%notdel%
        AND Z52_FILIAL = %exp:xFilial('Z52')%
        AND Z52_NUMERO = %exp:cNumero%
        AND Z52_CODPRD = %exp:cCodPrd%
    EndSQL

    While .not. (cAliasSQL)->(eof())
        nVlrUnit := (cAliasSQL)->Z52_VLRUNI
        (cAliasSQL)->(dbSkip())
    Enddo

    nValor := nQtd * nVlrUnit

    (cAliasSQL)->(dbCloseArea())

return nValor

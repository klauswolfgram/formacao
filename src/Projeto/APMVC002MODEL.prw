#include 'totvs.ch'
#include 'fwmvcdef.ch'

Static Function modeldef

    Local oStrcZ51
    Local oStrcZ52
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

    oStrcZ51        := fwFormStruct(1,'Z51')
    oStrcZ52        := fwFormStruct(1,'Z52')

    //-- Novo gatilho para gerar codigo do tipo de contrato
	aStrTrigger 	:= fwStruTrigger(   'Z51_TIPO'      ,; //-- Campo que dispara o gatilho
                                        'Z51_NUMERO'    ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'U_APMVC02A()'  ,; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '001')             //-- Sequencia de execução do gatilho

    oStrcZ51:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])                                     

    //-- Novo gatilho para preenchimento de dados do produto
	aStrTrigger 	:= fwStruTrigger(   'Z52_CODPRD'    ,; //-- Campo que dispara o gatilho
                                        'Z52_DESPRD'    ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'U_APMVC02B()'  ,; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '001')             //-- Sequencia de execução do gatilho    

    oStrcZ52:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])                                     

    //-- Novo gatilho para preenchimento de dados do produto
	aStrTrigger 	:= fwStruTrigger(   'Z52_CODPRD'    ,; //-- Campo que dispara o gatilho
                                        'Z52_LOCEST'    ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'SB1->B1_LOCPAD',; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '002')             //-- Sequencia de execução do gatilho                                                     

    oStrcZ52:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])  

    //-- Novo gatilho para preenchimento de dados do produto
	aStrTrigger 	:= fwStruTrigger(   'Z52_CODPRD'    ,; //-- Campo que dispara o gatilho
                                        'Z52_VLRUNI'    ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'SB1->B1_PRV1'  ,; //-- Retorna o codigo do tipo
                                        .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil             ,; //-- Chave de busca conforme parametro anterior
                                        Nil             ,; //-- Condição para execução do gatilho
                                        '003')             //-- Sequencia de execução do gatilho                                                     

    oStrcZ52:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])       

    //-- Novo gatilho para preenchimento de dados do produto
	aStrTrigger 	:= fwStruTrigger(   'Z52_VLRUNI'                                    ,; //-- Campo que dispara o gatilho
                                        'Z52_VALOR'                                     ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'fwFldGet("Z52_VLRUNI") * fwFldGet("Z52_QTD")'  ,; //-- Retorna o codigo do tipo
                                        .F.                                             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil                                             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil                                             ,; //-- Chave de busca conforme parametro anterior
                                        Nil                                             ,; //-- Condição para execução do gatilho
                                        '001')                                             //-- Sequencia de execução do gatilho                                                     

    oStrcZ52:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])      

    //-- Novo gatilho para preenchimento de dados do produto
	aStrTrigger 	:= fwStruTrigger(   'Z52_QTD'                                       ,; //-- Campo que dispara o gatilho
                                        'Z52_VALOR'                                     ,; //-- Campo que recebe o conteúdo
                    /*Ação executada*/  'fwFldGet("Z52_VLRUNI") * fwFldGet("Z52_QTD")'  ,; //-- Retorna o codigo do tipo
                                        .F.                                             ,; //-- Identifica se posiciona em uma tebala externa
                                        Nil                                             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                        Nil                                             ,; //-- Chave de busca conforme parametro anterior
                                        Nil                                             ,; //-- Condição para execução do gatilho
                                        '001')                                             //-- Sequencia de execução do gatilho                                                     

    oStrcZ52:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])                                                                                 

    oModel          := mpFormModel():new('MODEL_APMVC002',bModelPre,bModelPos,bModelCom,bModelCan)
    
    oModel:addFields('Z51MASTER',,oStrcZ51,bFieldPre,bFieldPos,bFieldload)
    oModel:setDescription('Contratos')
    oModel:setPrimaryKey({'Z51_FILIAL','Z51_NUMERO'})

    oModel:addGrid('Z52DETAIL','Z51MASTER',oStrcZ52,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
    oModel:setRelation('Z52DETAIL',{{'Z52_FILIAL','xFilial("Z52")'},{'Z52_NUMERO','Z51_NUMERO'}},Z52->(indexKey(1)))
    oModel:getModel('Z52DETAIL'):setUniqueLine({'Z52_ITEM'})
    oModel:setOptional('Z52DETAIL',.T.)

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

    Local oMaster   := oModel:getModel('Z51MASTER')
    Local oDetail   := oModel:getModel('Z52DETAIL')
    Local lCommit   := .T.
    Local nVlrTotal := 0
    Local nVlrItem  := 0
    Local nVlrMedi  := 0
    Local nItens    := oDetail:length()
    Local x

    For x := 1 To nItens
        
        oDetail:goLine(x)

        IF oDetail:isDeleted()
            Loop
        EndIF

        nVlrItem  := oDetail:getValue('Z52_VALOR' )
        nVlrMedi  := oDetail:getValue('Z52_VLRMED')
        
        nSaldo    := nVlrItem - nVlrMedi
        nVlrTotal += nVlrItem

        oDetail:loadValue('Z52_SALDO',nSaldo)

    Next

    oMaster:setValue('Z51_VALOR',nVlrTotal)

    lCommit       := fwFormCommit(oModel)

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

    Local oModel := fwModelActive()
    Local lValid := .T.

    DO CASE 

        CASE cAction == 'CANSETVALUE'

        CASE cAction == 'SETVALUE'

        CASE cAction == 'DELETE'

            oModel:setErrorMessage('Z52DETAIL' ,; //-- id do submodelo
                                   'Z52_CODPRD',; //-- id do campo
                                   'Z52DETAIL' ,; //-- id do submodelo
                                   'Z52_CODPRD',; //-- id do campo
                                   'Exclusão indevida',; //-- Identificador do erro
                                   'Não é possível excluir linhas do contrato.',; //-- Causador do erro
                                   'Não é possível excluir linhas do contrato!') //-- Solucao
            lValid := .F.       

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

Function U_APMVC02A

    Local cTipo     := ''
    Local cNovoCod  := ''
    Local cAliasSQL := getNextAlias()
    Local oModel    := fwModelActive()

    IF .not. cValToChar(oModel:getOperation()) $ '3/9'
        return oModel:getModel('Z51MASTER'):getValue('Z51_NUMERO')
    EndIF    

    cTipo           := oModel:getModel('Z51MASTER'):getValue('Z51_TIPO')

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z51_NUMERO),'00') Z51_NUMERO
        FROM %table:Z51% Z51
        WHERE Z51.%notdel%
        AND Z51_FILIAL = %exp:xFilial('Z51')%
        AND Z51_TIPO = %exp:cTipo%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z51_NUMERO)}),dbCloseArea())

    cNovoCod := if(cNovoCod == '00',cTipo + strzero(1,tamSX3('Z51_NUMERO')[1] - tamSX3('Z51_TIPO')[1]),soma1(cNovoCod))

return cNovoCod

Function U_APMVC02B

    SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+fwFldGet('Z52_CODPRD')))

return LEFT(SB1->B1_DESC,tamSX3('Z52_DESPRD')[1])

#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_STA0001
    Cadastro de tipos de contratos
    @type  Function
    @author Klaus Wolfgram
    @since 10/06/2023
    @version 1.0
    /*/
Function U_APMVC001

    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()

    oBrowse:setAlias('Z50')
    oBrowse:setDescription('Tipos de Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z50_TIPO == 'C' ","YELLOW","Compras"         )
    oBrowse:addLegend("Z50_TIPO == 'F' ","ORANGE","Faturamento"     )
    oBrowse:addLegend("Z50_TIPO == 'S' ","GRAY"  ,"Sem Integracao"  )
    oBrowse:activate()
    
Return 

/*/{Protheus.doc} menudef
    Retorna a estrutura de menus da aplicacao
    @type  Static Function
    /*/
Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'          OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.APMVC001'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.APMVC001'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.APMVC001'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.APMVC001'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.APMVC001'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.APMVC001'  OPERATION 9 ACCESS 0
    
Return aRotina

Static Function modeldef

    Local oModel
    Local oStruct

    oStruct := fwFormStruct(1,'Z50')
    oModel  := mpFormModel():new('MODEL_APMVC001',,{|oModel| fnValid(oModel)},{|oModel| fnCommit(oModel)})

    //-- Novo gatilho para gerar codigo do tipo de contrato
	aStrTrigger 		:= fwStruTrigger(   'Z50_TIPO'      ,; //-- Campo que dispara o gatilho
                                            'Z50_CODIGO'    ,; //-- Campo que recebe o conteúdo
                        /*Ação executada*/  'U_APMVC01A()'  ,; //-- Retorna o codigo do tipo
                                            .F.             ,; //-- Identifica se posiciona em uma tebala externa
                                            Nil             ,; //-- Prefixo da tabela a ser posicionada conforme parametro anterior
                                            Nil             ,; //-- Chave de busca conforme parametro anterior
                                            Nil             ,; //-- Condição para execução do gatilho
                                            Nil)               //-- Sequencia de execução do gatilho



	oStruct:addTrigger(aStrTrigger[1],aStrTrigger[2],aStrTrigger[3],aStrTrigger[4])      
    
    oModel:addFields('Z50MASTER',,oStruct)
    oModel:setDescription('Tipos de Contratos')
    oModel:setPrimaryKey({'Z50_FILIAL','Z50_CODIGO'})

return oModel

Static Function viewdef

    Local oView
    Local oModel
    Local oStruct

    oStruct     := fwFormStruct(2,'Z50')
    oModel      := fwLoadModel('APMVC001')
    oView       := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z50MASTER',oStruct,'Z50MASTER')
    oView:createHorizontalBox('BOXPRINCIPAL',100)
    oView:setOwnerView('Z50MASTER','BOXPRINCIPAL')

return oView

Static Function fnCommit(oModel)

    Local cTipo    := oModel:getModel('Z50MASTER'):getValue('Z50_TIPO'  )
    Local cCodTipo := oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO')

    IF oModel:getOperation() == 3 .or. oModel:getOperation() == 9
        IF Z50->(dbSetOrder(1),dbSeek(xFilial(alias())+cTipo+cCodTipo))
            cCodTipo := U_APMVC01A()
            oModel:getModel('Z50MASTER'):setValue('Z50_CODIGO',cCodTipo)
        EndIF
    EndIF

    lCommit     := fwFormCommit(oModel)

return lCommit

Static Function fnValid(oModel)

    Local lValid := .T.

    IF oModel:getOperation() == 5

        cCodigo     := Z50->Z50_CODIGO
        cAliasSQL   := mpSysOpenQuery("SELECT * FROM " + retSqlName("Z51") +;
                                      " WHERE D_E_L_E_T_ = ' ' AND Z51_FILIAL = '" + xFilial('Z51') + "' AND Z51_TIPO = '" + Z50->Z50_CODIGO + "' ")

        lUsado := .F.

        While .not. (cAliasSQL)->(eof())
            lUsado := .T.
            Exit
        Enddo

        (cAliasSQL)->(dbCloseArea())

        IF lUsado
            oModel:setErrorMessage('Z50MASTER' ,; //-- id do submodelo
                                   'Z50_CODIGO',; //-- id do campo
                                   'Z05MASTER' ,; //-- id do submodelo
                                   'Z50_CODIGO',; //-- id do campo
                                   'Tipo de Contrato em Uso.',; //-- Identificador do erro
                                   'O tipo de contrato selecionado ja está em uso.',; //-- Causador do erro
                                   'Para excluir o tipo de contrato, os contratos que o utilizam devem ser excluídos primeiro.') //-- Solucao
            return .F.
        EndIF

    EndIF

return lValid

Function U_APMVC01A

    Local cTipo     := ''
    Local cNovoCod  := ''
    Local cAliasSQL := getNextAlias()
    Local oModel    := fwModelActive()

    IF .not. cValToChar(oModel:getOperation()) $ '3/9'
        return oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO')
    EndIF    

    cTipo           := oModel:getModel('Z50MASTER'):getValue('Z50_TIPO')

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z50_CODIGO),'00') Z50_CODIGO
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO = %exp:cTipo%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}),dbCloseArea())

    cNovoCod := if(cNovoCod == '00',cTipo + '01',soma1(cNovoCod))

return cNovoCod

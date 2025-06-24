#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM001
    Exemplo de funcao MVC para construcao de cadastro no formato modelo 1
    @type  Function
    @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE (Cores de Legenda)
    @see https://tdn.totvs.com.br/display/framework/Classe_Acervo
    @see https://tdn.totvs.com.br/display/framework/FWMBrowse
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/FWFormModelStruct
    @see https://tdn.totvs.com/display/framework/FwStruTrigger
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
    @see https://tdn.totvs.com/display/framework/FWFormCommit
    @see https://tdn.totvs.com/display/framework/FWFormCancel
    @see https://tdn.totvs.com/display/framework/FWModelActive
    /*/
Function U_GCTM001
    
    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()
    
    oBrowse:setAlias('Z50')
    oBrowse:setDescription('Tipos de Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z50_TIPO == 'V' ","BR_AMARELO","Vendas"          )
    oBrowse:addLegend("Z50_TIPO == 'C' ","BR_LARANJA","Compras"         )
    oBrowse:addLegend("Z50_TIPO == 'S' ","BR_CINZA"  ,"Sem Integracao"  )
    oBrowse:activate()
   
Return 

Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.GCTM001'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.GCTM001'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.GCTM001'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.GCTM001'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.GCTM001'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.GCTM001'  OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} viewdef
    Construcao da interface grafica
    @type  Static Function
    /*/
Static Function viewdef

    Local oView
    Local oModel
    Local oStruct

    oStruct         := fwFormStruct(2,'Z50')
    oModel          := fwLoadModel('GCTM001')
    oView           := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z50MASTER',oStruct,'Z50MASTER')
    oView:createHorizontalBox('BOXZ50',100)
    oView:setOwnerView('Z50MASTER','BOXZ50')
    
Return oView

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel
    Local oStruct
    Local aTrigger
    Local bModelPre := {|x| fnModPre(x)}
    Local bModelPos := {|x| fnModPos(x)}
    Local bCommit   := {|x| fnCommit(x)}
    Local bCancel   := {|x| fnCancel(x)}
    Local bFieldPre := {|oSubModel,cIdAction,cIdField,xValue| fnFieldPre(oSubModel,cIdAction,cIdField,xValue)}
    Local bFieldPos := {|oSubModel|                           fnFieldPos(oSubModel)}
    Local bFieldLoad:= {|oSubModel,lCopy|                     fnFieldLoad(oSubModel,lCopy)}

    oStruct         := fwFormStruct(1,'Z50')
    oModel          := mpFormModel():new('MODEL_GCTM001',bModelPre,bModelPos,bCommit,bCancel)

    aTrigger        := fwStruTrigger('Z50_TIPO','Z50_CODIGO','U_GCTT001()',.F.,Nil,Nil,Nil,Nil)
    oStruct:addTrigger(aTrigger[1],aTrigger[2],aTrigger[3],aTrigger[4])
    oStruct:setProperty('Z50_TIPO',MODEL_FIELD_WHEN ,{|| INCLUI    })

    oModel:addFields('Z50MASTER',,oStruct,bFieldPre,bFieldPos,bFieldLoad)
    oModel:setDescription('Tipos de contratos')
    oModel:setPrimaryKey({'Z50_FILIAL','Z50_CODIGO'})
    
Return oModel

/*/{Protheus.doc} fnModPre
    Funcao de pre validacao do modelo de dados
    @type  Static Function
    /*/
Static Function fnModPre(oModel)

    Local lValid        := .T.
    Local nOperation    := oModel:getOperation() 
    Local cCampo        := strtran(readvar(),"M->","")

    IF nOperation == 4
        IF cCampo == 'Z50_DESCRI'
            //oModel:setErrorMessage(,,,,'ERRO DE VALIDACAO','ESSE CAMPO NAO PODE SER EDITADO!')
            //lValid := .F.
        EndIF
    EndIF
    
Return lValid

/*/{Protheus.doc} fnModPos
    Funcao de validacao final do modelo de dados, tudook
    @type  Static Function
    /*/
Static Function fnModPos(oModel)

    Local lValid    := .T.
    Local cAliasSQL := ''
    Local lExist    := .F.
    Local nOperation:= oModel:getOperation()

    IF nOperation == 5

        cAliasSQL       := getNextAlias()

        BeginSQL alias cAliasSQL
            SELECT * FROM %table:Z51% Z51
            WHERE Z51.%notdel%
            AND Z51_FILIAL = %exp:xFilial('Z51')%
            AND Z51_TIPO = %exp:Z50->Z50_CODIGO%
            LIMIT 1
        EndSQL

        (cAliasSQL)->(dbEval({|| lExist := .T.}),dbCloseArea())

        IF lExist
            oModel:setErrorMessage(,,,,'Registro ja utilizado','Esse registro nao pode ser excluido pois ja foi utilizado!')
            return .F.
        EndIF

    EndIF    
    
Return lValid

/*/{Protheus.doc} fnCommit
    Funcao executada para gravacao dos dados
    @type  Static Function
    /*/
Static Function fnCommit(oModel)

    Local lCommit := fwFormCommit(oModel,/*bBefore*/,/*bAfter*/,/*bAfterTTS*/,/*bInTTS*/,/*bBeforeTTS*/,/*bIntegEAI*/)
    
    IF .not. lCommit
        oModel:setErrorMessage(,,,,'Gravação não efetuada','Ocorreu um erro na gravação dos dados')
    EndIF    

Return lCommit

/*/{Protheus.doc} fnCancel
    Funcao executada para validacao do cancelamento dos dados
    @type  Static Function
    /*/
Static Function fnCancel(oModel)

    Local lCancel := fwFormCancel(oModel)
    
Return lCancel

/*/{Protheus.doc} fnFieldPre
    Pre validacao do submodelo
    @type  Static Function
    /*/
Static Function fnFieldPre(oSubModel,cIdAction,cIdField,xValue)

    Local oModel     := fwModelActive()
    Local lValid     := .T.

    IF cIdAction == 'SETVALUE'
        IF cIdField == 'Z50_DESCRI'
            IF empty(xValue)
                oModel:setErrorMessage(,,,,'NAOVAZIO','O conteudo nao pode ser vazio')
                lValid := .F.
            EndIF
        EndIF
    EndIF

Return lValid

/*/{Protheus.doc} fnFieldPos
    Validacao de tudook do submodelo
    @type  Static Function
    /*/
Static Function fnFieldPos(oSubModel)

    Local lValid := .T.
    
Return lValid

/*/{Protheus.doc} fnFieldLoad
    Funcao para carregamento dos dados
    @type  Static Function
    /*/
Static Function fnFieldLoad(oSubModel,lCopy)
    
Return formLoadField(oSubModel,lCopy)

/*/{Protheus.doc} U_GCTT001
    Funcao para execucao do gatilho de codigo
    @type  Function
    /*/
Function U_GCTT001

    Local cNovoCod  := ''
    Local cAliasSQL := ''
    Local oModel    := fwModelActive()
    Local nOperation:= 0

    nOperation      := oModel:getOperation()

    IF .not. (nOperation == 3 .or. nOperation == 9)
        cNovoCod    := oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO')
        return cNovoCod
    EndIF

    cAliasSQL       := getNextAlias()

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z50_CODIGO),'00') Z50_CODIGO
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO = %exp:M->Z50_TIPO%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}),dbCloseArea())

    IF cNovoCod == '00'
        cNovoCod := M->Z50_TIPO + '01'
    Else
        cNovoCod := soma1(cNovoCod)
    EndIF         
    
Return cNovoCod

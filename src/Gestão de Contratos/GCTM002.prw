#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM002
    Cadastro de contratos - ADVPL MVC
    @type  Function
    @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE (Cores de Legenda)
    @see https://tdn.totvs.com/display/framework/Classe_Acervo
    @see https://tdn.totvs.com/display/framework/FWMBrowse
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/FWFormViewStruct
    @see https://tdn.totvs.com/display/framework/FWFormModelStruct
    @see https://tdn.totvs.com/display/framework/FwStruTrigger
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
    @see https://tdn.totvs.com/display/framework/FWFormCommit
    @see https://tdn.totvs.com/display/framework/FWFormCancel
    @see https://tdn.totvs.com/display/framework/FWModelActive    
    @see https://tdn.totvs.com/display/framework/FWLoadMenuDef
    @see https://tdn.totvs.com/display/framework/FWFldGet
    @see https://tdn.totvs.com/display/framework/FWFldPut
    @see https://tdn.totvs.com/display/framework/formLoadGrid
    @see https://tdn.totvs.com/display/framework/FormLoadField
    @see https://tdn.totvs.com/display/framework/AdvPl+utilizando+MVC    
/*/
Function U_GCTB002

    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()
    
    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z51_TPINTE == 'V' "                          ,"BR_AMARELO"   ,"Vendas"          ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'C' "                          ,"BR_LARANJA"   ,"Compras"         ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'S' "                          ,"BR_CINZA"     ,"Sem Integracao"  ,'1')
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS)  "  ,"AMARELO"      ,"Não Iniciado"    ,'2')
    oBrowse:addLegend("Z51_STATUS == 'I' "                          ,"VERDE"        ,"Iniciado"        ,'2')
    oBrowse:addLegend("Z51_STATUS == 'E' "                          ,"VERMELHO"     ,"Encerrado"       ,'2')    
    oBrowse:activate()
    
Return 

Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.GCTM002'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.GCTM002'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.GCTM002'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.GCTM002'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.GCTM002'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.GCTM002'  OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} viewdef
    Construcao da interface grafica
    @type  Static Function
    /*/
Static Function viewdef

    Local oView
    Local oModel
    Local oStructZ51
    Local oStructZ52

    oStructZ51          := fwFormStruct(2,'Z51')
    oStructZ52          := fwFormStruct(2,'Z52',{|cCampo| .not. alltrim(cCampo) $ 'Z52_NUMERO'})
    oModel              := fwLoadModel('GCTM002')
    oView               := fwFormView():new()

    oStructZ51:setProperty('Z51_VALOR' ,MVC_VIEW_CANCHANGE,.F.)
    oStructZ52:setProperty('Z52_VALOR' ,MVC_VIEW_CANCHANGE,.F.)
    oStructZ52:setProperty('Z52_SALDO' ,MVC_VIEW_CANCHANGE,.F.)
    oStructZ52:setProperty('Z52_QTDATU',MVC_VIEW_CANCHANGE,.F.)
    oStructZ52:setProperty('Z52_VLRMED',MVC_VIEW_CANCHANGE,.F.)
    oStructZ52:setProperty('Z52_QTDMED',MVC_VIEW_CANCHANGE,.F.)

    oView:setModel(oModel)
    oView:addField('Z51MASTER',oStructZ51,'Z51MASTER')
    oView:addGrid('Z52DETAIL' ,oStructZ52,'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL','Z52_ITEM')
    oView:createHorizontalBox('BOXZ51',50)
    oView:createHorizontalBox('BOXZ52',50)
    oView:setOwnerView('Z51MASTER','BOXZ51')
    oView:setOwnerView('Z52DETAIL','BOXZ52')
    
Return oView

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel 
    Local oStructZ51
    Local oStructZ52
    Local bModelPre := {|oModel| .T.}
    Local bModelPos := {|oModel| .T.}
    Local bCommit   := {|oModel| fCommit(oModel)     }
    Local bCancel   := {|oModel| fCancel(oModel)     }
    Local bLinePre  := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    Local bGridPre  := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    Local bLinePos  := {|oGridModel,nLine| vGridPos(oGridModel,nLine,1)}
    Local bGridPos  := {|oGridModel,nLine| vGridPos(oGridModel,nLine,2)}
    Local bGridload := {|oGridModel,lCopy| vGridLoad(oGridModel,lCopy )}

    oStructZ51      := fwFormStruct(1,'Z51')
    oStructZ52      := fwFormStruct(1,'Z52')

    /*
    Z51_TIPO
    Z51_NUMERO
    Z51_CLIENT
    Z51_LOJA
    Z51_NOMCLI
    Z51_VALOR
    Z51_QTDMED
    */

    bModelWhen := {|| oModel:getOperation() == 3 .or. oModel:getOperation() == 9}
    bWhenEmiss := {|| vWhenEmis(oModel)}
    bModelInit := {|| getSxeNum("Z51","Z51_NUMERO") }
    bValid     := {|| vValid()}
    
    oStructZ51:setProperty('Z51_NUMERO' ,MODEL_FIELD_INIT,bModelInit)
    oStructZ51:setProperty('Z51_TIPO'   ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_NUMERO' ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_CLIENT' ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_LOJA'   ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_NOMCLI' ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_QTDMED' ,MODEL_FIELD_WHEN,bModelWhen)
    oStructZ51:setProperty('Z51_EMISSA' ,MODEL_FIELD_WHEN,bWhenEmiss)
    oStructZ51:setProperty('*'          ,MODEL_FIELD_VALID,bValid   )  
    oStructZ52:setProperty('*'          ,MODEL_FIELD_VALID,bValid   ) 

    aTrigger1        := fwStruTrigger("Z52_CODPRD","Z52_DESPRD","U_GCTT002(1)",.F.,Nil,Nil,Nil,Nil,"001") 
    aTrigger2        := fwStruTrigger("Z52_CODPRD","Z52_LOCEST","U_GCTT002(2)",.F.,Nil,Nil,Nil,Nil,"002")
    oStructZ52:addTrigger(aTrigger1[1],aTrigger1[2],aTrigger1[3],aTrigger1[4])
    oStructZ52:addTrigger(aTrigger2[1],aTrigger2[2],aTrigger2[3],aTrigger2[4])

    oModel          := mpFormModel():new('MODEL_CGTM002',bModelPre,bModelPos,bCommit,bCancel)
    oModel:setDescription('Contratos')
    oModel:addFields('Z51MASTER',,oStructZ51)
    oModel:setPrimaryKey({'Z51_FILIAL','Z51_NUMERO'})
    oModel:addGrid('Z52DETAIL','Z51MASTER',oStructZ52,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
    oModel:getModel('Z52DETAIL'):setUniqueLine({'Z52_ITEM'})
    oModel:setOptional('Z52DETAIL',.T.)
    oModel:setRelation('Z52DETAIL',{{'Z52_FILIAL','xFilial("Z52")'},{"Z52_NUMERO","Z51_NUMERO"}},Z52->(indexKey(1)))
    
Return oModel

Function U_GCTT002(nOpc)

    Local oModel
    Local cCodPrd

    DO CASE 

        CASE nOpc == 1 //-- Gatilho de descricao
           oModel  := fwModelActive() 
           cCodPrd := oModel:getModel('Z52DETAIL'):getValue('Z52_CODPRD')
           SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodPrd))
           return LEFT(SB1->B1_DESC,TAMSX3('Z52_DESPRD')[1])

        CASE nOpc == 2 //-- Gatilho de local de estoque
            return SB1->B1_LOCPAD

    END CASE

Return

Static Function vValid

    Local lValid := .T.
    Local cCampo := strtran(readvar(),"M->","")
    Local xValue := Nil
    Local oModel := fwModelActive()

    DO CASE

        CASE cCampo == 'Z51_TIPO'
            
            xValue    := oModel:getModel('Z51MASTER'):getValue('Z51_TIPO')
            cAliasSQL := mpSysOpenQuery("SELECT * FROM " + retSqlName("Z50") + " WHERE D_E_L_E_T_ = ' ' AND Z50_CODIGO = '" + xValue + "' ")
            lValid    := .F.
            (cAliasSQL)->(dbEval({|| lValid := .T.}),dbCloseArea())

        CASE cCampo == 'Z51_CLIENT' .or. cCampo == 'Z51_LOJA'

            cTpInte         := oModel:getModel('Z51MASTER'):getValue('Z51_TPINTE')
            cCodigo         := oModel:getModel('Z51MASTER'):getValue('Z51_CLIENT')
            cLoja           := oModel:getModel('Z51MASTER'):getValue('Z51_LOJA'  ) 
            cChaveBusca     :=  iif(empty(cCodigo),space(tamSX3('Z51_CLIENT')[1]),cCodigo) +;
                                iif(empty(cLoja),'',cLoja)

            IF cTpInte == 'C'
                SA2->(dbSetOrder(1),dbSeek(xFilial(alias())+cChaveBusca))
                IF SA2->(.not. Found())
                    lValid := .F.
                Else
                    oModel:getModel('Z51MASTER'):setValue('Z51_NOMCLI',left(SA2->A2_NOME,tamSX3('Z51_NOMCLI')[1]))    
                EndIF   
            Else
                SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cChaveBusca))
                IF SA1->(.not. Found())
                    lValid := .F.
                Else
                    oModel:getModel('Z51MASTER'):setValue('Z51_NOMCLI',left(SA1->A1_NOME,tamSX3('Z51_NOMCLI')[1]))    
                EndIF  
            EndIF

        CASE cCampo == 'Z52_QTD' .or. cCampo == 'Z52_VLRUNI' //-- Atualizar os campos de valor e saldo do valor   

            nQtd    := oModel:getModel('Z52DETAIL'):getValue('Z52_QTD'   )
            nVlrUni := oModel:getModel('Z52DETAIL'):getValue('Z52_VLRUNI')  
            nValor  := round(nQtd * nVlrUni,tamSX3('Z52_VALOR')[2]       ) 

            fwFldPut('Z52_VALOR',nValor)
            fwFldPut('Z52_SALDO',nValor)

    END CASE

return lValid

Static Function vWhenEmis(oModel)

    Local lWhen := .T.

    IF oModel:getOperation() == 4

        dDtAssinBd := Z51->Z51_DTASSI
        dDtAssinMd := oModel:getModel('Z51MASTER'):getValue('Z51_DTASSI')

        IF .not. empty(dDtAssinBd)
            lWhen := .F.
        EndIF    

    EndIF
 
return lWhen

Static Function fCommit(oModel)

    Local oModelFld := oModel:getModel('Z51MASTER')
    Local oModelGrid:= oModel:getModel('Z52DETAIL')
    Local lCommit   := .F.
    Local nVlrTotal := 0
    Local nItens    := oModelGrid:length()
    Local x

    For x := 1 To nItens
        oModelGrid:goLine(x)
        nVlrTotal += oModelGrid:getValue('Z52_VALOR')
    Next

    oModelFld:setValue('Z51_VALOR',nVlrTotal)

    lCommit         := fwFormCommit(oModel)

return lCommit

Static Function fCancel(oModel)

    Local lCancel := fwFormCancel(oModel)

    IF lCancel

        IF __lSX8
            rollbackSX8()
        EndIF

    EndIF

Return lCancel

Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,nOpc)

    Local lValid

return lValid

/*/{Protheus.doc} vGridPos
    Pos validacao do submodelo grid
    @type  Static Function
    /*/
Static Function vGridPos(oGridModel,nLine,nOpc)

    Local lValid := .T.
    
Return lValid

Static Function vGridLoad(oGridModel,lCopy)

    Local aRetorno := formLoadGrid(oGridModel,lCopy)

return aRetorno

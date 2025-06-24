#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} viewdef
    Construcao da interface grafica
    @type  Static Function
    /*/
Static Function viewdef

    Local oView
    Local oModel
    Local oStrZ53CAB
    Local oStrZ53DET

    oStrZ53CAB          := fwFormStruct(2,'Z53',{|cCampo|       alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})
    oStrZ53DET          := fwFormStruct(2,'Z53',{|cCampo| .not. alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})
    oModel              := fwLoadModel('GCTM003MODELDEF')
    oView               := fwFormView():new()

    oStrZ53CAB:setProperty('Z53_NUMERO' ,MVC_VIEW_ORDEM    ,'01')
    oStrZ53CAB:setProperty('Z53_TIPO'   ,MVC_VIEW_ORDEM    ,'02')
    oStrZ53CAB:setProperty('Z53_NUMMED' ,MVC_VIEW_ORDEM    ,'03')
    oStrZ53CAB:setProperty('Z53_EMISSA' ,MVC_VIEW_ORDEM    ,'04')

    oStrZ53CAB:setProperty('Z53_NUMERO' ,MVC_VIEW_LOOKUP   ,'Z51')

    oStrZ53CAB:setProperty('Z53_TIPO'   ,MVC_VIEW_CANCHANGE,.F. )
    oStrZ53CAB:setProperty('Z53_NUMMED' ,MVC_VIEW_CANCHANGE,.F. )
    oStrZ53DET:setProperty('Z53_VALOR'  ,MVC_VIEW_CANCHANGE,.F. )    
    oStrZ53DET:setProperty('Z53_STATUS' ,MVC_VIEW_CANCHANGE,.F. )
    oStrZ53DET:setProperty('Z53_PEDIDO' ,MVC_VIEW_CANCHANGE,.F. )
    oStrZ53DET:setProperty('Z53_ITEMPV' ,MVC_VIEW_CANCHANGE,.F. )

    oView:setModel(oModel)
    oView:addField('Z53MASTER',oStrZ53CAB,'Z53MASTER')
    oView:addGrid('Z53DETAIL' ,oStrZ53DET,'Z53DETAIL')
    oView:addIncrementView('Z53DETAIL','Z53_ITEM')
    oView:createHorizontalBox('BOXZ53CAB',20)
    oView:createHorizontalBox('BOXZ53DET',80)
    oView:setOwnerView('Z53MASTER','BOXZ53CAB')
    oView:setOwnerView('Z53DETAIL','BOXZ53DET')
    
Return oView

#include 'totvs.ch'
#include 'fwmvcdef.ch'

Static Function viewdef

    Local oView
    Local oModel
    Local oStrcZ51
    Local oStrcZ52

    oStrcZ51     := fwFormStruct(2,'Z51')
    oStrcZ52     := fwFormStruct(2,'Z52',{|cCampo| .not. cCampo $ 'Z52_NUMERO'})

    oModel       := fwLoadModel('APMVC002MODEL')
    oView        := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z51MASTER',oStrcZ51,'Z51MASTER')
    oView:addGrid('Z52DETAIL' ,oStrcZ52,'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL','Z52_ITEM')
    oView:createHorizontalBox('BOXZ51',50)
    oView:createHorizontalBox('BOXZ52',50)
    oView:setOwnerView('Z51MASTER','BOXZ51')  
    oView:setOwnerView('Z52DETAIL','BOXZ52')  

return oView

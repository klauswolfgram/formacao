#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} GCTB002
    Cadastro de contratos em MVC
    /*/
Function U_G__CTB002
    
    Private aRotina         := menudef()
    Private oBrowse         := fwMBrowse():new()

    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z51_TPINTE == 'V' "                          , "BR_AMARELO"  , "Vendas"          , "1")
    oBrowse:addLegend("Z51_TPINTE == 'C' "                          , "BR_LARANJA"  , "Compras"         , "1")
    oBrowse:addLegend("Z51_TPINTE == 'S' "                          , "BR_CINZA"    , "Sem Integracao"  , "1")
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS) "   , "AMARELO"     , "Não iniciado"    , "2")
    oBrowse:addLegend("Z51_STATUS == 'I' "                          , "VERDE"       , "Iniciado"        , "2")
    oBrowse:addLegend("Z51_STATUS == 'E' "                          , "VERMELHO"    , "Encerrado"       , "2")
    oBrowse:activate()

Return 


Static Function menudef
    
    local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTM002'  OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.GCTM002'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.GCTM002'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.GCTM002'  OPERATION 5 ACCESS 0    

Return aRotina

//interface grafica
Static Function viewdef

    local oView
    local oModel
    local oStructZ51
    local oStructZ52

    oStructZ51          := fwFormStruct(2, 'Z51')
    oStructZ52          := fwFormStruct(2, 'Z52')
    oModel              := fwLoadModel('GCTM002') //indico o nome do arquivo e ela faz a carga do oModel que está naquele arquivo
    oView               := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z51MASTER', oStructZ51, 'Z51MASTER')
    oView:addGrid('Z52DETAIL', oStructZ52, 'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL', 'Z52_ITEM')
    oView:createHorizontalBox('BOXZ51', 50)
    oView:createHorizontalBox('BOXZ52', 50)
    oView:setOwnerView('Z51MASTER', 'BOXZ51')
    oView:setOwnerView('Z52DETAIL', 'BOXZ52')

Return oView


//regra de negocio
Static Function modeldef
    
    local oModel
    local oStructZ51
    local oStructZ52
    local bModelPre     := {|oModel| .T.}
    local bModelPos     := {|oModel| .T.}
    local bCommit       := {|oModel| fwFormCommit(oModel)} //retorna .T. ou .F. dependendo se ele conseguiu gravar ou nao
    local bCancel       := {|oModel| fwFormCancel(oModel)}
    local bGridpre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    local bLinePre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    local bLinePos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 1)}
    local bGridPos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 2)}
    local bGridLoad     := {|oGridModel, lCopy| vGridLoad(oGridModel, lCopy)}

    oStructZ51  := fwFormStruct(1, 'Z51')
    oStructZ52  := fwFormStruct(1, 'Z52')

    oModel      := mpFormModel():new('MODEL_GCTB002', bModelPre, bModelPos, bCommit, bCancel)
    oModel:setDescription('Contratos')
    oModel:addFields('Z51MASTER',,oStructZ51) //vinculado com o componente field (singular) da viewdef
    oModel:setPrimaryKey({'Z51_FILIAL', 'Z51_NUMERO'})
    //para grid, ele tem validacao na linha e validacao no grid todo
    oModel:addGrid('Z52DETAIL', 'Z51MASTER', oStructZ52, bLinePre, bLinePos, bGridpre, bGridPos, bGridLoad)
    oModel:getModel('Z52DETAIL'):setUniqueLine({'Z52_ITEM'})
    oModel:setOptional('Z52DETAIL', .T.) //indica se o componente de detalhe é opcional ou obrigatorio
    oModel:setRelation('Z52DETAIL', {{'Z52_FILIAL', 'xFilial("Z52")'}, {"Z52_NUMERO", "Z51_NUMERO"}}) //indico componente relacionado com a principal

Return oModel

//pre validacao do objeto do submodelo grid
Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue, nOpc)

    local lValid
    
Return lValid

//pos validacao do objeto do submodelo grid
Static Function vGridPos(oGridModel, nLine, nOpc)

    local lValid
    
Return lValid


Static Function vGridLoad(oGridModel, lCopy)

    local aRetorno      := formGridLoad(oGridModel, lCopy)

Return aRetorno

#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM003
    Apontamentos de medição - ADVPL MVC
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
Function U_GCTB003

    Private aRotina     := fwLoadMenuDef('GCTM003MENUDEF')
    Private oBrowse     := fwMBrowse():new()
    
    oBrowse:setAlias('Z53')
    oBrowse:setDescription('Apontamento de medições')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'V'"   ,"BR_AMARELO"   ,"Vendas"          ,'1')
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'C' "  ,"BR_LARANJA"   ,"Compras"         ,'1')
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'S' "  ,"BR_CINZA"     ,"Sem Integracao"  ,'1')
    oBrowse:addLegend("Z53_STATUS $ 'A ' "        ,"VERDE"        ,"Aberto"          ,'2')
    oBrowse:addLegend("Z53_STATUS == 'E' "        ,"VERMELHO"     ,"Encerrado"       ,'2')    
    oBrowse:activate()
    
Return 

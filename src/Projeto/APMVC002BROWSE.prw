#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_APMVC002
    Programa de manutencao de contratos.
    @type  Function
    @author Klaus Wolfgram
    @since 10/06/2023
    @version 1.0
    @history 10/06/2023, Klaus Wolfgram, Construcao inicial do programa
    /*/
Function U_APMVC002

    Private aRotina := menudef()
    Private oBrowse := fwMBrowse():new()

    oBrowse:setAlias("Z51")
    oBrowse:setDescription("Manutencao de contratos")
    oBrowse:setExecuteDef(4)
    oBrowse:setUseFilter(.T.)
    oBrowse:addLegend("LEFT(Z51_TIPO,1) == 'C' ","YELLOW","Compras"         ,'1',.T.)
    oBrowse:addLegend("LEFT(Z51_TIPO,1) == 'F' ","ORANGE","Faturamento"     ,'1',.T.)
    oBrowse:addLegend("LEFT(Z51_TIPO,1) == 'S' ","GRAY"  ,"Sem Integracao"  ,'1',.T.)
    oBrowse:addLegend("Z51_STATUS == '0'"       ,"GREEN" ,"Nao iniciado"    ,'2',.T.)
    oBrowse:addLegend("Z51_STATUS == '1'"       ,"BLUE"  ,"iniciado"        ,'2',.T.)
    oBrowse:addLegend("Z51_STATUS == '2'"       ,"RED"   ,"Encerrado"       ,'2',.T.)
    oBrowse:activate()
    
Return 

Static Function menudef

    Local aRotina[0]

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'              OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.APMVC002VIEW'  OPERATION 9 ACCESS 0    

return aRotina

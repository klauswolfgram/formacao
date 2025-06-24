#include 'totvs.ch'
#include 'fwmvcdef.ch'
/*/
Programa para encerramento de medicoes
/*/
Function U_APMVC004

    Private cSQL      := ''
    Private cAliasSQL := getNextAlias()
    Private cAliasTmp := getNextAlias()
    Private aSize     := fwGetDialogSize()
    Private aRotina   := array(0) //menudef()
    Private aCmpTmp   := array(0)
    Private aCmpBrw   := array(0)
    Private aColuns   := array(0)
    Private oDlg      := nil
    Private oTempTab  := nil    
    Private oBrowse   := nil 
    Private nOpca     := 0
    Private bConfirm  := {|| nOpca := 1, oDlg:end()}
    Private bCancel   := {|| nOpca := 0, oDlg:end()}
    Private bInit     := {|| enchoiceBar(oDlg,bConfirm,bCancel)}

    oDlg              := tDialog():new(aSize[1],aSize[2],aSize[3],aSize[4],'Encerramento de medicoes',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    oDlg:lCentered    := .T.
    oDlg:bInit        := bInit    

    aadd(aCmpTmp, {"MARK"       , "C", 2                       , 0                       })
    aadd(aCmpTmp, {"Z53_NUMERO" , "C", tamSX3('Z53_NUMERO')[1] , 0                       })
    aadd(aCmpTmp, {"Z53_NUMMED" , "C", tamSX3('Z53_NUMMED')[1] , 0                       })
    aadd(aCmpTmp, {"Z53_ITEM"   , "C", tamSX3('Z53_ITEM'  )[1] , 0                       })   
    aadd(aCmpTmp, {"Z53_CODPRD" , "C", tamSX3('Z53_CODPRD')[1] , 0                       })
    aadd(aCmpTmp, {"Z53_DESPRD" , "C", tamSX3('Z53_DESPRD')[1] , 0                       })
    aadd(aCmpTmp, {"Z53_QTD"    , "N", tamSX3('Z53_QTD'   )[1] , tamSX3('Z53_QTD'  )[2]  })
    aadd(aCmpTmp, {"Z53_VALOR"  , "N", tamSX3('Z53_VALOR' )[1] , tamSX3('Z53_VALOR')[2]  }) 
    aadd(aCmpTmp, {"Z53_PEDIDO" , "C", tamSX3('Z53_PEDIDO')[1] , 0                       })

    oTempTab          := fwTemporaryTable():new(cAliasTmp,aCmpTmp)
    oTempTab:create()

    cSQL              := "SELECT Z53.*, '  ' AS MARK"
    cSQL              += CRLF + "FROM " + retSqlName("Z53") + " Z53"
    cSQL              += CRLF + "JOIN " + retSqlName("Z51") + " Z51 ON Z51.D_E_L_E_T_ = ' ' AND Z51_FILIAL = Z53_FILIAL AND Z51_NUMERO = Z53_NUMERO "
    cSQL              += CRLF + "JOIN " + retSqlName("Z50") + " Z50 ON Z50.D_E_L_E_T_ = ' ' AND Z50_FILIAL = Z51_FILIAL AND Z50_CODIGO = Z51_TIPO "
    cSQL              += CRLF + "WHERE Z53.D_E_L_E_T_ = ' ' "
    cSQL              += CRLF + "AND Z53_FILIAL = '" + xFilial('Z53') + "' "
    cSQL              += CRLF + "AND Z53_PEDIDO = ' ' "
    cSQL              += CRLF + "ORDER BY Z53_NUMERO,Z53_NUMMED,Z53_ITEM"

    dbUseArea(.T.,'TOPCONN',tcGenQry(,,cSQL),cAliasSQL,.T.,.F.)      

    While .not. (cAliasSQL)->(eof())
        
        (cAliasTmp)->(reclock(alias(),.T.))
            (cAliasTmp)->Z53_NUMERO := (cAliasSQL)->Z53_NUMERO
            (cAliasTmp)->Z53_NUMMED := (cAliasSQL)->Z53_NUMMED
            (cAliasTmp)->Z53_ITEM   := (cAliasSQL)->Z53_ITEM
            (cAliasTmp)->Z53_CODPRD := (cAliasSQL)->Z53_CODPRD
            (cAliasTmp)->Z53_DESPRD := (cAliasSQL)->Z53_DESPRD
            (cAliasTmp)->Z53_QTD    := (cAliasSQL)->Z53_QTD
            (cAliasTmp)->Z53_VALOR  := (cAliasSQL)->Z53_VALOR
        (cAliasTmp)->(msunlock())

        (cAliasSQL)->(dbSkip())

    Enddo

    (cAliasSQL)->(dbCloseArea())
    (cAliasTmp)->(dbGoTop())

    aadd(aCmpBrw, {"CONTRATO"    , "Z53_NUMERO" , "C", tamSX3('Z53_NUMERO')[1] , 0                       ,getSx3Cache("Z53_NUMERO","X3_PICTURE")})
    aadd(aCmpBrw, {"MEDICAO"     , "Z53_NUMMED" , "C", tamSX3('Z53_NUMMED')[1] , 0                       ,getSx3Cache("Z53_NUMMED","X3_PICTURE")})
    aadd(aCmpBrw, {"ITEM"        , "Z53_ITEM"   , "C", tamSX3('Z53_ITEM'  )[1] , 0                       ,getSx3Cache("Z53_ITEM"  ,"X3_PICTURE")})   
    aadd(aCmpBrw, {"PRODUTO"     , "Z53_CODPRD" , "C", tamSX3('Z53_CODPRD')[1] , 0                       ,getSx3Cache("Z53_CODPRD","X3_PICTURE")})
    aadd(aCmpBrw, {"DESCRICAO"   , "Z53_DESPRD" , "C", tamSX3('Z53_DESPRD')[1] , 0                       ,getSx3Cache("Z53_DESPRD","X3_PICTURE")})
    aadd(aCmpBrw, {"QUANTIDADE"  , "Z53_QTD"    , "N", tamSX3('Z53_QTD'   )[1] , tamSX3('Z53_QTD'  )[2]  ,getSx3Cache("Z53_QTD"   ,"X3_PICTURE")})
    aadd(aCmpBrw, {"VALOR"       , "Z53_VALOR"  , "N", tamSX3('Z53_VALOR' )[1] , tamSX3('Z53_VALOR')[2]  ,getSx3Cache("Z53_VALOR" ,"X3_PICTURE")}) 
    aadd(aCmpBrw, {"PEDIDO"      , "Z53_PEDIDO" , "N", tamSX3('Z53_PEDIDO')[1] , 0                       ,getSx3Cache("Z53_PEDIDO","X3_PICTURE")})     

    oBrowse := fwMarkBrowse():new()
    oBrowse:setOwner(oDlg)
    oBrowse:setAlias(cAliasTmp)                
    oBrowse:setDescription('Seleção de medições pendentes')
    oBrowse:setTemporary(.T.)
    oBrowse:setFields(aCmpBrw) 
    oBrowse:setFieldMark('MARK')     
    oBrowse:setFilterDefault("empty(Z53_PEDIDO)")
    oBrowse:disableReport()      
    oBrowse:activate()

    oDlg:activate()

    IF nOpca = 0
        oTempTab:delete()
        return 
    EndIF    

    oTempTab:delete()

return

Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Processar' ACTION 'U_APMVC04P()' OPERATION 2 ACCESS 0

return aRotina

Function U_APMVC04P

    fwAlertInfo('Processar')

return

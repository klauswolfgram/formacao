#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel 
    Local oStrZ53CAB
    Local oStrZ53DET
    Local bModelPre := {|oModel| .T. }
    Local bModelPos := {|oModel| fModelPos(oModel)}
    Local bCommit   := {|oModel| fCommit(oModel)  }
    Local bCancel   := {|oModel| fCancel(oModel)  }
    Local bLinePre  := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    Local bGridPre  := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    Local bLinePos  := {|oGridModel,nLine| vGridPos(oGridModel,nLine,1)}
    Local bGridPos  := {|oGridModel,nLine| vGridPos(oGridModel,nLine,2)}
    Local bGridload := {|oGridModel,lCopy| vGridLoad(oGridModel,lCopy )}

    oStrZ53CAB      := fwFormStruct(1,'Z53',{|cCampo|       alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})
    oStrZ53DET      := fwFormStruct(1,'Z53',{|cCampo| .not. alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})

    oStrZ53CAB:setProperty('Z53_NUMERO',MODEL_FIELD_VALID,{|| fnValid()                     })
    oStrZ53CAB:setProperty('Z53_NUMMED',MODEL_FIELD_INIT ,{|| getSxeNum('Z53','Z53_NUMMED') })
    oStrZ53CAB:setProperty('Z53_EMISSA',MODEL_FIELD_INIT ,{|| ddatabase                     })
    oStrZ53CAB:setProperty('Z53_EMISSA',MODEL_FIELD_WHEN ,{|| fnWhen(1)                     })
    oStrZ53DET:setProperty('*'         ,MODEL_FIELD_WHEN ,{|| fnWhen(2)                     })

    oModel          := mpFormModel():new('MODEL_CGTM003',bModelPre,bModelPos,bCommit,bCancel)
    oModel:setDescription('Apontamento de Medições')
    oModel:addFields('Z53MASTER',,oStrZ53CAB)
    oModel:setPrimaryKey({'Z53_FILIAL','Z53_NUMERO'})
    oModel:addGrid('Z53DETAIL','Z53MASTER',oStrZ53DET,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
    oModel:getModel('Z53DETAIL'):setUniqueLine({'Z53_ITEM'})
    oModel:setRelation('Z53DETAIL',{{'Z53_FILIAL','xFilial("Z53")'},{"Z53_NUMERO","Z53_NUMERO"}},Z53->(indexKey(1)))
    
Return oModel

Static Function fModelPos(oModel)

    Local lValid    := .T.
    Local oModGrid  := oModel:getModel('Z53DETAIL')
    Local x

    IF oModel:getOperation() == 5

        For x := 1 To oModGrid:length()

            oModGrid:goLine(x)

            IF oModGrid:getValue('Z53_STATUS') == 'E'
                oModel:setErrorMessage(,,,,'ERRO','ESSA MEDICAO POSSUI ITENS ENCERRADOS. NAO PODE SER EXCLUÍDA.')
                return .F.
            EndIF

        Next

    EndIF

return lValid

Static Function fnWhen(nOpcao)

    Local oModel    := fwModelActive()
    Local lWhen     := .T.
    Local lInclui   := oModel:getOperation() == 3 .or. oModel:getOperation() == 9 

    DO CASE 
        CASE nOpcao == 1 //-- When no campo de emissao
            return lInclui
        CASE nOpcao == 2 //-- Validacao de todos os campos da estrutura de detalhe
            IF fwFldGet('Z53_STATUS') == 'E'
                return .F.
            EndIF        
    END CASE

return lWhen

Static Function fCommit(oModel)

    Local lCommit := fwFormCommit(oModel,,,,{|| U_ATUALIZA_INDICADORES_DO_CONTRATO()})

return lCommit

Static Function fCancel(oModel)

    lCancel := fwFormCancel(oModel)

    IF lCancel
        IF __lSX8
            rollbacksx8()
        EndIF
    EndIF

return lCancel

Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,nOpcao)

    Local lValid := .T.
    Local oModel := fwModelActive()

    IF nOpcao == 2
        
        IF cAction == 'DELETE'

            IF fwFldGet('Z53_STATUS') == 'E'
                oModel:setErrorMessage(,,,,'ERRO DELETE','MEDICAO ENCERRADA NAO PODE SER DELETADA')
                return .F.
            EndIF

        ElseIF cAction == 'SETVALUE'
            
            IF cField == 'Z53_CODPRD'

                cAliasSQL := getNextAlias()

                BeginSQL alias cAliasSQL
                    SELECT * FROM %table:Z52% Z52
                    WHERE Z52.%notdel%
                    AND Z52_FILIAL = %exp:xFilial('Z52')%
                    AND Z52_NUMERO = %exp:fwFldGet('Z53_NUMERO')%
                    AND Z52_CODPRD = %exp:xValue%
                EndSQL

                nRecZ52 := 0
                
                (cAliasSQL)->(dbEval({|| nRecZ52 := R_E_C_N_O_}),dbCloseArea())

                IF nRecZ52 == 0
                    oModel:setErrorMessage(,,,,'ERRO PRODUTO','PRODUTO DIGITADO NAO ENCONTRADO NO CONTRATO')
                    return .F.
                EndIF

                Z52->(dbSetOrder(1),dbGoTo(nRecZ52))

                fwFldPut('Z53_DESPRD',Z52->Z52_DESPRD)
                fwFldPut('Z53_LOCEST',Z52->Z52_LOCEST)
                fwFldPut('Z53_VALOR' ,fwFldGet('Z53_QTD') * Z52->Z52_VLRUNI)

            ElseIF cField == 'Z53_QTD' 

                cAliasSQL := getNextAlias()

                BeginSQL alias cAliasSQL
                    SELECT * FROM %table:Z52% Z52
                    WHERE Z52.%notdel%
                    AND Z52_FILIAL = %exp:xFilial('Z52')%
                    AND Z52_NUMERO = %exp:fwFldGet('Z53_NUMERO')%
                    AND Z52_CODPRD = %exp:fwFldGet('Z53_CODPRD')%
                EndSQL

                nRecZ52 := 0
                
                (cAliasSQL)->(dbEval({|| nRecZ52 := R_E_C_N_O_}),dbCloseArea())

                Z52->(dbSetOrder(1),dbGoTo(nRecZ52))  
                fwFldPut('Z53_VALOR',xValue * Z52->Z52_VLRUNI)             

            EndIF

        EndIF

    EndIF

return lValid

Static Function vGridPos(oGridModel,nLine,nOpcao)

    Local lValid := .T.

return lValid    

Static Function vGridLoad(oGridModel,lCopy )

    Local aLoad := formLoadGrid(oGridModel,lCopy)

return aLoad

Static Function fnValid

    Local lValid := .T.
    Local cCampo := strtran(readvar(),"M->","")
    Local oModel := fwModelActive()

    DO CASE 
        
        CASE cCampo == 'Z53_NUMERO'
        
        Z51->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z53_NUMERO))
        
        lValid := Z51->(Found())

        IF lValid
            oModel:getModel('Z53MASTER'):setValue('Z53_TIPO',Z51->Z51_TIPO)
            return lValid
        EndIF

    END CASE

return lValid

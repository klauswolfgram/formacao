#include 'totvs.ch'

/*/{Protheus.doc} User Function TOOLS001
    Programa para adequação de dicionário e base dados às implementações do projeto pcp/prodwin fibrasa.
    @type  User Function
    @author Klaus Wolfram
    @since 10/09/2021
    @version 1.0
    /*/

Function U_TOOLS001

    TOOLS001('Z50',.F.)
    TOOLS001('Z51',.F.)
	TOOLS001('Z52',.F.)
	TOOLS001('Z53',.F.)

    fwAlertInfo('Ok')

Return

Static Function TOOLS001(cTabela,lShowMsg)

    Private oTools  := class_sxs():new()

    Default cTabela := ''
    Default lShowMsg:= .F.

    IF empty(cTabela)
        return
    EndIF    

    fwMsgRun(,{|| fnSX2(cTabela,lShowMsg)},oemtoansi('Processando sx2'),'Aguarde...')
    fwMsgRun(,{|| fnSX3(cTabela,lShowMsg)},oemtoansi('Processando sx3'),'Aguarde...')
    fwMsgRun(,{|| fnSIX(cTabela,lShowMsg)},oemtoansi('Processando six'),'Aguarde...')
    fwMsgRun(,{|| fnSXB(cTabela,lShowMsg)},oemtoansi('Processando sxb'),'Aguarde...')   
   
Return

//-- Atualiza os registros necessarios na tabela SX2
Static Function fnSX2(cTabela,lShowMsg)

    Local oSX2   := class_sx2():new()

    IF empty(cTabela) .or. SX2->(dbSetOrder(1),dbSeek(cTabela))
        return
    EndIF    
            
    oSX2:x2_chave   := cTabela
    oSX2:x2_arquivo := cTabela + cEmpAnt + '0'
    oSX2:x2_path    := ''  

    //-- projeto gestao de contratos
    IF cTabela == 'Z50'

        oSX2:x2_descri  := 'Tipos de contratos'
        oSX2:x2_unico   := 'Z50_FILIAL+Z50_CODIGO'   

    ElseIF cTabela == 'Z51'
   
        oSX2:x2_descri  := 'Cadastro de contratos - cabecalho'
        oSX2:x2_unico   := 'Z51_FILIAL+Z51_NUMERO' 

    ElseIF cTabela == 'Z52'    

        oSX2:x2_descri  := "Cadastro de contratos - itens"
        oSX2:x2_unico   := 'Z52_FILIAL+Z52_NUMERO+Z52_ITEM'

    ElseIF cTabela == 'Z53'     

        oSX2:x2_descri  := "Medicoes de contratos"
        oSX2:x2_unico   := 'Z53_FILIAL+Z53_NUMERO+Z53_NUMMED+Z53_ITEM'

    EndIF

    oTools:arq_sx2      := oSX2 
            
    IF oTools:put_sx2(lShowMsg)
        oTools:arq_sx2  := class_sx2():new()
    EndIF     

Return

//-- Atualiza os registros necessarios na tabela SX3
Static Function fnSX3(cTabela,lShowMsg)

    Local oSX3      := Nil
    Local aCampos   := array(0)
    Local x    
    
    oTools:arq_sx3  := array(0)

	IF cTabela == 'Z50'
	
		aCampos  := array(0)
		cvlduser := 'vazio() .or. existchav("Z50")'
        
        aadd(aCampos,{'Z50_FILIAL','C5_FILIAL'  ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/                   ,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z50_CODIGO','' 			,'C'     ,03         ,0          ,'Codigo'      ,'@!'       ,cvlduser                      ,'INCLUI',.T./*Obrigatorio*/,/*F3*/})
		aadd(aCampos,{'Z50_DESCRI',''  			,'C'     ,30		 ,0			 ,'Descricao'   ,'@!'       ,/*vlduser*/                   ,/*when*/,.T./*Obrigatorio*/,/*F3*/})		

    ElseIF cTabela == 'Z51' 

		aCampos := array(0)
		
        aadd(aCampos,{'Z51_FILIAL','C5_FILIAL'  ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_NUMERO',''           ,'C'     ,06	     ,0			 ,'Numero'	    ,'@!'		,''			,'INCLUI',.T./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z51_EMISSA','C5_EMISSAO' ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_CLIENT','C5_CLIENTE' ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_LOJA'  ,'C5_LOJA'    ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_NOMCLI','E1_NOMCLI'  ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_DTASSI','C5_EMISSAO' ,/*tipo*/,/*tamanho*/,/*decimal*/,'Dt Assinat'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_VALOR' ,'E1_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Valor'	    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_VALOR' ,'E1_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Vlr Medic.'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_QTDMED','C6_QTDVEN'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Qtd Medic.'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z51_OBS'   ,''           ,'M'     ,80	     ,0			 ,'Obs.'        ,'@!'		,''			,/*WHEN*/   ,.F./*Obrigatorio*/,/*F3*/})  

    ElseIF cTabela == 'Z52'    

		aCampos := array(0)
		
        aadd(aCampos,{'Z52_FILIAL','C5_FILIAL'  ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z52_NUMERO',''           ,'C'     ,06	     ,0			 ,'Contrato'	,'@!'		,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})       
        aadd(aCampos,{'Z52_ITEM'  ,''           ,'C'     ,03	     ,0			 ,'Item'	    ,'@!'		,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})       
        aadd(aCampos,{'Z52_CODPRD','C6_PRODUTO' ,/*tipo*/,/*tamanho*/,/*decimal*/,'Produto'     ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,'SB1' }) 
        aadd(aCampos,{'Z52_DESPRD','B1_DESC'    ,/*tipo*/,/*tamanho*/,/*decimal*/,'Descricao'   ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z52_LOCEST','B1_LOCPAD'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Loc. Est.'   ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,'NNR' }) 
        aadd(aCampos,{'Z52_QTD'   ,'C6_QTDVEN'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Quantidade'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})  
        aadd(aCampos,{'Z52_QTDATU','C6_QTDVEN'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Qtd. Atual'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z52_VALOR' ,'C6_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Valor'       ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z52_VLRMED','C6_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Vlr Medic.'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})               
        aadd(aCampos,{'Z52_QTDMED','C6_QTDVEN'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Qtd. Medic'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z52_SALDO' ,'C6_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Vlr Saldo'   ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z52_OBS'   ,''           ,'M'     ,80	     ,0			 ,'Obs.'        ,'@!'		,''			,/*when*/,.F./*Obrigatorio*/,/*F3*/})         

    ElseIF cTabela == 'Z53'

		aCampos := array(0)
		
        aadd(aCampos,{'Z53_FILIAL','C5_FILIAL'  ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z53_NUMERO',''           ,'C'     ,06	     ,0			 ,'Contrato'	,'@!'		,''			,'INCLUI',.F./*Obrigatorio*/,/*F3*/})        
        aadd(aCampos,{'Z53_NUMMED',''           ,'C'     ,06	     ,0			 ,'Num. Medic'	,'@!'		,''			,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z53_EMISSA','C5_EMISSAO' ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})        
        aadd(aCampos,{'Z53_ITEM'  ,''           ,'C'     ,03	     ,0			 ,'Item'	    ,'@!'		,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z53_CODPRD','C6_PRODUTO' ,/*tipo*/,/*tamanho*/,/*decimal*/,'Produto'     ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,'SB1' }) 
        aadd(aCampos,{'Z53_DESPRD','B1_DESC'    ,/*tipo*/,/*tamanho*/,/*decimal*/,'Descricao'   ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/}) 
        aadd(aCampos,{'Z53_LOCEST','B1_LOCPAD'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Loc. Est.'   ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,'NNR' })              
        aadd(aCampos,{'Z53_QTD'   ,'C6_QTDVEN'  ,/*tipo*/,/*tamanho*/,/*decimal*/,'Quantidade'  ,/*picture*/,/*vlduser*/,/*when*/,.F./*Obrigatorio*/,/*F3*/})             
        aadd(aCampos,{'Z53_VALOR' ,'C6_VALOR'   ,/*tipo*/,/*tamanho*/,/*decimal*/,'Valor'       ,/*picture*/,/*vlduser*/,'.F.'   ,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z53_STATUS',''           ,'C'     ,1			 ,0			 ,'Status'	    ,'@!'		,''			,'.F.'   ,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z53_PEDIDO','C6_NUM'     ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,'.F.'   ,.F./*Obrigatorio*/,/*F3*/})
        aadd(aCampos,{'Z53_ITEMPV','C6_ITEM'    ,/*tipo*/,/*tamanho*/,/*decimal*/,/*titulo*/    ,/*picture*/,/*vlduser*/,'.F.'   ,.F./*Obrigatorio*/,/*F3*/})

    EndIF    

	
	IF len(aCampos) > 0
	
		oTools:arq_sx3 := array(0)

        cAux            := cTabela

        For x := 1 To Len(aCampos)

            IF SX3->(dbSetOrder(2),dbSeek(aCampos[x,1]))
                Loop
            EndIF

            lSX3 := .F.

            IF .not. empty(aCampos[x,2])
               lSX3 := SX3->(dbSetOrder(2),dbSeek(aCampos[x,2]))
            EndIF    

            oSX3            := class_sx3():new()     
		
            oSX3:x3_arquivo := cAux
            oSX3:x3_ordem   := strzero(x,02)
            oSX3:x3_campo   := aCampos[x,01]
            oSX3:x3_tipo    := iif(lSX3,SX3->X3_TIPO    ,aCampos[x,03])
            oSX3:x3_tamanho := iif(lSX3,SX3->X3_TAMANHO ,aCampos[x,04])
            oSX3:x3_decimal := iif(lSX3,SX3->X3_DECIMAL ,aCampos[x,05])
            oSX3:x3_picture := iif(lSX3,SX3->X3_PICTURE ,aCampos[x,07])
			oSX3:x3_vlduser := aCampos[x,08]
			oSX3:x3_when    := aCampos[x,09]   
            oSX3:x3_f3      := aCampos[x,11]         
            
            IF .not. aCampos[x,10]
                oSX3:x3_obrigat := ''
            EndIF    

            IF lSX3
			
                IF '_FILIAL' $ aCampos[x,01]

                    oSX3:x3_usado   := SX3->X3_USADO
                    oSX3:x3_nivel   := SX3->X3_NIVEL
                    oSX3:x3_browse  := SX3->X3_BROWSE
                    oSX3:x3_valid	:= SX3->X3_VALID
                    oSX3:x3_when	:= SX3->X3_WHEN

                EndIF

                oSX3:x3_grpsxg      := SX3->X3_GRPSXG
                oSX3:x3_titulo      := SX3->X3_TITULO 
                oSX3:x3_descric     := SX3->X3_DESCRIC               

            EndIF    

            IF .not. empty(aCampos[x,06])

                oSX3:x3_titulo      := aCampos[x,06]
                oSX3:x3_descric     := aCampos[x,06]

            EndIF

            aadd(oTools:arq_sx3,oSX3)                       

        Next

        IF oTools:put_sx3(lShowMsg) 
            oTools:arq_sx3 := array(1,class_sx3():new())
        EndIF    

	EndIF

Return

//-- Atualiza os registros necessarios na tabela SIX
Static Function fnSIX(cTabela,lShowMsg)

    Local oIndice := nil
    Local cDescric:= ''    

    //-- cria o indice da tabela Z50
    IF cTabela == 'Z50'

        IF .not. SIX->(dbSetOrder(1),dbSeek('Z50'))

            oIndice                 := class_six():new()

            oIndice:ix_indice       := 'Z50'
            oIndice:ix_ordem        := '1'
            oIndice:ix_chave        := 'Z50_FILIAL+Z50_CODIGO'
            oIndice:ix_descricao    := 'Codigo'

            oTools:arq_six          := oIndice
            
            IF oTools:put_six(lShowMsg)
                oTools:arq_six      := class_six():new()
            EndIF    

        EndIF

    //-- Cria o indice da tabela Z51
    ElseIF cTabela == 'Z51'   

        IF .not. SXI->(dbSetOrder(1),dbSeek('Z51'))

            oIndice := class_six():new()

            oIndice:ix_indice       := 'Z51'
            oIndice:ix_ordem        := '1' 
            oIndice:ix_chave        := 'Z51_FILIAL+Z51_NUMERO'

            cDescric                := ''

            IF SX3->(dbSetOrder(2),dbSeek('Z51_NUMERO'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF

            oIndice:ix_descricao    := cDescric

            oTools:arq_six          := oIndice    

              IF oTools:put_six(lShowMsg)
                oTools:arq_six      := class_six():new()
            EndIF            

        EndIF

    ElseIF cTabela == 'Z52'    

        IF .not. SIX->(dbSetOrder(1),dbSeek('Z52'))

            oIndice := class_six():new()

            oIndice:ix_indice       := 'Z52'
            oIndice:ix_ordem        := '1' 
            oIndice:ix_chave        := 'Z52_FILIAL+Z52_NUMERO+Z52_ITEM'

            cDescric                := ''

            IF SX3->(dbSetOrder(2),dbSeek('Z52_NUMERO'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF            

            IF SX3->(dbSetOrder(2),dbSeek('Z52_ITEM'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF

            oIndice:ix_descricao    := cDescric

            oTools:arq_six          := oIndice    

            IF oTools:put_six(lShowMsg)
                oTools:arq_six      := class_six():new()
            EndIF

        EndIF 

    ElseIF cTabela == 'Z53'    

        IF .not. SIX->(dbSetOrder(1),dbSeek('Z53'))

            oIndice                 := class_six():new()

            oIndice:ix_indice       := 'Z53'
            oIndice:ix_ordem        := '1' 
            oIndice:ix_chave        := 'Z53_FILIAL+Z53_NUMERO+Z53_NUMMED+Z53_ITEM'

            cDescric                := ''

            IF SX3->(dbSetOrder(2),dbSeek('Z53_NUMERO'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF            

            IF SX3->(dbSetOrder(2),dbSeek('Z53_NUMMED'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF

            IF SX3->(dbSetOrder(2),dbSeek('Z53_ITEM'))
                cDescric += iif(empty(cDescric), '','+') + SX3->X3_TITULO
            EndIF          

            oIndice:ix_descricao    := cDescric

            oTools:arq_six          := oIndice    

            IF oTools:put_six(lShowMsg)
                oTools:arq_six      := class_six():new()
            EndIF                      

        EndIF

    EndIF

Return

//-- Atualiza os registros necessarios na tabela SXB
Static Function fnSXB(cTabela,lShowMsg)

Return

//-- Atualiza os registros necessários na tabela SX7
Static Function fnSX7(cTabela,cCampo,cContDom,cRegra,cCondic,lShowMsg)

Return

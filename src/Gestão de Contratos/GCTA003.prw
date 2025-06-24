#include 'totvs.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} U_GCTA002
    Exemplo de programa prototipo modelo 2 - advpl tradicional
    Cadastro de contratos
    @type  Function
	@see https://tdn.totvs.com/display/tec/TDialog
	@see https://tdn.totvs.com/display/framework/MsObjSize+-+Dimensionamento+de+janelas
	@see https://tdn.totvs.com/display/tec/FCount
	@see https://tdn.totvs.com/display/tec/FieldName
	@see https://tdn.totvs.com/display/tec/FieldGet
	@see https://tdn.totvs.com/display/framework/MsmGet
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6814879 (regToMemory)
	@see https://tdn.totvs.com/display/framework/MsNewGetDados
	@see https://tdn.totvs.com/display/framework/BEGIN+TRANSACTION
    @see https://tdn.totvs.com/display/tec/TFont   
    @see https://tdn.totvs.com/display/tec/TSay     
    @see https://tdn.totvs.com/display/tec/TGet	
    /*/
Function U_CGTA003

	Private cTitulo 	:= 'Registro de medições de contratos - modelo 2 - ADVPL Tradicional'
	Private aRotina[0]	
	
	//-- Montagem do array de itens do menu
	aadd(aRotina,{'Pesquisar'	,'AxPesqui'		,0,1})
	aadd(aRotina,{'Visualizar'	,'U_GCTA003M'	,0,2})
	aadd(aRotina,{'Incluir'		,'U_GCTA003M'	,0,3})
	aadd(aRotina,{'Alterar'		,'U_GCTA003M'	,0,4})
	aadd(aRotina,{'Excluir'		,'U_GCTA003M'	,0,5})	
	
	//-- Montagem da tela principal
	Z53->(dbSetOrder(1),mBrowse(,,,,alias())) 
    
Return 

Function U_GCTA003M(cAlias,nReg,nOpc)

	Local oDlg
	Local aAdvSize := msAdvSize()
	Local aInfo	   := {aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],3,3}
	Local aObj	   := {{100,060,.T.,.F.},{100,100,.T.,.T.},{100,010,.T.,.F.}}
	Local aPObj	   := msObjSize(aInfo,aObj)
	Local nStyle   := GD_INSERT+GD_UPDATE+GD_DELETE
	Local nSalvar  := 0
	Local bSalvar  := {|| if(obrigatorio(aGets,aTela),(nSalvar := 1, oDlg:end()),nil)}
	Local bCancelar:= {|| (nSalvar := 0, oDlg:end())}
	Local aButtons := array(0)
	Local aHeader  := fnGetHeader()
	Local aCols	   := fnGetCols(nOpc,aHeader)
    Local bValid   := {|| .T.}
    Local bWhen    := {|| .T.}
    Local bChange  := {|| }

	Private oGet
	Private aGets  := array(0)
	Private aTela  := array(0)

    Private oFont  := tFont():new('Courier New',,20,,.T.)
    Private oSay  
    Private oGetZ53, oGetEmis, oGetZ51, oGetZ50

    Private cNumZ53  := IF(nOpc == 3,getSxeNum('Z53','Z53_NUMMED') ,Z53->Z53_NUMMED ) //space(tamSX3('Z53_NUMMED')[1])
    Private dEmisZ53 := IF(nOpc == 3,ddatabase                     ,Z53->Z53_EMISSA )  
    Private cNumZ51  := IF(nOpc == 3,space(tamSX3('Z53_NUMERO')[1]),Z53->Z53_NUMERO )
    Private cNumZ50  := IF(nOpc == 3,space(tamSX3('Z53_TIPO'  )[1]),Z53->Z53_TIPO   )

	//-- Tela de dialog principal
	oDlg 		:= tDialog():new(0 				,; 	//-- Cordenada inicial, Linha inicial (Pixels)
								 0 				,;	//-- Cordenada inicial, Coluna inicial
								 aAdvSize[6] 	,;  //-- Cordenada final, Coluna final
								 aAdvSize[5] 	,;	//-- Cordenada final, Linha fina
								 cTitulo		,;	//-- Titulo da janela
								 Nil			,; 	//-- Fixo
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 CLR_BLACK		,;  //-- Cor do Texto
								 CLR_WHITE		,;  //-- Cor de fundo da tela
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 .T.			)   //-- Indica que as cordenadas serao em pixel 

	//-- Area do Cabecalho
	enchoicebar(oDlg,bSalvar,bCancelar,,aButtons)

    oSay    := tSay():new(40,010,{|| 'Medicao' },oDlg,nil,oFont,nil,nil,nil,.T.,CLR_RED,CLR_WHITE,40,15)
    oSay    := tSay():new(40,100,{|| 'Emissao' },oDlg,nil,oFont,nil,nil,nil,.T.,CLR_RED,CLR_WHITE,40,15)
    oSay    := tSay():new(40,190,{|| 'Contrato'},oDlg,nil,oFont,nil,nil,nil,.T.,CLR_RED,CLR_WHITE,40,15)
    oSay    := tSay():new(40,280,{|| 'Tipo'    },oDlg,nil,oFont,nil,nil,nil,.T.,CLR_RED,CLR_WHITE,40,15)

    oGetZ53 := tGet():new(60,010                                        ,; //-- Linha + Coluna
                         {|u| if(pCount() > 0, cNumZ53 := u, cNumZ53)}  ,; //-- Bloco de codigo para atualizacao do conteudo do campo
                         oDlg                                           ,; //-- Objeto ao qual o componente pertence
                         70,10                                          ,; //-- Largura e altura do campo
                         '@!'                                           ,; //-- Mascara do campo
                         {|| .T.}                                       ,; //-- Bloco de codigo para validacao do conteudo
                         CLR_BLACK,CLR_WHITE                            ,; //-- Cor do texto + Cor do fundo do texto
                         oFont                                          ,; //-- Objeto de fonte do texto
                         Nil,Nil                                        ,; //-- parametros fixos
                         .T.                                            ,; //-- Cordenadas em pixels
                         Nil,Nil                                        ,; //-- parametros fixos
                         {|| .T.}                                       ,; //-- Bloco de codigo para indicar que o campo esta editavel - X3_WHEN
                         .T.                                            ,; //-- Parametro fixo
                         .F.                                            ,; //-- Parametro fixo
                         {|| }                                          ,; //-- Bloco de codigo executado na mudanca do conteudo
                         .T.                                            ,; //-- Indica se o campo é somente leitura
                         .F.                                            ,; //-- Indica que se o campo é de senha
                         Nil                                            ,; //-- Fixo
                         'cNumZ53'                                      ,; //-- Nome da variavel associada ao campo
                         Nil,Nil,Nil                                    ,; //-- Parametros fixos
                         .F.)                                              //-- Indica se o campo possui um botao

    oGetEmis        := tGet():new(60,100, {|u| if(pCount() > 0, dEmisZ53 := u, dEmisZ53)},oDlg, 70,10,'',bValid,CLR_BLACK,CLR_WHITE,oFont,;
                                    Nil,Nil,.T.,Nil,Nil,bWhen ,.T.,.F.,bChange,.F.,.F.,Nil,'dEmisZ53',Nil,Nil,Nil,.T.)
    oGetEmis:bWhen  := {|| if(nOpc == 3, .T., .F.)}                               

    oGetZ51         := tGet():new(60,190, {|u| if(pCount() > 0, cNumZ51 := u, cNumZ51)},oDlg, 70,10,'',bValid,CLR_BLACK,CLR_WHITE,oFont,;
                                    Nil,Nil,.T.,Nil,Nil,bWhen ,.T.,.F.,bChange,.F.,.F.,Nil,'cNumZ51',Nil,Nil,Nil,.T.) 
    oGetZ51:cF3     := 'Z51'
    oGetZ51:bValid  := {|| vazio() .Or. existCpo("Z51")}   
    oGetZ51:bChange := {|| cNumZ50 := posicione("Z51",1,xFilial("Z51")+cNumZ51,'Z51_TIPO')}      
    oGetZ51:bWhen   := {|| if(nOpc == 3, .T., .F.)}                        

    oGetZ50         := tGet():new(60,280, {|u| if(pCount() > 0, cNumZ50 := u, cNumZ50)},oDlg, 70,10,'',bValid,CLR_BLACK,CLR_WHITE,oFont,;
                                    Nil,Nil,.T.,Nil,Nil,bWhen ,.T.,.F.,bChange,.F.,.F.,Nil,'cNumZ50',Nil,Nil,Nil,.T.) 
    oGetZ50:bWhen   := {|| .F.}

	//-- Area de Itens
	oGet := msNewGetDados():new(aPObj[2,1] 		,; //-- Cordenada inicial, Linha inicial
								aPObj[2,2] 		,; //-- Cordenada inicial, Coluna inicial
								aPObj[2,3] 		,; //-- Cordenada final  , Coluna final
								aPObj[2,4] 		,; //-- Cordenada final  , Linha final
								nStyle	   		,; //-- Opcoes que podem ser executadas
								'U_GCTA003V(1)'	,; //-- Validacao de mudanca de linha
								'U_GCTA003V(2)'	,; //-- Validacao final
								'+Z53_ITEM'		,; //-- Definicao do campo incremental
								NIL		   		,; //-- Lista dos campos que podem ser alterados
								0		   		,; //-- Fixo
								9999	   		,; //-- Total de linhas 
								'U_GCTA003V(3)'	,; //-- Funcao que validara cada campo preenchido
								Nil		 		,; //-- Fixo
								'U_GCTA003V(4)'	,; //-- Funcao que ira validar se a linha pode ser deletada
								oDlg	   		,; //-- Objeto proprietario
								aHeader    		,; //-- Vetor com as configuracoes dos campos
								aCols	   		)  //-- Vetor com os conteudos dos campos

	oDlg:activate()

	IF nSalvar = 1
		
		//-- Funcao de gravacao dos dados
		fnGravar(nOpc,aHeader,oGet:aCols)

		IF __lSX8
			confirmSX8()
		EndIF

	Else

		IF __lSX8
			rollbackSX8()
		EndIF

	EndIF	

Return

/*/{Protheus.doc} U_GCTA003V
	Valida linhas do Grid
	@type  Function
	/*/
Function U_GCTA003V(nOpcao)

	Local lValid := .T.

	IF nOpcao == 1 //-- Validacao de mudanca de linha
		lValid  := oGet:chkObrigat(n)
		cCodPrd := gdFieldGet('Z53_CODPRD',oGet:nAt,.F.,oGet:aHeader,oGet:aCols)
		IF empty(cCodPrd)
			fwAlertError('Codigo do produto nao foi preenchido','Erro')
			lValid := .F.
		EndIF
	ElseIF nOpcao == 2 //-- Validacao final
	ElseIF nOpcao == 3 //-- Validacao de campos
		cCampo := strtran(readvar(),"M->","")
		DO CASE 
			CASE cCampo == 'Z53_CODPRD'
				lAchou := fValidPrd()	
				lValid := vazio() .or. lAchou
			CASE cCampo == 'Z53_QTD'
				fUpdVlr()			
		ENDCASE
	ElseIF nOpcao == 4 //-- Validacao de delecao da linha		
	EndIF
	
Return lValid

Static Function fUpdVlr

	Local cAliasSQL := ''

	cAliasSQL 		:= getNextAlias()

	BeginSQL alias cAliasSQL
		SELECT * FROM %table:Z52% Z52
		WHERE Z52.%notdel%
		AND Z52_FILIAL = %exp:xFilial('Z52')%
		AND Z52_NUMERO = %exp:cNumZ51%
		AND Z52_CODPRD = %exp:gdFieldGet('Z53_CODPRD',oGet:nAt,.F.,oGet:aHeader,oGet:aCols)%
	EndSQL

	nRecZ52 := 0

	(cAliasSQL)->(dbEval({|| nRecZ52 := R_E_C_N_O_}),dbCloseArea())

	IF nRecZ52 > 0
		Z52->(dbSetOrder(1),dbGoTo(nRecZ52))
		gdFieldPut('Z53_VALOR',M->Z53_QTD * Z52->Z52_VLRUNI,oGet:nAt,oGet:aHeader,oGet:aCols)
	EndIF

return

Static Function fValidPrd

	Local cAliasSQL := ''

	cAliasSQL := getNextAlias()

	BeginSQL alias cAliasSQL
		SELECT * FROM %table:Z52% Z52
		WHERE Z52.%notdel%
		AND Z52_FILIAL = %exp:xFilial('Z52')%
		AND Z52_NUMERO = %exp:cNumZ51%
		AND Z52_CODPRD = %exp:&(readvar())%
	EndSQL

	nRecZ52 := 0

	(cAliasSQL)->(dbEval({|| nRecZ52 := R_E_C_N_O_}),dbCloseArea())

	IF nRecZ52 == 0
		M->Z53_CODPRD := space(tamSX3('Z53_CODPRD')[1])
		fwAlertError('Produto nao encontrado no contrato','Erro')
		return .F.
	EndIF

	Z52->(dbSetOrder(1),dbGoTo(nRecZ52))	

	nLinha  := oGet:nAt
	aHeader := oGet:aHeader
	aCols   := oGet:aCols

	gdFieldPut('Z53_DESPRD',Z52->Z52_DESPRD,nLinha,aHeader,aCols)
	gdFieldPut('Z53_LOCEST',Z52->Z52_LOCEST,nLinha,aHeader,aCols)

return .T.

/*/{Protheus.doc} fnGravar
	Funcao axiliar para gravacao
	@type  Static Function
	/*/
Static Function fnGravar(nOpc,aHeader,aCols)

	Local x,y
	Local cCampo
	Local xConteudo
	Local aLinha[0]
	Local lDelete
	Local lFound

	BEGIN TRANSACTION  //-- ABERTURA DO CONTROLE DE TRANSACOES

	DO CASE 

		CASE nOpc == 3 //-- Inclusao

			For x := 1 To Len(aCols)

				aLinha  := aClone(aCols[x])
				lDelete := aLinha[Len(aLinha)]

				IF lDelete 
					Loop
				EndIF			

				Z53->(reclock(alias(),.T.))

                    Z53->Z53_FILIAL     := xFilial('Z53')
                    Z53->Z53_NUMERO     := cNumZ51
                    Z53->Z53_NUMMED     := cNumZ53
                    Z53->Z53_EMISSA     := dEmisZ53
                    Z53->Z53_TIPO       := cNumZ50                    
					
                    For y := 1 To Len(aHeader)
						cCampo 			:= aHeader[y,2]
						xConteudo		:= aCols[x,y]
						Z53->&(cCampo) 	:= xConteudo
					Next

				Z53->(msunlock())

			Next

		CASE nOpc == 4 //-- Alteracao

			//-- GRAVACAO DOS ITENS
			For x := 1 To Len(aCols)

				//-- Posiciona no registro
				Z53->(dbSetOrder(1),dbSeek(xFilial(alias())+cNumZ51+cNumZ53+aCols[x,1]))

				lFound := Z53->(Found())

				aLinha  := aClone(aCols[x])
				lDelete := aLinha[Len(aLinha)]

				IF lDelete 

					IF lFound
						Z53->(reclock(alias(),.F.),dbDelete(),msunlock())
					EndIF

					Loop

				EndIF	

				lInc := .not. lFound		

				Z53->(reclock(alias(),lInc))

                    Z53->Z53_FILIAL     := xFilial('Z53')
                    Z53->Z53_NUMERO     := cNumZ51
                    Z53->Z53_NUMMED     := cNumZ53
                    Z53->Z53_EMISSA     := dEmisZ53
                    Z53->Z53_TIPO       := cNumZ50                 
					
					For y := 1 To Len(aHeader)
						cCampo 			:= aHeader[y,2]
						xConteudo		:= aCols[x,y]
						Z53->&(cCampo) 	:= xConteudo
					Next

				Z53->(msunlock())

			Next				

		CASE nOpc == 5 //-- Exclusao

			//-- Posiciona no registro
			Z53->(dbSetOrder(1),dbSeek(xFilial(alias())+cNumZ51+cNumZ53))  

            IF Z53->(Found())
                
                While .T.
                    
                    Z53->(reclock(alias(),.F.), dbDelete(),msunlock())
                    Z53->(dbSkip())

                    IF Z53->(eof())
                        Exit
                    EndIF

                    IF .not. Z53->(Z53_FILIAL+Z53_NUMERO+Z53_NUMMED) == xFilial('Z53')+cNumZ51+cNumZ53
                        Exit
                    EndIF 

                Enddo

            EndIF

	END CASE

	//-- atualiza indicadores do contrato
	U_ATUALIZA_INDICADORES_DO_CONTRATO()

	END TRANSACTION    //-- ENCERRAMENTO DO CONTROLE DE TRANSACOES

Return 

/*/{Protheus.doc} fnGetHeader
	Funcao que gera as configuracoes dos campos da msNewGetDados
	@type  Static Function
	/*/
Static Function fnGetHeader

	Local aHeader := array(0)
	Local aAux	  := array(0)

	SX3->(dbSetOrder(1),dbSeek("Z53"))

	While .not. SX3->(eof()) .and. SX3->X3_ARQUIVO == 'Z53'

		IF alltrim(SX3->X3_CAMPO) $ 'Z53_FILIAL|Z53_NUMERO|Z53_NUMMED|Z53_EMISSAO|Z53_TIPO'
			SX3->(dbSkip())
			Loop
		EndIF			

		aAux := {}
		aadd(aAux,SX3->X3_TITULO	)
		aadd(aAux,SX3->X3_CAMPO 	)
		aadd(aAux,SX3->X3_PICTURE	)
		aadd(aAux,SX3->X3_TAMANHO	)
		aadd(aAux,SX3->X3_DECIMAL	)
		aadd(aAux,SX3->X3_VALID		)
		aadd(aAux,SX3->X3_USADO		)
		aadd(aAux,SX3->X3_TIPO		)
		aadd(aAux,SX3->X3_F3		)
		aadd(aAux,SX3->X3_CONTEXT	)
		aadd(aAux,SX3->X3_CBOX		)
		aadd(aAux,SX3->X3_RELACAO	)
		aadd(aAux,SX3->X3_WHEN		)
		aadd(aAux,SX3->X3_VISUAL	)
		aadd(aAux,SX3->X3_VLDUSER	)
		aadd(aAux,SX3->X3_PICTVAR	)
		aadd(aAux,SX3->X3_OBRIGAT	)

		aadd(aHeader,aAux)
		SX3->(dbSkip())

	Enddo
	
Return aHeader

/*/{Protheus.doc} fnGetCols
	Retorna o conteudo do vetor aCols
	@type  Static Function
	/*/
Static Function fnGetCols(nOpc,aHeader)

	Local aCols     := array(0)
	Local aAux      := array(0)
    Local aAreaZ53  := Z53->(getArea())

	IF nOpc == 3 //-- Operacao de inclusao
		aEval(aHeader,{|x| aadd(aAux,criavar(x[2],.T.))})
		aAux[1] := '001'
		aadd(aAux,.F.)
		aadd(aCols,aAux)
		return aCols
	EndIF

	//-- Alteracao + Visualização + Exclusao
    cChaveZ53 := Z53->(Z53_FILIAL+Z53_NUMERO+Z53_NUMMED)
	Z53->(dbSetOrder(1),dbSeek(cChaveZ53))

	While .not. Z53->(eof()) .and. Z53->(Z53_FILIAL+Z53_NUMERO+Z53_NUMMED) == cChaveZ53
		aAux  := {}
		aEval(aHeader,{|x| aadd(aAux,Z53->&(x[2]))})
		aadd(aAux,.F.)
		aadd(aCols,aAux)
		Z53->(dbSkip())
	Enddo

    restArea(aAreaZ53)
	
Return aCols

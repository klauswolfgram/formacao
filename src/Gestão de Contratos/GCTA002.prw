#include 'totvs.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} U_GCTA002
    Exemplo de programa prototipo modelo 3 - advpl tradicional
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
Function U_CGTA002

	Private cTitulo 	:= 'Cadastro de Contratos - Prototipo Modelo 3'
	Private aRotina[0]	
	
	//-- Montagem do array de itens do menu
	aadd(aRotina,{'Pesquisar'	,'AxPesqui'		,0,1})
	aadd(aRotina,{'Visualizar'	,'U_GCTA002M'	,0,2})
	aadd(aRotina,{'Incluir'		,'U_GCTA002M'	,0,3})
	aadd(aRotina,{'Alterar'		,'U_GCTA002M'	,0,4})
	aadd(aRotina,{'Excluir'		,'U_GCTA002M'	,0,5})	
	
	//-- Montagem da tela principal
	Z51->(dbSetOrder(1),mBrowse(,,,,alias())) 
    
Return 

Function U_GCTA002M(cAlias,nReg,nOpc)

	Local oDlg
	Local aAdvSize := msAdvSize()
	Local aInfo	   := {aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],3,3}
	Local aObj	   := {{100,120,.T.,.F.},{100,100,.T.,.T.},{100,010,.T.,.F.}}
	Local aPObj	   := msObjSize(aInfo,aObj)
	Local nStyle   := GD_INSERT+GD_UPDATE+GD_DELETE
	Local nSalvar  := 0
	Local bSalvar  := {|| if(obrigatorio(aGets,aTela),(nSalvar := 1, oDlg:end()),nil)}
	Local bCancelar:= {|| (nSalvar := 0, oDlg:end())}
	Local aButtons := array(0)
	Local aHeader  := fnGetHeader()
	Local aCols	   := fnGetCols(nOpc,aHeader)

	Private oGet
	Private aGets  := array(0)
	Private aTela  := array(0)

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
	regToMemory(cAlias,if(nOpc == 3,.T.,.F.),.T.)
	M->Z51_NUMERO := if(nOpc == 3, getSxeNum('Z51','Z51_NUMERO'),Z51->Z51_NUMERO)
	msmGet():new(cAlias,nReg,nOpc,,,,,aPObj[1])
	enchoicebar(oDlg,bSalvar,bCancelar,,aButtons)

	//-- Area de Itens
	oGet := msNewGetDados():new(aPObj[2,1] 		,; //-- Cordenada inicial, Linha inicial
								aPObj[2,2] 		,; //-- Cordenada inicial, Coluna inicial
								aPObj[2,3] 		,; //-- Cordenada final  , Coluna final
								aPObj[2,4] 		,; //-- Cordenada final  , Linha final
								nStyle	   		,; //-- Opcoes que podem ser executadas
								'U_GCTA002V(1)'	,; //-- Validacao de mudanca de linha
								'U_GCTA002V(2)'	,; //-- Validacao final
								'+Z52_ITEM'		,; //-- Definicao do campo incremental
								NIL		   		,; //-- Lista dos campos que podem ser alterados
								0		   		,; //-- Fixo
								9999	   		,; //-- Total de linhas 
								'U_GCTA002V(3)'	,; //-- Funcao que validara cada campo preenchido
								Nil		 		,; //-- Fixo
								'U_GCTA002V(4)'	,; //-- Funcao que ira validar se a linha pode ser deletada
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

/*/{Protheus.doc} U_GCTA002V
	Valida linhas do Grid
	@type  Function
	/*/
Function U_GCTA002V(nOpcao)

	Local lValid := .T.

	IF nOpcao == 1 //-- Validacao de mudanca de linha
		lValid := oGet:chkObrigat(n)
	ElseIF nOpcao == 2 //-- Validacao final
	ElseIF nOpcao == 3 //-- Validacao de campos
	ElseIF nOpcao == 4 //-- Validacao de delecao da linha		
	EndIF
	
Return lValid

/*/{Protheus.doc} fnGravar
	Funcao axiliar para gravacao
	@type  Static Function
	/*/
Static Function fnGravar(nOpc,aHeader,aCols)

	Local x,y
	Local nCampos
	Local cCampo
	Local xConteudo
	Local aLinha[0]
	Local lDelete
	Local lFound

	BEGIN TRANSACTION  //-- ABERTURA DO CONTROLE DE TRANSACOES

	DO CASE 

		CASE nOpc == 3 //-- Inclusao

			nCampos := Z51->(fCount())

			//-- Gravacao dos dados do cabecalho
			Z51->(reclock(alias(),.T.))
				For x := 1 To nCampos
					Z51->&(fieldname(x)) := M->&(fieldname(x))
				Next
				Z51->Z51_FILIAL := xFilial('Z51')
			Z51->(msunlock())

			For x := 1 To Len(aCols)

				aLinha  := aClone(aCols[x])
				lDelete := aLinha[Len(aLinha)]

				IF lDelete 
					Loop
				EndIF			

				Z52->(reclock(alias(),.T.))
					For y := 1 To Len(aHeader)
						cCampo 			:= aHeader[y,2]
						xConteudo		:= aCols[x,y]
						Z52->&(cCampo) 	:= xConteudo
					Next

					Z52->Z52_FILIAL		:= xFilial('Z52')
					Z52->Z52_NUMERO		:= M->Z51_NUMERO
				Z52->(msunlock())

			Next

		CASE nOpc == 4 //-- Alteracao

			nCampos := Z51->(fCount())

			Z51->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z51_NUMERO))

			lFound := Z51->(Found())

			//-- Gravacao dos dados do cabecalho
			Z51->(reclock(alias(),.F.))
				For x := 1 To nCampos
					Z51->&(fieldname(x)) := M->&(fieldname(x))
				Next
				Z51->Z51_FILIAL := xFilial('Z51')
			Z51->(msunlock())	

			//-- GRAVACAO DOS ITENS
			For x := 1 To Len(aCols)

				//-- Posiciona no registro
				Z52->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z51_NUMERO+aCols[x,1]))

				lFound := Z52->(Found())

				aLinha  := aClone(aCols[x])
				lDelete := aLinha[Len(aLinha)]

				IF lDelete 

					IF lFound
						Z52->(reclock(alias(),.F.),dbDelete(),msunlock())
					EndIF

					Loop

				EndIF	

				lInc := .not. lFound		

				Z52->(reclock(alias(),lInc))
					
					For y := 1 To Len(aHeader)
						cCampo 			:= aHeader[y,2]
						xConteudo		:= aCols[x,y]
						Z52->&(cCampo) 	:= xConteudo
					Next

					Z52->Z52_FILIAL		:= xFilial('Z52')
					Z52->Z52_NUMERO		:= M->Z51_NUMERO

				Z52->(msunlock())

			Next				

		CASE nOpc == 5 //-- Exclusao

			Z52->(dbSetOrder(1),dbSeek(xFilial(alias())+Z51->Z51_NUMERO))

			While .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
				Z52->(reclock(alias(),.F.), dbDelete(),msunlock(),dbSkip())
			Enddo

			Z51->(reclock(alias(),.F.), dbDelete(), msunlock())

	END CASE

	END TRANSACTION    //-- ENCERRAMENTO DO CONTROLE DE TRANSACOES

Return 

/*/{Protheus.doc} fnGetHeader
	Funcao que gera as configuracoes dos campos da msNewGetDados
	@type  Static Function
	/*/
Static Function fnGetHeader

	Local aHeader := array(0)
	Local aAux	  := array(0)

	SX3->(dbSetOrder(1),dbSeek("Z52"))

	While .not. SX3->(eof()) .and. SX3->X3_ARQUIVO == 'Z52'

		IF alltrim(SX3->X3_CAMPO) $ 'Z52_FILIAL|Z52_NUMERO'
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

	Local aCols := array(0)
	Local aAux  := array(0)

	IF nOpc == 3 //-- Operacao de inclusao
		aEval(aHeader,{|x| aadd(aAux,criavar(x[2],.T.))})
		aAux[1] := '001'
		aadd(aAux,.F.)
		aadd(aCols,aAux)
		return aCols
	EndIF

	//-- Alteracao + Visualização + Exclusao
	Z52->(dbSetOrder(1),dbSeek(Z51->(Z51_FILIAL+Z51_NUMERO)))

	While .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
		aAux := {}
		aEval(aHeader,{|x| aadd(aAux,Z52->&(x[2]))})
		aadd(aAux,.F.)
		aadd(aCols,aAux)
		Z52->(dbSkip())
	Enddo
	
Return aCols

#include 'totvs.ch'

/*/{Protheus.doc} User Function CLASS001
    Classe para manutencao de dicionarios de dados
    @type  class
    @author Klaus Wolfgram
    @since 10/09/2021
    @version 1.0
    /*/

//-- Classe para manutencao de registros da tabela SX2
class class_sxs

    data arq_sx1
    data arq_sx2      
    data arq_sx3
    data arq_sx7
    data arq_six
    data arq_sxb

    method new() constructor

    method put_sx1()
    method put_sx2()
    method put_sx3()
    method put_sx7()
    method put_six()
    method put_sxb()
    
    method upd_sxs()

endclass

//-- metodo construtor da classe class_sxs
method new() class class_sxs

    self:arq_sx1    := array(1,class_sx1():new())
    self:arq_sx2    := class_sx2():new()
    self:arq_sx3    := array(1,class_sx3():new())
    self:arq_sx7    := class_sx7():new()
    self:arq_six    := class_six():new()
    self:arq_sxb    := array(1,class_sxb():new())

return self

//-- metodo para atualizacao de base de dados
method upd_sxs(cTabela,lShowMsg) class class_sxs

    Default cTabela     := ''
    Default lShowMsg    := .F.

    IF empty(cTabela)

        IF lShowMsg
            msgerror('Tabela não informada')
        EndIF

        return .F.

    EndIF    

    IF chkfile(cTabela)

        IF select(cTabela) > 0
            (cTabela)->(dbclosearea())
        EndIF    

        __setx31mode(.F.)
        
        dbSelectArea('SX2')
        dbSetOrder(1)
        dbSeek(cTabela)

        x31updtable(cTabela)

        IF __getx31error()
            msgstop(__getx31trace())
            return .F.
        EndIF

        IF lShowMsg
            msgInfo('Tabela ' + cTabela + ' atualizada')    
        EndIF 

        return .T.

    Else

        IF lShowMsg
            msgInfo('Tabela ' + cTabela + ' não encontrada.')
        EndIF    

        return .F.    

    EndIF

return .T.

//-- metodo para inclusao de registros na tabela SX1
method put_sx1(lShowMsg) class class_sxs

    Local aPergs := array(0)
    Local lInc   := .T.
    Local x

    Default lShowMsg := .F.

    IF valType(self:arq_sx1) <> 'A'

        IF lShowMsg
            msgstop(oemtoansi('Dados inválidos na propriedade arq_sx1'))
        EndIF

        return .F.

    EndIF

    IF empty(self:arq_sx1)

        IF lShowMsg
            msgstop(oemtoansi('Array vázio na propriedade arq_sx1'))
        EndIF

        return .F.
        
    EndIF

    aPergs := aclone(self:arq_sx1)

    SX1->(dbSetOrder(1))   

    For x := 1 To Len(aPergs)

        IF empty(aPergs[x]:x1_grupo)
            Loop
        EndIF

        lInc := .not. SX1->(dbSeek(padr(alltrim(aPergs[x]:x1_grupo),10) + strzero(val(aPergs[x]:x1_ordem),2)))

        SX1->(reclock('SX1',lInc))
            SX1->X1_GRUPO      := padr(alltrim(aPergs[x]:x1_grupo),10)
            SX1->X1_ORDEM      := strzero(val(aPergs[x]:x1_ordem),2)
            SX1->X1_PERGUNT    := aPergs[x]:x1_pergunt
            SX1->X1_PERSPA     := aPergs[x]:x1_pergunt
            SX1->X1_PERENG     := aPergs[x]:x1_pergunt
            SX1->X1_VARIAVL    := aPergs[x]:x1_variavl
            SX1->X1_TIPO       := aPergs[x]:x1_tipo
            SX1->X1_TAMANHO    := aPergs[x]:x1_tamanho
            SX1->X1_DECIMAL    := aPergs[x]:x1_decimal
            SX1->X1_PRESEL     := aPergs[x]:x1_presel
            SX1->X1_GSC        := aPergs[x]:X1_gsc
            SX1->X1_VALID      := aPergs[x]:x1_valid
            SX1->X1_VAR01      := aPergs[x]:x1_var01
            SX1->X1_DEF01      := aPergs[x]:x1_def01
            SX1->X1_DEFSPA01   := aPergs[x]:x1_def01
            SX1->X1_DEFENG01   := aPergs[x]:x1_def01
            SX1->X1_CNT01      := aPergs[x]:x1_cnt01 
            SX1->X1_VAR02      := aPergs[x]:x1_var02
            SX1->X1_DEF02      := aPergs[x]:x1_def02
            SX1->X1_DEFSPA02   := aPergs[x]:x1_def02
            SX1->X1_DEFENG02   := aPergs[x]:x1_def02
            SX1->X1_CNT02      := aPergs[x]:x1_cnt02
            SX1->X1_VAR03      := aPergs[x]:x1_var03
            SX1->X1_DEF03      := aPergs[x]:x1_def03
            SX1->X1_DEFSPA03   := aPergs[x]:x1_def03
            SX1->X1_DEFENG03   := aPergs[x]:x1_def03
            SX1->X1_CNT03      := aPergs[x]:x1_cnt03
            SX1->X1_VAR04      := aPergs[x]:x1_var04
            SX1->X1_DEF04      := aPergs[x]:x1_def04
            SX1->X1_DEFSPA04   := aPergs[x]:x1_def04
            SX1->X1_DEFENG04   := aPergs[x]:x1_def04
            SX1->X1_CNT04      := aPergs[x]:x1_cnt04
            SX1->X1_VAR05      := aPergs[x]:x1_var05
            SX1->X1_DEF05      := aPergs[x]:x1_def05
            SX1->X1_DEFSPA05   := aPergs[x]:x1_def05
            SX1->X1_DEFENG05   := aPergs[x]:x1_def05
            SX1->X1_CNT05      := aPergs[x]:x1_cnt05     
            SX1->X1_F3         := aPergs[x]:x1_f3
            SX1->X1_GRPSXG     := aPergs[x]:x1_grpsxg                                           
        SX1->(msUnlock())

    Next     

return .T.

//-- metodo para inclusao do registro na tabela SX2
method put_sx2(lShowMsg) class class_sxs

    Default lShowMsg := .F.

    IF valType(self:arq_sx2) <> 'O'
        msgstop(oemtoansi('Objeto SX2 inválido'))
        return .F.
    EndIF    

    IF empty(self:arq_sx2:x2_chave)
        msgstop(oemtoansi('Conteúdo inválido para o campo x2_chave'))
        return .F.
    EndIF

    IF SX2->(dbSetOrder(1),dbSeek(self:arq_sx2:x2_chave))
        msgstop(oemtoansi('A tabela já existe no banco de dados'))
        return .F.
    EndIF

    SX2->(reclock('SX2',.T.))
        SX2->X2_CHAVE   := self:arq_sx2:x2_chave
        SX2->X2_PATH    := self:arq_sx2:x2_path
        SX2->X2_ARQUIVO := self:arq_sx2:x2_arquivo
        SX2->X2_NOME    := self:arq_sx2:x2_descri
        SX2->X2_NOMESPA := self:arq_sx2:x2_descri
        SX2->X2_NOMEENG := self:arq_sx2:x2_descri
        SX2->X2_ROTINA  := self:arq_sx2:x2_rotina
        SX2->X2_MODO    := self:arq_sx2:x2_modo
        SX2->X2_MODOUN  := self:arq_sx2:x2_modoun
        SX2->X2_MODOEMP := self:arq_sx2:x2_modoemp
        SX2->X2_DELET   := self:arq_sx2:x2_delete
        SX2->X2_MODULO  := self:arq_sx2:x2_modulo
        SX2->X2_UNICO   := self:arq_sx2:x2_unico
    SX2->(msUnlock())  

    IF lShowMsg
        msgInfo(oemtoansi('Registro incluído com sucesso na tabela SX2.'))
    EndIF      

return .T.

//-- metodo para inclusao dos registros no arquivo sx3
method put_sx3(lShowMsg) class class_sxs

    Local x 
    Local aCampos[0]
//  Local cOrdemSX3     := ''

    Default lShowMsg    := .F.

    IF valType(self:arq_sx3) <> 'A'

        IF lShowMsg
            msgstop(oemtoansi('Dados inválidos na propriedade arq_sx3'))
        EndIF

        return .F.

    EndIF

    IF empty(self:arq_sx3)

        IF lShowMsg
            msgstop(oemtoansi('Array vázio na propriedade arq_sx3'))
        EndIF

        return .F.
        
    EndIF

    aCampos := self:arq_sx3

    SX3->(dbSetOrder(1))

    For x := 1 To Len(aCampos)

        IF empty(aCampos[x]:x3_campo)
            Loop
        EndIF

        IF empty(aCampos[x]:x3_arquivo)
            Loop
        EndIF        

        IF SX3->(dbSetOrder(2),dbSeek(aCampos[x]:x3_campo))
            Loop
        EndIF

        oAux            := aCampos[x]

        //cOrdemSX3     := getord('SX3',2,oAux:x3_arquivo)

        SX3->(reclock('SX3',.T.))
            SX3->X3_ARQUIVO := oAux:x3_arquivo
            SX3->X3_ORDEM   := oAux:x3_ordem
            SX3->X3_CAMPO   := oAux:x3_campo
            SX3->X3_TIPO    := oAux:x3_tipo
            SX3->X3_TAMANHO := oAux:x3_tamanho
            SX3->X3_DECIMAL := oAux:x3_decimal
            SX3->X3_TITULO  := oAux:x3_titulo
            SX3->X3_TITSPA  := oAux:x3_titulo
            SX3->X3_TITENG  := oAux:x3_titulo
            SX3->X3_DESCRIC := oAux:x3_descric
            SX3->X3_DESCSPA := oAux:x3_descric
            SX3->X3_DESCENG := oAux:x3_descric
            SX3->X3_PICTURE := oAux:x3_picture
            SX3->X3_VALID   := oAux:x3_valid
            SX3->X3_USADO   := oAux:x3_usado
            SX3->X3_RELACAO := oAux:x3_relacao
            SX3->X3_F3      := oAux:x3_f3
            SX3->X3_NIVEL   := oAux:x3_nivel
            SX3->X3_RESERV  := oAux:x3_reserv
            SX3->X3_PROPRI  := oAux:x3_propri
            SX3->X3_BROWSE  := oAux:x3_browse
            SX3->X3_VISUAL  := oAux:x3_visual
            SX3->X3_CONTEXT := oAux:x3_context
            SX3->X3_OBRIGAT := oAux:x3_obrigat
            SX3->X3_VLDUSER := oAux:x3_vlduser
            SX3->X3_CBOX    := oAux:x3_cbox
            SX3->X3_CBOXSPA := oAux:x3_cbox
            SX3->X3_CBOXENG := oAux:x3_cbox
            SX3->X3_PICTVAR := oAux:x3_pictvar
            SX3->X3_WHEN    := oAux:x3_when
            SX3->X3_INIBRW  := oAux:x3_inibrw
            SX3->X3_GRPSXG  := oAux:x3_grpsxg
            SX3->X3_FOLDER  := oAux:x3_folder
            SX3->X3_ORTOGRA := oAux:x3_ortogra
            SX3->X3_IDXFLD  := oAux:x3_idxfld
        SX3->(msUnlock())

    Next

    IF lShowMsg
        msgInfo(oemtoansi('Campos incluídos'))
    EndIF    

return .T.

//-- Recupera ordem disponivel para uso
Static Function getord(cArq,nIndice,cParam)

    Local cOrdem
    Local aAreaSX3  := SX3->(getarea())
    Local aAreaSX7  := SX7->(getarea())
    
    Default cArq    := ''
    Default nIndice := 1
    Default cParam  := ''

    IF empty(cArq)
        return '01'
    EndIF   

    IF cArq == 'SX3'

        IF .not. &(cArq)->(dbSetOrder(nIndice),dbSeek(cParam))
            restarea(aAreaSX3)
            return '01'
        EndIF    

        While .not. SX3->(eof()) .and. alltrim(SX3->X3_ARQUIVO) == alltrim(cParam)
            cOrdem := alltrim(SX3->X3_ORDEM)
            SX3->(dbSkip())
        Enddo 

    ElseIF cArq == 'SX7'    

        IF .not. SX7->(dbSetOrder(1),dbSeek(cParam))
            restarea(aAreaSX7)
            return '001'
        EndIF    

        While .not. SX7->(eof()) .and. alltrim(SX7->X7_CAMPO) == alltrim(cParam)

            cOrdem := SX7->X7_SEQUENC
            SX7->(dbSkip())

        Enddo    

    EndIF

    cOrdem := soma1(cOrdem)

    restarea(aAreaSX3)
    restarea(aAreaSX7)

Return cOrdem

//-- metodo para inclusao de registro no arquivo SX7
method put_sx7(lShowMsg) class class_sxs

    Local cSequenc := ''

    IF valType(self:arq_sx7) <> 'O'
        
        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido na propriedade arq_sx7'))
        EndIF  

        return .F.

    EndIF    

    IF empty(self:arq_sx7:x7_campo)
        
        IF lShowMsg
            msgstop(oemtoansi('Conteúdo invalido para propriedade x7_campo'))
        EndIF

        return .F.

    EndIF

    IF empty(self:arq_sx7:x7_cdomin)

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido para propriedade x7_cdomin'))
        EndIF

        return .F.

    EndIF

    IF empty(self:arq_sx7:x7_regra)

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido para propriedade x7_regra'))
        EndIF

        return .F.

    EndIF   

    cSequenc := getord('SX7',1,self:arq_sx7:x7_campo)

    SX7->(dbSetOrder(1),reclock('SX7',.T.))
        SX7->X7_CAMPO   := self:arq_sx7:x7_campo
        SX7->X7_SEQUENC := cSequenc
        SX7->X7_REGRA   := self:arq_sx7:x7_regra
        SX7->X7_CDOMIN  := self:arq_sx7:x7_cdomin
        SX7->X7_TIPO    := self:arq_sx7:x7_tipo
        SX7->X7_SEEK    := self:arq_sx7:x7_seek
        SX7->X7_ALIAS   := self:arq_sx7:x7_alias
        SX7->X7_ORDEM   := self:arq_sx7:x7_ordem
        SX7->X7_CHAVE   := self:arq_sx7:x7_chave
        SX7->X7_CONDIC  := self:arq_sx7:x7_condic
        SX7->X7_PROPRI  := self:arq_sx7:x7_propri
    SX7->(msUnlock())   

    IF SX3->(dbSetOrder(2),dbSeek(self:arq_sx7:x7_campo))
        SX3->(reclock('SX3',.F.),X3_TRIGGER := 'S',msUnlock())
    EndIF     

    IF lShowMsg
        msgInfo(oemtoansi('Gatilho incluído com sucesso')) 
    EndIF     

Return .T.

//-- Metodo para inclusao de registro no arquivo SIX
method put_six(lShowMsg) class class_sxs

    Default lShowMsg := .F.

    IF valType(self:arq_six) <> 'O'

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido na propriedade arq_six'))
        EndIF

        return .F.

    EndIF    

    IF empty(self:arq_six:ix_indice)

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo invalido para propriedade ix_indice'))
        EndIF

        return .F.

    EndIF

    IF SIX->(dbSetOrder(1),dbSeek(self:arq_six:ix_indice+self:arq_six:ix_ordem))
//      msgInfo(oemtoansi('Indice ' + self:arq_six:ix_indice + ' ordem ' + self:arq_six:ix_ordem + ' criado anteriormente'))
        return .T.
    EndIF

    SIX->(reclock('SIX',.T.))
        SIX->INDICE     := self:arq_six:ix_indice
        SIX->ORDEM      := self:arq_six:ix_ordem
        SIX->CHAVE      := self:arq_six:ix_chave
        SIX->DESCRICAO  := self:arq_six:ix_descricao
        SIX->DESCSPA    := self:arq_six:ix_descricao
        SIX->DESCENG    := self:arq_six:ix_descricao
        SIX->PROPRI     := self:arq_six:ix_propri
        SIX->SHOWPESQ   := self:arq_six:ix_showpesq
    SIX->(msUnlock())    

    IF lShowMsg
        msgInfo(oemtoansi('Indice incluído do sucesso'))
    EndIF    

return .T.

//-- classe para manutencao do arquivo sxb
method put_sxb(lShowMsg) class class_sxs

    Local aSXB := self:arq_sxb
    Local x

    Default lShowMsg := .F.

    IF valType(aSXB) <> 'A'

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido na propriedade arq_sxb'))
        EndIF

        return .F.

    EndIF

    IF empty(aSXB)

        IF lShowMsg
            msgstop(oemtoansi('Conteúdo inválido na propriedade arq_sxb'))
        EndIF

        return .F.

    EndIF

    IF SXB->(dbSetOrder(1),dbSeek(aSXB[1]:xb_alias))
        return .T.
    EndIF

    For x := 1 To Len(aSXB)

        SXB->(reclock('SXB',.T.))
            SXB->XB_ALIAS   := aSXB[x]:xb_alias
            SXB->XB_TIPO    := aSXB[x]:xb_tipo
            SXB->XB_SEQ     := aSXB[x]:xb_seq
            SXB->XB_COLUNA  := aSXB[x]:xb_coluna
            SXB->XB_DESCRI  := aSXB[x]:xb_descri
            SXB->XB_DESCSPA := aSXB[x]:xb_descri
            SXB->XB_DESCENG := aSXB[x]:xb_descri
            SXB->XB_CONTEM  := aSXB[x]:xb_contem
        SXB->(msUnlock())

    Next    

    IF lShowMsg
        msgInfo(oemtoansi('Consulta padrão incluída com sucesso'))
    EndIF    

return .T.

//-- classe para manutencao do arquivo sx1
class class_sx1
    
    data x1_grupo   
    data x1_ordem   
    data x1_pergunt 
    data x1_variavl  
    data x1_tipo 
    data x1_tamanho    
    data x1_decimal 
    data x1_presel 
    data X1_gsc  
    data x1_valid 
    data x1_var01
    data x1_def01
    data x1_cnt01
    data x1_var02
    data x1_def02
    data x1_cnt02
    data x1_var03
    data x1_def03
    data x1_cnt03
    data x1_var04
    data x1_def04
    data x1_cnt04
    data x1_var05
    data x1_def05 
    data x1_cnt05
    data x1_f3
    data x1_grpsxg

    method new() constructor

endclass

//-- metodo construtor da classe
method new() class class_sx1

    self:x1_grupo   := ''
    self:x1_ordem   := '01'
    self:x1_pergunt := ''
    self:x1_variavl := '' 
    self:x1_tipo    := 'C'
    self:x1_tamanho := 0   
    self:x1_decimal := 0
    self:x1_presel  := 0
    self:X1_gsc     := 'G'
    self:x1_valid   := ''
    self:x1_var01   := ''
    self:x1_def01   := ''
    self:x1_cnt01   := ''
    self:x1_var02   := ''
    self:x1_def02   := ''
    self:x1_cnt02   := ''
    self:x1_var03   := ''
    self:x1_def03   := ''
    self:x1_cnt03   := ''
    self:x1_var04   := ''
    self:x1_def04   := ''
    self:x1_cnt04   := ''
    self:x1_var05   := ''
    self:x1_def05   := '' 
    self:x1_cnt05   := ''
    self:x1_f3      := ''
    self:x1_grpsxg  := ''

return self

//-- classe para manutencao do arquivo sx2
class class_sx2
    
    data x2_chave   
    data x2_path    
    data x2_arquivo 
    data x2_descri   
    data x2_rotina  
    data x2_modo    
    data x2_modoun  
    data x2_modoemp 
    data X2_delete  
    data x2_modulo 
    data x2_unico 

    method new() constructor

endclass

//-- metodo construtor da classe
method new() class class_sx2

    self:x2_chave   := ''
    self:x2_path    := ''
    self:x2_arquivo := ''
    self:x2_descri  := ''
    self:x2_rotina  := ''
    self:x2_modo    := 'E'
    self:x2_modoun  := 'E'
    self:x2_modoemp := 'E'
    self:X2_delete  := 0 
    self:x2_modulo  := 0
    self:x2_unico   := '' 

return self

//-- classe para manutencao do arquivo sx3
class class_sx3

    data x3_arquivo        
    data x3_ordem       
    data x3_campo        
    data x3_tipo        
    data x3_tamanho  
    data x3_decimal      
    data x3_titulo        
    data x3_descric
    data x3_picture
    data x3_valid
    data x3_usado
    data x3_relacao
    data x3_nivel
    data x3_reserv
    data x3_propri
    data x3_browse
    data x3_visual
    data x3_context
    data x3_f3
    data x3_obrigat
    data x3_vlduser
    data x3_cbox
    data x3_pictvar
    data x3_when
    data x3_inibrw
    data x3_grpsxg
    data x3_folder
    data x3_ortogra
    data x3_idxfld   

    method new() constructor

endclass

method new() class class_sx3

    self:x3_arquivo := ''       
    self:x3_ordem   := '01'       
    self:x3_campo   := ''        
    self:x3_tipo    := 'C'        
    self:x3_tamanho := 1   
    self:x3_tamanho := 0     
    self:x3_titulo  := ''        
    self:x3_descric := self:x3_titulo
    self:x3_picture := ''
    self:x3_valid   := ''
    self:x3_usado   := 'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     '
    self:x3_relacao := ''
    self:x3_nivel   := 0
    self:x3_reserv  := 'xxxxxx x        '
    self:x3_propri  := 'U'
    self:x3_browse  := 'S'
    self:x3_visual  := 'A'
    self:x3_context := 'R'
    self:x3_obrigat := ''
    self:x3_f3      := ''
    self:x3_vlduser := ''
    self:x3_cbox    := ''
    self:x3_pictvar := ''
    self:x3_when    := ''
    self:x3_inibrw  := ''
    self:x3_grpsxg  := ''
    self:x3_folder  := ''
    self:x3_ortogra := 'N'
    self:x3_idxfld  := 'N'

return self

//-- classe para manutencao do arquivo sx7
class class_sx7

    data x7_campo 
    data x7_sequenc
    data x7_regra
    data x7_cdomin
    data x7_tipo
    data x7_seek
    data x7_alias
    data x7_ordem
    data x7_chave
    data x7_condic
    data x7_propri

    method new() constructor

endclass

//-- metodo construtor da classe class_sx7
method new() class class_sx7

    self:x7_campo   := ''
    self:x7_sequenc := '001'
    self:x7_regra   := ''
    self:x7_cdomin  := ''
    self:x7_tipo    := 'P'
    self:x7_seek    := 'N'
    self:x7_alias   := ''
    self:x7_ordem   := 0
    self:x7_chave   := ''
    self:x7_condic  := ''
    self:x7_propri  := 'P'

return self

//-- classe para manutencao do arquivo sxb
class class_sxb

    data xb_alias
    data xb_tipo
    data xb_seq
    data xb_descri
    data xb_contem
    data xb_coluna

    method new() constructor

endclass

//-- metodo construtor da classe class_sxb
method new() class class_sxb

    self:xb_alias := ''
    self:xb_tipo  := '1'
    self:xb_seq   := '01'
    self:xb_descri:= ''
    self:xb_contem:= ''
    self:xb_coluna:= ''

return self

//-- classe para manutencao do arquivo six
class class_six

    data ix_indice
    data ix_ordem
    data ix_chave
    data ix_descricao
    data ix_propri
    data ix_f3
    data ix_showpesq

    method new() constructor

endclass

//-- metodo construtor da classe class_six
method new() class class_six

    self:ix_indice      := ''
    self:ix_ordem       := 1
    self:ix_chave       := ''
    self:ix_descricao   := ''
    self:ix_propri      := 'U'
    self:ix_f3          := ''
    self:ix_showpesq    := 'S'

return self



#include 'totvs.ch'

/*/{Protheus.doc} U_VARIAVEIS
    Exemplo de declaracao de variaveis
    @type  Function
    @author Klaus Wolfgram
    @since 07/06/2023
    @version 1.0
    @history 07/06/2023, Klaus Wolfgram, Construcao inicial do programa
    /*/

Function U_VARIAVEIS

    Local xVar := Nil           //-- valType() => U => Variant
    Local cVar := ""            //-- valType() => C => Texto
    Local dVar := date()        //-- valType() => D => Data
    Local nVar := 99            //-- valType() => N => Numeric
    Local lVar := .T.           //-- valType() => L => Logical
    Local bVar := {|| }         //-- valType() => B => Bloco de codigo
    Local oVar := tFont():new() //-- valType() => O => Objeto
    Local aVar := array(0)      //-- valType() => A => Array

    xVar := nil
    cVar := 'Texto'
    dVar := date()
    nVar := 99
    lVar := .T.
    bVar := {|| alert('ok')}
    oVar := fwJsonObject():new()
    aVar := array(0)

Return 


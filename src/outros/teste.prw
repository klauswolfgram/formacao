#include 'totvs.ch'

/*/{Protheus.doc} buscaCliALD
Exemplo de funcao para processo de estagio.
@type user function
@author Jesse Carlos Furtuoso Goncalves Tan Huare
@since 19/04/2026
@version 1.0

@see https://tdn.totvs.com/display/public/framework/rpcsetenv
@see https://tdn.totvs.com/display/public/framework/BEGIN+SEQUENCE+...+END
@see https://tdn.totvs.com/display/public/framework/fwinputbox
@see https://tdn.totvs.com/display/public/framework/alltrim
@see https://tdn.totvs.com/display/public/framework/dbusearea
@see https://tdn.totvs.com/display/public/framework/dbSelectArea
@see https://tdn.totvs.com/display/public/framework/dbSetOrder
@see https://tdn.totvs.com/display/public/framework/dbSeek
@see https://tdn.totvs.com/display/public/framework/empty
@see https://tdn.totvs.com/pages/releaseview.action?pageId=24346996 (MSGINFO)
@see https://tdn.totvs.com/pages/releaseview.action?pageId=24346992 (MSGALERT)
@see https://tdn.totvs.com/pages/releaseview.action?pageId=24346998 (MSGSTOP)
/*/
User Function buscaCliALD()

    Local cCodigo    := space(6) // Variavel usada para armazenar o codigo do cliente a ser encontrado
    Local cLoja      := '01'     // Variavel para armazenar a loja. Nesse exemplo será assumido que todos os clientes tem loja 01.
    Local lRPC       := .F.

    // Variavel que ira receber o texto indicando o erro que ocorreu, caso ocorra 
    Local cError     := ""       

    // Nesse exemplo sera usado o controle de fluxo de execucao da funcao, por meio de BEGIN SEQUENCE / RECOVER / END SEQUENCE
    // Variavel abaixo sera usada para definir o que vai acontecer caso ocorra um erro na execucao da funcao.
    // A descricao do erro sera gravada em cError e o fluxo da execucao do programa sera desviado para o recover.
    // Pode ser que o sistema trate erros de outra forma, entao grava a forma padrao na variavel bLastError pra ser restaurado no final do programa.
    Local bLastError := errorBlock({|e| cError := e:description, break(e)}) 

    // Caso no momento da execucao desse programa não haja ambiente preparado, ou seja, não esta sendo o executado a partir do menu do protheus,
    IF type('cEmpAnt') <> 'C' 

        // prepara o ambiente para empresa 99 - Teste e filial 01 - Matriz
        rpcSetEnv('99','01') 

        // Variavel de controle para executar a rpcClearEnv caso seja necessario
        lRPC      := .T. 
    EndIF

    // Comando para iniciar o controle de sequence.
    // Usado para que, em caso de erro, o uso do protheus nao seja abortado. 
    // Ao inves disso sera mostrada a mensagem de erro definida no recover.
    BEGIN SEQUENCE

        // Mostra a tela para que o usuario digite o cliente, usando o codigo 000001 como conteudo padrao
        // Depois tira os espacos adicionais se existirem
        cCodigo   := alltrim(fwInputBox('Digite o coodigo do cliente','000001'))

        /*
        Caso a tabela nao existisse no dicionario, apenas no banco, seria necessario preparar uma area de trabalho usando a funcao dbUseArea
        Exemplo: Caso existisse uma tabela de nome CLIENTES no banco de dados, ela seria preparada com a dbUseArea usando o seguinte comando:
        dbUseArea(.T., // indica que se trata de uma nova area de trabalho, que é como nos referimos às tabelas carregadas na memoria
        "TOPCONN", // Indica que a tabela esta no banco de dados
        "CLIENTES", // nome na tabela do banco
        "CLIENTES", // nome pelo qual a tabela seria chamada
        .F., // Indica que a tabela sera aberta em modo exclusivo, que nao permite que outros programas acessem a tabeal por essa area de trabalho
        .F.  // Indica que o conteudo da tabela NÃO é somente leitura.)
        */        

        // Funcao para selecionar a tabela registrada no dicionario de dados onde sera feita a busca.
        dbSelectArea('SA1')       

        // Indica que sera usado o indice para ordenacao e busca dos clientes na tabela
        // Indice 1 = A1_FILIAL + A1_COD + A1_LOJA
        SA1->(dbSetOrder(1))  

        // usa empty() para verificar se o usuario digitou alguma coisa. Usa o ! para negacao. Nesse caso se o usuario nao deixou a variavel vazia - !empty(cCodigo) - passa para proxima funcao
        // funcao dbseek para verificar se o codigo digitado existe. Se nao existir, retorna .F.
        IF !empty(cCodigo) .Or. SA1->(dbSeek(xFilial("SA1")+cCodigo+cLoja))
            msgInfo('Cliente encontrado: ' + SA1->A1_NOME) // Mostra o nome do cliente numa mensagem informativa
        Else
            msgStop('Codigo invalido: ' + cCodigo) // mostra um alerta na mensagem de warning. O codigo pode ser vazio ou nao cadastrado.
        EndIF

    // O bloco abaixo indica o que deve acontecer caso ocorra algum erro na execucao do programa
    RECOVER
        msgStop(cError,"ERRO") // Mostra o erro gerado pelo errorBlock() registrado na variavel cError.

    //-- Encerra o fluxo de controle    
    END SEQUENCE

    // O programa ira verificar se foi executado o comando rpcSetEnv. 
    // Nesse caso sera obrigatorio a execucao do comando rpcClearEnv para que as licenças usadas não fiquem bloqueadas.
    // Fica fora do fluxo de controle para garantir que seja executado, se necessario, ocorrendo erro ou nao.
    IF lRPC == .T.
        rpcClearEnv() // Limpa o ambiente e libera as licenças selecionadas
    EndIF

    // Restaura o controle de erro existente antes da execucao do programa
    errorBlock(bLastError)

Return 

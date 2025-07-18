#include 'totvs.ch'
/*/
-> ADVPL TRADICIONAL (ADVANCED PROTHEUS LANGUAGE)
    - LINGUAGEM PROPRIETARIA DA TOTVS PARA O ERP TOTVS PROTHEUS
    - BASEADA EM CLIPER
    - AMPLAMENTE UTILIZADA NA CONSTRUÇÃO DE TELAS, PONTOS DE ENTRADA, RELATÓRIOS, ENTRE OUTROS
    - OS CODIGOS PODEM SER ESCRITOS DE FORMA PROCEDURAL OU BASEADO EM ORIENTAÇÃO A OBJETOS
    - FRACAMENTE TIPADA
    - POSSUI LIMITACOES QUANTO A QUANTIDADE DE CARACTERES QUE COMPOE NOMES DE VARIAVEIS E FUNCOES
    - AINDA DOMINANTE NO ANO DE 2023
    - MSEXECAUTO() RESPONSAVEL PELA EXECUCAO DE PROGRAMAS DE FORMA AUTOMÁTICA

-> ADVPL MVC (MODEL VIEW CONTROL)
    - ATUALIZAÇÃO DA LINGUAGEM ADVPL TRADICIONAL PARA CONSTRUÇÃO DE APLICAÇÕES BASEADAS NA ARQUITETURA MVC
    - SEPARA A APLICAÇÃO EM DIFERENTES PARTES QUE SEGUEM UM MODELO PADRAO DEFINIDO
    - OS COMPONENTES DESSE MODELO PODEM OU NAO FAZER PARTE DO MESMO ARQUIVO DE CODIGO FONTE
    - A ESTRUTURA DE UM PROGRAMA EM ADVPL MVC POSSUI OS SEGUINTES COMPONENTES:
        -> FUNCAO PRINCIPAL RESPONSAVEL PELO COMPONENTE BROWSE
        -> FUNCAO STATIC NOMEADA COMO MENUDEF, ONDE É DEFINIDA A ESTRUTURA DO MENU
        -> FUNCAO STATIC NOMEADA COMO VIEWDEF, ONDE É CONSTRUÍDA A LÓGICA DE IMPLEMENTAÇÃO DA INTERFACE GRAFICA
        -> FUNCAO STATIC NOMEADA COMO MODELDEF, ONDE É CONSTRUÍDA A LÓGICA DAS REGRAS DA APLICACAO
        -> PODE POSSUIR FUNCOES ADICIONAIS DE APOIO ÀS REGRAS DA MODELDEF
    - MUDANÇA NA LOGICA DE IMPLEMENTAÇÃO DE PONTOS DE ENTRADA
    - MUDANÇA NO CONCEITO DE ROTINAS AUTOMÁTICAS

-> TOTVS LANGUAGE PLUS PLUS (TLPP)
    - EVOLUCAO DA LINGUAGEM ADVPL TRACIONAL
    - ADICIONA NOVOS RECURSOS À LINGUAGEM
    - A DECLARACAO DE FUNÇÕES, VARIÁVEIS, ATRIBUTOS DE CLASSES E MÉTODOS PASSA A PODER SER TIPADA DE FORMA
        EXPLICITA
    - POSSUI TRATAMENTOS EM TEMPO DE COMPILAÇÃO PARA PREVENÇÃO DE ERROS
    - NÃO É COMPATIVEL COM ADVPL MVC            
/*/

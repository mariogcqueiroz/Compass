*** Settings ***
Documentation       Cenários de autenticação do usuário

Resource            ../../resources/base.resource

Test Setup          Start Session
Test Teardown       Take Screenshot

*** Test Cases ***
Deve poder logar com um usuário pré-cadastrado

    ${user}    Create Dictionary
    ...    name=Mario
    ...    email=mario@gmail.com
    ...    password=123456
    
    Remove Cinema User    ${user}
    Insert Cinema User   ${user}
    
    Submit login form           ${user}
    User should be logged in    ${user}[name]

Não deve logar com senha inválida

    ${user}    Create Dictionary
    ...    name=Steve Woz
    ...    email=woz@apple.com
    ...    password=123456
    
    Remove Cinema User    ${user}
    Insert Cinema User   ${user}

    Set To Dictionary    ${user}        password=abc123
    
    Submit login form       ${user}
    Notice should be       Ocorreu um erro ao fazer login, verifique suas credenciais.

Deve poder cadastrar um novo usuário
    ${user}    Create Dictionary
    ...    name=Mario
    ...    email=Mario@gmail.com
    ...    password=123456

    Remove Cinema User    ${user}

    Go to signup page
    Submit signup form    ${user}
    Notice should be    Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir o cadastro com email duplicado
    [Tags]    dup

    ${user}    Create Dictionary
    ...    name=Papito Fernando
    ...    email=fernando@gmail.com
    ...    password=123456

    Remove Cinema User    ${user}
    Insert Cinema User   ${user}

    Go to signup page
    Submit signup form    ${user}
    Notice should be    Oops! Já existe uma conta com o e-mail informado.

Campos obrigatórios
    [Tags]    required

    ${user}    Create Dictionary
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}

    Go to signup page
    Submit signup form    ${user}

    Alert should be    Informe seu nome completo
    Alert should be    Informe seu e-email
    Alert should be    Informe uma senha com pelo menos 6 digitos

Não deve cadastrar com email incorreto
    [Tags]    inv_email

    ${user}    Create Dictionary
    ...    name=Charles Xavier
    ...    email=xavier.com.br
    ...    password=123456

    Go to signup page
    Submit signup form    ${user}
    Alert should be    Digite um e-mail válido

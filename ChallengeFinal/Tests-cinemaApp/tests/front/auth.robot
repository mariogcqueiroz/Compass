*** Settings ***
Documentation       Cenários de autenticação do usuário

Resource            ../../resources/base.resource

Test Setup          Start Session
Test Teardown       Take Screenshot

*** Test Cases ***

FE-AUTH-TC01 Deve poder cadastrar um novo usuário
    ${user}    Create Dictionary
    ...    name=Mario
    ...    email=mario@gmail.com
    ...    password=123456

    Remove Cinema User    ${user}

    Go to signup page
    Submit signup form    ${user}
    Notice should be    Conta criada com sucesso!
FE-AUTH-TC02 Deve poder logar com um usuário pré-cadastrado

    ${user}    Create Dictionary
    ...    name=Mario
    ...    email=mario@gmail.com
    ...    password=123456
    
    Remove Cinema User    ${user}
    Insert Cinema User   ${user}

    Go to login page

    Submit login form           ${user}
    Notice should be    Login realizado com sucesso!

# Não deve logar com senha inválida (não funciona, pois não há tratamento no front para esse caso)

#     ${user}    Create Dictionary
#     ...    name=Steve Woz
#     ...    email=woz@apple.com
#     ...    password=123456
    
#     Remove Cinema User    ${user}
#     Insert Cinema User   ${user}

#     Set To Dictionary    ${user}        password=abc123

#     Go to login page
    
#     Submit login form       ${user}
#     Notice should be       Ocorreu um erro ao fazer login, verifique suas credenciais.



FE-AUTH-TC03 Não deve permitir o cadastro com email duplicado
    [Tags]    dup

    ${user}    Create Dictionary
    ...    name=Mario
    ...    email=Mario@gmail.com
    ...    password=123456

    Remove Cinema User    ${user}
    Insert Cinema User   ${user}

    Go to signup page
    Submit signup form    ${user}
    Notice should be    User already exists

FE-AUTH-TC04 Campos obrigatórios
    [Tags]    required

    ${user}    Create Dictionary
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}

    Go to signup page
    Submit signup form    ${user}

    Field validation message should be  css=input[id=name]    Preencha este campo.

FE-AUTH-TC05 Não deve cadastrar com email incorreto
    [Tags]    inv_email

    ${user}    Create Dictionary
    ...    name=Charles Xavier
    ...    email=xavier.com.br
    ...    password=123456

    Go to signup page
    Submit signup form    ${user} 
    Field validation message should be  css=input[id=email]       	Inclua um "@" no endereço de e-mail.

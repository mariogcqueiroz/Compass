*** Settings ***
Documentation       Cenários de testes do cadastro de usuários.
Library      Browser
Resource    ../resources/base.resource
Test Setup         Start Session
*** Test Cases ***
Deve poder cadastrar um novo usuário
    [Documentation]    Este teste preenche e submete o formulário de cadastro.
    ${name}=    Set Variable    Mario 
    ${email}=    Set Variable   mg@gmail.com
    ${password}=   Set Variable  012345

    Remove user from database    ${email}
    Go to Signup Page
    Submit Signup Form    ${name}    ${email}    ${password}
    Notice Should Be    Boas vindas ao Mark85, o seu gerenciador de tarefas.  

Não deve permitir cadastro com email já utilizado
    [Documentation]    Este teste tenta cadastrar um usuário com um email já existente.
    ${name}=    Set Variable    Mario 
    ${email}=    Set Variable   mg@gmail.com
    ${password}=   Set Variable  012345
    Remove user from database    ${email}
    Insert user from database    ${name}    ${email}    ${password}
    Go to Signup Page
    Submit Signup Form    ${name}    ${email}    ${password}
    Notice Should Be  Oops! Já existe uma conta com o e-mail informado.

Campos obrigatórios
    [Tags]  required
    [Documentation]    Este teste tenta cadastrar um usuário sem preencher os campos obrigatórios.
    Go to Signup Page
    Submit Signup Form    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Alert Should Be    Informe seu nome completo
    Alert Should Be    Informe seu e-email
    Alert Should Be    Informe uma senha com pelo menos 6 digitos

Não deve permitir cadastro com email inválido
    [Tags]  email
    [Documentation]    Este teste tenta cadastrar um usuário com um email inválido.
    ${name}=    Set Variable    Mario 
    ${email}=    Set Variable   mgmail.com
    ${password}=   Set Variable  012345
    Go to Signup Page
    Submit Signup Form    ${name}    ${email}    ${password}
    Alert Should Be    Digite um e-mail válido

Não deve cadastrar com senha muito curta
    [Tags]    short_pass

    # A navegação é feita apenas uma vez, ANTES do loop.
    Go to signup page

    @{password_list}=    Create List     1    12    123    1234    12345

    FOR    ${short_pass}    IN    @{password_list}
        # Criamos as variáveis necessárias para a keyword
        ${name}=    Set Variable    Mario 
        ${email}=   Set Variable    mario@gmail.com 
        Submit Signup Form    ${name}    ${email}    ${short_pass}

        Alert should be       Informe uma senha com pelo menos 6 digitos
    END
*** Settings ***
Documentation       Cenários de testes do cadastro de usuários.
Library             Browser
Library    FakerLibrary
Resource    ../resources/base.robot

*** Test Cases ***
Deve poder cadastrar um novo usuário
    [Documentation]    Este teste preenche e submete o formulário de cadastro.
    ${name}=    Set Variable    Mario 
    ${email}=    Set Variable   mg@gmail.com
    ${password}=   Set Variable  012345

    Remove user from database    ${email}
    # 1. Setup: Inicia o navegador e acessa a página de cadastro
    Start Session
    Go To               http://localhost:3000/signup

    # 2. Checkpoint: Garante que estamos na página correta
    Wait For Elements State    css=h1    visible    5
    Get Text                   css=h1    ==         Faça seu cadastro

    # 3. Action: Preenche os campos do formulário
    Fill Text    id=name        ${name}
    Fill Text    id=email       ${email}
    Fill Text    id=password    ${password}

    # 4. Action: Clica no botão para submeter o formulário
    Click               id=buttonSignup

   Wait For Elements State    css=.notice p    visible    5
   Get Text                   css=.notice p    equal      Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir cadastro com email já utilizado
    [Documentation]    Este teste tenta cadastrar um usuário com um email já existente.
    ${name}=    Set Variable    Mario 
    ${email}=    Set Variable   mg@gmail.com
    ${password}=   Set Variable  012345
    Remove user from database    ${email}
    Insert user from database    ${name}    ${email}    ${password}
    Start Session
    Go To               http://localhost:3000/signup

    # 2. Checkpoint: Garante que estamos na página correta
    Wait For Elements State    css=h1    visible    5
    Get Text                   css=h1    ==         Faça seu cadastro
    Fill Text    id=name        ${name}
    Fill Text    id=email       ${email}
    Fill Text    id=password    ${password}

    Click               id=buttonSignup

    Wait For Elements State    css=.notice p    visible    5
    Get Text                   css=.notice p    ==         Oops! Já existe uma conta com o e-mail informado.
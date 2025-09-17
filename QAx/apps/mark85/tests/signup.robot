*** Settings ***
Documentation       Cenários de testes do cadastro de usuários.
Library             Browser
Library    FakerLibrary

*** Test Cases ***
Deve poder cadastrar um novo usuário
    [Documentation]    Este teste preenche e submete o formulário de cadastro.
    ${name}=    FakerLibrary.name
    ${email}=   FakerLibrary.email
    ${password}=  FakerLibrary.password    length=10    special_chars=True    digits=True
    # 1. Setup: Inicia o navegador e acessa a página de cadastro
    New Browser         browser=chromium    headless=False
    New Page            http://localhost:3000/signup

    # 2. Checkpoint: Garante que estamos na página correta
    Wait For Elements State    css=h1    visible    timeout=5s
    Get Text                   css=h1    ==         Faça seu cadastro

    # 3. Action: Preenche os campos do formulário
    Fill Text    id=name        ${name}
    Fill Text    id=email       ${email}
    Fill Text    id=password    ${password}

    # 4. Action: Clica no botão para submeter o formulário
    Click               id=buttonSignup

    # Pausa temporária para observação visual do resultado
    Sleep               5s
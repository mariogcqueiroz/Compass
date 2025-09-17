*** Settings ***
Documentation       Cenários de testes do cadastro de usuários.
Library             Browser

*** Test Cases ***
Deve poder cadastrar um novo usuário
    [Documentation]    Este teste verifica a página de cadastro antes de preencher o formulário.

    # 1. Inicia a sessão do navegador
    New Browser         browser=chromium    headless=False

    # 2. Acessa a página de cadastro da aplicação
    New Page            http://localhost:3000/signup

    # 3. Checkpoint para garantir que estamos na página correta
    # Aguarda o título H1 estar visível e depois valida o seu texto.
    Wait For Elements State    xpath=//h1    visible    timeout=5s
    Get Text                   xpath=//h1    ==         Faça seu cadastro

    # Pausa temporária para observação visual do resultado
    Sleep               3s
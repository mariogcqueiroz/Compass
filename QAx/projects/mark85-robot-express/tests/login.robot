*** Settings ***
Documentation       Cenários de autenticação do usuário

Library             Collections
Resource            ../resources/base.resource

Test Setup          Start Session
Test Teardown       Take Screenshot

*** Test Cases ***
Deve poder logar com um usuário pré-cadastrado
    # --- Massa de Teste ---
    ${name}=        Set Variable    mario g
    ${email}=       Set Variable    marioqa@gmail.com
    ${password}=    Set Variable    abcdef
    
    # --- Preparação (Given) ---
    Remove user from database    ${email}
    Insert user from database    ${name}    ${email}    ${password}
    
    # --- Ação (When) ---
    Submit login form           ${email}    ${password}
    
    # --- Validação (Then) ---
    User should be logged in     ${name}


Não deve logar com senha inválida
    # --- Massa de Teste ---
    ${name}=              Set Variable    Steve Woz
    ${email}=             Set Variable    woz@apple.com
    ${correct_password}=  Set Variable    123456
    ${invalid_password}=  Set Variable    abc123
    
    # --- Preparação (Given) ---
    Remove user from database    ${email}
    Insert user from database    ${name}    ${email}    ${correct_password}
    
    # --- Ação (When) ---
    Submit login form            ${email}    ${invalid_password}
    
    # --- Validação (Then) ---
    Notice should be             Ocorreu um erro ao fazer login, verifique suas credenciais.
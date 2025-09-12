*** Settings ***
Documentation    Cenários de teste para o endpoint /login, cobrindo a User Story US002
Resource         ../../config/config.robot
Resource         ../../support/common/common.robot
Resource         ../../support/common/api_keywords.robot

Suite Setup      Setup Usuario Comum
*** Keywords ***
Setup Usuario Comum
    Iniciar Sessao
    ${json}=    Importar JSON    login.json
    ${payload_login}=    Set Variable    ${json["login_usuario_comum"]}
    &{payload_usuario}=    Create Dictionary
    ...    nome=Usuario Comum
    ...    email=${payload_login["email"]}
    ...    password=${payload_login["password"]}
    ...    administrador=false
    ${resp_criar}=    POST Usuario    &{payload_usuario}
    Run Keyword If    '${resp_criar.status_code}' != '201'    Log    Usuário já existe ou erro ao criar
*** Test Cases ***
US002-TC01: Realizar login com credenciais corretas
    ${json}=      Importar JSON    login.json
    ${payload}=   Set Variable     ${json["login_usuario_comum"]}
    ${response}=  POST Login       ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key  ${response.json()}    authorization


US002-TC02: Tentar realizar login com um e-mail não cadastrado
    ${json}=      Importar JSON    login.json
    ${payload}=   Set Variable     ${json["email_nao_cadastrado"]}
    ${response}=  POST Login       ${payload}
    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal As Strings     ${response.json()["message"]}    Email e/ou senha inválidos


US002-TC03: Tentar realizar login com senha incorreta
    ${json}=      Importar JSON    login.json
    ${payload}=   Set Variable     ${json["senha_incorreta"]}
    ${response}=  POST Login       ${payload}
    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal As Strings     ${response.json()["message"]}    Email e/ou senha inválidos


US002-TC04: Tentar realizar login com campos vazios
    ${json}=      Importar JSON    login.json
    ${payload}=   Set Variable     ${json["campos_vazios"]}
    ${response}=  POST Login       ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings     ${response.json()["email"]}    email não pode ficar em branco
    Should Be Equal As Strings     ${response.json()["password"]}    password não pode ficar em branco
US002-TC05: Tentar realizar login com formato de e-mail inválido
    ${json}=      Importar JSON    login.json
    ${payload}=   Set Variable     ${json["formato_email_invalido"]}
    ${response}=  POST Login       ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings     ${response.json()["email"]}    email deve ser um email válido    
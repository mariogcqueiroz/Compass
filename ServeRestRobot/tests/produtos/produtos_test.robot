*** Settings ***
Documentation       Cenários de teste para o endpoint /produtos, cobrindo a User Story US003.
Resource            ../../support/common/api_keywords.robot
Resource            ../../config/config.robot
Resource            ../../support/fixtures/dynamics.robot
Suite Setup         Realizar Login Como Administrador
Test Teardown       Deletar Produto Criado Se Existir

*** Test Cases ***
US003-TC01: Cadastrar produto com token de administrador
    [Tags]    US003    TC01    happy_path
    GIVEN que eu tenha os dados de um novo produto
    WHEN eu envio uma requisição POST para /produtos com token de administrador
    THEN o produto deve ser criado com sucesso e status 201

US003-TC02: Tentar cadastrar produto sem token de autenticação
    [Tags]    US003    TC02    sad_path
    GIVEN que eu tenha os dados de um novo produto
    WHEN eu envio uma requisição POST para /produtos sem token
    THEN a API deve retornar um erro de token ausente com status 401

US003-TC03: Tentar cadastrar produto com nome já existente
    [Tags]    US003    TC03    sad_path
    GIVEN que eu já tenha um produto cadastrado
    WHEN eu tento cadastrar outro produto com o mesmo nome
    THEN a API deve retornar um erro de produto duplicado com status 400

*** Keywords ***
Realizar Login Como Administrador
    Iniciar Sessao
    &{payload_admin}=    Criar Usuario Valido    true
    ${resp_criar}=    POST Usuario    &{payload_admin}
    Run Keyword If    '${resp_criar.status_code}' != '201'    Log    Usuário admin já existe ou erro ao criar
    &{payload_login}=    Create Dictionary    email=${payload_admin.email}    password=${payload_admin.password}
    ${response}=    POST Login    ${payload_login}    
    Should Be Equal As Integers    ${response.status_code}    200
    Set Suite Variable    ${TOKEN_ADMIN}    ${response.json()['authorization']}




Deletar Produto Criado Se Existir
    Run Keyword If    '${ID_PRODUTO}' != '${null}'    DELETE Produto por ID    ${TOKEN_ADMIN}    ${ID_PRODUTO}
    Set Suite Variable    ${ID_PRODUTO}    ${null}

que eu tenha os dados de um novo produto
    &{payload_produto}=    Criar Produto Valido
    Set Test Variable    ${payload}    &{payload_produto}

que eu já tenha um produto cadastrado
    &{payload_produto}=    Criar Produto Valido
    ${response}=    POST Produto    ${TOKEN_ADMIN}    ${payload_produto}
    Should Be Equal As Integers    ${response.status_code}    201
    Set Test Variable    ${ID_PRODUTO}    ${response.json()['_id']}
    Set Test Variable    ${payload}    ${payload_produto}

eu envio uma requisição POST para /produtos com token de administrador
    ${response}=    POST Produto    ${TOKEN_ADMIN}    ${payload}
    Set Test Variable    ${response}
    Set Test Variable    ${ID_PRODUTO}    ${response.json()['_id']}

eu envio uma requisição POST para /produtos sem token
    ${response}=    POST Produto    ${null}    ${payload}
    Set Test Variable    ${response}

eu tento cadastrar outro produto com o mesmo nome
    ${response}=    POST Produto    ${TOKEN_ADMIN}    ${payload}
    Set Test Variable    ${response}

o produto deve ser criado com sucesso e status 201
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()["message"]}    Cadastro realizado com sucesso

a API deve retornar um erro de token ausente com status 401
    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()["message"]}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

a API deve retornar um erro de produto duplicado com status 400
    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()["message"]}    Já existe produto com esse nome

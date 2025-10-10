*** Settings ***
Documentation    Testes para a API de Autenticação
Resource         ../../resources/base.resource

*** Test Cases ***
US-AUTH-TC01 [Happy Path] Cadastrar um novo usuário com dados válidos
    ${user}    Get Fixture    users.json    new_user
    Clean Cinema User    ${user}[email]    # Garante que o usuário não existe antes
    ${resp}    Register User    ${user}
    Should Be Equal As Strings    ${resp.status_code}    201
    Clean Cinema User    ${user}[email]    # Limpa o usuário criado

US-AUTH-TC02 Cadastrar um usuário com e-mail já existente
    ${user}    Get Fixture    users.json    existing_user
    Reset Test User    ${user}    # Garante que o usuário exista
    ${resp}    Register User    ${user}
    Should Be Equal As Strings    ${resp.status_code}    400
    Clean Cinema User    ${user}[email]

US-AUTH-TC03 Cadastrar um usuário com e-mail em formato inválido
    ${user}    Get Fixture    users.json    invalid_email_user
    ${resp}    Register User    ${user}
    Should Be Equal As Strings    ${resp.status_code}    400

US-AUTH-TC04 Cadastrar um usuário com senha fora do limite
    ${user}    Get Fixture    users.json    short_password_user
    ${resp}    Register User    ${user}
    Should Be Equal As Strings    ${resp.status_code}    400

US-AUTH-TC05 [Happy Path] Realizar login com dados de um usuário válido
    ${user}    Get Fixture    users.json    existing_user
    Reset Test User    ${user}
    ${resp}    Login User and get response   ${user} 
    Should Be Equal As Strings    ${resp.status_code}    200
    Clean Cinema User    ${user}[email]

US-AUTH-TC06 Tentar realizar login com dados de um usuário inválido
    ${user}    Get Fixture    users.json    existing_user
    ${user_invalid}    Create Dictionary    email=${user}[email]    password=wrongpass
    ${resp}    Login User and get response    ${user_invalid}
    Should Be Equal As Strings    ${resp.status_code}    401

US-AUTH-TC07 [Happy Path] Acessar o perfil do usuário logado
    ${user}    Get Fixture    users.json    existing_user
    Reset Test User    ${user}
    ${token}    Login User    ${user}
    ${resp}    Get My Profile    ${token}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][email]    ${user}[email]
    Clean Cinema User    ${user}[email]

US-AUTH-TC08 Acessar o perfil do usuário sem token nos headers
    ${resp}    Get My Profile    ${EMPTY}
    Should Be Equal As Strings    ${resp.status_code}    401

US-AUTH-TC09 Buscar um usuário com token de autenticação inválido
    ${resp}    Get My Profile    "Bearer token-invalido-123"
    Should Be Equal As Strings    ${resp.status_code}    403  

US-AUTH-TC10 [Happy Path] Atualizar dados do usuário com dados válidos
    ${user}           Get Fixture    users.json    existing_user
    ${update_data}    Get Fixture    users.json    update_payload
    Reset Test User    ${user}
    ${token}    Login User    ${user}
    ${resp}    Update My Profile    ${update_data}    ${token}
    Should Be Equal As Strings    ${resp.status_code}    200
    Clean Cinema User    ${user}[email]

US-AUTH-TC11 Atualizar dados do usuário com senha atual incorreta
    ${user}           Get Fixture    users.json    existing_user
    ${update_data}    Get Fixture    users.json    update_payload
    Reset Test User    ${user}
    ${token}    Login User    ${user}
    Clean Cinema User    ${user}[email]
    ${resp}    Update My Profile    ${update_data}    ${token}
    Should Be Equal As Strings    ${resp.status_code}    401
US-AUTH-TC12 Atualizar um usuário inexistente
    ${user}           Get Fixture    users.json    existing_user
    ${update_data}    Get Fixture    users.json    update_payload
    Reset Test User    ${user}
    ${token}    Login User    ${user}
    Clean Cinema User    ${user}[email]
    ${resp}    Update My Profile    ${update_data}    ${token}
    Should Be Equal As Strings    ${resp.status_code}    404
*** Settings ***
Documentation    Testes para a API de Gerenciamento de Cinemas (Theaters)
Resource         ../../resources/base.resource
Suite Setup      Setup Theaters API Tests
Suite Teardown   Teardown Theaters API Tests
Test Setup       Initialize Theater ID      # Executa ANTES de CADA teste
Test Teardown    Clean Up Created Theater   # Executa DEPOIS de CADA teste

*** Keywords ***
Setup Theaters API Tests
    [Documentation]    Faz o login dos usuários necessários para a suíte de testes.
    ${admin}    Get Fixture    users.json    admin_user
    ${common}   Get Fixture    users.json    common_user
    Reset Test User    ${admin}
    Reset Test User    ${common}
    ${admin_token}    Login User    ${admin}
    ${common_token}   Login User    ${common}
    Set Suite Variable    ${ADMIN_TOKEN}          ${admin_token}
    Set Suite Variable    ${COMMON_USER_TOKEN}    ${common_token}
    ${valid_theater}    Get Fixture    theaters.json    valid_theater
    ${updated_theater}  Get Fixture    theaters.json    updated_theater
    Clean Theater By Name    ${valid_theater}[name]
    Clean Theater By Name    ${updated_theater}[name]

Teardown Theaters API Tests
    [Documentation]    Limpa os usuários criados para a suíte de testes.
    ${admin}    Get Fixture    users.json    admin_user
    ${common}   Get Fixture    users.json    common_user
    Clean Cinema User    ${admin}[email]
    Clean Cinema User    ${common}[email]

Initialize Theater ID
    [Documentation]    Garante que a variável de ID do cinema sempre exista antes de cada teste.
    Set Test Variable   ${CREATED_THEATER_ID}    ${None}

Clean Up Created Theater
    [Documentation]    Deleta o cinema que foi criado durante o teste para garantir um estado limpo.
    Run Keyword If    '${CREATED_THEATER_ID}' != '${None}'
    ...    Delete Theater By Id    ${CREATED_THEATER_ID}    ${ADMIN_TOKEN}

*** Test Cases ***
USTHE-TC93 [Happy Path] Consultar lista de cinemas
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${resp}          Get All Theaters    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USTHE-TC94 [Happy Path] Criar um cinema com dados válidos
    ${payload}    Get Fixture    theaters.json    valid_theater
    ${resp}       Create Theater    ${payload}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    201
    Set Test Variable    ${CREATED_THEATER_ID}    ${resp.json()}[data][_id]

USTHE-TC95 Criar um cinema com dados inválidos
    ${payload}    Get Fixture    theaters.json    invalid_theater
    ${resp}       Create Theater    ${payload}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USTHE-TC96 Criar um cinema com um token inválido
    ${payload}    Get Fixture    theaters.json    valid_theater
    ${resp}       Create Theater    ${payload}    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401


USTHE-TC97 Criar um cinema com um usuário não admin
    ${payload}    Get Fixture    theaters.json    valid_theater
    ${resp}       Create Theater    ${payload}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USTHE-TC98 Criar um cinema com nome repetido
    ${payload}           Get Fixture    theaters.json    valid_theater
    ${res_create}        Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${payload_conflict}  Get Fixture    theaters.json    conflicting_theater
    ${resp}              Create Theater    ${payload_conflict}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409

USTHE-TC99 [Happy Path] Consultar um cinema pelo ID
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${resp}          Get Theater By Id    ${CREATED_THEATER_ID}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USTHE-TC100 Consultar cinema inexistente
    ${resp}    Get Theater By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USTHE-TC101 [Happy Path] Atualizar um cinema existente com dados válidos
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${update_data}   Get Fixture    theaters.json    updated_theater
    ${resp}          Update Theater By Id    ${CREATED_THEATER_ID}    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
USTHE-TC102 Atualizar um cinema informando dados inválidos
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${invalid_data}  Get Fixture    theaters.json    invalid_theater
    ${resp}          Update Theater By Id    ${CREATED_THEATER_ID}    ${invalid_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USTHE-TC103 Atualizar um cinema sem ter um token de autenticação
    ${update_data}    Get Fixture    theaters.json    updated_theater
    ${resp}           Update Theater By Id    "some-fake-id"    ${update_data}    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

USTHE-TC104 Atualizar um cinema por meio de um usuário não admin
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${update_data}   Get Fixture    theaters.json    updated_theater
    ${resp}          Update Theater By Id    ${CREATED_THEATER_ID}    ${update_data}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USTHE-TC105 Atualizar um cinema informando um ID inexistente
    ${update_data}    Get Fixture    theaters.json    updated_theater
    ${resp}           Update Theater By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USTHE-TC106 Atualizar um cinema com nome que já está sendo utilizado
    ${payload1}      Get Fixture    theaters.json    valid_theater
    ${res_create1}   Create Theater    ${payload1}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create1.json()}[data][_id]
    ${payload2}      Get Fixture    theaters.json    updated_theater
    ${res_create2}   Create Theater    ${payload2}    ${ADMIN_TOKEN}
    ${theater_id2}   Set Variable    ${res_create2.json()}[data][_id]
    # Tenta atualizar o segundo cinema com o nome do primeiro
    ${conflict_data}    Create Dictionary    name=${payload1}[name]
    ${resp}          Update Theater By Id    ${theater_id2}    ${conflict_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409
    # Teardown adicional para o segundo cinema
    Delete Theater By Id    ${theater_id2}    ${ADMIN_TOKEN}

USTHE-TC107 [Happy Path] Deletar um cinema existente
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    ${theater_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}          Delete Theater By Id    ${theater_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
    # O Teardown não precisa fazer nada, pois a ação do teste já foi deletar.
    # Setamos a variável como ${None} para o Teardown não tentar deletar de novo.
    Set Test Variable    ${CREATED_THEATER_ID}    ${None}
USTHE-TC108 Deletar um cinema sem um token válido nos headers
    ${resp}    Delete Theater By Id    "some-fake-id"    65f1a5b8b9e8b4e8b4e8b4e8
    Should Be Equal As Integers    ${resp.status_code}    401
USTHE-TC109 Deletar um cinema sem permissão
    ${payload}       Get Fixture    theaters.json    valid_theater
    ${res_create}    Create Theater    ${payload}    ${ADMIN_TOKEN}
    Set Test Variable    ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${resp}          Delete Theater By Id    ${CREATED_THEATER_ID}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USTHE-TC110 Deletar um cinema inexistente
    ${resp}    Delete Theater By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404
USTHE-TC111 Deletar um cinema com sessões ativas
    # --- SETUP ---
    ${theater_payload}    Get Fixture    theaters.json    valid_theater
    ${res_create}         Create Theater    ${theater_payload}    ${ADMIN_TOKEN}
    Set Test Variable     ${CREATED_THEATER_ID}    ${res_create.json()}[data][_id]
    ${movie_payload}      Get Fixture    movies.json    valid_movie
    ${res_movie}          Create Movie    ${movie_payload}    ${ADMIN_TOKEN}
    ${movie_id}           Set Variable    ${res_movie.json()}[data][_id]
    ${session_payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary     ${session_payload}    movie=${movie_id}    theater=${CREATED_THEATER_ID}
    Create Sessions        ${session_payload}    ${ADMIN_TOKEN}
    # --- AÇÃO ---
    ${resp}    Delete Theater By Id    ${CREATED_THEATER_ID}    ${ADMIN_TOKEN}
    # --- VALIDAÇÃO ---
    Should Be Equal As Integers    ${resp.status_code}    409
    # --- TEARDOWN ADICIONAL ---
    # O Teardown padrão cuidará do cinema, mas precisamos limpar o filme.
    [Teardown]    Run Keywords    Delete Movie By Id    ${movie_id}    ${ADMIN_TOKEN}    AND    Clean Up Created Theater
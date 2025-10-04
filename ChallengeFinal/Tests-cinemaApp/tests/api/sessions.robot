*** Settings ***
Documentation    Testes para a API de Sessões
Resource         ../../resources/base.resource
Suite Setup      Setup Sessions API Tests
Suite Teardown   Teardown Sessions API Tests

*** Keywords ***
Setup Sessions API Tests
    [Documentation]    Cria usuários, filme e cinema para os testes de sessão.
    # --- Usuários ---
    ${admin}    Get Fixture    users.json    admin_user
    ${common}   Get Fixture    users.json    common_user
    Reset Test User    ${admin}
    Reset Test User    ${common}
    ${admin_token}    Login User    ${admin}
    ${common_token}   Login User    ${common}
    Set Suite Variable    ${ADMIN_TOKEN}          ${admin_token}
    Set Suite Variable    ${COMMON_USER_TOKEN}    ${common_token}

    # --- Filme e Cinema ---
    ${movie_payload}    Get Fixture    movies.json    valid_movie
    ${res_movie}        Create Movie    ${movie_payload}    ${admin_token}
    Set Suite Variable    ${MOVIE_ID}    ${res_movie.json()}[data][_id]

    ${theater_payload}  Get Fixture    reservations.json    theater_for_reservation
    ${res_theater}      Create Theater    ${theater_payload}    ${admin_token}
    Set Suite Variable    ${THEATER_ID}    ${res_theater.json()}[data][_id]

Teardown Sessions API Tests
    Delete Movie By Id      ${MOVIE_ID}      ${ADMIN_TOKEN}
    Delete Theater By Id    ${THEATER_ID}    ${ADMIN_TOKEN}

*** Test Cases ***
USSNS-TC69 [Happy Path] Criar uma sessão com dados válidos
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    201

USSNS-TC70 Criar uma sessão com dados inválidos
    ${payload}    Get Fixture    sessions.json    invalid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USSNS-TC71 Criar uma sessão com um token inválido
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload}    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

USSNS-TC72 Criar uma sessão por meio de um usuário não admin
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USSNS-TC73 Criar uma sessão com filme ou cinema inválidos
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=65f1a5b8b9e8b4e8b4e8b4e8    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404


USSNS-TC74 Criar uma sessão com horários coincidentes
    # Primeira sessão
    ${payload1}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload1}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    Create Sessions    ${payload1}    ${ADMIN_TOKEN}
    # Segunda sessão com conflito
    ${payload2}    Get Fixture    sessions.json    conflicting_session
    Set To Dictionary    ${payload2}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${resp}    Create Sessions    ${payload2}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409

USSNS-TC75 [Happy Path] Consultar lista de sessões
    # A API de sessões não tem um GET all, mas podemos simular buscando por um filme
    # Se a API for atualizada para /sessions, este teste pode ser ajustado.
    ${resp}    Get All Movies     # Assumindo que a busca por sessões é via detalhes do filme.
    Should Be Equal As Integers    ${resp.status_code}    200
USSNS-TC76 [Happy Path] Consultar sessão pelo ID
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Get Session By Id    ${session_id}
    Should Be Equal As Integers    ${resp.status_code}    200

USSNS-TC77 Consultar sessão por um ID inválido
    ${resp}    Get Session By Id    65f1a5b8b9e8b4e8b4e8b4e8
    Should Be Equal As Integers    ${resp.status_code}    404
USSNS-TC78 [Happy Path] Atualizar uma sessão existente com dados válidos
    ${payload}        Get Fixture    sessions.json    valid_session
    ${update_data}    Get Fixture    sessions.json    updated_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Update Sessions    ${session_id}    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
USSNS-TC79 Atualizar uma sessão informando dados inválidos
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]

    ${invalid_data}    Get Fixture    sessions.json    invalid_session
    ${resp}    Update Sessions    ${session_id}    ${invalid_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USSNS-TC80 Atualizar uma sessão sem ter um token de autenticação
    ${update_data}    Get Fixture    sessions.json    updated_session
    ${resp}    Update Sessions    "some-id"    ${update_data}    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

USSNS-TC81 Atualizar uma sessão por meio de um usuário não admin
    ${payload}        Get Fixture    sessions.json    valid_session
    ${update_data}    Get Fixture    sessions.json    updated_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Update Sessions    ${session_id}    ${update_data}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USSNS-TC82 Atualizar uma sessão informando um ID inexistente
    ${update_data}    Get Fixture    sessions.json    updated_session
    ${resp}    Update Sessions    65f1a5b8b9e8b4e8b4e8b4e8    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USSNS-TC83 Atualizar uma sessão com reservas existentes
    # Setup: Criar sessão e uma reserva nela
    ${payload}       Get Fixture    sessions.json    valid_session
    ${update_data}   Get Fixture    sessions.json    updated_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${res_payload}   Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${res_payload}    session=${session_id}
    Create Reservation    ${res_payload}    ${COMMON_USER_TOKEN}
    # Ação e Validação
    ${resp}    Update Sessions   ${session_id}    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409

USSNS-TC84 [Happy Path] Deletar uma sessão existente
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Delete Session By Id    ${session_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
USSNS-TC85 Deletar uma sessão sem um token válido nos headers
    ${resp}    Delete Session By Id    "some-id"    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

USSNS-TC86 Deletar uma sessão sem permissão
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Delete Session By Id    ${session_id}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USSNS-TC87 Deletar uma sessão inexistente
    ${resp}    Delete Session By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USSNS-TC88 Deletar uma sessão com reservas confirmadas
    # Setup: Criar sessão e uma reserva nela
    ${payload}       Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${res_payload}   Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${res_payload}    session=${session_id}
    Create Reservation    ${res_payload}    ${COMMON_USER_TOKEN}
    # Ação e Validação
    ${resp}    Delete Session By Id    ${session_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409

USSNS-TC89 [Happy Path] Resetar assentos de uma sessão
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Reset Session Seats    ${session_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USSNS-TC90 Resetar assentos de uma sessão sem token de autenticação
    ${resp}    Reset Session Seats    "some-id"    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

USSNS-TC91 Resetar assentos de uma sessão por meio de um usuário não admin
    ${payload}    Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_create}    Create Sessions    ${payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Reset Session Seats    ${session_id}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USSNS-TC92 Resetar assentos de uma sessão informando um ID inexistente
    ${resp}    Reset Session Seats    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404
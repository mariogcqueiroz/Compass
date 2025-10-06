*** Settings ***
Documentation    Testes para a API de Reservas
Resource         ../../resources/base.resource
Suite Setup      Setup Reservations API Tests
Suite Teardown   Teardown Reservations API Tests
Test Setup       Reset The Test Session Seats
*** Keywords ***
Setup Reservations API Tests
    [Documentation]    Cria todo o ecossistema necessário para uma reserva: usuários, filme, cinema e sessão.
    # --- Usuários ---
    ${admin}    Get Fixture    users.json    admin_user
    ${common}   Get Fixture    users.json    common_user
    Reset Test User    ${admin}
    Reset Test User    ${common}
    ${admin_token}    Login User    ${admin}
    ${common_token}   Login User    ${common}
    Set Suite Variable    ${ADMIN_TOKEN}          ${admin_token}
    Set Suite Variable    ${COMMON_USER_TOKEN}    ${common_token}

    # --- Filme ---
    ${movie_payload}    Get Fixture    movies.json    valid_movie
    ${res_movie}        Create Movie    ${movie_payload}    ${admin_token}
    Set Suite Variable    ${MOVIE_ID}    ${res_movie.json()}[data][_id]

    # --- Cinema (Theater) ---
    ${theater_payload}  Get Fixture    reservations.json    theater_for_reservation
    Clean Theater By Name    ${theater_payload}[name]
    ${res_theater}      Create Theater    ${theater_payload}    ${admin_token}
    Set Suite Variable    ${THEATER_ID}    ${res_theater.json()}[data][_id]

    # --- Sessão ---
    ${session_payload}  Get Fixture    reservations.json    session_for_reservation
    Set To Dictionary    ${session_payload}    movie=${MOVIE_ID}    theater=${THEATER_ID}
    ${res_session}      Create Sessions    ${session_payload}    ${admin_token}
    Set Suite Variable    ${SESSION_ID}    ${res_session.json()}[data][_id]

Reset The Test Session Seats
    [Documentation]    Reseta os assentos da sessão de teste para garantir a independência dos testes.
    Reset Session Seats    ${SESSION_ID}    ${ADMIN_TOKEN}
Teardown Reservations API Tests
    Delete Movie By Id      ${MOVIE_ID}      ${ADMIN_TOKEN}
    Delete Theater By Id    ${THEATER_ID}    ${ADMIN_TOKEN}

*** Test Cases ***
USRES-TC48 [Happy Path] Criar uma reserva com dados válidos
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${resp}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    201

USRES-TC49 Criar uma reserva com dados inválidos
    ${payload}    Get Fixture    reservations.json    invalid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${resp}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USRES-TC50 Criar uma reserva com um token inválido
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${resp}    Create Reservation    ${payload}    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

USRES-TC51 Criar uma reserva com sessão inválida
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=65f1a5b8b9e8b4e8b4e8b4e8
    ${resp}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USRES-TC52 [Happy Path] Consultar reservas do usuário logado
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${resp}    Get My Reservations    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USRES-TC53 Consultar reservas com token inválido
    ${resp}    Get My Reservations    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

USRES-TC54 [Happy Path] Listar todas as reservas (Admin)
    ${resp}    Get All Reservations    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USRES-TC55 Tentar listar todas as reservas sem um token válido
    ${resp}    Get All Reservations    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

USRES-TC56 Tentar listar todas as reservas com usuário não admin
    ${resp}    Get All Reservations    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USRES-TC57 [Happy Path] Buscar uma reserva por um ID existente
    # Setup: Criar uma reserva para poder buscá-la
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]

    # Ação e Validação
    ${resp}    Get Reservation By Id    ${reservation_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][_id]    ${reservation_id}

USRES-TC58 Buscar uma reserva sem token de autenticação
    ${resp}    Get Reservation By Id    "some-fake-id"    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

USRES-TC59 Buscar uma reserva inválida (Admin)
    ${resp}    Get Reservation By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

USRES-TC60 [Happy Path] Atualizar uma reserva (Admin)
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]
    ${update_data}    Get Fixture    reservations.json    update_reservation_payload
    ${resp}    Update Reservation By Id    ${reservation_id}    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USRES-TC61 Atualizar uma reserva com dados inválidos (Admin)
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]
    ${invalid_data}    Get Fixture    reservations.json    invalid_update_reservation_payload
    ${resp}    Update Reservation By Id    ${reservation_id}    ${invalid_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400

USRES-TC62 Atualizar uma reserva sem ter um token de autenticação
    ${update_data}    Get Fixture    reservations.json    update_reservation_payload
    ${resp}    Update Reservation By Id    "some-fake-id"    ${update_data}    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

USRES-TC63 Atualizar uma reserva sem permissão (não admin)
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]
    ${update_data}    Get Fixture    reservations.json    update_reservation_payload
    ${resp}    Update Reservation By Id    ${reservation_id}    ${update_data}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USRES-TC64 Atualizar uma reserva informando um ID inexistente
    # A descrição fala em "filme", mas o contexto é de reserva.
    ${update_data}    Get Fixture    reservations.json    update_reservation_payload
    ${resp}    Update Reservation By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404
USRES-TC65 [Happy Path] Deletar uma reserva (Admin)
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Delete Reservation By Id    ${reservation_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

USRES-TC66 Deletar uma reserva sem um token válido nos headers
    ${resp}    Delete Reservation By Id    "some-fake-id"    65f1a5b8b9e8b4e8b4e8b4e8
    Should Be Equal As Integers    ${resp.status_code}    401
USRES-TC67 Deletar uma reserva sem permissão (não admin)
    ${payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${payload}    session=${SESSION_ID}
    ${res_create}    Create Reservation    ${payload}    ${COMMON_USER_TOKEN}
    ${reservation_id}    Set Variable    ${res_create.json()}[data][_id]
    ${resp}    Delete Reservation By Id    ${reservation_id}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

USRES-TC68 Deletar uma reserva inexistente (Admin)
    ${resp}    Delete Reservation By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404
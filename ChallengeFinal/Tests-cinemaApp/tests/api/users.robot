*** Settings ***
Documentation    Testes para a API de Gerenciamento de Usuários (Admin)
Resource         ../../resources/base.resource
Suite Setup      Setup Users API Tests
Suite Teardown   Teardown Users API Tests

*** Keywords ***
Setup Users API Tests
    ${admin}    Get Fixture    users.json    admin_user
    ${common}   Get Fixture    users.json    common_user
    Reset Test User    ${admin}
    Reset Test User    ${common}
    ${admin_token}    Login User    ${admin}
    ${common_token}   Login User    ${common}
    Set Suite Variable    ${ADMIN_TOKEN}          ${admin_token}
    Set Suite Variable    ${COMMON_USER_TOKEN}    ${common_token}
    Set Suite Variable    ${ADMIN_USER_DATA}      ${admin}
    Set Suite Variable    ${COMMON_USER_DATA}     ${common}

Teardown Users API Tests
    Clean Cinema User    ${ADMIN_USER_DATA}[email]
    Clean Cinema User    ${COMMON_USER_DATA}[email]

*** Test Cases ***
US-AUTH-TC13 [Happy Path] Listar todos os usuários cadastrados
    ${resp}    Get All Users    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be True    ${resp.json()}[data] != []

US-AUTH-TC14 Tentar listar todos os usuários sem um token válido
    ${resp}    Get All Users    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

US-AUTH-TC15 Tentar listar todos os usuários com usuário não admin
    ${resp}    Get All Users    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

US-AUTH-TC16 [Happy Path] Buscar um usuário por um ID existente
    ${user_id}    Get User ID By Email    ${COMMON_USER_DATA}[email]
    ${resp}    Get User By Id    ${user_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][email]    ${COMMON_USER_DATA}[email]

US-AUTH-TC17 Buscar um usuário sem token de autenticação
    ${resp}    Get User By Id    "some-fake-id"    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

US-AUTH-TC18 Buscar um usuário com usuário não admin
    ${user_id}    Get User ID By Email    ${ADMIN_USER_DATA}[email]
    ${resp}    Get User By Id    ${user_id}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403

US-AUTH-TC19 Buscar um usuário por um ID inexistente
    ${resp}    Get User By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

US-AUTH-TC20 [Happy Path] Atualizar um usuário existente com dados válidos
    ${user}         Get Fixture    users.json    user_to_be_managed
    ${update_data}  Get Fixture    users.json    user_update_valid_payload
    Reset Test User    ${user}
    ${user_id}      Get User ID By Email    ${user}[email]
    ${resp}         Update User By Id    ${user_id}    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][role]    admin
    Clean Cinema User    ${user}[email]

US-AUTH-TC21 Atualizar um usuário informando dados inválidos
    ${user}          Get Fixture    users.json    user_to_be_managed
    ${invalid_data}  Get Fixture    users.json    user_update_invalid_payload
    Reset Test User    ${user}
    ${user_id}       Get User ID By Email    ${user}[email]
    ${resp}          Update User By Id    ${user_id}    ${invalid_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    400
    Clean Cinema User    ${user}[email]

US-AUTH-TC22 Atualizar um usuário sem ter um token de autenticação
    ${update_data}  Get Fixture    users.json    user_update_valid_payload
    ${resp}         Update User By Id    "some-fake-id"    ${update_data}    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

US-AUTH-TC23 Atualizar um usuário por meio de um usuário não admin
    ${user}         Get Fixture    users.json    user_to_be_managed
    ${update_data}  Get Fixture    users.json    user_update_valid_payload
    Reset Test User    ${user}
    ${user_id}      Get User ID By Email    ${user}[email]
    ${resp}         Update User By Id    ${user_id}    ${update_data}    ${COMMON_USER_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    403
    Clean Cinema User    ${user}[email]

US-AUTH-TC24 Atualizar um usuário informando um ID inexistente
    ${update_data}  Get Fixture    users.json    user_update_valid_payload
    ${resp}         Update User By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${update_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404
US-AUTH-TC25 Atualizar para um e-mail que já está em uso
    ${user1}        Get Fixture    users.json    user_to_be_managed
    ${user2}        Get Fixture    users.json    another_user_for_conflict
    ${conflict_data}  Get Fixture    users.json    user_update_conflict_payload
    Reset Test User    ${user1}
    Reset Test User    ${user2}
    ${user1_id}     Get User ID By Email    ${user1}[email]
    ${resp}         Update User By Id    ${user1_id}    ${conflict_data}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409
    Clean Cinema User    ${user1}[email]
    Clean Cinema User    ${user2}[email]

US-AUTH-TC26 [Happy Path] Deletar um usuário existente
    ${user}     Get Fixture    users.json    user_to_be_managed
    Reset Test User    ${user}
    ${user_id}  Get User ID By Email    ${user}[email]
    ${resp}     Delete User By Id    ${user_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    200

US-AUTH-TC27 Deletar um usuário sem um token válido nos headers
    ${resp}    Delete User By Id    "some-fake-id"    "Bearer token-invalido"
    Should Be Equal As Integers    ${resp.status_code}    401

US-AUTH-TC28 Deletar um usuário sem permissão
    ${user_to_delete}    Get Fixture    users.json    user_to_be_managed
    Reset Test User    ${user_to_delete}
    ${user_id_to_delete}    Get User ID By Email    ${user_to_delete}[email]

    ${resp}    Delete User By Id    ${user_id_to_delete}    ${COMMON_USER_TOKEN}

    Should Be Equal As Integers    ${resp.status_code}    403

    Clean Cinema User    ${user_to_delete}[email]

US-AUTH-TC29 Deletar um usuário inexistente
    ${resp}    Delete User By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    404

US-AUTH-TC30 Deletar um usuário com reservas ativas
    [Documentation]    Este é um teste de integração, pois envolve a criação de filme, sala, sessão e reserva.
 
    ${user}    Get Fixture    users.json    user_to_be_managed
    Reset Test User    ${user}
    ${user_id}    Get User ID By Email    ${user}[email]
    ${user_token}    Login User    ${user}


    ${movie_payload}    Get Fixture    movies.json    valid_movie
    ${res_create_movie}    Create Movie    ${movie_payload}    ${ADMIN_TOKEN}
    ${movie_id}    Set Variable    ${res_create_movie.json()}[data][_id]


    ${theater_payload}  Get Fixture    reservations.json    theater_for_reservation
    Clean Theater By Name    ${theater_payload}[name]
    ${res_theater}      Create Theater    ${theater_payload}    ${ADMIN_TOKEN}
    ${theater_id}       Set Variable    ${res_theater.json()}[data][_id]


    ${session_payload}  Get Fixture    sessions.json    valid_session
    Set To Dictionary    ${session_payload}    movie=${movie_id}    theater=${theater_id}
    ${res_create_session}    Create Sessions    ${session_payload}    ${ADMIN_TOKEN}
    ${session_id}    Set Variable    ${res_create_session.json()}[data][_id]

    ${reservation_payload}    Get Fixture    reservations.json    valid_reservation_payload
    Set To Dictionary    ${reservation_payload}    session=${session_id}
    Create Reservation    ${reservation_payload}    ${user_token}

    ${resp}    Delete User By Id    ${user_id}    ${ADMIN_TOKEN}
    Should Be Equal As Integers    ${resp.status_code}    409

    # --- TEARDOWN (Limpeza) ---
    Clean Cinema User    ${user}[email]
    Delete Movie By Id    ${movie_id}    ${ADMIN_TOKEN}
    Delete Theater By Id    ${theater_id}    ${ADMIN_TOKEN}
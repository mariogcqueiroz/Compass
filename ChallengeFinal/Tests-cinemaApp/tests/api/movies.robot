*** Settings ***
Documentation    Testes para a API de Filmes
Resource         ../../resources/base.resource
Suite Setup      Setup Movie Tests        # Executa UMA VEZ antes de todos os testes
Suite Teardown   Teardown Movie Tests     # Executa UMA VEZ após todos os testes
Test Setup       Initialize Movie ID      # Executa ANTES de CADA teste
Test Teardown    Clean Up Created Movie    ${CREATED_MOVIE_ID}    ${ADMIN_TOKEN}

*** Variables ***
${VALID_MOVIE_PAYLOAD}    

*** Keywords ***
Setup Movie Tests
    [Documentation]    Cria os usuários no DB, faz o login do admin e carrega os fixtures.
    # PASSO 1: Carrega os dados dos usuários do arquivo JSON.
    ${admin_user}       Get Fixture    users.json    admin_user
    ${common_user}      Get Fixture    users.json    common_user

    # PASSO 2: Garante que os usuários estejam limpos e sejam inseridos no banco de dados.
    Reset Test User    ${admin_user}
    Reset Test User    ${common_user}
    Set Suite Variable    ${ADMIN_USER_DATA}    ${admin_user}   # Salva para o Teardown
    Set Suite Variable    ${COMMON_USER_DATA}   ${common_user}  # Salva para o Teardown

    # PASSO 3: Agora que o admin existe no DB, faz o login para obter o token.
    ${admin_token}      Login User     ${admin_user}
    Set Suite Variable  ${ADMIN_TOKEN}    ${admin_token}

    # PASSO 4: Carrega o fixture do filme.
    ${movie_fixture}    Get Fixture    movies.json    valid_movie
    Set Suite Variable    ${VALID_MOVIE_PAYLOAD}    ${movie_fixture}

    ${movie_fixture}    Get Fixture    movies.json    invalid_movie
    Set Suite Variable    ${INVALID_MOVIE_PAYLOAD}    ${movie_fixture}

Teardown Movie Tests
    [Documentation]    Limpa os usuários criados para esta suíte do banco de dados.
    Clean Cinema User    ${ADMIN_USER_DATA}[email]
    Clean Cinema User    ${COMMON_USER_DATA}[email]

Initialize Movie ID
    [Documentation]    Garante que a variável de ID sempre exista antes de cada teste.
    Set Test Variable   ${CREATED_MOVIE_ID}    ${None}

*** Test Cases ***

[Happy Path] USMOV-TC31 Consultar lista de filmes
    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}

    ${resp}    Get All Movies

    Should Be Equal As Strings    ${resp.status_code}    200

    ${data_list}    Set Variable    ${resp.json()}[data]

    Should Be Equal As Strings    ${data_list}[0][title]    ${VALID_MOVIE_PAYLOAD}[title]
[Happy Path]USMOV-TC32 Criar um filme com dados válidos
    ${resp}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    201
    # Sobrescreve a variável do teste com o ID real do filme criado
    Set Test Variable    ${CREATED_MOVIE_ID}    ${resp.json()}[data][_id]

USMOV-TC33 Criar um filme com dados inválidos
    ${resp}    Create Movie    ${INVALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    400
    #Should Contain    ${resp.text}    Invalid input data

USMOV-TC34 Criar um filme com com um token inválido
    ${admin_user}    Get Fixture    users.json    admin_user
    ${common_token}   Login User     ${admin_user}
    ${resp}    Create Movie    ${VALID_MOVIE_PAYLOAD}    invalid
    Should Be Equal As Strings    ${resp.status_code}    401 

USMOV-TC35 Criar um filme com um usuário não admin
    ${common_user}    Get Fixture    users.json    common_user
    ${common_token}   Login User     ${common_user}
    ${resp}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${common_token}
    Should Be Equal As Strings    ${resp.status_code}    403

# --- Cenários para GET /movies/{id} ---
[Happy Path] USMOV-TC36 Consultar um filme pelo ID
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]
    Set Test Variable    ${CREATED_MOVIE_ID}    ${movie_id}

    ${resp}    Get Movie By Id    ${movie_id}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][title]    ${VALID_MOVIE_PAYLOAD}[title]

USMOV-TC37 Consultar filme com formato inválido de ID
    ${movie_id}      Set Variable    12345-invalid-id

    ${resp}    Get Movie By Id    ${movie_id}
    Should Be Equal As Strings    ${resp.status_code}    404
    Should Contain    ${resp.text}    Movie not found
USMOV-TC38 Consultar filme inexistente
    ${resp}    Get Movie By Id    65f1a5b8b9e8b4e8b4e8b4e8 
    Should Be Equal As Strings    ${resp.status_code}    404
    Should Contain    ${resp.text}    Movie not found
# --- Cenários para PUT /movies/{id} ---
[Happy Path] USMOV-TC39 Atualizar um filme existente com dados válidos
    # Pré-condição: Criar um filme para poder atualizá-lo
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]
    Set Test Variable    ${CREATED_MOVIE_ID}    ${movie_id}

    # Ação: Atualizar o filme
    ${updated_data}    Get Fixture    movies.json    updated_movie
    ${resp}    Update Movie    ${movie_id}    ${updated_data}    ${ADMIN_TOKEN}

    # Validação
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()}[data][title]    ${updated_data}[title]

USMOV-TC40 Atualizar um filme informando dados inválidos
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]
    Set Test Variable    ${CREATED_MOVIE_ID}    ${movie_id}

    ${invalid_data}    Get Fixture    movies.json    invalid_movie
    ${resp}    Update Movie    ${movie_id}    ${invalid_data}    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    400

USMOV-TC41 Atualizar um filme sem ter um token de autenticação
    # Não precisa criar filme, pois a falha deve ocorrer antes
    ${updated_data}    Get Fixture    movies.json    updated_movie
    ${resp}    Update Movie    "some-fake-id"    ${updated_data}    ${EMPTY}
    Should Be Equal As Strings    ${resp.status_code}    401

USMOV-TC42 Atualizar um filme por meio de um usuário não admin
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]
    Set Test Variable    ${CREATED_MOVIE_ID}    ${movie_id}

    ${common_token}   Login User     ${COMMON_USER_DATA}
    ${updated_data}    Get Fixture    movies.json    updated_movie
    ${resp}    Update Movie    ${movie_id}    ${updated_data}    ${common_token}
    Should Be Equal As Strings    ${resp.status_code}    403

USMOV-TC43 Atualizar um filme informando um ID inexistente
    ${updated_data}    Get Fixture    movies.json    updated_movie
    ${resp}    Update Movie    65f1a5b8b9e8b4e8b4e8b4e8    ${updated_data}    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    404

# --- Cenários para DELETE /movies/{id} ---
[Happy Path] USMOV-TC44 Deletar um filme existente
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]

    # Ação: Deletar o filme
    ${resp}    Delete Movie By Id    ${movie_id}    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    200

    # Validação extra: Tentar buscar o filme deletado deve resultar em 404
    ${resp_get}    Get Movie By Id    ${movie_id}
    Should Be Equal As Strings    ${resp_get.status_code}    404

USMOV-TC45 Deletar um filme sem um token válido nos headers
    ${resp}    Delete Movie By Id    "some-fake-id"    "Bearer token-invalido"
    Should Be Equal As Strings    ${resp.status_code}    401

USMOV-TC46 Deletar um filme sem permissão de admin
    ${res_create}    Create Movie    ${VALID_MOVIE_PAYLOAD}    ${ADMIN_TOKEN}
    ${movie_id}      Set Variable    ${res_create.json()}[data][_id]
    Set Test Variable    ${CREATED_MOVIE_ID}    ${movie_id}

    ${common_token}   Login User     ${COMMON_USER_DATA}
    ${resp}    Delete Movie By Id    ${movie_id}    ${common_token}
    Should Be Equal As Strings    ${resp.status_code}    403

USMOV-TC47 Deletar um filme inexistente
    # A descrição fala em "usuário inexistente", mas o contexto é deletar um filme.
    # Assumindo que o teste é para um filme inexistente.
    ${resp}    Delete Movie By Id    65f1a5b8b9e8b4e8b4e8b4e8    ${ADMIN_TOKEN}
    Should Be Equal As Strings    ${resp.status_code}    404
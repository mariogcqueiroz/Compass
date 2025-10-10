*** Settings ***
Documentation       Cenários de filmes

Resource            ../../resources/base.resource

Suite Setup         Setup Movie Suite
Test Setup          Setup Movie Test
Test Teardown       Teardown Movie Test

*** Variables ***
&{TEST_USER}        name=Mario    email=mario@gmail.com    password=123456

*** Keywords ***
Setup Movie Suite
    [Documentation]    Faz o login do admin UMA VEZ para toda a suíte.
    ${admin}    Get Fixture    users.json    admin_user
    Reset Test User        ${admin}    
    ${admin_token}    Login User    ${admin}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}

Setup Movie Test
    [Documentation]    Cria o filme necessário para o teste e abre o navegador.
    ${movie_payload}    Get Fixture    movies.json    valid_movie2
    ${movie_id}         Create Movie Via API    ${movie_payload}    ${ADMIN_TOKEN}
    Set Test Variable   ${CREATED_MOVIE_ID}    ${movie_id}
    Set Test Variable   ${TARGET_MOVIE}        ${movie_payload}[title]
    Start Session
    Reset Test User    ${TEST_USER}

Teardown Movie Test
    [Documentation]    Deleta o filme criado para o teste e limpa o usuário.
    Take Screenshot
    Delete Movie Via API    ${CREATED_MOVIE_ID}    ${ADMIN_TOKEN}
    Clean Cinema User       ${TEST_USER}[email]

*** Test Cases ***
FE-MOV-TC01 Deve poder acessar filmes
    [Documentation]    Valida que um usuário logado consegue ver a lista de filmes.
    
    Do Login    ${TEST_USER}
    Go To Movie List
    Should Be On Movie List Page

FE-MOV-TC02 Deve poder acessar filme específico
    [Documentation]    Valida que um usuário logado consegue navegar para a página de detalhes de um filme.
    Do Login    ${TEST_USER}
    Go To Movie List
    Select Movie By ID    ${CREATED_MOVIE_ID}
    Movie Details Page Should Be Visible    ${TARGET_MOVIE}

FE-MOV-TC03 Deve permitir acessar filmes sem estar logado
    Go To Movie List
    Should Be On Movie List Page


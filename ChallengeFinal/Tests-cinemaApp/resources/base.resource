*** Settings ***
Library          libs/database.py
Library          Browser
Library          JSONLibrary
Library          RequestsLibrary
Library          Collections
Library          libs/database.py
Documentation    Base de recursos para testes 
Resource         env.resource
Resource         api/movies.resource
Resource         api/auth.resource
Resource         api/users.resource
Resource         api/theaters.resource
Resource         api/sessions.resource
Resource         api/reservations.resource

*** Keywords ***
Start Session
    New Browser     browser=${BROWSER}    headless=False
    New Page        ${BASE_URL}

# Helpers
Get Fixture
    [Arguments]        ${file_name}        ${scenario}

    ${data}    Load Json From File
    ...    ${CURDIR}/fixtures/${file_name}
    ...    encoding=utf-8
    
    RETURN    ${data}[${scenario}]

Reset Test User
    [Arguments]    ${user_data}
    [Documentation]    Garante um estado limpo para o usuário, removendo-o e inserindo-o novamente.
    Clean Cinema User    ${user_data}[email]
    Insert Cinema User    ${user_data}
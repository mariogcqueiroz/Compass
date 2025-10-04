*** Settings ***
Documentation    Keywords para a API de Autenticação
Resource         ../base.resource

*** Keywords ***
Login User
    [Arguments]    ${user_credentials}
    # Pré-condição: Garantir que o usuário exista (opcional, mas recomendado)
    # Aqui poderíamos ter uma keyword para criar o usuário via /setup/admin ou similar

    # Ação de Login
    ${payload}    Create Dictionary
    ...    email=${user_credentials}[email]
    ...    password=${user_credentials}[password]

    ${resp}    POST
    ...    url=${BASE_URL_API}/auth/login
    ...    json=${payload}
    ...    expected_status=200

    ${token}    Set Variable    Bearer ${resp.json()}[data][token]
    RETURN    ${token}

Login User and get response 
    [Arguments]    ${user_credentials}

    ${resp}    POST
    ...    url=${BASE_URL_API}/auth/login
    ...    json=${user_credentials}
    ...    expected_status=any
    RETURN    ${resp}
Register User
    [Arguments]    ${payload}
    ${resp}    POST
    ...    url=${BASE_URL_API}/auth/register
    ...    json=${payload}
    ...    expected_status=any
    RETURN    ${resp}

Get My Profile
    [Arguments]    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/auth/me
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Update My Profile
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/auth/profile
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
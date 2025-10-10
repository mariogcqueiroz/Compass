*** Settings ***
Library         RequestsLibrary
Resource        ./base.resource
*** Keywords ***
Create Movie Via API
    [Arguments]    ${movie_payload}    ${admin_token}
    [Documentation]    Cria um filme usando a API e retorna o ID.
    ${resp}    Create Movie    ${movie_payload}    ${admin_token}
    Should Be Equal As Integers    ${resp.status_code}    201    msg=Falha ao criar filme de pré-condição via API.
    ${movie_id}    Set Variable    ${resp.json()}[data][_id]
    RETURN    ${movie_id}

Delete Movie Via API
    [Arguments]    ${movie_id}    ${admin_token}
    [Documentation]    Deleta um filme usando a API.
    Run Keyword If    '${movie_id}' != '${None}'
    ...    Delete Movie By Id    ${movie_id}    ${admin_token}


Create Theater via API
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE_URL_API}/theaters
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
   
Delete Theater via API
    [Arguments]    ${theater_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/theaters/${theater_id}
    ...    headers=&{headers}
    ...    expected_status=200
    RETURN    ${resp}

Create Session via API
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE__URL_API}/sessions
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=201
    RETURN    ${resp}
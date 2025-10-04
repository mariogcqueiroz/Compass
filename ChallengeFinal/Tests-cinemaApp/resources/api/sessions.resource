*** Settings ***
Documentation    Keywords para a API de Sessões (Sessions)
Resource         ../base.resource

*** Keywords ***
Create Sessions
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE__URL_API}/sessions
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get Session By Id
    [Arguments]    ${session_id}
    ${resp}    GET
    ...    url=${BASE_URL_API}/sessions/${session_id}
    ...    expected_status=any
    RETURN    ${resp}

Update Sessions
    [Arguments]    ${session_id}    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/sessions/${session_id}
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Delete Session By Id
    [Arguments]    ${session_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/sessions/${session_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Reset Session Seats
    [Arguments]    ${session_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/sessions/${session_id}/reset-seats
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
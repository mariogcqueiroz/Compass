*** Settings ***
Documentation    Keywords para a API de Cinemas (Theaters)
Resource         ../base.resource

*** Keywords ***
Get All Theaters
    [Arguments]    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/theaters
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Create Theater
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE_URL_API}/theaters
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get Theater By Id
    [Arguments]    ${theater_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/theaters/${theater_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Update Theater By Id
    [Arguments]    ${theater_id}    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/theaters/${theater_id}
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Delete Theater By Id
    [Arguments]    ${theater_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/theaters/${theater_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
*** Settings ***
Documentation    Keywords para a API de Usuários (Users)
Resource         ../base.resource

*** Keywords ***
Get All Users
    [Arguments]    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/users
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get User By Id
    [Arguments]    ${user_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/users/${user_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Update User By Id
    [Arguments]    ${user_id}    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/users/${user_id}
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Delete User By Id
    [Arguments]    ${user_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/users/${user_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
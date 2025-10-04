*** Settings ***
Documentation    Keywords para a API de Reservas (Reservations)
Resource         ../base.resource

*** Keywords ***
Create Reservation
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE_URL_API}/reservations
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get My Reservations
    [Arguments]    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/reservations/me
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get All Reservations
    [Arguments]    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/reservations
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Get Reservation By Id
    [Arguments]    ${reservation_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    GET
    ...    url=${BASE_URL_API}/reservations/${reservation_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Update Reservation By Id
    [Arguments]    ${reservation_id}    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/reservations/${reservation_id}
    ...    json=${payload}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}

Delete Reservation By Id
    [Arguments]    ${reservation_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/reservations/${reservation_id}
    ...    headers=&{headers}
    ...    expected_status=any
    RETURN    ${resp}
*** Settings ***
Documentation    Keywords para a API de Filmes (Movies)
Resource         ../base.resource

*** Keywords ***
Get All Movies
    [Arguments]    &{params}
    # O &{params} permite passar filtros como title, genre, etc. de forma opcional
    Run Keyword If    '${params}' == ''    Set To Dictionary    ${params}
    ${resp}    GET
    ...    url=${BASE_URL_API}/movies
    ...    params=&{params}
    RETURN    ${resp}

Get Movie By Id
    [Arguments]    ${movie_id}
    ${resp}    GET
    ...    url=${BASE_URL_API}/movies/${movie_id}   
    ...    expected_status=any
    RETURN    ${resp}

Create Movie
    [Arguments]    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    POST
    ...    url=${BASE_URL_API}/movies
    ...    expected_status=any
    ...    json=${payload}
    ...    headers=&{headers}
    RETURN    ${resp}

Update Movie
    [Arguments]    ${movie_id}    ${payload}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    PUT
    ...    url=${BASE_URL_API}/movies/${movie_id}
    ...    expected_status=any
    ...    json=${payload}
    ...    headers=&{headers}
    RETURN    ${resp}

Delete Movie By Id
    [Arguments]    ${movie_id}    ${token}
    &{headers}    Create Dictionary    Authorization=${token}
    ${resp}    DELETE
    ...    url=${BASE_URL_API}/movies/${movie_id}
    ...    expected_status=any
    ...    headers=&{headers}
    RETURN    ${resp}

Clean Up Created Movie
    [Documentation]    Deleta o filme criado durante o teste para não sujar a base.
    [Arguments]    ${CREATED_MOVIE_ID}    ${ADMIN_TOKEN}    
    Run Keyword If    '${CREATED_MOVIE_ID}' != '${None}'
    ...    Delete Movie By Id    ${CREATED_MOVIE_ID}    ${ADMIN_TOKEN}
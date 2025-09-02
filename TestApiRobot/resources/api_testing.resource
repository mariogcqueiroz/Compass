*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           DateTime

*** Variables ***
${BASE_URL}       https://restful-booker.herokuapp.com
${USERNAME}       admin
${PASSWORD}       password123

*** Keywords ***
Conectar na API
    Create Session    restful_booker    ${BASE_URL}

Verificar se a API está online
    [Documentation]    Faz uma chamada no endpoint /ping para checar a saúde da API.
    ${response}=    GET On Session    restful_booker    /ping
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.text}    Created

Autenticar e obter token
    [Documentation]    Cria um token de autenticação e valida a resposta.
    ${body}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    restful_booker    /auth    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token
    ${token}=    Get From Dictionary    ${response.json()}    token
    Should Not Be Empty    ${token}
    [Return]    ${token}

Listar reservas existentes
    [Documentation]    Busca a lista de reservas e valida se não está vazia.
    ${response}=    GET On Session    restful_booker    /booking
    Should Be Equal As Integers    ${response.status_code}    200
    ${reservas}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${reservas}    A lista de reservas não deveria estar vazia
    [Return]    ${reservas}

Criar uma nova reserva
    [Documentation]    Cria uma nova reserva com dados padrão e retorna o ID.
    ${datas_reserva}=    Create Dictionary
    ...    checkin=2025-09-01
    ...    checkout=2025-09-15
    ${booking_data}=    Create Dictionary
    ...    firstname=Joao
    ...    lastname=Silva
    ...    totalprice=250
    ...    depositpaid=${True}
    ...    bookingdates=${datas_reserva}
    ...    additionalneeds=Cafe da manha
    ${response}=    POST On Session    restful_booker    /booking    json=${booking_data}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    bookingid
    ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
    Should Be True    ${booking_id} > 0
    [Return]    ${booking_id}

Consultar reserva por ID
    [Documentation]    Busca os detalhes de uma reserva específica usando seu ID.
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    restful_booker    /booking/${booking_id}
    Should Be Equal As Integers    ${response.status_code}    200
    ${detalhes}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${detalhes}    Os detalhes da reserva não deveriam estar vazios
    [Return]    ${detalhes}

Validar dados da reserva
    [Documentation]    Valida se os dados da reserva estão corretos.
    [Arguments]    ${detalhes}
    Dictionary Should Contain Key    ${detalhes}    firstname
    Dictionary Should Contain Key    ${detalhes}    lastname
    Dictionary Should Contain Key    ${detalhes}    totalprice
    Dictionary Should Contain Key    ${detalhes}    depositpaid
    Dictionary Should Contain Key    ${detalhes}    bookingdates
    Should Be Equal As Strings    ${detalhes['firstname']}    Joao
    Should Be Equal As Strings    ${detalhes['lastname']}    Silva
    Should Be Equal As Integers    ${detalhes['totalprice']}    250

Atualizar reserva completa
    [Documentation]    Atualiza todos os dados de uma reserva existente.
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${datas_atualizadas}=    Create Dictionary
    ...    checkin=2025-10-01
    ...    checkout=2025-10-15
    ${dados_atualizados}=    Create Dictionary
    ...    firstname=Maria
    ...    lastname=Santos
    ...    totalprice=350
    ...    depositpaid=${False}
    ...    bookingdates=${datas_atualizadas}
    ...    additionalneeds=Almoco
    ${response}=    PUT On Session    restful_booker    /booking/${booking_id}
    ...    json=${dados_atualizados}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()['firstname']}    Maria

Atualizar reserva parcial
    [Documentation]    Atualiza parcialmente os dados de uma reserva.
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${dados_parciais}=    Create Dictionary    firstname=Pedro    totalprice=300
    ${response}=    PATCH On Session    restful_booker    /booking/${booking_id}
    ...    json=${dados_parciais}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()['firstname']}    Pedro
    Should Be Equal As Integers    ${response.json()['totalprice']}    300

Deletar reserva
    [Documentation]    Remove uma reserva existente.
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${response}=    DELETE On Session    restful_booker    /booking/${booking_id}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    201

Consultar reserva inexistente
    [Documentation]    Tenta consultar uma reserva que não existe.
    ${response}=    GET On Session    restful_booker    /booking/99999    expected_status=404
    Should Be Equal As Integers    ${response.status_code}    404

Tentar autenticação inválida
    [Documentation]    Tenta autenticar com credenciais inválidas.
    ${body}=    Create Dictionary    username=invalid    password=invalid
    ${response}=    POST On Session    restful_booker    /auth    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    reason
    Should Be Equal As Strings    ${response.json()['reason']}    Bad credentials

Criar reserva com dados inválidos
    [Documentation]    Tenta criar reserva com dados inválidos.
    ${booking_data}=    Create Dictionary    firstname=${EMPTY}    totalprice=abc
    ${response}=    POST On Session    restful_booker    /booking    json=${booking_data}    expected_status=500
    Should Be Equal As Integers    ${response.status_code}    500

Filtrar reservas por nome
    [Documentation]    Filtra reservas por nome e sobrenome.
    [Arguments]    ${firstname}    ${lastname}
    ${params}=    Create Dictionary    firstname=${firstname}    lastname=${lastname}
    ${response}=    GET On Session    restful_booker    /booking    params=${params}
    Should Be Equal As Integers    ${response.status_code}    200
    ${reservas_filtradas}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${reservas_filtradas}
*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://restful-booker.herokuapp.com
${USERNAME}       admin
${PASSWORD}       password123

*** Keywords ***
Conectar na API
    Create Session    restful_booker    ${BASE_URL}

Verificar se a API está online
    [Documentation]    Faz uma chamada no endpoint /ping para checar a saúde da API.
    Conectar na API
    ${response}=    GET On Session    restful_booker  ${BASE_URL}  /ping
    Should Be Equal As Integers    ${response.status_code}    200

Autenticar e obter token
    [Documentation]    Cria um token de autenticação e valida a resposta.
    Conectar na API
    ${body}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    restful_booker    /auth    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token

Listar reservas existentes
    [Documentation]    Busca a lista de reservas e valida se não está vazia.
    Conectar na API
    ${response}=    GET On Session   restful_booker    /booking
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}    A lista de reservas não deveria estar vazia.

Criar uma nova reserva
    [Documentation]    Cria uma nova reserva com dados padrão e retorna o ID.
    Conectar na API
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
    ${response}=    POST On Session   restful_booker    /booking    json=${booking_data}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    bookingid
    [Return]    ${response.json()['bookingid']}

Consultar reserva por ID
    [Documentation]    Busca os detalhes de uma reserva específica usando seu ID.
    [Arguments]    ${booking_id}
    Conectar na API
    ${response}=    GET On Session   restful_booker    /booking/${booking_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}    Os detalhes da reserva não deveriam estar vazios.
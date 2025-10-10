*** Settings ***
Documentation       Cenários de teste de ponta a ponta para o fluxo de reserva.
Resource            ../../resources/base.resource

Suite Setup         Setup Reservation Suite
Test Setup          Setup Reservation Test
Test Teardown       Teardown Reservation Test
Test Template       Complete Reservation With Payment Method

*** Variables ***
&{TEST_USER}        name=Mario Reserva    email=mario.reserva@gmail.com    password=123456

*** Keywords ***
Setup Reservation Suite
    [Documentation]    Faz o login do admin UMA VEZ para toda a suíte.
    ${admin}          Get Fixture    users.json    admin_user
    Reset Test User   ${admin}
    ${admin_token}    Login User    ${admin}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}

Setup Reservation Test
    [Documentation]    Cria um ecossistema completo (filme, cinema, sessão, usuário) para o teste.
    ${random}             Generate Random String    6    [LOWER]
    ${movie_p}            Get Fixture       movies.json    valid_movie
    Set To Dictionary     ${movie_p}        title=Filme Reserva ${random}
    ${movie_id}           Create Movie Via API    ${movie_p}    ${ADMIN_TOKEN}
    Set Test Variable     ${CREATED_MOVIE_ID}     ${movie_id}
    Set Test Variable     ${TARGET_MOVIE}         ${movie_p}[title]
    ${theater_p}          Get Fixture       reservations.json    theater_for_reservation
    Set To Dictionary     ${theater_p}      name=Sala Reserva ${random}
    ${res_theater}        Create Theater via API    ${theater_p}    ${ADMIN_TOKEN}
    ${theater_id}         Set Variable      ${res_theater.json()}[data][_id]
    Set Test Variable     ${CREATED_THEATER_ID}    ${theater_id}
    ${session_p}          Get Fixture       sessions.json    valid_session
    Set To Dictionary     ${session_p}      movie=${movie_id}    theater=${theater_id}
    Create Session via API    ${session_p}    ${ADMIN_TOKEN}
    Start Session
    Reset Test User    ${TEST_USER}

Teardown Reservation Test
    [Documentation]    Limpa todos os recursos criados para o teste.
    Take Screenshot
    Delete Movie Via API      ${CREATED_MOVIE_ID}      ${ADMIN_TOKEN}
    Delete Theater Via API    ${CREATED_THEATER_ID}    ${ADMIN_TOKEN}
    Clean Cinema User         ${TEST_USER}[email]

Complete Reservation With Payment Method
    [Arguments]    ${payment_method}
    [Documentation]    Template que executa o fluxo de reserva com um método de pagamento.
    Do Login                ${TEST_USER}
    Select Movie By ID   ${CREATED_MOVIE_ID}
    Select Session     17:00
    Select Seats            F-8    
    Proceed To Checkout
    Select Payment Method   ${payment_method}
    Finalize Booking
    Should be on confirmation page  Reserva Confirmada!
    Go To My Reservations Page
    Reservation Card Should Be Visible    ${TARGET_MOVIE}

*** Test Cases ***
FE-RES-TC01 Deve poder reservar com Cartão de Crédito
    Cartão de Crédito

FE-RES-TC02 Deve poder reservar com Cartão de Débito
    Cartão de Débito

FE-RES-TC03 Deve poder reservar com PIX
    PIX

FE-RES-TC04 Deve poder reservar com Transferência
    Transferência Bancária

FE-RES-TC05 Deve poder acessar a tela de minhas reservas e ver detalhes
    [Tags]   smoke
    [Template]    NONE    
    Do Login                ${TEST_USER}
    Select Movie By ID   ${CREATED_MOVIE_ID}
    Select Session     17:00
    Select Seats            F-8    
    Proceed To Checkout
    Select Payment Method   PIX
    Finalize Booking
    Should be on confirmation page  Reserva Confirmada!
    Go To My Reservations Page
    Reservation for Movie Should Have Status    ${TARGET_MOVIE}    CONFIRMADA

FE-RES-TC06 Realizar reserva limpando assentos previamente selecionados
    [Tags]   smoke
    [Template]    NONE    
    Do Login                ${TEST_USER}
    Select Movie By ID   ${CREATED_MOVIE_ID}
    Select Session     17:00
    Select Seats            F-8    
    Proceed To Checkout
    Select Payment Method   PIX
    Finalize Booking
    Should be on confirmation page  Reserva Confirmada!
    Go To Movie List 
    Select Movie By ID   ${CREATED_MOVIE_ID}
    Select Session     17:00
    Reset seats
    Select Seats            F-8    
    Proceed To Checkout
    Select Payment Method   PIX
    Finalize Booking
    Should be on confirmation page  Reserva Confirmada!
*** Settings ***
Documentation       Ações e elementos das páginas de listagem e detalhes de filmes.
Library             Browser
Resource            ../base.resource

*** Keywords ***
Go To reservations
    [Documentation]    Navega para a página inicial que lista os filmes.
    Go To    ${BASE_URL}/reservations

Should Be on reservations Page
    [Documentation]    Verifica se está na pagina de reservas
    ${title_selector}    Set Variable    css=.reservations-header h1
    
    Wait For Elements State    ${title_selector}    visible    5
    Get Text                   ${title_selector}    equal      Minhas Reservas 

Should be on confirmation page
    [Arguments]    ${expected_message}
    [Documentation]    Verifica se está na página de confirmação de reserva com a mensagem correta.
    ${message_selector}    Set Variable    css=.confirmation-header h1
    
    Wait For Elements State    ${message_selector}    visible    5
    Get Text                   ${message_selector}    equal      ${expected_message}
Reservation Details Page Should Be Visible
    [Arguments]    ${movie_name}
    [Documentation]    Verifica se a página de detalhes de uma reserva especifica está confirmada.


    ${title_selector}    Set Variable    css=.status-badge 
    
    Wait For Elements State    ${title_selector}    visible    5
    Get Text                   ${title_selector}    equal      ${movie_name}

Reservation for Movie Should Have Status
    [Arguments]    ${movie_name}    ${expected_status}
    [Documentation]    Encontra o card de uma reserva e verifica o status dela.
    # CORREÇÃO: Esta keyword agora é muito mais útil. Ela primeiro encontra o
    # card da reserva do filme certo, e DENTRO dele, procura pelo status.
    ${card_selector}    Set Variable    css=.reservation-card:has-text("${movie_name}")
    Wait For Elements State    ${card_selector}    visible    5
    Get Text    ${card_selector} >> css=.status-badge    equal    ${expected_status}


Select Session 
    [Arguments]    ${session_time}
    [Documentation]    Encontra um card de sessão pelo horário e clica no botão "Selecionar Assentos" dentro dele.
    
    # Este seletor encontra o card que contém o texto do horário (ex: "20:00")
    # e, a partir dele, encontra o botão para selecionar os assentos.
    ${card_selector}    Set Variable    css=.session-card:has-text("${session_time}")
    
    Wait For Elements State    ${card_selector}    visible    5
    Click    css=a.btn.btn-primary.session-button

Select Seats
    [Arguments]    ${seat_code}
    [Documentation]    Clica em um assento.
    ${row}    Set Variable    ${seat_code.split('-')[0]}
    ${number}    Set Variable    ${seat_code.split('-')[1]}

    # Encontra a fileira com a label correta e dentro dela o assento certo
    ${seat_selector}    Set Variable    css=.seat.available[title^="Fileira ${row}, Assento ${number} "]
    Wait For Elements State    ${seat_selector}    visible    5
    Click    ${seat_selector}
Proceed To Checkout
    [Documentation]    Clica no botão para avançar para o checkout.
    Click    css=.checkout-button >> text=Continuar Para Pagamento

Select Payment Method
    [Arguments]    ${method}
    [Documentation]    Seleciona uma forma de pagamento. Ex: PIX, Cartão de Crédito
    Click    css=.payment-method:has-text("${method}")

Finalize Booking
    [Documentation]    Clica no botão final para confirmar a reserva.
    Click    css=.btn-checkout:has-text("Finalizar Compra")

Go To My Reservations Page
    [Documentation]    Navega para a página de histórico de reservas do usuário.
    Click    css=.nav:nth-child(3) 

Reservation Card Should Be Visible
    [Arguments]    ${movie_title}
    [Documentation]    Verifica se um card de reserva para um filme está visível.
    Wait For Elements State    css=.reservation-card:has-text("${movie_title}")    visible    5

Reset seats
    [Documentation]    Clica no botão para resetar os assentos selecionados.
    Click    css=.btn-sm.reset-seats-btn
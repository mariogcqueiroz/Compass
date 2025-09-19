*** Settings ***
Documentation        Ações e elementos da página de login

Library        Browser
Library        String

*** Keywords ***
User should be logged in
    [Arguments]    ${full_name}


    ${welcome_element}=    Set Variable    css=header .right small

    ${split_name}=         Split String    ${full_name}

    ${first_name}=         Set Variable    ${split_name}[0]
    
    ${expected_message}=   Set Variable    Olá, ${first_name}


    Wait For Elements State    ${welcome_element}    visible    timeout=5s
    Get Text                   ${welcome_element}    ==         ${expected_message}

Go to task form
    Click    css=.button-add
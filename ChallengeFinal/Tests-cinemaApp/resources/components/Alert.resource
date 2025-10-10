*** Settings ***
Documentation        Ações e elementos do componente de alertas
Library        Browser

*** Keywords ***
Alert Should Be
    [Arguments]    ${expected_text}
    Wait For Elements State    css=.alert-content >> text=${expected_text}    visible    5s
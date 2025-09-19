*** Settings ***
Documentation        Ações e elementos da página de login

Library        Browser


*** Keywords ***
Submit login form
    [Arguments]    ${email}    ${password}

    Fill Text      css=input[placeholder$=mail]    ${email}
    Fill Text      css=input[placeholder=Senha]    ${password}

    Click          css=button >> text=Entrar



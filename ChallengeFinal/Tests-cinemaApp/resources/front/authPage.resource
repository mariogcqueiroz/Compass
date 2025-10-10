*** Settings ***
Library          Browser
Documentation    Elementos e ações da página de cadastro
Resource         ../env.resource

*** Keywords ***
Go to signup page
    Go To        ${BASE_URL}/register
    
    # Checkpoint
    Wait For Elements State        css=.register-container h1        visible      5
    Get Text                       css=.register-container h1     equal        Cadastro


Go to login page
    Go To        ${BASE_URL}/login
    
    # Checkpoint
    Wait For Elements State        css=.login-header h1        visible      5
    Get Text                       css=.login-header h1     equal        Login
Submit signup form
    [Arguments]        ${user}

    Fill Text        css=input[id=name]        ${user}[name]
    Fill Text        css=input[id=email]       ${user}[email]
    Fill Text        css=input[id=password]    ${user}[password]
    Fill Text        css=input[id=confirmPassword]     ${user}[password]

    Click            css=button[type=submit] 
Submit login form
    [Arguments]        ${user}

    Fill Text        css=input[id=email]       ${user}[email]
    Fill Text        css=input[id=password]    ${user}[password]

    Click        css=button[type=submit] 


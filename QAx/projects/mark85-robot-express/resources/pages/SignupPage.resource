*** Settings ***
Library          Browser
Documentation    Elementos e ações da página de cadastro
Resource        ../libs/env.resource

*** Keywords ***
Go to Signup Page
    Go To               ${BASE_URL}/signup


    Wait For Elements State    css=h1    visible    5
    Get Text                   css=h1    ==         Faça seu cadastro

Submit Signup Form
    [Arguments]    ${name}    ${email}    ${password}
    Fill Text    id=name        ${name}
    Fill Text    id=email       ${email}
    Fill Text    id=password    ${password}
    Click               id=buttonSignup



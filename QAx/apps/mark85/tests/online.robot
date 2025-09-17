*** Settings ***
Documentation    On line
Library          Browser

*** Test Cases ***
O web app deve estar online
    [Documentation]    Verificar se a aplicação web está online.
    New Browser      browser=chromium    headless=False
    New Page         http://localhost:3000
    Sleep            3s  # Pausa por 3 segundos para observação
    ${title}=        Get Title
    Should Be Equal As Strings    ${title}    Mark85 by QAx
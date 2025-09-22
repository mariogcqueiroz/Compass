*** Settings ***
Documentation    On line
Library          Browser
Resource    ../resources/base.resource

*** Test Cases ***
O web app deve estar online
    [Documentation]    Verificar se a aplicação web está online.
    Start Session
    ${title}=        Get Title
    Should Be Equal As Strings    ${title}    Mark85 by QAx
*** Settings ***
Documentation    Configuração inicial do projeto
Library          RequestsLibrary

*** Variables ***
${BASE_URL}      https://serverest.dev

*** Keywords ***
Iniciar Sessao
    Create Session    serverest    ${BASE_URL}

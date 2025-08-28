*** Settings ***
Resource          ../resources/api_testing.resource

*** Test Cases ***
Cenário 01: Verificar Saúde da API
    Verificar se a API está online

Cenário 02: Obter Token de Autenticação
    Autenticar e obter token

Cenário 03: Listar Reservas
    Listar reservas existentes

Cenário 04: Criar Nova Reserva
    Criar uma nova reserva

Cenário 05: Consultar Reserva por ID
    ${id_reserva}=    Criar uma nova reserva
    Consultar reserva por ID    ${id_reserva}
*** Settings ***
Resource          ../resources/api_testing.resource
Suite Setup       Conectar na API
Suite Teardown    Delete All Sessions

*** Test Cases ***
Cenário 01: Verificar Saúde da API
    Verificar se a API está online

Cenário 02: Obter Token de Autenticação
    ${token}=    Autenticar e obter token
    Should Not Be Empty    ${token}

Cenário 03: Listar Reservas
    ${reservas}=    Listar reservas existentes
    Should Be True    len($reservas) > 0

Cenário 04: Criar Nova Reserva
    ${id_reserva}=    Criar uma nova reserva
    Should Be True    ${id_reserva} > 0

Cenário 05: Consultar Reserva por ID
    ${id_reserva}=    Criar uma nova reserva
    ${detalhes}=    Consultar reserva por ID    ${id_reserva}
    Validar dados da reserva    ${detalhes}

Cenário 06: Atualizar Reserva Completa
    ${token}=    Autenticar e obter token
    ${id_reserva}=    Criar uma nova reserva
    Atualizar reserva completa    ${id_reserva}    ${token}

Cenário 07: Atualizar Reserva Parcial
    ${token}=    Autenticar e obter token
    ${id_reserva}=    Criar uma nova reserva
    Atualizar reserva parcial    ${id_reserva}    ${token}

Cenário 08: Deletar Reserva
    ${token}=    Autenticar e obter token
    ${id_reserva}=    Criar uma nova reserva
    Deletar reserva    ${id_reserva}    ${token}

Cenário 09: Consultar Reserva Inexistente
    Consultar reserva inexistente

Cenário 10: Autenticação com Credenciais Inválidas
    Tentar autenticação inválida

Cenário 11: Criar Reserva com Dados Inválidos
    Criar reserva com dados inválidos

Cenário 12: Filtrar Reservas por Nome
    ${id_reserva}=    Criar uma nova reserva
    Filtrar reservas por nome    Joao    Silva
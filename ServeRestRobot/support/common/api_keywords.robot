*** Settings ***
Documentation       Keywords centralizadas para todos os endpoints da API ServeRest e para manipulação de dados de teste.
Library             RequestsLibrary
Library             Collections
Library             Process
Resource            ./common.robot

*** Keywords ***
# =========================================================
# KEYWORDS DE DADOS (FIXTURES)
# =========================================================
Pegar Dados de Usuario Estatico
    [Arguments]    ${tipo_usuario}
    ${json}=    Importar JSON    usuarios_validos.json
    Set Suite Variable    ${payload}    ${json["${tipo_usuario}"]}

Pegar Dados de Login Estatico
    [Arguments]    ${tipo_login}
    ${json}=    Importar JSON    login.json
    Set Suite Variable    ${payload}    ${json["${tipo_login}"]}

Pegar Dados Invalidos de Usuario
    [Arguments]    ${cenario_invalido}
    ${json}=    Importar JSON    usuarios_invalidos.json
    Set Suite Variable    ${payload}    ${json["${cenario_invalido}"]}

Pegar Dados Invalidos de Produto
    [Arguments]    ${cenario_invalido}
    ${json}=    Importar JSON    produtos_invalidos.json
    Set Suite Variable    ${payload}    ${json["${cenario_invalido}"]}

# =========================================================
# USUÁRIOS (/usuarios)
# =========================================================
POST Usuario
    [Arguments]    &{payload}
    &{header}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    headers=&{header}    expected_status=any
    RETURN    ${response}

GET Usuarios
    [Arguments]    ${token}=${null}
    &{header}=    Create Dictionary    Content-Type=application/json
    IF    '${token}' != '${null}'
        Set To Dictionary    ${header}    Authorization=${token}
    END
    ${response}=    GET On Session    serverest    /usuarios    headers=&{header}    expected_status=any
    RETURN    ${response}

GET Usuario por ID
    [Arguments]    ${id_usuario}
    ${response}=    GET On Session    serverest    /usuarios/${id_usuario}    expected_status=any
    RETURN    ${response}

PUT Usuario por ID
    [Arguments]    ${id_usuario}    &{payload}
    &{header}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    serverest    /usuarios/${id_usuario}    json=${payload}    headers=&{header}    expected_status=any
    RETURN    ${response}

DELETE Usuario por ID
    [Arguments]    ${id_usuario}
    ${response}=    DELETE On Session    serverest    /usuarios/${id_usuario}    expected_status=any
    RETURN    ${response}

# =========================================================
# LOGIN (/login)
# =========================================================
POST Login
    [Arguments]    ${payload}=${None}
    ${response}=    POST On Session    serverest    /login    json=${payload}    expected_status=any
    RETURN    ${response}

# =========================================================
# PRODUTOS (/produtos)
# =========================================================
POST Produto
    [Arguments]    ${token}    ${payload}
    &{header}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=&{header}    expected_status=any
    RETURN    ${response}

GET Produtos
    ${response}=    GET On Session    serverest    /produtos    expected_status=any
    RETURN    ${response}

GET Produto por ID
    [Arguments]    ${id_produto}
    ${response}=    GET On Session    serverest    /produtos/${id_produto}    expected_status=any
    RETURN    ${response}

PUT Produto por ID
    [Arguments]    ${token}    ${id_produto}    ${payload}
    &{header}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    PUT On Session    serverest    /produtos/${id_produto}    json=${payload}    headers=&{header}    expected_status=any
    RETURN    ${response}

DELETE Produto por ID
    [Arguments]    ${token}    ${id_produto}
    &{header}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /produtos/${id_produto}    headers=&{header}    expected_status=any
    RETURN    ${response}

# =========================================================
# CARRINHOS (/carrinhos)
# =========================================================
POST Carrinho
    [Arguments]    ${token}    ${payload}
    &{header}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    POST On Session    serverest    /carrinhos    json=${payload}    headers=&{header}    expected_status=any
    RETURN    ${response}

GET Carrinhos
    [Arguments]    ${token}
    &{header}=    Create Dictionary    Authorization=${token}
    ${response}=    GET On Session    serverest    /carrinhos    headers=&{header}    expected_status=any
    RETURN    ${response}

GET Carrinho por ID
    [Arguments]    ${id_carrinho}
    ${response}=    GET On Session    serverest    /carrinhos/${id_carrinho}    expected_status=any
    RETURN    ${response}

DELETE Concluir Compra
    [Arguments]    ${token}
    &{header}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/concluir-compra    headers=&{header}    expected_status=any
    RETURN    ${response}

DELETE Cancelar Compra
    [Arguments]    ${token}
    &{header}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=&{header}    expected_status=any
    RETURN    ${response}

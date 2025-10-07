*** Settings ***
Documentation       Cenários de teste para o endpoint /usuarios, cobrindo a User Story US001.
Resource            ../../support/common/api_keywords.robot
Resource            ../../config/config.robot
Resource            ../../support/fixtures/dynamics.robot
Suite Setup         Iniciar Sessao e Criar Usuario Base
Suite Teardown      Deletar Usuario Base

*** Test Cases ***
US001-TC01: Cadastrar usuário não administrador com dados válidos
    [Tags]    US001    TC01    happy_path
    GIVEN que eu tenha os dados de um novo usuário
    WHEN eu envio uma requisição POST para /usuarios
    THEN o usuário deve ser criado com sucesso e status 201

US001-TC02: Tentar cadastrar um usuário com e-mail já existente
    [Tags]    US001    TC02    sad_path
    GIVEN que eu tenha um usuário já cadastrado
    WHEN eu tento cadastrar um novo usuário com o mesmo e-mail
    THEN a API deve retornar um erro de e-mail duplicado com status 400

US001-TC06: Listar todos os usuários cadastrados
    [Tags]    US001    TC06    happy_path
    WHEN eu envio uma requisição GET para /usuarios
    THEN a API deve retornar a lista de usuários com status 200

US001-TC09: Atualizar um usuário existente com dados válidos
    [Tags]    US001    TC09    happy_path
    GIVEN que eu tenha um usuário já cadastrado
    WHEN eu envio uma requisição PUT para atualizar o usuário com dados válidos
    THEN o usuário deve ser atualizado com sucesso e status 200

US001-TC10: Atualizar (PUT) um usuário informando um ID inexistente (deve criar um novo)
    [Tags]    US001    TC10    happy_path
    GIVEN que eu tenha os dados de um novo usuário
    WHEN eu envio uma requisição PUT para atualizar um usuário com ID inexistente
    THEN a API deve criar um novo usuário com sucesso e status 201
    [Teardown]    Remover Usuario Secundario
US001-TC12: Deletar um usuário existente
    [Tags]    US001    TC12    happy_path
    GIVEN que eu tenha um usuário já cadastrado
    WHEN eu envio uma requisição DELETE para o ID deste usuário
    THEN o usuário deve ser deletado com sucesso e status 200

US001-TC13: Tentar deletar um usuário inexistente
    [Tags]    US001    TC13    sad_path    bug_reportado
    WHEN eu tento deletar um usuário com um ID que não existe
    THEN a API deve retornar a mensagem "Nenhum registro excluído" com status 200

*** Keywords ***
Iniciar Sessao e Criar Usuario Base
    Iniciar Sessao
    &{payload_base}=    Criar Usuario Valido
    ${response}=    POST Usuario    &{payload_base}
    Set Suite Variable    ${ID_USUARIO_BASE}    ${response.json()["_id"]}
    Set Suite Variable    ${EMAIL_BASE}    ${payload_base["email"]}

Deletar Usuario Base
    Run Keyword And Ignore Error    DELETE Usuario por ID    ${ID_USUARIO_BASE}

que eu tenha os dados de um novo usuário
    &{payload}=    Criar Usuario Valido
    Set Test Variable    ${payload}

que eu tenha um usuário já cadastrado
    Log    Usando usuário base com ID: ${ID_USUARIO_BASE}

eu envio uma requisição PUT para atualizar um usuário com ID inexistente
    ${id_inexistente}=    Set Variable    id_inexistente_12345
    ${response}=    PUT Usuario por ID    ${id_inexistente}    &{payload}
    Set Test Variable    ${response}
    # Guardar o ID retornado para exclusão no teardown
    Set Test Variable    ${ID_USUARIO_SECUNDARIO}    ${response.json()["_id"]}

a API deve criar um novo usuário com sucesso e status 201
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()["message"]}    Cadastro realizado com sucesso
    Dictionary Should Contain Key  ${response.json()}    _id
Remover Usuario Secundario
    Run Keyword And Ignore Error    DELETE Usuario por ID    ${ID_USUARIO_SECUNDARIO}
eu envio uma requisição POST para /usuarios
    ${response}=    POST Usuario    &{payload}
    Set Test Variable    ${response}

eu tento cadastrar um novo usuário com o mesmo e-mail
    &{payload_duplicado}=    Criar Usuario Valido
    Set To Dictionary    ${payload_duplicado}    email=${EMAIL_BASE}
    ${response}=    POST Usuario    &{payload_duplicado}
    Set Test Variable    ${response}

eu envio uma requisição GET para /usuarios
    ${response}=    GET Usuarios
    Set Test Variable    ${response}

eu envio uma requisição PUT para atualizar o usuário com dados válidos
    &{payload_update}=    Criar Usuario Valido    admin=true
    ${response}=    PUT Usuario por ID    ${ID_USUARIO_BASE}    &{payload_update}
    Set Test Variable    ${response}

eu tento atualizar o segundo usuário com o e-mail do primeiro
    &{payload_update}=    Criar Usuario Valido
    Set To Dictionary    ${payload_update}    email=${EMAIL_BASE}
    Log    Tentando atualizar usuário ${ID_USUARIO_SECUNDARIO} com email duplicado: ${EMAIL_BASE}
    ${response}=    PUT Usuario por ID    ${ID_USUARIO_SECUNDARIO}    &{payload_update}
    Set Test Variable    ${response}

eu envio uma requisição DELETE para o ID deste usuário
    ${response}=    DELETE Usuario por ID    ${ID_USUARIO_BASE}
    Set Test Variable    ${response}
    Set Suite Variable    ${ID_USUARIO_BASE}    ${null}

eu tento deletar um usuário com um ID que não existe
    ${response}=    DELETE Usuario por ID    id_inexistente_12345
    Set Test Variable    ${response}

o usuário deve ser criado com sucesso e status 201
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()["message"]}    Cadastro realizado com sucesso
    ${id_criado}=    Set Variable    ${response.json()["_id"]}
    Run Keyword And Ignore Error    DELETE Usuario por ID    ${id_criado}

a API deve retornar um erro de e-mail duplicado com status 400
    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()["message"]}    Este email já está sendo usado

a API deve retornar a lista de usuários com status 200
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()["usuarios"]}

o usuário deve ser atualizado com sucesso e status 200
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()["message"]}    Registro alterado com sucesso

o usuário deve ser deletado com sucesso e status 200
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()["message"]}    Registro excluído com sucesso

a API deve retornar a mensagem "Nenhum registro excluído" com status 200
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()["message"]}    Nenhum registro excluído

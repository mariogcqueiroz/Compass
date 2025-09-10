*** Settings ***
Documentation    Geração dinâmica de dados de usuários
Library          FakerLibrary

*** Keywords ***
Criar Usuário Valido
    ${nome}      FakerLibrary.First Name
    ${email}     FakerLibrary.Email
    ${senha}     FakerLibrary.Password    length=8    special_chars=True
    &{payload}   Create Dictionary
    ...          nome=${nome}
    ...          email=${email}
    ...          password=${senha}
    ...          administrador=false
    [Return]     ${payload}

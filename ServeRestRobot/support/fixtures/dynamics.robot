*** Settings ***
Documentation    Massa dinâmica para usuários, produtos e carrinhos (FakerLibrary)
Library          FakerLibrary

*** Keywords ***
Criar Usuario Valido
    [Arguments]    ${admin}=false
    ${nome}=      FakerLibrary.First Name
    ${email}=     FakerLibrary.Email
    ${senha}=     FakerLibrary.Password    length=8
    &{payload}=   Create Dictionary
    ...           nome=${nome}
    ...           email=${email}
    ...           password=${senha}
    ...           administrador=${admin}
    RETURN        &{payload}

Criar Produto Valido
    ${nome}=      FakerLibrary.Word
    ${preco}=     FakerLibrary.Random Int    min=10    max=5000
    ${descricao}=  FakerLibrary.Sentence
    ${quantidade}=    FakerLibrary.Random Int    min=1    max=100
    &{payload}=   Create Dictionary
    ...           nome=${nome}
    ...           preco=${preco}
    ...           descricao=${descricao}
    ...           quantidade=${quantidade}
    RETURN        &{payload}

Criar Carrinho Valido
    [Arguments]    ${id_produto}    ${quantidade}=1
    Run Keyword If    '${id_produto}' == '${null}'    Fail    id_produto é obrigatório para Criar Carrinho Valido
    &{item}=       Create Dictionary    idProduto=${id_produto}    quantidade=${quantidade}
    @{lista}=      Create List    ${item}
    &{payload}=    Create Dictionary    produtos=${lista}
    RETURN         &{payload}

*** Settings ***
Documentation        Ações e elementos do componente de notificações

Library        Browser


*** Keywords ***
Notice should be
    [Arguments]    ${expected_text}

    ${element}        Set Variable        css=.alert-content
    
    Wait For Elements State      ${element}        visible        5
    Get Text                     ${element}        equal          ${expected_text}

Field validation message should be
    [Arguments]    ${field_selector}    ${expected_text_fragment}
    [Documentation]    Verifica se a mensagem de validação CONTÉM um texto específico.
    
    ${actual_message} =    Get Property    ${field_selector}    validationMessage
    
    Should Contain    ${actual_message}    ${expected_text_fragment}
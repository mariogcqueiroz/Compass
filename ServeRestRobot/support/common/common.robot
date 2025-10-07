*** Settings ***
Documentation    Keywords de utilidades comuns, como manipulação de arquivos
Library          OperatingSystem
Library          Collections
Library          JSONLibrary

*** Keywords ***
Importar JSON
    [Arguments]    ${file_name}
    ${file_path}=    Set Variable    ${EXECDIR}/support/fixtures/${file_name}
    ${json}=    Load JSON From File    ${file_path}
    RETURN    ${json}

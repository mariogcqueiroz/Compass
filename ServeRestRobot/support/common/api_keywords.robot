*** Settings ***
Library    RequestsLibrary
Resource   ../../config/config.robot
*** Keywords ***
POST Request
    [Arguments]    ${endpoint}    ${payload}    ${headers}={}
    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    ${endpoint}    json=${payload}    headers=${headers}
    [Return]    ${response}

GET Request
    [Arguments]    ${endpoint}    ${headers}={}
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    ${endpoint}    headers=${headers}
    [Return]    ${response}

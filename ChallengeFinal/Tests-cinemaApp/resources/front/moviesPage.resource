*** Settings ***
Documentation       Ações e elementos das páginas de listagem e detalhes de filmes.
Library             Browser
Resource            ../base.resource

*** Keywords ***
Go To Movie List
    [Documentation]    Navega para a página inicial que lista os filmes.
    Go To    ${BASE_URL}/movies

Should Be On Movie List Page
    [Documentation]    Verifica se está na pagina de listagem de filmes.
    ${title_selector}    Set Variable    css=.movies-container h1
    
    Wait For Elements State    ${title_selector}    visible    5
    Get Text                   ${title_selector}    equal      Filmes em Cartaz
Select Movie By ID
    [Arguments]    ${movie_ID}
    [Documentation]    Clica no card de um filme específico na listagem.
 
    ${card_selector}    Set Variable    css=a[href*="${movie_ID}"]
    
    Wait For Elements State    ${card_selector}    visible    5
    Click                      ${card_selector}

Movie Details Page Should Be Visible
    [Arguments]    ${movie_name}
    [Documentation]    Verifica se a página de detalhes do filme correto foi carregada.

    # Verifica se o título do filme (h1) está visível na página de detalhes.
    ${title_selector}    Set Variable    css=.movie-info h1
    
    Wait For Elements State    ${title_selector}    visible    5
    Get Text                   ${title_selector}    equal      ${movie_name}


# Testes Automatizados da API Restful Booker com Robot Framework

Este projeto contém uma suíte de testes automatizados para a [Restful Booker API](https://restful-booker.herokuapp.com/apidoc/index.html) utilizando o Robot Framework e a RequestsLibrary.


## Pré-requisitos

- Python 3.7+
- [pip](https://pip.pypa.io/en/stable/)
- [Robot Framework](https://robotframework.org/)
- [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests)

## Instalação

1. Clone este repositório:
    ```sh
    git clone https://github.com/mariogcqueiroz/Compass.git
    cd TestApiRobot
    ```

2. Crie um ambiente virtual (opcional, mas recomendado):
    ```sh
    python3 -m venv venv
    source venv/bin/activate
    ```

3. Instale as dependências:
    ```sh
    pip install robotframework robotframework-requests
    ```

## Como Executar os Testes

Execute todos os testes com o comando:

```sh
robot tests/

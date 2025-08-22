# Calculadora em Python

## 1. Descrição

Este projeto consiste na criação de uma classe `Calculadora` em Python, desenvolvida com foco em robustez e boas práticas de programação. A calculadora implementa as quatro operações matemáticas básicas e duas operações adicionais (potenciação e raiz quadrada).

Todo o desenvolvimento foi guiado por testes (TDD-like) utilizando o framework **Pytest** para garantir a confiabilidade e a corretude dos métodos.

## 2. Funcionalidades

A classe `Calculadora` possui os seguintes métodos:

* **Operações Básicas:**
    * `adicionar(a, b)`
    * `subtrair(a, b)`
    * `multiplicar(a, b)`
    * `dividir(a, b)`
* **Operações Adicionais:**
    * `potencia(base, expoente)`
    * `raiz_quadrada(numero)`

## 3. Estrutura do Projeto

```
calculadora_projeto/
├── calculadora/
│   ├── main.py
│   └── test_calculadora.py
├── .gitignore
├── README.md
└── requirements.txt
```

## 4. Instalação e Funcionamento

Siga os passos abaixo para configurar e executar o projeto em seu ambiente local.

### Pré-requisitos

* Python 3.8 ou superior
* pip (gerenciador de pacotes do Python)

### Passos para Instalação

1.  **Clone o repositório:**
    ```bash
    git clone <https://github.com/mariogcqueiroz/Compass/tree/Sprint5>
    cd CalculadoraPytest
    ```

2.  **Crie e ative um ambiente virtual (Recomendado):**
    ```bash
    # Para Windows
    python -m venv venv
    .\venv\Scripts\activate

    # Para macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Instale as dependências:**
    O projeto utiliza Pytest para os testes. Instale-o a partir do arquivo `requirements.txt`.
    ```bash
    pip install -r requirements.txt
    ```

### Executando os Testes

Para verificar se a calculadora está funcionando corretamente, execute os testes automatizados com Pytest. No diretório raiz (`CalculadoraPytest`), execute o comando:

```bash
pytest
```
ou 
python3 -m pytest

Você verá a saída dos testes, indicando se todos passaram com sucesso.

### Como Utilizar a Calculadora

Você pode importar a classe `Calculadora` em outros scripts Python para utilizá-la.

```python
# Exemplo de uso em um arquivo app.py
from calculadora.main import Calculadora

# Crie uma instância da calculadora
calc = Calculadora()

# Use os métodos
soma = calc.adicionar(10, 5)
print(f"Soma: {soma}") # Saída: Soma: 15

pot = calc.potencia(2, 3)
print(f"Potência: {pot}") # Saída: Potência: 8

try:
    resultado_divisao = calc.dividir(10, 0)
except ValueError as e:
    print(e) # Saída: Erro: Divisão por zero não é permitida.

```


## 5. Referências

Para o desenvolvimento deste projeto, foram consultados os seguintes recursos:
* **Documentação Oficial do Pytest:** Para a criação e estruturação dos testes. (https://docs.pytest.org)
* **Google Gemini:** Utilizada como ferramenta de assistência para brainstorming e geração de documentação.
# Suíte de Testes Automatizados - Cinema App

Este repositório contém a suíte de testes automatizados para a aplicação **Cinema App**, cobrindo tanto o **Backend (API)** quanto o **Frontend (E2E)**. Os testes são desenvolvidos com [Robot Framework](https://robotframework.org/) e suas bibliotecas.

O principal objetivo desta suíte é garantir a qualidade, a estabilidade e a correção das regras de negócio da aplicação, simulando interações de API e jornadas de usuário no navegador.

## 🏛️ Arquitetura de Testes

A automação está dividida em duas camadas principais:

1.  **Testes de API (`/tests/api`):** Validam a lógica de negócio, contratos, segurança e regras de banco de dados diretamente nos endpoints. Esta é a base da pirâmide de testes, com uma cobertura de 111 cenários.
2.  **Testes de Frontend E2E (`/tests/front`):** Validam os fluxos críticos do usuário final em um navegador real, garantindo a integração entre a interface e o backend. Focam na experiência de um usuário comum (cadastro, login, reserva).

## 📋 Pré-requisitos

Antes de começar, garanta que você tenha os seguintes softwares instalados e configurados em sua máquina:

* **Node.js** (v16.0 ou superior)
* **MongoDB** (serviço local rodando ou uma instância no Atlas)
* **Python** (v3.8 ou superior)
* **Git** para clonar os repositórios

## 🚀 Guia de Instalação e Configuração

Para executar os testes, é necessário configurar três componentes: o **Backend**, o **Frontend** e a **Suíte de Testes**. Recomenda-se usar três janelas de terminal separadas.

### Passo 1: Configurar o Backend

1.  **Clone o repositório do backend:**
    ```bash
    git clone [https://github.com/juniorschmitz/cinema-challenge-back.git](https://github.com/juniorschmitz/cinema-challenge-back.git)
    cd cinema-challenge-back
    ```

2.  **Instale as dependências:**
    ```bash
    npm install
    ```

3.  **Configure as variáveis de ambiente:** Crie um arquivo `.env` na raiz do projeto com o seguinte conteúdo:
    ```
    PORT=3000
    MONGODB_URI=mongodb://localhost:27017/cinema-app
    ```
    
(configure o mongodb URI de acordo com sua implementação para o banco, podendo ser cloud(https://cloud.mongodb.com/) ou local).
4.  **Inicie o servidor do backend:**
    ```bash
    npm run dev
    ```
    O servidor deverá estar rodando em `http://localhost:3000`.

### Passo 2: Configurar o Frontend

1.  **Clone o repositório do frontend:**
    ```bash
    git clone [https://github.com/juniorschmitz/cinema-challenge-front.git](https://github.com/juniorschmitz/cinema-challenge-front.git)
    cd cinema-challenge-front
    ```

2.  **Instale as dependências:**
    ```bash
    npm install
    ```

3.  **Inicie o servidor de desenvolvimento:**
    ```bash
    npm run dev
    ```
    A aplicação deverá estar acessível em `http://localhost:3002` (ou outra porta indicada no terminal).

### Passo 3: Configurar a Suíte de Testes (Este Repositório)

1.  **Clone este repositório:**
    ```bash
    git clone <url-do-seu-repositorio-de-testes>
    cd <pasta-do-seu-repositorio-de-testes>
    ```

2.  **Instale as dependências Python:** Crie um arquivo `requirements.txt` na raiz do projeto com o conteúdo abaixo e execute o comando de instalação.

    **Arquivo `requirements.txt`:**
    ```
    robotframework
    robotframework-browser
    robotframework-requests
    pymongo
    bcrypt
    ```

    **Comando de instalação:**
    ```bash
    pip install -r requirements.txt
    ```

3.  **Inicialize a Browser Library:** Este comando fará o download dos navegadores necessários para os testes de frontend.
    ```bash
    rfbrowser init
    ```

## ⚡ Executando os Testes

Com os servidores do backend e frontend rodando, você pode executar os testes automatizados.

### Executar Testes da API

Para validar todos os endpoints do backend:
```bash
python3 -m robot -d ./reports tests/api

Executar Testes do Frontend (E2E)
Para validar os fluxos de usuário no navegador:

Bash

python3 -m robot -d ./reports tests/front
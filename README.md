# To-Do App com Expo, Docker e CI/CD no Azure

Este projeto demonstra a criação de um aplicativo "To-Do" utilizando Expo (React Native para Web), com um pipeline de CI/CD configurado no GitHub Actions para construir uma imagem Docker multi-stage e fazer o deploy para o Azure Web App for Containers.

## Estrutura do Projeto

- `App.js`: O código-fonte principal do aplicativo To-Do em React Native.
- `package.json`: Define as dependências e scripts do projeto.
- `app.json`: Configurações do Expo para o aplicativo.
- `Dockerfile`: Instruções para construir a imagem Docker da aplicação web.
- `.dockerignore`: Arquivos e diretórios a serem ignorados pelo Docker durante a construção da imagem.
- `.github/workflows/main.yml`: Workflow do GitHub Actions para CI/CD.

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- Node.js e npm
- Expo CLI (`npm install -g expo-cli`)
- Docker
- Conta no Docker Hub
- Conta no Azure
- Repositório no GitHub

## Configuração Local

Para rodar o aplicativo localmente:

1. Clone o repositório:
   ```bash
   git clone <URL_DO_SEU_REPOSITORIO>
   cd todo-app
   ```
2. Instale as dependências:
   ```bash
   npm install
   ```
3. Inicie o aplicativo web:
   ```bash
   npm start --web
   ```
   O aplicativo estará disponível em `http://localhost:19006` (ou outra porta indicada).

## Dockerfile

O `Dockerfile` utiliza um build multi-stage para otimizar o tamanho da imagem final:

- **Estágio 1 (build)**: Utiliza uma imagem `node:18-alpine` para instalar as dependências e construir a aplicação web do Expo, gerando os arquivos estáticos na pasta `dist`.
- **Estágio 2 (serve)**: Utiliza uma imagem `nginx:stable-alpine` para servir os arquivos estáticos gerados no estágio anterior. Isso resulta em uma imagem final leve e segura.

## GitHub Actions (CI/CD)

O arquivo `.github/workflows/main.yml` define o pipeline de CI/CD que será executado no GitHub Actions. Ele é composto por dois jobs principais:

### 1. `build-and-push`

Este job é responsável por:

- Fazer o checkout do código do repositório.
- Realizar o login no Docker Hub utilizando as credenciais configuradas como secrets.
- Construir a imagem Docker com base no `Dockerfile` e fazer o push para o Docker Hub com a tag `seu-usuario-do-docker/todo-app:latest`.

**Secrets Necessários para Docker Hub:**

Você precisará configurar os seguintes secrets no seu repositório GitHub (Settings > Secrets and variables > Actions > New repository secret):

- `DOCKERHUB_USERNAME`: Seu nome de usuário do Docker Hub.
- `DOCKERHUB_TOKEN`: Um Personal Access Token (PAT) do Docker Hub com permissões de escrita. **NUNCA use sua senha diretamente!**

### 2. `deploy-to-azure`

Este job é responsável por:

- Realizar o login no Azure utilizando as credenciais configuradas como secrets.
- Fazer o deploy da imagem Docker construída (disponível no Docker Hub) para um Azure Web App for Containers.

**Secrets Necessários para Azure:**

Você precisará configurar o seguinte secret no seu repositório GitHub:

- `AZURE_CREDENTIALS`: As credenciais de login do Azure. Você pode obter isso gerando um Service Principal no Azure e configurando-o no GitHub. Exemplo de como obter as credenciais:
  ```bash
  az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --json-auth
  ```
  Copie a saída JSON e cole-a no secret `AZURE_CREDENTIALS`.

## Deploy para o Azure

O deploy para o Azure é feito automaticamente pelo GitHub Actions após o build e push da imagem para o Docker Hub. Certifique-se de que você tem um Azure Web App for Containers criado e configurado para puxar imagens do Docker Hub.

## Como Usar o CI/CD

1. Configure os secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` e `AZURE_CREDENTIALS` no seu repositório GitHub.
2. Faça um commit e push para a branch `main` (ou `master`).
3. Vá para a aba "Actions" do seu repositório no GitHub para acompanhar o progresso do pipeline.

## Avaliação

Para avaliação, você deverá fornecer:

- Link do Repositório GitHub (público).
- Link da Imagem Pública no Docker Hub (ex: `hub.docker.com/r/seu-usuario/todo-app`).
- Screenshot da aba "Actions" do GitHub mostrando o workflow com sucesso.

---

**Autor:** Manus AI
**Data:** 01 de Junho de 2026

# Estágio 1: Build da aplicação Node.js
FROM node:22-alpine AS build

WORKDIR /app

# Copia os arquivos de dependências
COPY package*.json ./

# Instala as dependências (limpando o cache para garantir)
RUN npm install

# Copia o restante dos arquivos do projeto
COPY . .

# Faz o build da aplicação para web
RUN npm run build:web

# Estágio 2: Servindo com NGINX
FROM nginx:stable-alpine

# Copia os arquivos estáticos gerados no estágio anterior
COPY --from=build /app/dist /usr/share/nginx/html

# Expõe a porta 80
EXPOSE 80

# Comando para rodar o NGINX
CMD ["nginx", "-g", "daemon off;"]

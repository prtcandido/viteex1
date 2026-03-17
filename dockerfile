# Estágio 1: Build
FROM node:20-slim AS build
WORKDIR /app

# Copia arquivos de dependências primeiro (otimiza o cache de camadas)
COPY package*.json ./
RUN npm install

# Copia o restante dos arquivos e gera o build
COPY . .
RUN npm run build

# Estágio 2: Produção (Servidor Nginx)
FROM nginx:alpine
# Copia o resultado do build do estágio anterior para a pasta do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
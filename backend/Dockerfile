# Image Docker du backend.
# installe les dépendances et lance directement le serveur sans étape de build.
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3001

CMD ["node", "src/index.js"]

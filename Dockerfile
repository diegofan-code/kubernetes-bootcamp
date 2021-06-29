FROM node:16.3.0-buster-slim
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
EXPOSE 8080
CMD ["node", "index.js"]

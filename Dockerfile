FROM node:16.3.0-buster-slim
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
EXPOSE 8080
CMD ["node", "index.js", "--workers=3", "--bind", "0.0.0.0:8080", "app:app"]

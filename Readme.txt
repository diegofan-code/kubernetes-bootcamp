
#########README############

Direitos ao kubedev.io bootcamp de kubernetes

Tutorial do passo a passo para criar um Kubernetes local:

Passo 1 : Cria um arquivo Dockerfile especificando a imagem:

Exemplo:

FROM node:16.3.0-buster-slim
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
EXPOSE 8080
CMD ["node", "index.js", "--workers=3", "--bind", "0.0.0.0:8080", "app:app"]


Aqui você especifica os pacotes, a porta que irá setar, a imagem que irá usar, nesse caso deve ir para o site
do dockerhub para ver qual a imagem que deseja usar.


- Roda o arquivo Dockerfile criando uma imagem : exemplo "docker build -t diegofan/api-conversao-diego:v1 ." # lembra de especificar o "." pois está indo no diretório local. A imagem tem que ser com seu nome.

- Dá um push na imagem com o comando "docker push diegofan/apiconversao-diego:v1"

- Cria a Tag "latest" para pegar a última versão com o comando "docker tag diegofan/api-conversao-diego:v1 diegofan
/api-conversao-diego:latest"

- Dá um push novamente na imagem com o comando "docker push diegofan/apiconversao-diego:latest" criando a versão latest.


Passo 2 : Criado a imagem agora vamos criar o cluster, usaremos o k3d para a criação.


- Roda o comando " k3d cluster create meucluster --servers 1 --agents 2 -p "8080:30000@loadbalancer" "

- verifica o cluster criado com o comando "kubectl get nodes"


Passo 3 : Criado o cluster agora vamos partir para a criação do manifesto para o deploy da aplicação.

- Abre uma pasta dentro da API pode dar qualquer nome eu dei o nome de "web":

- Dentro da pasta cria um manifesto chamado de deployment.yaml :

apiVersion: apps/v1
kind: Deployment
metadata:
  name: apiconversao
spec:
  selector:
    matchLabels:
      app: apiconversao
  template:
    metadata:
      labels:
        app: apiconversao
    spec:
      containers:
      - name: apiconversao
        image: diegofan/api-conversao-diego:v1
        ports:
        - containerPort: 8080

- Cria outro arquivo yaml para o manifesto chamado de service.yaml:

apiVersion: v1
kind: Service
metadata:
  name: apiconversao-service
spec:
  selector:
    app: apiconversao
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30000
  type: NodePort

- Roda os dois manifestos com os comandos    "kubectl apply -f ./web/service.yaml"       "kubectl apply -f ./web/deployment.yaml"  perceba  qual pasta ele está rodando.

- Verifica se o deployment, service, replica e pods estão rodando com o comando "kubectl get all".

- Pronto, se estiver rodando é só visitar a URL em uma página da internet com  o link http://localhost:8080/api-docs/

- Se quiser criar mais réplicas para não haver perda de serviço roda o comando "kubectl scale deployment apiconversao --replicas 10", agora você tem 10 replicas rodando dentro do container.


Observação:

Lembrando que é preciso ter:
- o Docker instalado na Máquina
- k3d para criação do cluster
- Kubectl para a criação do Kubernetes e do deployment.



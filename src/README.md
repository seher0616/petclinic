# Project : Spring-petclinic

## Description

Spring PetClinic is a sample application used to demonstrate the use of the Spring Framework in creating web applications. It provides a basic management system for a veterinary clinic, allowing users to add and manage pets, owners, veterinarians, and appointments.

The application is built using Java and the Spring Framework, and it follows best practices for modern web application development, such as using a responsive UI design and implementing RESTful web services. The code is open-source and available on GitHub for anyone to use and contribute to.

The Spring PetClinic application has been used as a teaching tool in many Java and Spring Framework courses

This project [Spring Petclinic](Java: https://github.com/spring-projects/spring-petclinic). Elastic Compute Cloud (EC2) Instance is used build .

## Flow of Tasks for Project Realization

| Local Development Environment | Prepare Development Server Manually on EC2 Instance Prepare development server manually on Amazon Linux 2 for developers, enabled with `Docker` , `Docker-Compose` , `Java 17` , `Git` . |
| Local Development Environment | Prepare GitHub Repository for the Project Clone the Petclinic app from the repository [ spring-petclinic](https://github.com/spring-projects/spring-petclinic) |

| Local Development Environment | Prepare Development , enabled with `Docker` , `Docker-Compose` , `Java 17` , `Git` . 
| Local Development Build | Prepare Dockerfiles for Microservices  Prepare Dockerfiles for each microservices. 
| Local Development Environment | Prepare Script for Building Docker Images  Prepare a script to package and build the docker images for all microservices. 
| Local Development Build | Create Docker Compose File for Local Development  Prepare docker compose file to deploy the application locally. 



##  1 - Prepare Development Server Manually on EC2 Instance


- Prepare development server manually on Amazon Linux 2 (t3a.micro) for developers, enabled with `Docker`, `Docker-Compose`, `Java 17`, `Git`.

```bash
#! /bin/bash
sudo yum update -y
sudo hostnamectl set-hostname spring-petclinic
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo yum install git -y
sudo yum install java-17-amazon-corretto -y
newgrp docker
```


##  2 - Prepare GitHub Repository for the Project

- Connect to your Development Server via `ssh` and clone the petclinic app from the repository [Spring Petclinic](https://github.com/spring-projects/spring-petclinic).

```bash
git clone (https://github.com/spring-projects/spring-petclinic)
```

- Change your working directory to **petclinic-microservices** and delete the **.git** directory.

```bash
cd spring-petclinic
rm -rf .git
```

 *****note :   spring.datasource.url=${MYSQL_URL:jdbc:mysql://localhost/petclinic}
 spring.datasource.url=${MYSQL_URL:jdbc:mysql://mysql:3306/petclinic} changed.************ 



- Take the compiled code and package it in its distributable `JAR` format.

```bash
./mvnw clean package


```

- Install distributable `JAR`s into local repository.





##  3 - Prepare a Dockerfile for the under `spring-petclinic`.

```Dockerfile
FROM openjdk:17.0.1-jdk
ENV spring_profiles_active mysql
ADD https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz dockerize.tar.gz
RUN tar -xzf dockerize.tar.gz
RUN chmod +x dockerize
RUN mkdir /app
COPY ./target/spring-petclinic-3.0.0-SNAPSHOT.jar /app/app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]
```

- Can build and run the Dockerfile using the following commands:




```bash
docker build --force-rm -t "petclinic" .


docker network create petclinic   # (We created a network called petclinic, which allows containers to communicate with each other.)

docker run --name="mysql" --network="petclinic" -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -dp 3306:3306 mysql:8.0
 docker run --name="petclinic" --network="petclinic" -dp 8080:8080 petclinic 

```

 

- Prepare docker compose file to deploy the application locally and save it as `docker-compose-local.yml` under `sping-petclinic` folder.

```yaml
 mysql:
    image: mysql:8.0
    container_name: mysql
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_ALLOW_EMPTY_PASSWORD=true
      - MYSQL_USER=petclinic
      - MYSQL_PASSWORD=petclinic
      - MYSQL_DATABASE=petclinic
    volumes:
      - "./conf.d:/etc/mysql/conf.d:ro"
  petclinic:
    image: petclinic
    container_name: petclinic
    ports:
      - "8080:8080"
    depends_on: 
      - mysql
    entrypoint: ["/dockerize", "-wait=tcp://mysql:3306", "-timeout=160s", "--", "java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]

```



---To dockerize the Spring PetClinic application and provide a Docker Compose file to run it locally with just a  command, you can follow these  step



```bash
docker-compose up


```



*** This will build the Docker image and start the application in a container, mapping port 8080 in the container to port 8080 on the host. You can access the application at http://localhost:8080.

```bash

docker compose down

```


********************************

##  1 - Run minikube/kind or any kind of local kubernetes cluster locally. Provide a script and/or the documentation of how to do it.


-Download and install Minikube: Download the latest version of Minikube from the official Minikube releases page. Once downloaded, double-click the installer to start the installation process. Follow the prompts to complete the installation.


```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && sudo install minikube-linux-amd64 /usr/local/bin/minikube
```



  - Start Minikube: Open a command prompt and run the following command to start Minikube:

  
```bash
 minikube start  $(minikube docker-env)

 docker build --force-rm -t "petclinic2" .

```


 - To install kubectl on ec2 using Chocolatey:





```bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

 


##  2- Prepare kubernetes manifests(yaml files) for the application and for the DB of the app. You can deploy the DB with a helm chart with a helm command as well. If you want to show your skills, you can also develop a helm chart or kustomize yaml as well for the app.


********* mysql deployment and service manifets for k8s*********

-Prepare a mysql.yaml for the under `spring-petclinic`.




```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  labels:
    app: mysql 
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:8.0
        name: mysql
        env:
        - name: MYSQL_DATABASE
          value: petclinic
        - name: MYSQL_PASSWORD
          value: petclinic
        - name: MYSQL_ROOT_PASSWORD
          value: root
        - name: MYSQL_USER
          value: petclinic
        ports:
        - containerPort: 3306
          name: mysql
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
  - port: 3306
  selector:
    app: mysql
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
  - port: 3306
  selector:
    app: mysql

```
***********************************
```bash

kubectl apply -f mysql.yaml
```




****** petclinic deployment and service for k8s*************

- Prepare a petclinic.yaml for the under `spring-petclinic`.




```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: petclinic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: petclinic
  template:
    metadata:
      labels:
        app: petclinic
    spec:
# petclinic pod will wait for mysql pod to boot up.
      initContainers:
      - name: init-mysql-server
        image: busybox
        command: ['sh', '-c', 'until nc -z mysql:3306; do echo waiting for discovery-server; sleep 2; done;']
      containers:
      - image: petclinic2
        name: petclinic
        imagePullPolicy: Never
        ports:
        - containerPort: 8080
          name: petclinic
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: petclinic
  name: petclinic
spec:
  type: NodePort
  ports:
    - name: http
      port: 8080
      targetPort: 8080
  selector:
    app: petclinic

```

```bash

kubectl apply -f petclinic.yaml

```

# 3 -  Prepare a CI pipeline for the application in any CI tool(Jenkins, Github Actions, GitLab etc.). If you want to show your skills, prepare a CD pipeline as well.

--A CI/CD pipeline is a set of automated processes that helps developers to build, test, and deploy their applications quickly and with high quality. CI stands for Continuous Integration, which is the practice of integrating code changes frequently to detect errors early. CD stands for Continuous Delivery or Continuous Deployment, which is the practice of automatically delivering the code changes to production.




- To run jenkins server in docker container run this command:

```bash
docker run -p 8090:8090 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
```

- Prepare a jenkinsfile for the under `spring-petclinic`.


```bash

pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // Checkout the code from git
        git branch: 'main', url: 'https://github.com/your-repo'
      }
    }
    
    stage('Package Application') {
            steps {
                echo 'Packaging the app into jars with maven'
                sh "./mvnw clean package"
            }
        }


    stage('Build App Docker Images') {
            steps {
                echo 'Building App Docker Images'
                sh "docker build --force-rm -t 'petclinic' ."
                sh 'docker image ls'
            }
        }
    
    stage('Deploy to Minikube') {
      steps {
        // Apply the Kubernetes configuration to the Minikube cluster
        sh 'kubectl apply -f petclinic.yaml'
        sh 'kubectl apply -f mysql.yaml'
      }
    }
  }
}

```


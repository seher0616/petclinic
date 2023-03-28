
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // Checkout the code from git
        git branch: 'main', url: 'https://github.com/seher0616/spring-petclinic.git'
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

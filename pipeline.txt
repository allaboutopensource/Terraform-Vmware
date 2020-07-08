pipeline {
  agent {
    node {
      label 'terraform'
      customWorkspace '/root/openstack'
    }  
  }
  stages {
    stage('terraform version') {
      steps {
          sh 'terraform version'
      }   
    }
    
    stage('terraform init') {
      steps {
          sh 'terraform init'
      }   
    }
    stage('terraform plan') {
      steps {
          sh 'terraform plan'
      }   
    }
        }
}

#!/usr/bin/env groovy
pipeline {
    agent {
        label 'openshift-prg'
    }
    environment {
        ARTIFACTORY_CREDS = credentials('565c5882-f085-485e-be9b-f9e8f9b98eda')
    }
    stages {
        stage('Checkout From Git') {
            steps {
                checkout scm
            }
        }
        stage('Docker Login') {
            steps {
                sh 'docker login -u ${ARTIFACTORY_CREDS_USR} -p ${ARTIFACTORY_CREDS_PSW} docker.artifactory.dhl.com'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh './gradlew docker -Penv=${env} -PartifactoryUser=${ARTIFACTORY_CREDS_USR} -PartifactoryPass=${ARTIFACTORY_CREDS_PSW} --no-daemon --info --stacktrace'
            }
        }
        stage('Run Docker Image') {
            steps {
                sh './gradlew generateDockerComposeFile dockerComposeUp -Penv=${env} -PartifactoryUser=${ARTIFACTORY_CREDS_USR} -PartifactoryPass=${ARTIFACTORY_CREDS_PSW} --no-daemon --info --stacktrace'
            }
        }
    }
}
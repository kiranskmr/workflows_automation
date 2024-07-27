// Filename: Jenkinsfile
node {
  def GITREPOREMOTE = "https://github.com/kiranskmr/workflows_automation.git"
  def GITBRANCH     = "kiran-feature"
  def BUNDLETARGET  = "dev"

  stage('Checkout') {
    git branch: GITBRANCH, url: GITREPOREMOTE
  }
  stage('Validate Bundle') {
    sh """#!/bin/bash
          /opt/homebrew/bin/databricks bundle validate -t ${BUNDLETARGET}
       """
  }
  stage('Deploy Bundle') {
    sh """#!/bin/bash
         /opt/homebrew/bin/databricks bundle deploy -t ${BUNDLETARGET}
       """
  }
}
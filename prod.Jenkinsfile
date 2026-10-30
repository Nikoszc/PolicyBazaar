pipeline {
    agent any
		environment {
        SERVICE = 'pbpocrparser-qa'
		EMAILSUBJECT = 'QA-PBPOCRParser'
		CLUSTER = 'QA-AI'
		EMAILRECIPIENTS = 'rajivk@policybazaar.com;devops@policybazaar.com;ayushsingh2@pbpartners.com'
    }
    parameters {
    gitParameter branchFilter: 'origin/(.*)', defaultValue: 'qa', name: 'BRANCH', type: 'PT_BRANCH'
  }
    stages {

      stage('Clone') {
            steps {
               git branch: "${params.BRANCH}", credentialsId: '434df6cf-73a1-4a66-b58c-6104454ecc38', url: 'https://bitbucket.org/ETECHACES/pbp_ocr.git'
              }
            }
        stage('Publish') {
           steps {
                sh '''
                set +x
                /usr/bin/docker build -t ${SERVICE} -f pbp_ocr_service/deploy/ecs/Dockerfile.ocr pbp_ocr_service
                /usr/bin/docker tag ${SERVICE}:latest 971766671640.dkr.ecr.ap-south-1.amazonaws.com/${SERVICE}:latest
                /usr/bin/docker push 971766671640.dkr.ecr.ap-south-1.amazonaws.com/${SERVICE}:latest
                set -x
                '''
            }
        }
        stage('Container-building') {
           steps {
                sh '''
                set +x
                aws ecs update-service --cluster ${CLUSTER} --service ${SERVICE}-svc --force-new-deployment
                sleep 10s
                set -x
                '''
            }
        post {
            failure {
                emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
                    to: "${EMAILRECIPIENTS}",
                    subject: "${EMAILSUBJECT} Build failed in Jenkins: - #$BUILD_NUMBER",
                    from: 'jenkins@policybazaar.com'
            }
            unstable {
                emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
                    to: "${EMAILRECIPIENTS}",
                    subject: "${EMAILSUBJECT} Unstable build in Jenkins: - #$BUILD_NUMBER",
                    from: 'jenkins@policybazaar.com'
            }
            changed {
                emailext body: 'Check console output at $BUILD_URL to view the results.',
                    to: "${EMAILRECIPIENTS}",
                    subject: "${EMAILSUBJECT} Changed build: -#$BUILD_NUMBER",
                    from: 'jenkins@policybazaar.com'
            }
             success {
                    emailext body:  'Check console output at $BUILD_URL to view the results.',
                    to:     "${EMAILRECIPIENTS};infosec@policybazaar.com",
                    subject: "${EMAILSUBJECT} Success build is sucessfully: - #$BUILD_NUMBER",
                    from: 'jenkins@policybazaar.com'
            }
		}
	}
  }
}

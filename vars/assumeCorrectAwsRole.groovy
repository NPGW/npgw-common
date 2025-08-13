def call(String roleArn) {
        def credentialsJson = sh(script: """
            aws sts assume-role \
                --role-arn ${roleArn} \
                --role-session-name JenkinsSession
            """, returnStdout: true).trim()

        env.AWS_ACCESS_KEY_ID = sh(script: "echo '${credentialsJson}' | jq -r '.Credentials.AccessKeyId'", returnStdout: true).trim()
        env.AWS_SECRET_ACCESS_KEY = sh(script: "echo '${credentialsJson}' | jq -r '.Credentials.SecretAccessKey'", returnStdout: true).trim()
        env.AWS_SESSION_TOKEN = sh(script: "echo '${credentialsJson}' | jq -r '.Credentials.SessionToken'", returnStdout: true).trim()
}
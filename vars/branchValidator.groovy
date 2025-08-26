def branchExists(String repo, String branch) {
    withCredentials([string(credentialsId: 'GH_TOKEN', variable: 'GH_TOKEN')]) {
        return (sh(
            script: "gh api --silent /repos/NPGW/${repo}/git/ref/heads/${branch}",
            returnStatus: true
        ) == 0)
    }
}

def returnShaIfBranchExists(String repo, String branch) {
    withCredentials([string(credentialsId: 'GH_TOKEN', variable: 'GH_TOKEN')]) {
        return sh(
            script: "gh api /repos/NPGW/${repo}/git/ref/heads/${branch} --jq .object.sha",
            returnStdout:true
        ).trim()
    }
}

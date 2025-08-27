def branchExists(String repo, String branch) {
    return (sh(
        script: "gh api --silent /repos/NPGW/${repo}/git/ref/heads/${branch}",
        returnStatus: true
    ) == 0)
}

def returnShaIfBranchExists(String repo, String branch) {
    try {
        return sh(
                script: "gh api /repos/NPGW/${repo}/git/ref/heads/${branch} --jq .object.sha",
                returnStdout:true
        ).trim()
    } catch (ignored) {
        return null
    }
}

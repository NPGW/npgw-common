def call(repoBranchMap, String credentialsId = 'github-pat') {
    repoBranchMap.each { repoName, repoBranch ->
        dir(repoName) {
            git credentialsId: credentialsId, url: "https://github.com/NPGW/${repoName}.git", branch: repoBranch
        }
    }
}
/**
 * Checks out multiple repositories by repo name and branch.
 *
 * @param repoBranchMap Map of repoName -> branchName (String -> String)
 * @param credentialsId Jenkins credentialsId for GitHub (default: 'github-pat')
 */

def call(repoBranchMap, String credentialsId = 'github-pat') {
    if (!repoBranchMap || repoBranchMap.isEmpty()) {
        error "[checkoutRepos.groovy] No repositories provided to checkout."
    }
    repoBranchMap.each { repoName, repoBranch ->
        dir(repoName) {
            echo "[checkoutRepos.groovy] Cloning ${repoName}, branch: ${repoBranch}"
            try {
                git credentialsId: credentialsId, url: "https://github.com/NPGW/${repoName}.git", branch: repoBranch
            } catch (Exception e) {
                error "[checkoutRepos.groovy] Failed to check out ${repoName}, ${repoBranch}, ${e.message}"
            }
        }
    }
}
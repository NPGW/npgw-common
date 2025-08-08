/**
 * Resolve the ECR image tag for a "latest" RELEASE_VERSION.
 *
 * @param repoName     Name of the ECR repo (e.g. 'npgw/merchant')
 * @param region     AWS region
 * @return           The latest tag found in repo
 */

def call(String repoName, String region = env.AWS_REGION) {
    def latestTag = sh(
        script: """
            set -eo pipefail
                aws ecr describe-images \
                    --repository-name "${repoName}" \
                    --region "${region}" \
                    --registry-id "214404897309" \
                    --no-paginate \
                    --query 'sort_by(imageDetails,&imagePushedAt)[-1].imageTags[0]' \
                    --output text
        """,
        returnStdout: true
    ).trim()

    if (!latestTag || latestTag == 'None') {
        error "[getLatestEcrTag] No image tags found in ${repoName}"
    }
    echo "Resolved latest tag: ${latestTag}"

    return latestTag
}
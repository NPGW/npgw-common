/**
 * Returns the AWS IAM role ARN to assume for the given environment and role type.
 * (e.g., 'test', 'dev', 'prod', 'sandbox').
 *
 * @param environment  The target environment name (e.g., 'dev')
 * @param type         The role type: 'deploy' or 'terraform'
 * @return             The ARN of the IAM role to assume as a string.
 * @throws             Error if the environment is invalid.
 */

def call(String environment, String type) {
    def rolesByType = [
            "terraform": [
                    "test"   : "arn:aws:iam::820242903147:role/npgw-jenkins-terraform-env-role",
                    "dev"    : "arn:aws:iam::872515291967:role/npgw-jenkins-terraform-env-role",
                    "prod"   : "arn:aws:iam::721719382766:role/npgw-jenkins-terraform-env-role",
                    "sandbox": "arn:aws:iam::225989351233:role/npgw-jenkins-terraform-env-role"
            ],
            "deploy": [
                    "test"   : "arn:aws:iam::820242903147:role/npgw-jenkins-deploy-a-version-role",
                    "dev"    : "arn:aws:iam::872515291967:role/npgw-jenkins-deploy-a-version-role",
                    "prod"   : "arn:aws:iam::721719382766:role/npgw-jenkins-deploy-a-version-role",
                    "sandbox": "arn:aws:iam::225989351233:role/npgw-jenkins-deploy-a-version-role"
            ]
    ]

    def roles = rolesByType.get(type)
    if (!roles) {
        error("Invalid type '${type}'. Supported types: ${rolesByType.keySet().join(', ')}")
    }

    def selectedRole = roles.get(environment)
    if (!selectedRole) {
        error("Invalid environment '${environment}'. Supported environments: ${roles.keySet().join(', ')} for type '${type}'")
    }
    return selectedRole
}
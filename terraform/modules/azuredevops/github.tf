data "github_user" "current" {
  username = ""
}

data "github_repository" "repo" {
  full_name = var.repo_name
}

resource "github_repository_environment" "env" {
  environment         = "qa"
  repository          = data.github_repository.repo.name
  reviewers {
    users = [data.github_user.current.id]
  }
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

# resource "github_actions_environment_secret" "env_secret" {
#   repository  = data.github_repository.repo.name
#   environment = github_repository_environment.env.environment
#   secret_name = "SP_TOKEN"
#   plaintext_value = ""
# }

# resource "github_actions_environment_variable" "node_variable" {
#   repository       = data.github_repository.repo.name
#   environment      = github_repository_environment.env.environment
#   variable_name    = "BUNDLE_VAR_NODE_TYPE"
#   value            = "update this"
# }

# resource "github_actions_environment_variable" "warehouse_variable" {
#   repository       = data.github_repository.repo.name
#   environment      = github_repository_environment.env.environment
#   variable_name    = "BUNDLE_VAR_WAREHOUSE_ID"
#   value            = "update this"
# }

# resource "github_actions_environment_variable" "host_variable" {
#   repository       = data.github_repository.repo.name
#   environment      = github_repository_environment.env.environment
#   variable_name    = "DATABRICKS_HOST"
#   value            = "update this"
# }
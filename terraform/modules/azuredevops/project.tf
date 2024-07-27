resource "azuredevops_project" "project" {
  name            = var.project_name
  visibility      = "private"
  version_control = "Git"
  features = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "testplans"    = "enabled"
    "artifacts"    = "enabled"
  }
}
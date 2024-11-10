# CONFIG
variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

# REQUIRED
variable "branch" {
  type = string
  description = "Branch"
}

variable "name" {
  type = string
  description = "Name"
}

variable "repository" {
  type = string
  description = "Repository"
}

# OPTIONAL
variable "additional_project_globs" {
  type = list(string)
  description = "Additional project globs"
  default = []
}

variable "administrative" {
  type = bool
  description = "Administrative"
  default = true
}

variable "after_apply" {
  type = list(string)
  description = "After apply"
  default = null
}

variable "after_destroy" {
  type = list(string)
  description = "After destroy"
  default = null
}

variable "after_init" {
  type = list(string)
  description = "After init"
  default = null
}

variable "after_perform" {
  type = list(string)
  description = "After perform"
  default = null
}

variable "after_plan" {
  type = list(string)
  description = "After plan"
  default = null
}

variable "after_run" {
  type = list(string)
  description = "After run"
  default = null
}

# ansible

variable "autodeploy" {
  type = bool
  description = "Auto deploy"
  default = null
}

variable "autoretry" {
  type = bool
  description = "Auto retry"
  default = null
}

# azure_devops

variable "before_apply" {
  type = list(string)
  description = "Before apply"
  default = null
}

variable "before_destroy" {
  type = list(string)
  description = "Before destroy"
  default = null
}

variable "before_init" {
  type = list(string)
  description = "Before init"
  default = null
}

variable "before_perform" {
  type = list(string)
  description = "Before perform"
  default = null
}

variable "before_plan" {
  type = list(string)
  description = "Before plan"
  default = null
}

# bitbucket_cloud
# bitbucket_datacenter
# cloudformation

variable "description" {
  type = string
  description = "Description"
  default = null
}

variable "enable_local_preview" {
  type = bool
  description = "Enable local preview"
  default = null
}

variable "enable_well_known_secret_masking" {
  type = bool
  description = "Enable well known secret masking"
  default = null
}

variable "github_action_deploy" {
  type = bool
  description = "Enable well known secret masking"
  default = null
}

# github_enterprise
# gitlab

variable "import_state" {
  type = string
  description = "Import state"
  default = null
}

variable "import_state_file" {
  type = string
  description = "Import state file"
  default = null
}

# kubernetes

variable "labels" {
  type = list(string)
  description = "Labels"
  default = null
}

variable "manage_state" {
  type = bool
  description = "Manage state"
  default = null
}

variable "project_root" {
  type = string
  description = "Project root"
  default = null
}

variable "protect_from_deletion" {
  type = bool
  description = "Protect from deletion"
  default = null
}

# pulumi
# raw_git

variable "runner_image" {
  type = string
  description = "Runner image"
  default = null
}

# showcase

variable "slug" {
  type = string
  description = "Slug"
  default = null
}

variable "space_id" {
  type = string
  description = "Space ID"
  default = null
}

variable "terraform_external_state_access" {
  type = bool
  description = "Terraform external state access"
  default = null
}

variable "terraform_smart_sanitization" {
  type = bool
  description = "Terraform smart sanitization"
  default = null
}

variable "terraform_version" {
  type = string
  description = "Terraform version"
  default = null
}

variable "terraform_workflow_tool" {
  type = string
  description = "Terraform workflow tool"
  default = null
}

variable "terraform_workspace" {
  type = string
  description = "Terraform workspace"
  default = null
}

# terragrunt

variable "worker_pool_id" {
  type = string
  description = "Worker pool ID"
  default = null
}
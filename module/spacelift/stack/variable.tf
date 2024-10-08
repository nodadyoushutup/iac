# REQUIRED
variable "name" {
  description = "Name of the Spacelift stack."
  type = string
}

# OPTIIONAL (FORCE DEAULTS)
variable "repository" {
  description = "Repository URL for the Spacelift stack."
  type = string
  default = null
}

variable "branch" {
  description = "Git branch to use for the stack."
  type = string
  default = null
}

# OPTIONAL
variable "project_root" {
  description = "Project root directory for the Spacelift stack."
  type = string
  default = null
}

variable "description" {
  description = "Description of the Spacelift stack."
  type = string
  default = null
}

variable "labels" {
  description = "List of labels to assign to the stack."
  type = list(string)
  default = null
}

variable "import_state" {
  description = "File path for the state to import (sensitive)."
  type = string
  default = null
}

variable "import_state_file" {
  description = "File path for the state to import."
  type = string
  default = null
}



variable "space_id" {
  description = "ID of the space where the stack is created."
  type = string
  default = null
}

variable "administrative" {
  description = "Flag to indicate if the stack has administrative permissions."
  type = bool
  default = null
}

variable "autodeploy" {
  description = "Flag to enable automatic deployment for the stack."
  type = bool
  default = null
}

variable "terraform_version" {
  description = "Terraform version to use for the stack."
  type = string
  default = null
}

variable "context_priority" {
  description = "Priority of the context when attached to the stack."
  type = number
  default = null
}

variable "additional_project_globs" {
  description = "Glob patterns to include additional projects."
  type = list(string)
  default = null
}

variable "autoretry" {
  description = "Enable or disable masking of well-known secrets."
  type = bool
  default = null
}

variable "enable_local_preview" {
  description = "Enable or disable local preview mode."
  type        = bool
  default     = null
}

variable "enable_well_known_secret_masking" {
  description = "Enable or disable masking of well-known secrets."
  type = bool
  default = null
}

variable "github_action_deploy" {
  description = "Enable or disable GitHub Action deployment."
  type = bool
  default = null
}

variable "manage_state" {
  description = "Enable or disable state management."
  type = bool
  default = null
}

variable "protect_from_deletion" {
  description = "Enable or disable protection from deletion."
  type = bool
  default = null
}

variable "terraform_smart_sanitization" {
  description = "Enable or disable smart sanitization in Terraform."
  type = bool
  default = null
}

variable "terraform_workflow_tool" {
  description = "Specify the workflow tool to use with Terraform."
  type = string
  default = null
}

# HOOKS
variable "before_init" {
  description = "Before init hook"
  type = list(string)
  default = null
}

variable "before_plan" {
  description = "Before plan hook"
  type = list(string)
  default = null
}

variable "before_apply" {
  description = "Before apply hook"
  type = list(string)
  default = null
}

variable "before_destroy" {
  description = "Before destroy hook"
  type = list(string)
  default = null
}

variable "before_perform" {
  description = "Before perform hook"
  type = list(string)
  default = null
}

variable "after_init" {
  description = "After init hook"
  type = list(string)
  default = null
}

variable "after_plan" {
  description = "After plan hook"
  type = list(string)
  default = null
}

variable "after_apply" {
  description = "After apply hook"
  type = list(string)
  default = null
}

variable "after_destroy" {
  description = "After destroy hook"
  type = list(string)
  default = null
}

variable "after_perform" {
  description = "After perform hook"
  type = list(string)
  default = null
}

variable "after_run" {
  description = "After run hook"
  type = list(string)
  default = null
}

variable "github_enterprise" {
  description = "Github enterprise organization"
  type = string
  default = null
}




# variable "github_enterprise" {
#   description = "Configuration for GitHub Enterprise integration."
#   type = object({
#     namespace = string
#   })
#   default = null
# }

# variable "github_enterprise" {
#   description = "Configuration for GitHub Enterprise integration."
#   type        = string
#   default     = null 
# }

# variable "ansible" {
#   description = "Configuration for GitHub Enterprise integration."
#   type = object({
#     playbook = optional(string, null)
#   })
#   default = null
# }
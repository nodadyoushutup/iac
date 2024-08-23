# REQUIRED
variable "name" {
  description = "Name of the Spacelift stack."
  type        = string
}

variable "repository" {
  description = "Repository URL for the Spacelift stack."
  type        = string
}

variable "branch" {
  description = "Git branch to use for the stack."
  type= string
  default= "main"
}

#OPTIONAL
variable "space_id" {
  description = "ID of the space where the stack is created."
  type= string
  default = "root"
}

variable "administrative" {
  description = "Flag to indicate if the stack has administrative permissions."
  type= bool
  default= false
}

variable "autodeploy" {
  description = "Flag to enable automatic deployment for the stack."
  type= bool
  default= false
}

variable "description" {
  description = "Description of the Spacelift stack."
  type        = string
  default     = null
}

variable "project_root" {
  description = "Project root directory for the Spacelift stack."
  type        = string
  default     = "/"
}

variable "terraform_version" {
  description = "Terraform version to use for the stack."
  type        = string
  default     = null
}

variable "labels" {
  description = "List of labels to assign to the stack."
  type        = list(string)
  default     = []
}

variable "context_priority" {
  description = "Priority of the context when attached to the stack."
  type        = number
  default     = 100
}

variable "github_enterprise" {
  description = "Configuration for GitHub Enterprise integration."
  type = object({
    namespace = optional(string, "nodadyoushutup-iac")
  })
  default = null
}

variable "ansible" {
  description = "Configuration for GitHub Enterprise integration."
  type = object({
    playbook = optional(string, null)
  })
  default = null
}

variable "additional_project_globs" {
  description = "Glob patterns to include additional projects."
  type        = list(string)
  default     = []
}

variable "autoretry" {
  description = "Enable or disable masking of well-known secrets."
  type        = bool
  default     = false
}

variable "enable_local_preview" {
  description = "Enable or disable local preview mode."
  type        = bool
  default     = false
}

variable "enable_well_known_secret_masking" {
  description = "Enable or disable masking of well-known secrets."
  type        = bool
  default     = false
}

variable "github_action_deploy" {
  description = "Enable or disable GitHub Action deployment."
  type        = bool
  default     = true
}

variable "import_state" {
  description = "File path for the state to import (sensitive)."
  type        = string
  default     = null
}

variable "import_state_file" {
  description = "File path for the state to import."
  type        = string
  default     = null
}

variable "manage_state" {
  description = "Enable or disable state management."
  type        = bool
  default     = true
}

variable "protect_from_deletion" {
  description = "Enable or disable protection from deletion."
  type        = bool
  default     = false
}

variable "terraform_smart_sanitization" {
  description = "Enable or disable smart sanitization in Terraform."
  type        = bool
  default     = false
}

variable "terraform_workflow_tool" {
  description = "Specify the workflow tool to use with Terraform."
  type        = string
  default     = "TERRAFORM_FOSS"
}

# HOOKS
variable "before" {
  description = "Hooks to run before various stages."
  type = object({
    apply    = optional(list(string), [])
    destroy  = optional(list(string), [])
    init     = optional(list(string), [])
    perform  = optional(list(string), [])
    plan     = optional(list(string), [])
    run      = optional(list(string), [])
  })
  default = {
    apply    = []
    destroy  = []
    init     = []
    perform  = []
    plan     = []
    run      = []
  }
}

variable "after" {
  description = "Hooks to run after various stages."
  type = object({
    apply    = optional(list(string), [])
    destroy  = optional(list(string), [])
    init     = optional(list(string), [])
    perform  = optional(list(string), [])
    plan     = optional(list(string), [])
    run      = optional(list(string), [])
  })
  default = {
    apply    = []
    destroy  = []
    init     = []
    perform  = []
    plan     = []
    run      = []
  }
}


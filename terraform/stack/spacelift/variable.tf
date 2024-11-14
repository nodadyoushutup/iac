variable "PATH_CONFIG" {
    type = string
    description = "Configuration path"
    default = "/mnt/workspace/config.yaml"
}

variable "GIT_BRANCH" {
    type = string
    description = "Environment branch"
    default = null
}

variable "GIT_REPOSITORY" {
    type = string
    description = "Environment repository"
    default = null
}

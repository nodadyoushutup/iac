locals {
    name = try(var.name, null) != null ? var.name : data.external.random_string.result.value

    folder = try(var.folder, null) != null ? var.folder : try(var.config.global.jenkins.job.folder, null) != null ? var.config.global.jenkins.job.folder : null

    discard_build = { 
        day = try(var.discard_build.day, null) != null ? var.discard_build.day : try(var.config.global.jenkins.job.discard_build.day, null) != null ? var.config.global.jenkins.job.discard_build.day : -1
        max = try(var.discard_build.max, null) != null ? var.discard_build.max : try(var.config.global.jenkins.job.discard_build.max, null) != null ? var.config.global.jenkins.job.discard_build.max : 10
    }

    path = {
        xml = try(var.path.xml, null) != null ? var.path.xml : try(var.config.global.jenkins.job.path.xml, null) != null ? var.config.global.jenkins.job.path.xml : "./template/job.xml.tpl"
        script = try(var.path.script, null) != null ? var.path.script : try(var.config.global.jenkins.job.path.script, null) != null ? var.config.global.jenkins.job.path.script : "terraform/job/jenkins/pipeline/terraform.jenkins"
    }

    parameter = try(var.parameter, null) != null ? var.parameter : try(var.config.global.jenkins.job.parameter, null) != null ? var.config.global.jenkins.job.parameter : {subdir = "terraform/job/${local.name}"}

    git_repository = { 
        branch = try(var.git_repository.branch, null) != null ? var.git_repository.branch : try(var.config.global.jenkins.job.git_repository.branch, null) != null ? var.config.global.jenkins.job.git_repository.branch : "main"
        url = try(var.git_repository.url, null) != null ? var.git_repository.url : try(var.config.global.jenkins.job.git_repository.url, null) != null ? var.config.global.jenkins.job.git_repository.url : "https://github.com/nodadyoushutup/iac" # TODO: Fallback to config.git data
    }
}
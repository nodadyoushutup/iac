locals {
  repo_url = "https://github.com/nodadyoushutup/homelab"

  multi_stage_services = {
    jenkins = {
      jobs = {
        controller = {
          description = "Jenkins controller deployment"
          script_path = "pipeline/jenkins/controller.jenkins"
        }
        agent = {
          description = "Jenkins agent deployment"
          script_path = "pipeline/jenkins/agent.jenkins"
        }
        config = {
          description = "Jenkins configuration apply"
          script_path = "pipeline/jenkins/config.jenkins"
        }
      }
    }
    grafana = {
      jobs = {
        app = {
          description = "Grafana application deployment"
          script_path = "pipeline/grafana/app.jenkins"
        }
        config = {
          description = "Grafana configuration apply"
          script_path = "pipeline/grafana/config.jenkins"
        }
      }
    }
    prometheus = {
      jobs = {
        app = {
          description = "Prometheus application deployment"
          script_path = "pipeline/prometheus/app.jenkins"
        }
        config = {
          description = "Prometheus configuration (config-only target)"
          script_path = "pipeline/prometheus/config.jenkins"
        }
      }
    }
  }

  single_stage_jobs = {
    dozzle = {
      description = "Dozzle Swarm deployment"
      script_path = "pipeline/dozzle/deploy.jenkins"
    }
    node_exporter = {
      description = "Node Exporter Swarm deployment"
      script_path = "pipeline/node_exporter/deploy.jenkins"
    }
    graphite = {
      description = "Graphite Swarm deployment"
      script_path = "pipeline/graphite/deploy.jenkins"
    }
  }

  multi_stage_jobs = merge([
    for service, cfg in local.multi_stage_services : {
      for job_name, job in cfg.jobs :
      "${service}-${job_name}" => {
        folder      = service
        name        = job_name
        description = job.description
        script_path = job.script_path
      }
    }
  ]...)
}

resource "jenkins_folder" "folder_jenkins" {
  name = "homelab"
}

resource "jenkins_folder" "service" {
  for_each = local.multi_stage_services

  name   = each.key
  folder = jenkins_folder.folder_jenkins.id
}

resource "jenkins_job" "multi_stage" {
  for_each = local.multi_stage_jobs

  name   = each.value.name
  folder = jenkins_folder.service[each.value.folder].id

  template = templatefile("${path.module}/job/bash_pipeline.xml.tmpl", {
    description = each.value.description
    script_path = each.value.script_path
    repo_url    = local.repo_url
  })
}

resource "jenkins_job" "single_stage" {
  for_each = local.single_stage_jobs

  name = each.key

  template = templatefile("${path.module}/job/bash_pipeline.xml.tmpl", {
    description = each.value.description
    script_path = each.value.script_path
    repo_url    = local.repo_url
  })
}

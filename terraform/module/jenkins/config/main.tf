locals {
  repo_url = "https://github.com/nodadyoushutup/homelab"

  jenkins_jobs = {
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

  multi_stage_services = {
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
        name        = "${service}-${job_name}"
        description = job.description
        script_path = job.script_path
      }
    }
  ]...)
}

resource "jenkins_folder" "jenkins_service" {
  name = "jenkins"
}

resource "jenkins_job" "multi_stage" {
  for_each = local.multi_stage_jobs

  name = each.value.name

  template = templatefile("${path.module}/job/bash_pipeline.xml.tmpl", {
    description = each.value.description
    script_path = each.value.script_path
    repo_url    = local.repo_url
  })
}

resource "jenkins_job" "jenkins" {
  for_each = local.jenkins_jobs

  name   = each.key
  folder = jenkins_folder.jenkins_service.id

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

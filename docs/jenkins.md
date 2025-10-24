# Jenkins Overview

The Jenkins stack provides CI/CD orchestration for the platform. Everything
needed to build, publish, and run the controller and agent images lives under
`docker/jenkins/`.

## Controller image

- Path: `docker/jenkins/controller/`
- Built and pushed by the
  [.github/workflows/jenkins_controller_build_push.yml](../.github/workflows/jenkins_controller_build_push.yml)
  workflow.
- Includes bundled plugins defined in `docker/jenkins/controller/plugins.txt`.

## Agent image

- Path: `docker/jenkins/agent/`
- Built and pushed by the
  [.github/workflows/jenkins_agent_build_push.yml](../.github/workflows/jenkins_agent_build_push.yml)
  workflow.
- Tailored for pipeline steps that need Docker, Terraform, and other DevOps
  tools.

## Local development

1. Build the controller image: `docker/jenkins/build-controller.sh`
2. Build the agent image: `docker/jenkins/build-agent.sh`
3. Launch the stack with `docker-compose` (compose file coming soon).

When you're done, run `docker/jenkins/purge.sh` to clean up dangling images and
volumes.

## Next steps

- Capture the production Jenkins configuration under `jenkins/` with job
  definitions managed as code.
- Document secrets management and credential provisioning once Vault or SSM
  integration is in place.
- Integrate Terraform-driven infrastructure for Jenkins itself when the repo
  becomes the `iac` home.

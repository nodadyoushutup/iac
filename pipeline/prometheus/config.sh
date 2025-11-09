#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PIPELINE_SCRIPT_ROOT="${ROOT_DIR}/pipeline/script"

SERVICE_NAME="prometheus"
STAGE_NAME="Prometheus config"
ENTRYPOINT_RELATIVE="pipeline/prometheus/config.sh"

PLAN_ARGS_EXTRA=(-target=docker_config.prometheus)
APPLY_ARGS_EXTRA=(-target=docker_config.prometheus)

PIPELINE_ARGS=("$@")

source "${PIPELINE_SCRIPT_ROOT}/swarm_pipeline.sh"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PIPELINE_SCRIPT_ROOT="${ROOT_DIR}/pipeline/script"

SERVICE_NAME="grafana"
STAGE_NAME="Grafana config"
ENTRYPOINT_RELATIVE="pipeline/grafana/config.sh"

PLAN_ARGS_EXTRA=(-target=module.grafana_config)
APPLY_ARGS_EXTRA=(-target=module.grafana_config)

PIPELINE_ARGS=("$@")

source "${PIPELINE_SCRIPT_ROOT}/swarm_pipeline.sh"

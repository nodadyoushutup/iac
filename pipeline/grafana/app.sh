#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PIPELINE_SCRIPT_ROOT="${ROOT_DIR}/pipeline/script"

SERVICE_NAME="grafana"
STAGE_NAME="Grafana app"
ENTRYPOINT_RELATIVE="pipeline/grafana/app.sh"

PLAN_ARGS_EXTRA=(-refresh=false -target=module.grafana_app)
APPLY_ARGS_EXTRA=(-refresh=false -target=module.grafana_app)

PIPELINE_ARGS=("$@")

source "${PIPELINE_SCRIPT_ROOT}/swarm_pipeline.sh"

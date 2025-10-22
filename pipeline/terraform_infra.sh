#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCRIPT_ROOT="${SCRIPT_DIR}/script"
ENV_SCRIPT="${SCRIPT_ROOT}/env_check.sh"
RESOLVE_SCRIPT="${SCRIPT_ROOT}/resolve_inputs.sh"
EXEC_SCRIPT="${SCRIPT_ROOT}/terraform_exec.sh"

TFVARS_ARG=""
BACKEND_ARG=""

usage() {
  cat <<'USAGE'
Usage: pipeline/terraform_infra.sh [--tfvars <path>] [--backend <path>] [tfvars_path] [backend_path]

Provision only the Jenkins infrastructure (module.jenkins_app).

Optional arguments can be provided either as flags or positional values.
If omitted, defaults are:
  TFVARS  -> $HOME/.tfvars/jenkins.tfvars (falls back to first *.tfvars in ./terraform)
  BACKEND -> $HOME/.tfvars/minio.backend.hcl
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tfvars)
      if [[ $# -lt 2 ]]; then
        echo "[ERR] --tfvars flag requires a path argument" >&2
        usage >&2
        exit 2
      fi
      TFVARS_ARG="$2"
      shift 2
      ;;
    --backend)
      if [[ $# -lt 2 ]]; then
        echo "[ERR] --backend flag requires a path argument" >&2
        usage >&2
        exit 2
      fi
      BACKEND_ARG="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "${TFVARS_ARG}" ]]; then
        TFVARS_ARG="$1"
      elif [[ -z "${BACKEND_ARG}" ]]; then
        BACKEND_ARG="$1"
      else
        echo "[ERR] Unexpected argument: $1" >&2
        usage >&2
        exit 2
      fi
      shift
      ;;
  esac
done

if [[ ! -x "${ENV_SCRIPT}" ]]; then
  echo "[ERR] Missing helper script: ${ENV_SCRIPT}" >&2
  exit 1
fi
if [[ ! -x "${RESOLVE_SCRIPT}" ]]; then
  echo "[ERR] Missing helper script: ${RESOLVE_SCRIPT}" >&2
  exit 1
fi
if [[ ! -x "${EXEC_SCRIPT}" ]]; then
  echo "[ERR] Missing helper script: ${EXEC_SCRIPT}" >&2
  exit 1
fi

PYTHON_CMD=""
FILTER_SCRIPT=""
FILTER_AVAILABLE="0"

ENV_OUTPUT="$(${ENV_SCRIPT})" || exit 1
while IFS='=' read -r key value; do
  case "$key" in
    PYTHON_CMD) PYTHON_CMD="$value" ;;
    FILTER_SCRIPT) FILTER_SCRIPT="$value" ;;
    FILTER_AVAILABLE) FILTER_AVAILABLE="$value" ;;
  esac
done <<<"${ENV_OUTPUT}"

TFVARS_PATH=""
BACKEND_CONFIG_PATH=""

RESOLVE_OUTPUT="$(TFVARS_ARG="${TFVARS_ARG}" BACKEND_ARG="${BACKEND_ARG}" "${RESOLVE_SCRIPT}")" || exit 1
while IFS='=' read -r key value; do
  case "$key" in
    TFVARS_PATH) TFVARS_PATH="$value" ;;
    BACKEND_PATH) BACKEND_CONFIG_PATH="$value" ;;
  esac
done <<<"${RESOLVE_OUTPUT}"

if [[ -z "${TFVARS_PATH}" || ! -f "${TFVARS_PATH}" ]]; then
  echo "[ERR] Missing TFVARS file: ${TFVARS_PATH}" >&2
  exit 1
fi
if [[ -z "${BACKEND_CONFIG_PATH}" || ! -f "${BACKEND_CONFIG_PATH}" ]]; then
  echo "[ERR] Missing backend config file: ${BACKEND_CONFIG_PATH}" >&2
  exit 1
fi

echo "TFVARS file: ${TFVARS_PATH}"
echo "Backend config: ${BACKEND_CONFIG_PATH}"

cd "${ROOT_DIR}/terraform"

export PYTHON_CMD FILTER_SCRIPT FILTER_AVAILABLE TFVARS_PATH BACKEND_CONFIG_PATH

echo "[STEP] terraform init"
"${EXEC_SCRIPT}" init -backend-config="${BACKEND_CONFIG_PATH}"

echo "[STAGE] App plan"
"${EXEC_SCRIPT}" plan -input=false -refresh=false -var-file="${TFVARS_PATH}" -target=module.jenkins_app

echo "[STAGE] App apply"
"${EXEC_SCRIPT}" apply -input=false -refresh=false -auto-approve -var-file="${TFVARS_PATH}" -target=module.jenkins_app

echo "[DONE] Jenkins infrastructure applied."

#!/usr/bin/env bash

command -v terraform >/dev/null 2>&1 || { echo "[ERR] terraform not found in PATH" >&2; exit 127; }
command -v realpath  >/dev/null 2>&1 || { echo "[ERR] realpath not found in PATH" >&2; exit 127; }

PYTHON_CMD=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  PYTHON_CMD="$(command -v python)"
else
  echo "[WARN] python3 not found; Terraform warnings will be displayed" >&2
fi

echo "Starting pipeline"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
FILTER_SCRIPT="${SCRIPT_DIR}/terraform_output_filter.py"

if [[ -n "${PYTHON_CMD}" && ! -f "${FILTER_SCRIPT}" ]]; then
  echo "[WARN] Terraform filter helper missing at ${FILTER_SCRIPT}; warnings will be displayed" >&2
fi

TFVARS_ARG=""
BACKEND_ARG=""

usage() {
  cat <<'EOF'
Usage: pipeline/terraform.sh [--tfvars <path>] [--backend <path>] [tfvars_path] [backend_path]

Optional arguments can be provided either as flags or positional values.
If omitted, defaults are:
  TFVARS  -> $HOME/.tfvars/jenkins.tfvars (falls back to first *.tfvars in ./terraform)
  BACKEND -> $HOME/.tfvars/minio.backend.hcl
EOF
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

resolve_tfvars_path() {
  local provided_path="${1:-}"
  local terraform_dir="${2:-}"
  local candidate

  if [[ -n "${provided_path}" ]]; then
    candidate="${provided_path}"
    if [[ -f "${candidate}" ]]; then
      realpath "${candidate}"
      return 0
    else
      echo "[WARN] Provided TFVARS file not found: ${candidate}" >&2
    fi
  fi

  candidate="${HOME}/.tfvars/jenkins.tfvars"
  if [[ -f "${candidate}" ]]; then
    realpath "${candidate}"
    return 0
  fi

  if [[ -d "${terraform_dir}" ]]; then
    candidate="$(find "${terraform_dir}" -maxdepth 1 -type f -name '*.tfvars' | sort | head -n 1 || true)"
    if [[ -n "${candidate}" && -f "${candidate}" ]]; then
      realpath "${candidate}"
      return 0
    fi
  fi

  echo "[ERR] Unable to determine a TFVARS file" >&2
  return 1
}

resolve_backend_path() {
  local provided_path="${1:-}"
  local default_path="${HOME}/.tfvars/minio.backend.hcl"
  local candidate

  if [[ -n "${provided_path}" ]]; then
    candidate="${provided_path}"
    if [[ -f "${candidate}" ]]; then
      realpath "${candidate}"
      return 0
    else
      echo "[ERR] Provided backend config not found: ${candidate}" >&2
      return 1
    fi
  fi

  if [[ -f "${default_path}" ]]; then
    realpath "${default_path}"
    return 0
  fi

  echo "[ERR] Unable to determine a backend config file" >&2
  return 1
}


run_terraform() {
  if [[ -n "${PYTHON_CMD}" && -f "${FILTER_SCRIPT}" ]]; then
    "${PYTHON_CMD}" "${FILTER_SCRIPT}" -- "$@"
    return
  fi

  terraform "$@"
}


TFVARS_PATH="$(resolve_tfvars_path "${TFVARS_ARG}" "${ROOT_DIR}/terraform")" || exit 1
BACKEND_CONFIG_PATH="$(resolve_backend_path "${BACKEND_ARG}")" || exit 1

[ -f "${TFVARS_PATH}" ] || { echo "[ERR] Missing ${TFVARS_PATH}" >&2; exit 1; }
[ -f "${BACKEND_CONFIG_PATH}" ] || { echo "[ERR] Missing ${BACKEND_CONFIG_PATH}" >&2; exit 1; }

cd "${ROOT_DIR}/terraform"

echo "[STEP] terraform init"
run_terraform init -backend-config="${BACKEND_CONFIG_PATH}"

echo "[STAGE] App plan"
run_terraform plan -input=false -refresh=false -var-file="${TFVARS_PATH}" -target=module.jenkins_app

echo "[STAGE] App apply"
run_terraform apply -input=false -refresh=false -auto-approve -var-file="${TFVARS_PATH}" -target=module.jenkins_app

sleep 10

echo "[STAGE] Jenkins config plan"
run_terraform plan -input=false -var-file="${TFVARS_PATH}"

echo "[STAGE] Jenkins config apply"
run_terraform apply -input=false -auto-approve -var-file="${TFVARS_PATH}"

echo "[DONE] Multi-stage apply complete."

#!/usr/bin/env bash

command -v terraform >/dev/null 2>&1 || { echo "[ERR] terraform not found in PATH" >&2; exit 127; }
command -v realpath  >/dev/null 2>&1 || { echo "[ERR] realpath not found in PATH" >&2; exit 127; }

echo "Starting pipeline"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

TFVARS_ARG="${1:-}"

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

TFVARS_PATH="$(resolve_tfvars_path "${TFVARS_ARG}" "${ROOT_DIR}/terraform")"
BACKEND_CONFIG_PATH="$(realpath "${HOME}/.tfvars/minio.backend.hcl")"

[ -f "${TFVARS_PATH}" ] || { echo "[ERR] Missing ${TFVARS_PATH}" >&2; exit 1; }
[ -f "${BACKEND_CONFIG_PATH}" ] || { echo "[ERR] Missing ${BACKEND_CONFIG_PATH}" >&2; exit 1; }

cd "${ROOT_DIR}/terraform"

echo "[STEP] terraform init"
terraform init -backend-config="${BACKEND_CONFIG_PATH}"

echo "[STAGE] App plan"
terraform plan -input=false -refresh=false -var-file="${TFVARS_PATH}" -target=module.jenkins_app

echo "[STAGE] App apply"
terraform apply -input=false -refresh=false -auto-approve -var-file="${TFVARS_PATH}" -target=module.jenkins_app

sleep 10

echo "[STAGE] Jenkins config plan"
terraform plan -input=false -var-file="${TFVARS_PATH}"

echo "[STAGE] Jenkins config apply"
terraform apply -input=false -auto-approve -var-file="${TFVARS_PATH}"

echo "[DONE] Multi-stage apply complete."

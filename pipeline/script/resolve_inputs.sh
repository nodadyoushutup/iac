#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PIPELINE_DIR}/.." && pwd)"

TFVARS_ARG="${TFVARS_ARG:-}"
BACKEND_ARG="${BACKEND_ARG:-}"

if [[ $# -gt 0 ]]; then
  TFVARS_ARG="$1"
fi
if [[ $# -gt 1 ]]; then
  BACKEND_ARG="$2"
fi

resolve_tfvars() {
  local provided_path="$1"
  local terraform_dir="$2"
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

  return 1
}

resolve_backend() {
  local provided_path="$1"
  local default_path="${HOME}/.tfvars/minio.backend.hcl"
  local candidate

  if [[ -n "${provided_path}" ]]; then
    candidate="${provided_path}"
    if [[ -f "${candidate}" ]]; then
      realpath "${candidate}"
      return 0
    else
      echo "[ERR] Provided backend config not found: ${candidate}" >&2
      return 2
    fi
  fi

  if [[ -f "${default_path}" ]]; then
    realpath "${default_path}"
    return 0
  fi

  return 1
}

TERRAFORM_DIR="${ROOT_DIR}/terraform/jenkins"

TFVARS_PATH=""
if TFVARS_PATH="$(resolve_tfvars "${TFVARS_ARG}" "${TERRAFORM_DIR}")"; then
  :
else
  echo "[ERR] Unable to determine a TFVARS file" >&2
  exit 1
fi

BACKEND_PATH=""
BACKEND_STATUS=0
if BACKEND_PATH="$(resolve_backend "${BACKEND_ARG}")"; then
  :
else
  BACKEND_STATUS=$?
  if [[ ${BACKEND_STATUS} -eq 2 ]]; then
    exit 1
  fi
  echo "[ERR] Unable to determine a backend config file" >&2
  exit 1
fi

echo "TFVARS_PATH=${TFVARS_PATH}"
echo "BACKEND_PATH=${BACKEND_PATH}"

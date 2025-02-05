#!/usr/bin/env bash
#
# Get values from Secret Manager
#
# Required globals:
#   AWS_ACCESS_KEY_ID
#   AWS_SECRET_ACCESS_KEY
#   AWS_DEFAULT_REGION
#   AWS_SECRET_MANAGER
#   BITBUCKET_PIPE_STORAGE_DIR

source "$(dirname "$0")/common.sh"

# mandatory parameters
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'AWS_DEFAULT_REGION variable missing.'}
AWS_SECRET_MANAGER=${AWS_SECRET_MANAGER:?'AWS_SECRET_MANAGER variable missing.'}
BITBUCKET_PIPE_STORAGE_DIR=${BITBUCKET_PIPE_STORAGE_DIR:?'BITBUCKET_PIPE_STORAGE_DIR variable missing.'}


default_authentication() {
  info "Using default authentication with AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY."
  AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'AWS_ACCESS_KEY_ID variable missing.'}
  AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'AWS_SECRET_ACCESS_KEY variable missing.'}
}

oidc_authentication() {
  info "Authenticating with a OpenID Connect (OIDC) Web Identity Provider."
      mkdir -p /.aws-oidc
      AWS_WEB_IDENTITY_TOKEN_FILE=/.aws-oidc/web_identity_token
      echo "${BITBUCKET_STEP_OIDC_TOKEN}" >> ${AWS_WEB_IDENTITY_TOKEN_FILE}
      chmod 400 ${AWS_WEB_IDENTITY_TOKEN_FILE}
      aws configure set web_identity_token_file ${AWS_WEB_IDENTITY_TOKEN_FILE}
      aws configure set role_arn ${AWS_OIDC_ROLE_ARN}
      unset AWS_ACCESS_KEY_ID
      unset AWS_SECRET_ACCESS_KEY
}

setup_authentication() {
  enable_debug
  AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'AWS_DEFAULT_REGION variable missing.'}
  if [[ -n "${AWS_OIDC_ROLE_ARN}" ]]; then
    if [[ -n "${BITBUCKET_STEP_OIDC_TOKEN}" ]]; then
      oidc_authentication
    else
      warning 'Parameter `oidc: true` in the step configuration is required for OIDC authentication'
      default_authentication
    fi
  else
    default_authentication
  fi
}

setup_authentication

info "Getting values from Secret Manager..."

# Pipe standard output to /dev/null so run does not echo out secrets
run aws secretsmanager get-secret-value --region ${AWS_DEFAULT_REGION} --secret-id ${AWS_SECRET_MANAGER} --query SecretString --output text 1> /dev/null

SECRET_MANAGER_EXPORT="secret_manager_export.sh"

if [[ "${status}" -eq 0 ]]; then
  for s in $(cat ${output_file} | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
      echo "export ${s}" >> $BITBUCKET_PIPE_STORAGE_DIR/$SECRET_MANAGER_EXPORT
  done

  success "Exporting Secret Manager values to ${BITBUCKET_PIPE_STORAGE_DIR} as ${SECRET_MANAGER_EXPORT} file successful."
else
  fail "Getting Secret Manager values failed."
fi







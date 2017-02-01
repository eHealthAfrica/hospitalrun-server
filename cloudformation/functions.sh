#!/usr/bin/env bash

function _error {
    echo "${*}"
    exit 1
}

function parse_args {
    if [ -z "${1}" ]; then
        export cf_action='create-stack'
    elif [[ "${1}" == 'update' ]]; then
        export cf_action='update-stack'
    else
        _error 'not recognized parameter'
    fi
}

function validate_template {
    local template_file="${1}"
    echo "validating ${template_file} syntax"
    aws cloudformation validate-template --template-body "file://${template_file}"
}

function put_credentials {
    local cred_name="${1}"
    local cred_value="${2}"
    set +e
    current_value="$(credstash -r us-east-1 get "${cred_name}" 2>/dev/null)"
    local return_code="${?}"
    set -e
    if [ "${return_code}" -ne 0 ]; then
        credstash -r us-east-1 put "${cred_name}" "${cred_value}" >/dev/null 2>&1
    else
        local cred_value="${current_value}"
    fi
    echo "${cred_value}"
}

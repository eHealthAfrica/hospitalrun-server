#!/usr/bin/env bash
#

set -e -x

script_dir="$(cd "$(dirname "$0")"; pwd)"
source "${script_dir}/functions.sh"

parse_args "${*}"

validate_template "${script_dir}/cloudformation.json"
validate_template "${script_dir}/cloudformation-env.json"

source "${script_dir}/config.sh"

if [[ ${cf_action} == 'create-stack' ]]; then
    # define array of parameters which can only be passed while creating stack

    if [ -z "${created_by}" ] || [ -z "${requested_by}" ]; then
        _error 'created_by and requested_by envs expected to be set in the env'
    fi

    create_parameters=(--tags)
    create_parameters+=(Key=StackName,Value="${stack_name}")
    create_parameters+=(Key=BILLING_PROJECT,Value="${billing_project}")
    create_parameters+=(Key=RequestedBy,Value="${requested_by}")
    create_parameters+=(Key=CreatedBy,Value="${created_by}" )
fi

aws s3 cp "cloudformation-env.json" "s3://${cf_s3_bucket}/${stack_name}-cloudformation-env.json"

echo "starting stack ${cf_action} operation"
aws cloudformation ${cf_action} \
    --stack-name "${stack_name}" \
    --template-body "file://${script_dir}/cloudformation.json" \
    --capabilities CAPABILITY_IAM \
    --parameters \
    ParameterKey=ProjectName,ParameterValue="${stack_name}" \
    ParameterKey=HostedZone,ParameterValue="${hosted_zone_name}" \
    ParameterKey=KeyName,ParameterValue="${ssh_key_name}" \
    ParameterKey=S3Bucket,ParameterValue="${cf_s3_bucket}" \
    ParameterKey=S3ZipFile,ParameterValue="${cf_s3_zip_file}" \
    ParameterKey=RenameResourcesLambda,ParameterValue="${rename_lambda}" \
    ParameterKey=SNSTopic,ParameterValue="${sns_topic}" \
    ParameterKey=SSLCertARN,ParameterValue="${ssl_cert}" \
    ParameterKey=ImageId,ParameterValue="${image_id}" \
    ParameterKey=SpotPrices,ParameterValue="\"$(IFS=, eval 'echo "${spot_prices[*]}"')\"" \
    ParameterKey=Environments,ParameterValue="\"$(IFS=, eval 'echo "${environments[*]}"')\"" \
    ParameterKey=InstanceTypes,ParameterValue="\"$(IFS=, eval 'echo "${instance_types[*]}"')\"" \
    ${create_parameters[*]}

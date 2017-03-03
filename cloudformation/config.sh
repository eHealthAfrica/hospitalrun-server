#!/usr/bin/env bash

script_dir="$(cd "$(dirname "$0")"; pwd)"
source "${script_dir}/functions.sh"

stack_name="hospitalrun"
billing_project='HospitalRunCURE'
hosted_zone_name="ehealthafrica.org"
ssh_key_name="aws-deploy"
cf_s3_bucket="eha-cloudformation"
cf_s3_zip_file="example-docker.zip"
rename_lambda="arn:aws:lambda:eu-west-1:387526361725:function:rename_resources"
sns_topic="arn:aws:sns:eu-west-1:387526361725:slack_notification"
ssl_cert="arn:aws:acm:eu-west-1:387526361725:certificate/b093a099-e453-4290-90b4-8a97f43174ec"
image_id="ami-d0fa87a3"

# list of supported environments and their variables passed to the stack
#
# to add an environment add value to each of the arrays and create corrspondive resource and output (Env*) in cloudformation.json
# to remove an environment remove value from each of the arrays (order matters)
# and remove correspondive resource (order matters here as well) and output (Env*) in cloudformation.json
environments=('dev')
instance_types=('t2.medium')
spot_prices=('')

# create arrays with credentials correspondive to the environment from environments array
# don't change values if credentials already exist in credential store
for env in ${environments[*]}; do
    db_password="$(date |md5sum |awk '{print $1}')"
    db_passwords+=("$(put_credentials "${stack_name}-${env}-db_password" "${db_password}")")
    db_user="temba"
    db_users+=("$(put_credentials "${stack_name}-${env}-db_user" "${db_user}")")
    db_name="temba"
    db_names+=("$(put_credentials "${stack_name}-${env}-db_name" "${db_name}")")
    db_port="5432"
    db_ports+=("$(put_credentials "${stack_name}-${env}-db_port" "${db_port}")")
done

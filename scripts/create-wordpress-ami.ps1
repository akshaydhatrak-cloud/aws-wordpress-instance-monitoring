param(
  [Parameter(Mandatory = $true)][string]$InstanceId,
  [string]$AmiName = "wordpress-portfolio-dev-ami",
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
  throw "AWS CLI is required but was not found in PATH."
}

$timestamp = Get-Date -Format "yyyyMMddHHmmss"

aws ec2 create-image `
  --region $Region `
  --instance-id $InstanceId `
  --name "$AmiName-$timestamp" `
  --description "WordPress AMI created from the live project instance" `
  --no-reboot `
  --tag-specifications "ResourceType=image,Tags=[{Key=Project,Value=wordpress-portfolio},{Key=Role,Value=wordpress-dev-base}]"

param(
  [Parameter(Mandatory = $true)][string]$StackName,
  [Parameter(Mandatory = $true)][string]$VpcId,
  [Parameter(Mandatory = $true)][string]$SubnetId,
  [Parameter(Mandatory = $true)][string]$KeyName,
  [Parameter(Mandatory = $true)][string]$AdminCidr,
  [Parameter(Mandatory = $true)][string]$WordPressDbPassword,
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
  throw "AWS CLI is required but was not found in PATH."
}

$templatePath = Join-Path $PSScriptRoot "../cloudformation/wordpress-stack.yml"

aws cloudformation deploy `
  --region $Region `
  --stack-name $StackName `
  --template-file $templatePath `
  --capabilities CAPABILITY_NAMED_IAM `
  --parameter-overrides `
    VpcId=$VpcId `
    SubnetId=$SubnetId `
    KeyName=$KeyName `
    AdminCidr=$AdminCidr `
    WordPressDbPassword=$WordPressDbPassword

aws cloudformation describe-stacks `
  --region $Region `
  --stack-name $StackName `
  --query "Stacks[0].Outputs"

param(
  [Parameter(Mandatory = $true)][string]$StackName,
  [Parameter(Mandatory = $true)][string]$WordPressAmiId,
  [Parameter(Mandatory = $true)][string]$VpcId,
  [Parameter(Mandatory = $true)][string]$SubnetIds,
  [Parameter(Mandatory = $true)][string]$KeyName,
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
  throw "AWS CLI is required but was not found in PATH."
}

$templatePath = Join-Path $PSScriptRoot "../cloudformation/dev-wordpress-asg.yml"

aws cloudformation deploy `
  --region $Region `
  --stack-name $StackName `
  --template-file $templatePath `
  --parameter-overrides `
    WordPressAmiId=$WordPressAmiId `
    VpcId=$VpcId `
    SubnetIds=$SubnetIds `
    KeyName=$KeyName

aws cloudformation describe-stacks `
  --region $Region `
  --stack-name $StackName `
  --query "Stacks[0].Outputs"

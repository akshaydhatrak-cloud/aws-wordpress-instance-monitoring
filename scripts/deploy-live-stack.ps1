param(
  [Parameter(Mandatory = $true)][string]$StackName,
  [Parameter(Mandatory = $true)][string]$VpcId,
  [Parameter(Mandatory = $true)][string]$SubnetId,
  [Parameter(Mandatory = $true)][string]$KeyName,
  [Parameter(Mandatory = $true)][string]$AdminCidr,
  [Parameter(Mandatory = $true)][string]$WordPressDbPassword,
  [string]$Region = "us-east-1"
)

aws cloudformation deploy `
  --region $Region `
  --stack-name $StackName `
  --template-file "../cloudformation/wordpress-stack.yml" `
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

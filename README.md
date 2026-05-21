# Set Up and Monitor a WordPress Instance on AWS

AWS infrastructure project for deploying a WordPress instance with CloudFormation, creating an AMI from the instance, and launching a scheduled development instance from that AMI.

## Features

- CloudFormation template for a WordPress EC2 instance
- Apache, PHP, MariaDB, and WordPress bootstrap through EC2 user data
- AMI creation script for the configured WordPress instance
- Development Auto Scaling group launched from the WordPress AMI
- Scheduled development capacity from 9 AM to 6 PM
- Route 53 HTTP health check for WordPress availability monitoring

## Tech Stack

- AWS CloudFormation
- Amazon EC2
- Amazon Machine Images
- Auto Scaling
- Route 53 Health Checks
- AWS IAM
- PowerShell

## Project Structure

```text
aws-wordpress-instance-monitoring/
|-- cloudformation/
|   |-- dev-wordpress-asg.yml
|   `-- wordpress-stack.yml
|-- scripts/
|   |-- create-wordpress-ami.ps1
|   |-- deploy-dev-asg.ps1
|   `-- deploy-live-stack.ps1
`-- README.md
```

## Setup

Prerequisites:

- AWS account with permissions for EC2, IAM, CloudFormation, Auto Scaling, and Route 53 health checks
- AWS CLI configured locally
- Existing VPC, subnet, and EC2 key pair
- PowerShell

Deploy the WordPress stack:

```powershell
cd scripts
.\deploy-live-stack.ps1 `
  -StackName wordpress-live `
  -VpcId vpc-xxxxxxxx `
  -SubnetId subnet-xxxxxxxx `
  -KeyName your-key-pair `
  -AdminCidr 203.0.113.10/32 `
  -WordPressDbPassword "replace-with-a-strong-password" `
  -Region us-east-1
```

Create an AMI from the configured WordPress instance:

```powershell
.\create-wordpress-ami.ps1 `
  -InstanceId i-xxxxxxxxxxxxxxxxx `
  -AmiName wordpress-dev-base `
  -Region us-east-1
```

Deploy the development Auto Scaling group:

```powershell
.\deploy-dev-asg.ps1 `
  -StackName wordpress-dev `
  -WordPressAmiId ami-xxxxxxxxxxxxxxxxx `
  -VpcId vpc-xxxxxxxx `
  -SubnetIds "subnet-xxxxxxxx,subnet-yyyyyyyy" `
  -KeyName your-key-pair `
  -Region us-east-1
```

## Resources

The CloudFormation templates create:

- EC2 instance for WordPress
- Security group for HTTP and SSH access
- IAM role and instance profile
- Route 53 health check
- Launch template for the development instance
- Auto Scaling group with scheduled actions

## Security Notes

- SSH access is restricted by `AdminCidr`.
- The instance role uses `AmazonSSMManagedInstanceCore` for managed access support.
- The WordPress database password is passed through a `NoEcho` CloudFormation parameter.

# AWS CloudFormation WordPress Deployment

## Business Objective

This project provisions a WordPress environment on AWS using CloudFormation. It is designed as a production-like single-instance WordPress deployment with a repeatable path for creating a development environment from an approved AMI.

## Cloud Architecture Overview

The live stack deploys an EC2 instance into an existing VPC subnet. CloudFormation installs Apache, PHP, MariaDB, and WordPress through EC2 user data. A security group allows HTTP access and restricts SSH to an approved admin CIDR. IAM attaches an instance role for managed instance access.

After the live instance is configured, a script can create a WordPress AMI. A second CloudFormation stack uses that AMI with a launch template and Auto Scaling group for a scheduled development instance.

The draw.io source is available at `docs/architecture.drawio`.

## Services Used

- AWS CloudFormation
- Amazon EC2
- Amazon VPC
- AWS IAM
- Amazon Machine Images
- Auto Scaling
- Route 53 Health Checks

## Deployment Workflow

1. Deploy the live WordPress stack from `infrastructure/cloudformation/wordpress-stack.yml`.
2. Provide an existing VPC, subnet, EC2 key pair, admin CIDR, and database password.
3. Allow the EC2 user data process to install and configure WordPress.
4. Validate the WordPress endpoint from the stack output.
5. Create an AMI from the configured WordPress instance.
6. Deploy the development Auto Scaling stack from `infrastructure/cloudformation/dev-wordpress-asg.yml`.
7. Use scheduled scaling to run the development instance during defined business hours.

Example live deployment:

```powershell
cd infrastructure/scripts
.\deploy-live-stack.ps1 `
  -StackName wordpress-live `
  -VpcId vpc-xxxxxxxx `
  -SubnetId subnet-xxxxxxxx `
  -KeyName wordpress-key `
  -AdminCidr 203.0.113.10/32 `
  -WordPressDbPassword "replace-with-a-strong-password" `
  -Region us-east-1
```

## Security Considerations

- SSH access is restricted through the `AdminCidr` parameter.
- The database password is passed as a CloudFormation `NoEcho` parameter.
- The EC2 instance uses an IAM instance profile instead of embedded AWS credentials.
- HTTP is open based on the configured allowed CIDR.
- Development infrastructure is separated into its own stack.

## Performance and Scalability Improvements

The live deployment is intentionally simple and uses a single EC2 instance. The AMI and Auto Scaling workflow improves repeatability for development environments and allows scheduled capacity, reducing unnecessary runtime.

## Operational Insights

- Route 53 health checks monitor the live WordPress HTTP endpoint.
- CloudFormation outputs expose the instance ID, public DNS, website URL, and health check ID.
- The AMI creation script captures a configured WordPress baseline for later use.
- Scheduled scaling keeps the development environment aligned with working hours.

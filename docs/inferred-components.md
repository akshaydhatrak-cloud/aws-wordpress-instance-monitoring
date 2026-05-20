# Inferred Components

The PDF provided the objective, scenario, tools, task list, and output screenshot placeholder. It did not include source code or CloudFormation templates. The following components were inferred from standard AWS implementation patterns:

- A single EC2-hosted WordPress live instance using Amazon Linux 2023, Apache, PHP, and MariaDB.
- A Route 53 HTTP health check for availability monitoring.
- A script to create an AMI from the live WordPress instance.
- A development Auto Scaling group that launches from the created AMI.
- Auto Scaling scheduled actions to run the development instance during business hours only.
- PowerShell helper scripts for repeatable deployment from a Windows workstation.

The repo does not add unrelated services such as RDS, CloudFront, WAF, or CI/CD because those were not required by the project prompt.

# Deployment Notes

The live stack deployed WordPress on a single EC2 instance using CloudFormation user data.

Main checks after deployment:

- CloudFormation stack reaches `CREATE_COMPLETE`
- EC2 instance passes status checks
- HTTP port 80 is reachable from the allowed CIDR
- WordPress setup page loads from the stack output URL
- Route 53 health check reports healthy after the site responds
- development Auto Scaling group uses the AMI created from the configured WordPress instance

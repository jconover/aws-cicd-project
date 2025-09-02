#!/bin/bash
yum update -y
yum install -y ruby wget nodejs npm

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Start CodeDeploy agent
service codedeploy-agent start
chkconfig codedeploy-agent on

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent

# Create health check endpoint
mkdir -p /var/www/html
cat > /var/www/html/health << 'HEALTH_EOF'
{
  "status": "healthy",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)",
  "region": "$(curl -s http://169.254.169.254/latest/meta-data/placement/region)",
  "instance": "$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
}
HEALTH_EOF

# Start simple web server on port 8080
nohup python3 -m http.server 8080 --directory /var/www/html > /dev/null 2>&1 &

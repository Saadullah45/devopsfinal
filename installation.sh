#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sleep 90

# Update packages
sudo yum update -y

# --- Install Git ---
sudo yum install -y git

# --- Install Nginx ---
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx
sudo systemctl start nginx

# --- Install Docker ---
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# --- Install Node.js 20 ---
# First, install NodeSource repo
# sudo curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
# sudo yum install -y nodejs
sudo yum install -y python3-pip
sudo yum install -y jq

# --- Confirm installations ---
nginx -v
docker --version

echo "Building and running frontend application..."
cd /home/ec2-user
sudo git clone https://github.com/Saadullah45/reactapp.git
sudo chown -R ec2-user:ec2-user reactapp
cd /home/ec2-user/reactapp
sudo docker build -t reactapp .
sudo docker run -d -p 3000:3000 --name reactapp reactapp

# Configure Nginx as reverse proxy (HTTP only, SSL handled at ALB)
echo "Configuring Nginx as reverse proxy..."
cat <<EOF | sudo tee /etc/nginx/conf.d/frontend.conf
server {
    listen 80;
    server_name saadullah.shop;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Health check endpoint for ALB
    location /health {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
EOF

echo "Waiting for frontend container to start..."
sleep 30

# Restart nginx to apply configuration
echo "Restarting Nginx..."
sudo systemctl restart nginx

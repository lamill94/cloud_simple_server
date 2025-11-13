#!/bin/bash

# Variables
KEY_PATH=~/.ssh/lauren_miller_cloud_deployment.pem
EC2_HOST=ec2-user@18.135.28.71
REMOTE_DIR=/home/ec2-user/flask-app

# Copy necessary files
echo "> Uploading files to EC2"
scp -i $KEY_PATH app.py requirements.txt Dockerfile $EC2_HOST:$REMOTE_DIR

# Connect and run container
ssh -i $KEY_PATH $EC2_HOST << EOF
    cd flask-app
    docker build -t my_flask_app .
    docker stop my-flask-app || true
    docker rm my-flask-app || true
    docker run -d -p 5001:5001 --name my-flask-app my-flask-app
EOF

echo "✅ Deployment complete! Visit: http://18.135.28.71:5001"

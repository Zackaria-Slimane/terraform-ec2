#! /bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo hostnamectl set-hostname terraform-jenkins

#install automatic updates and reboots
sudo apt-get update -y
sudo apt-get install unattended-upgrades -y
sudo dpkg-reconfigure -f noninteractive unattended-upgrades
echo 'Unattended-Upgrade::Automatic-Reboot "true";' | sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades
echo 'APT::Periodic::Enable "1";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Update-Package-Lists "1";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' | sudo tee -a /etc/apt/apt.conf.d/10periodic

# Install Git
sudo apt install git -y

# Install Jenkins
sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y

wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

sudo apt update -y
sudo apt install temurin-17-jdk -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Install Docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker terraform-jenkins
newgrp docker
sudo chmod 777 /var/run/docker.sock

docker run hello-world

sudo systemctl enable docker
sudo systemctl start docker


#
sudo cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/127.0.0.1:2375 -H unix:\/\/\/var\/run\/docker.sock/g' /lib/systemd/system/docker.service
sudo systemctl restart docker
sudo systemctl restart jenkins

# Install Docker-compose
sudo apt-get update
sudo apt-get install docker-compose-plugin


# Install AWS CLI v2
sudo apt install unzip -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Install Ansible
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y && sudo apt install ansible-core -y

#install nodejs and npm
sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get update -y
sudo apt-get install -y nodejs
node --version
npm --version
sudo npm install -g pm2



# Install Boto3
sudo apt install  pip -y
pip install boto3 botocore

# Install Terraform
sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update -y && sudo apt-get install terraform -y

# Install Kubectl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt install kubectl -y


echo "You're all set!"
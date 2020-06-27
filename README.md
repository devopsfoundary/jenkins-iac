# Jenkin IAC

This project can be used to provision the Jenkins on AWS with zero touch deployment.

## Instructions

Need terraform to execute this scripts.

```bash
cd ~/
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
cp terraform /bin
terraform -v
```

## Install Ansible provision-er (community edition)

```bash
mkdir $HOME/.terraform.d/plugins
curl -sSL https://github.com/radekg/terraform-provisioner-ansible/releases/download/v2.2.1/terraform-provisioner-ansible-linux-amd64_v2.2.1 --output $HOME/.terraform.d/plugins/terraform-provisioner-ansible_v2.2.1
chmod +x $HOME/.terraform.d/plugins/terraform-provisioner-ansible_v2.2.1	
```

Make sure keypair name is changed in the 

## How to run.
Make sure keypair name is changed in the terraform.tfvars file.

Add below local DNS entries in your machine or change the DNS entries in the jenkins-master.yaml file.

127.0.0.1 test.jenkins.local
127.0.0.1 test.app.local

make sure the machine has respective permission to provision infra in AWS else assign respective role to the ec2 machine.

Permission required:
1. EC2 admin


```bash
terraform apply --auto-approve #to create the infra + jenkins.
```
## How to create a simple nodejs deployment job.

1. Go to jenkins UI. 
2. Add the private key to jenkins credentials. (To authenticate with GitHUB).
3. Create a freestyle job.
4. add the gut details, Project link: https://github.com/fhinkel/nodejs-hello-world 
5. Use the below script to run the servelet.

```bash
#!/bin/bash
forever stop /opt/helloworld/index.js
rm -rf /opt/helloworld/
sudo mkdir /opt/helloworld/
cp index.js package.json /opt/helloworld/
cd /opt/helloworld/ && npm install 
forever -a -l helloworld.log start /opt/helloworld/index.js
```

## License
[MIT](https://choosealicense.com/licenses/mit/)

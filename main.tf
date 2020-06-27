resource "aws_security_group" "jenkins" {
  vpc_id       = "${data.aws_vpc.default.id}"
  name         = "jenkins Security Group"
  description  = "jenkins Security Group"
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
 
   ingress {
    cidr_blocks = ["0.0.0.0/0"]  
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
 
   ingress {
    cidr_blocks = ["0.0.0.0/0"]  
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "jenkins Security Groupp"
   Description = "jenkins Security Group"
}
}

resource "aws_instance" "jenkins-server" {
  ami           = "${lookup(var.ami_id,"ubuntu")}"
  instance_type = "${lookup(var.instance_family,"test")}"
  key_name      = "${var.keypair}"
  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]

  tags = {
    Name = "${format("${var.instance_name}-%03d", count.index + 1)}"
  }
    provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python ",
    ]
	} 
    connection {
      type        = "ssh"
      user        = "${var.connect_username}"
      host        = "${self.public_ip}"
      private_key = "${file("${var.private_key}")}"
	  agent = false
    }
}

resource "null_resource" "jenkins-server" {
  connection {
    user = "${var.connect_username}"
    private_key = "${file("${var.private_key}")}"
  }
  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "jenkins-master.yaml"
      }
      hosts = ["${aws_instance.jenkins-server.*.public_ip}"]
    }
    ansible_ssh_settings{
      connect_timeout_seconds = 60
    }
  }
}
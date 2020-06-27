variable "ami_id" {
  type = "map"

  default = {
    ubuntu = "ami-04b9e92b5572fa0d1"
    centos = "ami-00068cd7555f543d5"
  }
}

variable "instance_family" {
  type = "map"

  default = {
    test = "t2.micro"
    prod = "t2.micro"
  }
}

variable "instance_name" {
  description = "Name of the instance"
  default = "jenkins-server"
}

variable "keypair" {
  description = "Name of the keypair to use"
}

variable "connect_username" {
  description = "Name of the system username to use"
  default = "ubuntu"
}

variable "private_key" {
  description = "Name of the private key to use for SSH connection"
}

variable "instance_type" {
    description = "Type of ec2 instance"
    type = string
    default = "t2.medium"
}

variable "ami" {
    description = "The AMI id for ec2 instance"
    type = string
}

variable "key_pair" {
    description = "The key pair for login to the ec2 instance"
    type = string
}

variable "ec2_security_group" {
    description = "The security defined for the ec2"
    type = string
}
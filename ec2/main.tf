# Create key-pair on AWS using ssh-public key
resource "aws_key_pair" "ec2_key" {
    key_name = var.key_pair
    public_key = file("${path.module}/my-key.pub")
}

# Create a security group   
resource "aws_security_group" "my_sg" {
        name = var.ec2_security_group
        description = "Allow ssh traffic"
        ingress {
            description = "allow ssh"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
        
        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
            Name = "ec2-security-group"
        }
}

# Create a EC2 instance using Amazon Linux
resource "aws_instance" "my_instance" {
        ami = var.ami
        instance_type = var.instance_type
        vpc_security_group_ids = [aws_security_group.my_sg.id]
        key_name = aws_key_pair.ec2_key.key_name
        associate_public_ip_address = true
        tags = {
            Name = "terraform-vm"
        }

}
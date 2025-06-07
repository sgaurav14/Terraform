output "public_ip" {
    description = "The public ip of the deployed ec2 instance"
    value = aws_instance.my_instance.public_ip
}
# Terraform Cheat Sheet

A quick reference for commonly used Terraform commands, concepts, and
configurations.

------------------------------------------------------------------------

## 1. Provider Configuration

Define required providers in `main.tf` or `providers.tf`.

``` hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Configure the provider:

``` hcl
provider "aws" {
  region = "us-east-1"
}
```

------------------------------------------------------------------------

## 2. Configure AWS Credentials

**Using AWS CLI**

``` bash
aws configure
```

**Or directly in provider configuration (not recommended for
production):**

``` hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}
```

------------------------------------------------------------------------

## 3. Terraform Workflow Commands

Initialize Terraform project

``` bash
terraform init
```

Validate Terraform configuration

``` bash
terraform validate
```

Preview infrastructure changes

``` bash
terraform plan
```

Apply configuration

``` bash
terraform apply
```

Apply without approval

``` bash
terraform apply -auto-approve
```

Destroy infrastructure

``` bash
terraform destroy
```

Destroy without approval

``` bash
terraform destroy -auto-approve
```

Destroy specific resource

``` bash
terraform destroy -target aws_instance.myec2
```

------------------------------------------------------------------------

## 4. Terraform State

Terraform stores infrastructure state in:

    terraform.tfstate

------------------------------------------------------------------------

## 5. Refresh State

Refresh infrastructure state manually:

``` bash
terraform refresh
```

Note: This is already executed internally during `plan` and `apply`.

------------------------------------------------------------------------

## 6. Upgrade Providers

``` bash
terraform init -upgrade
```

------------------------------------------------------------------------

## 7. Resource Attribute Reference

    resource_type.resource_name.attribute

Example:

    aws_eip.lb.public_ip

------------------------------------------------------------------------

## 8. Recommended Terraform Folder Structure

    provider.tf
    main.tf
    variables.tf
    outputs.tf
    terraform.tfvars

Use variable files:

``` bash
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="prod.tfvars"
```

`terraform.tfvars` is automatically loaded.

------------------------------------------------------------------------

## 9. Variables

Declare variable:

``` hcl
variable "instance_type" {
  type = string
}
```

Terraform prompts for the value if none is provided.

------------------------------------------------------------------------

## 10. Ways to Define Variable Values

1.  Variable default values
2.  `.tfvars` files
3.  Environment variables

```{=html}
<!-- -->
```
    TF_VAR_variable_name

Example:

``` bash
export TF_VAR_instance_type=t2.micro
```

4.  Command line

``` bash
terraform plan -var="instance_type=t2.micro"
```

------------------------------------------------------------------------

## 11. Variable Precedence

Highest → Lowest

1.  `-var` and `-var-file`
2.  `*.auto.tfvars`
3.  `terraform.tfvars.json`
4.  `terraform.tfvars`
5.  Environment variables
6.  Variable defaults

------------------------------------------------------------------------

## 12. Variable Data Types

Example:

``` hcl
variable "user_id" {
  type = number
}
```

Common types:

    string
    number
    bool
    list
    map
    object

------------------------------------------------------------------------

## 13. List Data Type

``` hcl
["a", "b", "c"]
```

Used for:

-   security group IDs
-   multiple tags
-   multiple resources

------------------------------------------------------------------------

## 14. Map Data Type

``` hcl
{
  Team = "DevOps"
  location = "us-east-1"
}
```

Commonly used for tagging.

------------------------------------------------------------------------

## 15. Count

Create multiple resources.

``` hcl
resource "aws_instance" "my_ec2" {
  ami           = "ami-123"
  instance_type = "t2.micro"
  count         = 3
}
```

------------------------------------------------------------------------

## 16. count.index

``` hcl
resource "aws_instance" "my_ec2" {

  ami           = "ami-123"
  instance_type = "t2.micro"
  count         = 3

  tags = {
    Name = "my-app-server-${count.index}"
  }
}
```

------------------------------------------------------------------------

## 17. Count with Variables

``` hcl
variable "users" {
  type    = list(string)
  default = ["sid", "gaurav", "andy"]
}

resource "aws_iam_user" "test" {
  name  = var.users[count.index]
  count = 3
}
```

------------------------------------------------------------------------

## 18. Conditional Expression

``` hcl
instance_type = var.env == "dev" ? "t2.micro" : "m5.large"
```

Syntax:

    condition ? true_value : false_value

------------------------------------------------------------------------

## 19. Terraform Functions

Open console:

``` bash
terraform console
```

Examples:

    max(10,20,30)
    file("userdata.sh")

------------------------------------------------------------------------

## 20. Local Values

``` hcl
locals {
  default_tags = {
    app = "payment-app"
  }
}

resource "aws_security_group" "sg" {
  name = "app-firewall"
  tags = local.default_tags
}
```

------------------------------------------------------------------------

## 21. Data Sources

Fetch data from existing infrastructure.

Example:

``` hcl
data "local_file" "userdata" {
  filename = "${path.module}/userdata.sh"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-123"
  instance_type = "t2.micro"

  user_data = data.local_file.userdata.content
}
```

------------------------------------------------------------------------

## 22. Terraform Logging

Enable logs:

``` bash
export TF_LOG=DEBUG
```

Log levels:

    TRACE
    DEBUG
    INFO
    WARN
    ERROR

Save logs to file:

``` bash
export TF_LOG_PATH=terraform.log
```

------------------------------------------------------------------------

## 23. Dynamic Blocks

``` hcl
variable "aws_sg_ports" {
  type    = list(number)
  default = [8080,80,443]
}

resource "aws_security_group" "my_sg" {

  dynamic "ingress" {
    for_each = var.aws_sg_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

------------------------------------------------------------------------

## 24. Replace Resource

Force recreation of resource.

``` bash
terraform apply -replace="aws_instance.myec2"
```

------------------------------------------------------------------------

## 25. Splat Expression

``` hcl
resource "aws_iam_user" "lb" {
  name  = "iamuser.${count.index}"
  count = 3
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}
```

------------------------------------------------------------------------

## 26. Terraform Graph

Generate dependency graph:

``` bash
terraform graph
```

Generate SVG:

``` bash
terraform graph | dot -Tsvg > graph.svg
```

Requires Graphviz.

------------------------------------------------------------------------

## 27. Save Terraform Plan

``` bash
terraform plan -out=tfplan
```

View saved plan:

``` bash
terraform show tfplan
```

JSON format:

``` bash
terraform show -json tfplan | jq
```

Apply saved plan:

``` bash
terraform apply tfplan
```

------------------------------------------------------------------------

## 28. Terraform Output

``` bash
terraform output
```

Example:

``` bash
terraform output iam_names
```

------------------------------------------------------------------------

## 29. Terraform Settings

``` hcl
terraform {
  required_version = ">= 1.8"
}
```

------------------------------------------------------------------------

## 30. Provider Requirement

``` hcl
terraform {

  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
}
```

------------------------------------------------------------------------

## 31. Resource Targeting

Plan specific resource:

``` bash
terraform plan -target aws_instance.myec2
```

Apply specific resource:

``` bash
terraform apply -target aws_instance.myec2
```

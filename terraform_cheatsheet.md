# Terraform Cheat Sheet (Beginner Friendly)

This cheat sheet explains the most common Terraform concepts and
commands in a **simple way for beginners**.\
Terraform is an **Infrastructure as Code (IaC)** tool used to create and
manage infrastructure such as EC2, VPC, databases, Kubernetes clusters,
etc.

------------------------------------------------------------------------

# 1. Provider Configuration

Terraform works with different platforms like **AWS, Azure, GCP,
Kubernetes**.\
These platforms are called **providers**.

You must define which provider Terraform should use.

Example:

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

Explanation:

-   `required_providers` → tells Terraform which provider to download
-   `source` → where the provider plugin is located
-   `version` → which version should be used

------------------------------------------------------------------------

# 2. Configure the Provider

After declaring the provider, we must configure it.

Example:

``` hcl
provider "aws" {
  region = "us-east-1"
}
```

Explanation:

-   `provider "aws"` → tells Terraform we are using AWS
-   `region` → AWS region where resources will be created

------------------------------------------------------------------------

# 3. Configure AWS Credentials

Terraform needs credentials to access AWS.

### Option 1 (Recommended)

Use AWS CLI:

``` bash
aws configure
```

It stores credentials in:

    ~/.aws/credentials

### Option 2

Define credentials inside Terraform (not recommended):

``` hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "XXXX"
  secret_key = "XXXX"
}
```

------------------------------------------------------------------------

# 4. Terraform Workflow

Terraform generally follows this workflow.

### Initialize Terraform

``` bash
terraform init
```

What it does:

-   Downloads provider plugins
-   Creates `.terraform` directory
-   Initializes working directory

------------------------------------------------------------------------

### Validate Configuration

``` bash
terraform validate
```

Checks if the Terraform configuration has **syntax errors**.

------------------------------------------------------------------------

### Plan Infrastructure

``` bash
terraform plan
```

Shows:

-   What Terraform **will create**
-   What Terraform **will modify**
-   What Terraform **will destroy**

This command **does not create resources**.

------------------------------------------------------------------------

### Apply Configuration

``` bash
terraform apply
```

Creates or modifies infrastructure.

Terraform will ask for confirmation before applying changes.

------------------------------------------------------------------------

### Auto Approve Apply

``` bash
terraform apply -auto-approve
```

Skips confirmation prompt.

Useful in **CI/CD pipelines**.

------------------------------------------------------------------------

### Destroy Infrastructure

``` bash
terraform destroy
```

Deletes all infrastructure defined in Terraform.

------------------------------------------------------------------------

### Destroy Specific Resource

``` bash
terraform destroy -target aws_instance.myec2
```

Deletes only a specific resource.

------------------------------------------------------------------------

# 5. Terraform State

Terraform stores the infrastructure state in a file:

    terraform.tfstate

This file contains:

-   resource IDs
-   infrastructure configuration
-   metadata

Terraform uses this file to understand **what already exists**.

------------------------------------------------------------------------

# 6. Upgrade Providers

If you change provider versions, run:

``` bash
terraform init -upgrade
```

This downloads the newer provider version.

------------------------------------------------------------------------

# 7. Referencing Resource Attributes

Sometimes one resource needs information from another resource.

Syntax:

    resource_type.resource_name.attribute

Example:

    aws_eip.lb.public_ip

Explanation:

-   `aws_eip` → resource type
-   `lb` → resource name
-   `public_ip` → attribute

------------------------------------------------------------------------

# 8. Terraform Folder Structure

A common Terraform project structure looks like:

    terraform-project/
    │
    ├── provider.tf
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars

Explanation:

-   `provider.tf` → provider configuration
-   `main.tf` → main infrastructure code
-   `variables.tf` → variable definitions
-   `outputs.tf` → outputs after deployment
-   `terraform.tfvars` → variable values

------------------------------------------------------------------------

# 9. Variables

Variables allow us to make Terraform configurations **reusable and
flexible**.

Example:

``` hcl
variable "instance_type" {
  type = string
}
```

If no value is provided, Terraform will ask the user during execution.

------------------------------------------------------------------------

# 10. Ways to Provide Variable Values

Terraform supports multiple ways to provide variables.

### 1. Default value

``` hcl
variable "instance_type" {
  default = "t2.micro"
}
```

------------------------------------------------------------------------

### 2. tfvars file

Example:

    dev.tfvars
    prod.tfvars

Run:

``` bash
terraform plan -var-file="dev.tfvars"
```

------------------------------------------------------------------------

### 3. Environment variables

Terraform supports environment variables with prefix:

    TF_VAR_

Example:

``` bash
export TF_VAR_instance_type=t2.micro
```

------------------------------------------------------------------------

### 4. Command line

``` bash
terraform plan -var="instance_type=t2.micro"
```

------------------------------------------------------------------------

# 11. Variable Precedence

If the same variable exists in multiple places, Terraform follows this
priority.

Highest → Lowest

1.  `-var` and `-var-file`
2.  `*.auto.tfvars`
3.  `terraform.tfvars.json`
4.  `terraform.tfvars`
5.  Environment variables
6.  Default values

------------------------------------------------------------------------

# 12. Variable Data Types

Terraform supports different types.

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

# 13. List Data Type

A **list** stores multiple values.

Example:

``` hcl
["web", "db", "cache"]
```

Used for:

-   multiple security groups
-   tags
-   ports

------------------------------------------------------------------------

# 14. Map Data Type

A **map** stores key-value pairs.

Example:

``` hcl
{
  Team = "DevOps"
  Project = "Payment"
}
```

Mostly used for **tags**.

------------------------------------------------------------------------

# 15. Count

`count` allows creating multiple resources.

Example:

``` hcl
resource "aws_instance" "my_ec2" {

  ami           = "ami-123"
  instance_type = "t2.micro"
  count         = 3

}
```

This creates **3 EC2 instances**.

------------------------------------------------------------------------

# 16. count.index

`count.index` helps generate unique values.

Example:

``` hcl
tags = {
  Name = "app-server-${count.index}"
}
```

Result:

    app-server-0
    app-server-1
    app-server-2

------------------------------------------------------------------------

# 17. Conditional Expressions

Terraform supports conditional logic.

Example:

``` hcl
instance_type = var.env == "dev" ? "t2.micro" : "m5.large"
```

Explanation:

    condition ? true_value : false_value

------------------------------------------------------------------------

# 18. Terraform Functions

Terraform has built-in functions.

Open console:

``` bash
terraform console
```

Examples:

    max(10,20,30)
    file("userdata.sh")

`file()` reads a file and returns its content.

------------------------------------------------------------------------

# 19. Local Values

Locals store reusable values.

Example:

``` hcl
locals {
  app_name = "payment-service"
}
```

Use it:

``` hcl
tags = {
  Name = local.app_name
}
```

------------------------------------------------------------------------

# 20. Data Sources

Data sources fetch information from **existing infrastructure**.

Example:

``` hcl
data "aws_instance" "example" {

  filter {
    name = "tag:Name"
    values = ["Production"]
  }

}
```

Terraform can now use that instance's attributes.

------------------------------------------------------------------------

# 21. Terraform Logging

Enable debugging logs:

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

# 22. Dynamic Blocks

Dynamic blocks help create repeated nested blocks.

Example:

``` hcl
dynamic "ingress" {

  for_each = var.aws_ports

  content {
    from_port = ingress.value
    to_port   = ingress.value
    protocol  = "tcp"
  }

}
```

Useful when generating **multiple security group rules**.

------------------------------------------------------------------------

# 23. Replace Resources

Force Terraform to recreate a resource.

``` bash
terraform apply -replace="aws_instance.myec2"
```

------------------------------------------------------------------------

# 24. Splat Expression

Retrieve attributes from multiple resources.

Example:

``` hcl
output "arns" {
  value = aws_iam_user.lb[*].arn
}
```

Returns **list of ARNs**.

------------------------------------------------------------------------

# 25. Terraform Graph

Shows resource dependency graph.

``` bash
terraform graph
```

Convert to image:

``` bash
terraform graph | dot -Tsvg > graph.svg
```

Requires **Graphviz**.

------------------------------------------------------------------------

# 26. Save Terraform Plan

Save plan output to file.

``` bash
terraform plan -out=tfplan
```

View plan:

``` bash
terraform show tfplan
```

Apply saved plan:

``` bash
terraform apply tfplan
```

------------------------------------------------------------------------

# 27. Terraform Output

Outputs display useful values after deployment.

Example:

``` hcl
output "instance_ip" {
  value = aws_instance.myec2.public_ip
}
```

View output:

``` bash
terraform output
```

------------------------------------------------------------------------

# 28. Terraform Version Requirement

Define minimum Terraform version.

``` hcl
terraform {
  required_version = ">= 1.8"
}
```

------------------------------------------------------------------------

# 29. Provider Requirement

``` hcl
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }

}
```

------------------------------------------------------------------------

# 30. Resource Targeting

Apply changes only to specific resources.

Plan:

``` bash
terraform plan -target aws_instance.myec2
```

Apply:

``` bash
terraform apply -target aws_instance.myec2
```

⚠️ Should be used carefully because it may break dependency chains.

------------------------------------------------------------------------

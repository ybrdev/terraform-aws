# AWS VPC

This Terraform configuration sets up an AWS Virtual Private Cloud (VPC) with associated public and private subnets, route tables, NAT gateways, an Internet Gateway, and an S3 VPC endpoint.

## Overview

This configuration is designed to create a scalable and secure network environment in AWS, suitable for deploying applications in both public and private subnets.

## Prerequisites

- **Terraform**: Version 1.9.5 or higher.
- **AWS Account**: With appropriate IAM permissions to create VPC resources.
- **AWS CLI**: Configured with credentials to deploy resources.

## Usage

1. **Clone the repository** to your local machine.
2. **Navigate to the directory** containing the Terraform files.
3. **Customize the `variables.tf`** file or provide the necessary variables through a `terraform.tfvars` file.
4. **Initialize Terraform**:

   ```bash
   terraform init
   ```

5. **Plan the infrastructure**:

   ```bash
   terraform plan
   ```

   Review the plan to ensure everything looks correct.

6. **Apply the configuration**:

   ```bash
   terraform apply
   ```

   Confirm the action when prompted.

## Variables

Below are the key variables used in this configuration:

| Name                  | Description                              | Type   | Default | Required |
| --------------------- | ---------------------------------------- | ------ | ------- | -------- |
| `region`              | AWS region to deploy resources in        | string | n/a     | yes      |
| `vpc_cidr`            | CIDR block for the VPC                   | string | n/a     | yes      |
| `public_subnet_cidrs` | List of CIDR blocks for public subnets   | list   | n/a     | yes      |
| `private_subnet_cidrs`| List of CIDR blocks for private subnets  | list   | n/a     | yes      |
| `env`                 | Environment name (e.g., `dev`, `prod`)   | string | "dev"   | yes      |

## Outputs

Once the infrastructure is applied, the following outputs are available:

| Name                    | Description                              |
| ----------------------- | ---------------------------------------- |
| `vpc_id`                | The ID of the VPC                        |
| `public_subnet_ids`     | List of public subnet IDs                |
| `private_subnet_ids`    | List of private subnet IDs               |
| `internet_gateway_id`   | The ID of the Internet Gateway           |
| `nat_gateway_ids`       | List of NAT Gateway IDs                  |
| `public_route_table_id` | The ID of the public route table         |
| `private_route_table_ids` | List of private route table IDs        |
| `s3_vpc_endpoint_id`    | The ID of the VPC Endpoint for S3        |

## Project Structure

- `main.tf`: Contains the core resources for VPC, subnets, NAT gateways, route tables, etc.
- `variables.tf`: Defines the variables used in the configuration.
- `outputs.tf`: Lists the outputs provided after deployment.
- `terraform.tfvars` (optional): File where you can specify variable values.

## Example `terraform.tfvars`

```hcl
region               = "us-west-2"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
env                  = "dev"
```

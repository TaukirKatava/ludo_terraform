# Ludo Terraform Infrastructure

This repository contains the Terraform infrastructure code for deploying and managing the **Ludo** game environment on AWS. The setup includes provisioning networking, compute resources, security configurations, and automation scripts to streamline deployments.

## 🚀 Project Structure

```plaintext
.
├── main.tf                 # Root Terraform configuration
├── provider.tf             # AWS provider configuration
├── variables.tf            # Global variables for Terraform
├── output.tf               # Terraform output definitions
├── terraform.tfvars        # Terraform variable values
├── modules/                # Modular Terraform configurations
│   ├── alb/                # Application Load Balancer module
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── ami/                # AMI module for instance images
│   ├── asg/                # Auto Scaling Group module
│   ├── ec2/                # EC2 instance module
│   ├── iam/                # IAM role and policy configurations
│   ├── launch_template/    # EC2 Launch Template module
│   ├── pem_file/           # Key Pair management
│   ├── tg/                 # Target Group module
│   └── vpc/                # VPC and networking configurations
├── stag_scripts/           # Staging environment automation scripts
│   ├── stag_classic_auto.sh
│   ├── stag_classic_manual.sh
│   ├── stag_demo.sh
│   ├── stag_multiplayer.sh
│   ├── stag_quick.sh
└── README.md               # Project documentation
```

## 🌟 Features

- **Modular Architecture**: Each AWS resource is encapsulated in a module for reusability and scalability.
- **Scalable Deployment**: Uses Auto Scaling Groups (ASG) and Load Balancers (ALB) for dynamic scaling.
- **Secure Configurations**: IAM roles and security groups are configured with best practices.
- **Environment Automation**: Staging scripts to quickly set up different game environments.
- **State Management**: Terraform state files ensure consistent and trackable infrastructure changes.

## 📌 Prerequisites

Ensure you have the following installed before running Terraform commands:

- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS IAM credentials with necessary permissions
- SSH Key Pair for EC2 access

## 🛠️ Setup & Deployment

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/yourusername/ludo_terraform.git
cd ludo_terraform
```

### 2️⃣ Initialize Terraform

```sh
terraform init
```

### 3️⃣ Plan the Deployment

```sh
terraform plan
```

### 4️⃣ Apply the Infrastructure

```sh
terraform apply -auto-approve
```

### 5️⃣ Destroy the Infrastructure (If Needed)

```sh
terraform destroy -auto-approve
```

## 📂 Module Descriptions

| Module            | Description                              |
| ----------------- | ---------------------------------------- |
| `vpc`             | Provisions the networking infrastructure |
| `alb`             | Deploys an Application Load Balancer     |
| `asg`             | Configures Auto Scaling Groups           |
| `ec2`             | Manages EC2 instances                    |
| `iam`             | Defines IAM roles and policies           |
| `launch_template` | Configures EC2 launch templates          |
| `tg`              | Manages Target Groups for ALB            |
| `ami`             | Handles AMI configurations               |
| `pem_file`        | Manages SSH key pairs                    |

## 🔐 Security Considerations

- Ensure sensitive variables (e.g., AWS credentials) are stored securely.
- Use **Terraform Cloud** or **AWS S3 Backend** for state management.
- Rotate IAM keys and SSH keys periodically.
- Restrict EC2 security group access as per the principle of least privilege.

## 🤝 Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m "Added feature X"`)
4. Push the branch (`git push origin feature-branch`)
5. Open a Pull Request

## 📜 License

This project is licensed under the **MIT License**.

---

👾 **Happy Coding!** 🎲


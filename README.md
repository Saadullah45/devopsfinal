# saadterraform

Automated AWS Infrastructure using Terraform — Deploys a Dockerized Node.js app, private RDS (MySQL/PostgreSQL), and Metabase BI under a secure custom domain.

> **Live App:** https://farjadas.online  
> **Metabase BI (Saad Analytics):** https://bi.farjadas.online  
> **Loom Demo Video:** [Watch Deployment Walkthrough](https://www.loom.com/share/ce48e3baa26f4d7580e515db61b43294?sid=274e1879-e82b-4090-bf8c-672303e8e0f4)

---

## Project Structure

```bash
saadterraform/
├── main.tf
├── ec2.tf
├── rds.tf
├── alb.tf
├── route53.tf
├── security_groups.tf
├── target_group.tf
├── outputs.tf
├── variables.tf
├── docker/
│   ├── Dockerfile
│   └── app/                # Node.js Application
├── scripts/
│   └── tunnelling.sh       # SSH Tunnel Setup Script
├── README.md
└── report.pdf

---

## Tech Stack

- **Infrastructure as Code:** Terraform  
- **Cloud Services:** AWS EC2, ALB, RDS, Route 53  
- **Runtime:** Docker, Node.js 20  
- **Proxy:** Nginx  
- **Databases:** MySQL & PostgreSQL (via RDS)  
- **BI Tool:** Metabase (Dockerized)  
- **SSL & Domains:** Route 53, Let's Encrypt, AWS ACM  

---

##  Infrastructure Overview

### 1️ EC2 Auto Scaling Group

- Launches 3 EC2 instances using a Launch Template.
- Installs:
  - Nginx
  - Docker
  - Node.js 20
- OS: **Amazon Linux 2**
- SSH Key Pair: **saad-aws**

---

### 2️ RDS (Private Databases)

- Two RDS instances:
  - `saadterraform_postgresdb` (PostgreSQL)
  - `saadterraform_mysql_db` (MySQL)
- Located in **private subnets**.
- Accessed securely via **SSH tunnel through EC2**.

---

### 3️ Security Groups

- **EC2 SG:** SSH (22), HTTP (80), HTTPS (443)  
- **RDS SG:** Internal traffic only from EC2 SG  
- **ALB SG:** Allows inbound on ports 80/443  

---

### 4️ Application Load Balancer (ALB)

- Public-facing ALB
- Listens on ports **80** and **443**
- Routes traffic to **EC2 Docker containers**

---

### 5️ Dockerized App Deployment

- Multi-stage Docker build in `docker/Dockerfile`
- App runs **Node.js backend** with **Nginx** as reverse proxy
- Deployed on **2 EC2 instances**

---

### 6️ Metabase BI (Saad Analytics)

- Dockerized BI tool on **3rd EC2 instance**
- Connected to **PostgreSQL RDS**
- Dashboards reflect **real-time database updates**

---

### 7️ Domain & SSL

- **Main App:** [https://farjadas.online](https://farjadas.online)  
- **BI Tool:** [https://bi.farjadas.online](https://bi.farjadas.online)  
- SSL Certificates: **Let's Encrypt** or **AWS ACM**  
- HTTPS enforced via **ALB and Nginx**

---

##  Deployment Instructions

###  Prerequisites

- AWS CLI configured
- Terraform v1.5 or higher
- Docker installed
- SSH access using key `saad-aws`
- Domain registered on Route 53

---

###  Terraform Deployment

```bash
# Clone the repository
git clone https://github.com/Saadullah45/devopsfinal
cd saadterraform

# Initialize Terraform
terraform init

# Review infrastructure plan
terraform plan

# Apply infrastructure
terraform apply


## 🔌 Database Access via SSH Tunnel

### Script

```bash
bash scripts/tunnelling.sh

##  Use with DB Client

## Metabase BI — Saad Analytics
- URL: https://bi.farjadas.online
- Tool: Metabase (Dockerized)
- Connected to: PostgreSQL RDS
- Purpose: Real-time dashboards from live database data

---

## Docker & Nginx Configuration
- Location: /docker/Dockerfile
- Build Type: Multi-stage build for performance
- Features:
Includes Nginx reverse proxy
Runs on EC2 instances behind ALB

---

## Loom Deployment Video
https://www.loom.com/share/ce48e3baa26f4d7580e515db61b43294?sid=274e1879-e82b-4090-bf8c-672303e8e0f4

---

## Covered in the video:
- Full infrastructure provisioning via Terraform
- EC2 + Dockerized App + Nginx Setup
- SSH Tunneling to RDS
- Metabase dashboard usage
- SSL + Domain configuration

---

## Final Report
report.pdf contains:
- Breakdown of each Terraform component
- Screenshots of:
- Terraform apply logs
- Metabase dashboard
- Security configurations
- DNS + ALB setup
- Deployment flow summary

---

## Author
- Name: Saad
- Website: https://farjadas.online
- GitHub: https://github.com/Saadullah45/devopsfinal

---

# Summary
This project automates full-stack cloud infrastructure on AWS using Terraform, deploys scalable containerized applications with Docker and Nginx, secures the system with HTTPS and domain routing, and provides powerful BI via Metabase — all with modular, reusable, and production-grade infrastructure code.

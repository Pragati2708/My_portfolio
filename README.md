# DevOps Portfolio Project

## Project Overview

This project demonstrates a complete end-to-end DevOps implementation using:

* Terraform for Infrastructure as Code
* AWS EC2 for cloud infrastructure
* Ansible for server configuration automation
* Docker & Docker Compose for containerization
* GitHub Actions for CI/CD automation
* Prometheus for monitoring
* Grafana for observability dashboards
* Nginx for web serving
* HTTPS & Domain integration

The goal of this project was not only to deploy an application, but also to understand and troubleshoot real-world DevOps challenges while building a production-style deployment pipeline.

---

# Final Architecture

```text
Terraform
   ↓
AWS EC2
   ↓
Ansible
   ↓
Docker Compose
   ↓
Portfolio Application
   ↓
Prometheus + Grafana
   ↓
GitHub Actions CI/CD
   ↓
HTTPS + Domain
```

---

# Technologies Used

| Category                 | Tools                   |
| ------------------------ | ----------------------- |
| Cloud                    | AWS EC2                 |
| IaC                      | Terraform               |
| Configuration Management | Ansible                 |
| Containerization         | Docker, Docker Compose  |
| CI/CD                    | GitHub Actions          |
| Monitoring               | Prometheus              |
| Visualization            | Grafana                 |
| Web Server               | Nginx                   |
| Version Control          | Git & GitHub            |
| SSL                      | Certbot & Let's Encrypt |

---

# Key Features Implemented

* Automated EC2 provisioning using Terraform
* Automated server configuration using Ansible
* Dockerized portfolio application
* Monitoring stack with Prometheus & Grafana
* CI/CD deployment pipeline using GitHub Actions
* Domain & HTTPS integration
* Persistent Grafana dashboards using Docker volumes
* Elastic IP usage for stable infrastructure

---

# Project Structure

```text
portfolio-project/
│
├── ansible/
│   ├── inventory
│   ├── inventory.example
│   └── playbook.yml
│
├── terraform/
│   └── main.tf
│
├── monitoring/
│   └── prometheus.yml
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── docker-compose.yml
├── Dockerfile
├── index.html
└── .gitignore
```

---

# Monitoring Dashboard Metrics

Implemented Grafana dashboard panels for:

* CPU Usage
* Memory Usage
* Disk Usage
* Network Traffic
* Prometheus Health
* Node Exporter Health
* Server Uptime

---

# Challenges Faced & Fixes Implemented

## 1. Docker Port Conflict

### Issue

Containers failed to start due to port conflicts.

### Error

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

### Root Cause

Another container was already using port 8080.

### Fix

* Identified running containers using:

```bash
docker ps
```

* Removed conflicting container:

```bash
docker rm -f <container-name>
```

### Learning

Only one container/service can bind to a host port at a time.

---

## 2. Multiple Deployment Folders on EC2

### Issue

Website changes were not reflecting after successful CI/CD deployment.

### Root Cause

Two different folders existed on EC2:

```text
~/portfolio
~/portfolio-project
```

GitHub Actions was deploying the old folder while updated code existed in another folder.

### Fix

* Standardized deployment path to:

```text
~/portfolio-project
```

* Updated GitHub Actions workflow.

### Learning

Deployment paths must remain consistent across automation tools.

---

## 3. GitHub Actions Successful but Website Still Showing Old Code

### Issue

GitHub Actions pipeline showed success but application changes were not visible.

### Root Cause

* Wrong deployment folder
* Old Docker images
* Docker cache issues

### Fix

* Cleaned old images and containers
* Rebuilt Docker images using:

```bash
docker compose build --no-cache
```

### Learning

A successful CI/CD pipeline does not always guarantee that the latest application version is running.

---

## 4. Grafana Dashboards Getting Deleted

### Issue

Grafana dashboards disappeared after container recreation.

### Root Cause

Grafana container did not use persistent Docker volumes.

### Fix

Added named volume in docker-compose.yml:

```yaml
volumes:
  - grafana-data:/var/lib/grafana
```

Added bottom volumes section:

```yaml
volumes:
  grafana-data:
```

### Learning

Containers are ephemeral. Persistent data must use Docker volumes.

---

## 5. Docker Compose YAML Indentation Errors

### Issue

Docker Compose failed due to YAML structure issues.

### Root Cause

Incorrect indentation of:

* Grafana service
* Node exporter service
* Volumes section

### Fix

Corrected YAML indentation and hierarchy.

### Learning

YAML indentation is extremely important in DevOps configuration files.

---

## 6. SSH Timeout in GitHub Actions

### Error

```text
dial tcp ***:22: i/o timeout
```

### Root Cause

EC2 instance was stopped.

### Fix

* Started EC2 instance
* Verified SSH connectivity

### Learning

CI/CD pipelines depend on infrastructure availability.

---

## 7. Ansible SSH Host Verification Failure

### Error

```text
Host key verification failed
```

### Root Cause

EC2 SSH fingerprint was not trusted locally.

### Fix

* Removed old SSH host entry
* Connected manually once using SSH

### Learning

SSH host fingerprints are stored in:

```text
~/.ssh/known_hosts
```

---

## 8. PEM File Path & Permission Issues

### Error

```text
Identity file not accessible
```

### Root Cause

PEM file was not placed inside the .ssh directory.

### Fix

Moved PEM file:

```bash
mv ~/Downloads/2026_key.pem ~/.ssh/
```

Applied proper permissions:

```bash
chmod 400 ~/.ssh/2026_key.pem
```

### Learning

SSH keys require correct permissions and proper paths.

---

## 9. Git Permission & Ownership Issues on EC2

### Errors

```text
detected dubious ownership
FETCH_HEAD permission denied
```

### Root Cause

Repository files were owned by root because of mixed sudo operations.

### Fix

Fixed ownership:

```bash
sudo chown -R ubuntu:ubuntu /home/ubuntu/portfolio-project
```

### Learning

Consistent Linux file ownership is critical in automation environments.

---

## 10. Ansible become_user Misconfiguration

### Error

```text
Unsupported parameters for (git) module: become_user
```

### Root Cause

become_user was incorrectly placed inside module parameters.

### Fix

Moved become_user to task level.

### Learning

Ansible privilege escalation directives belong at task level.

---

## 11. Container Name Conflicts

### Error

```text
container name "/portfolio" already exists
```

### Root Cause

Old standalone containers still existed in Docker.

### Fix

Removed stale containers:

```bash
docker rm -f portfolio
```

### Learning

Container names must remain unique across Docker environments.

---

## 12. Monitoring Stack Accessible Only on Localhost

### Issue

Grafana and Prometheus worked locally but not via EC2 public IP.

### Root Cause

AWS Security Groups did not allow ports 3000 and 9090.

### Fix

Added inbound rules for:

* Port 3000 (Grafana)
* Port 9090 (Prometheus)

### Learning

Cloud networking and security groups directly affect monitoring accessibility.

---

## 13. Docker Volume Persistence Understanding

### Issue

Needed to rebuild Docker setup without losing Grafana dashboards.

### Root Cause

Confusion between deleting containers/images vs deleting volumes.

### Fix

Avoided:

```bash
docker compose down -v
```

Used:

```bash
docker compose down
```

### Learning

Docker volumes persist data independently from containers and images.

---

## 14. CI/CD Deployment Validation

### Validated Workflow

```text
Local Change
    ↓
Git Push
    ↓
GitHub Actions
    ↓
EC2 Pulls Latest Code
    ↓
Docker Compose Rebuild
    ↓
Website Updates Automatically
```

### Learning

A real CI/CD pipeline requires:

* Proper deployment paths
* Correct Git synchronization
* Clean Docker deployment strategy
* Infrastructure consistency

---

## 15. Terraform & Ansible Integration Understanding

### Realization

Initially deployment was running on a manually created EC2 server.

### Understanding Gained

True Infrastructure as Code means:

```text
Terraform creates infrastructure
Ansible configures infrastructure
```

instead of manually creating servers.

### Learning

Infrastructure should be reproducible entirely from code.

---

# Major DevOps Concepts Learned

* Infrastructure as Code
* CI/CD Automation
* Containerization
* Docker Networking
* Persistent Volumes
* Monitoring & Observability
* Linux File Permissions
* SSH Authentication
* Git Ownership & Safe Directory Handling
* YAML Configuration Management
* Elastic IP Usage
* HTTPS & SSL Automation
* Infrastructure Reproducibility
* Server Automation using Ansible
* Cloud Security Groups & Networking

---

# Final Outcome

Successfully built a production-style DevOps portfolio project with:

* Automated infrastructure provisioning
* Automated application deployment
* Monitoring & observability stack
* CI/CD automation pipeline
* Dockerized deployment architecture
* HTTPS-enabled application hosting
* Real-world troubleshooting & debugging experience

---

# How to Run This Project

## 1. Clone Repository

```bash
git clone https://github.com/Pragati2708/My_portfolio.git
cd My_portfolio
```

---

## 2. Configure Terraform

Navigate to terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Verify execution plan:

```bash
terraform plan
```

Create infrastructure:

```bash
terraform apply
```

Terraform automatically:

* Creates EC2 instance
* Creates Security Group
* Attaches Elastic IP

---

## 3. Configure Ansible Inventory

Update inventory file with Elastic IP:

```ini
[web]
YOUR_ELASTIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/YOU_PEM_KEY_NAME.pem
```

---

## 4. Run Ansible Playbook

Navigate to project root:

```bash
cd ..
```

Test Ansible connectivity:

```bash
ansible web -i ansible/inventory -m ping
```

Run playbook:

```bash
ansible-playbook -i ansible/inventory ansible/playbook.yml
```

Ansible automatically:

* Installs Docker
* Installs Docker Compose
* Installs Git
* Installs Nginx
* Installs Certbot
* Clones GitHub repository
* Configures Docker containers
* Configures Nginx reverse proxy
* Configures SSL certificates
* Deploys monitoring stack

---

## 5. Access Services

| Service           | URL                                                |
| ----------------- | -------------------------------------------------- |
| Portfolio Website | [https://pragatisingh.in](https://pragatisingh.in) |
| Grafana           | http://YOUR_IP:3000                                |
| Prometheus        | http://YOUR_IP:9090                                |

---

## 6. CI/CD Deployment Flow

Any push to main branch automatically:

```text
Git Push
   ↓
GitHub Actions Trigger
   ↓
SSH Into EC2
   ↓
Git Pull Latest Code
   ↓
Docker Compose Rebuild
   ↓
Application Updated
```

---

# Additional Infrastructure Troubleshooting & Learnings

## 16. Elastic IP Recreation & Infrastructure Consistency

### Issue

Terraform recreated EC2 but public IP changed.

### Root Cause

Terraform was creating a new Elastic IP instead of reusing the existing Elastic IP.

### Fix

Replaced:

```hcl
resource "aws_eip"
```

with:

```hcl
resource "aws_eip_association"
```

and attached existing Allocation ID.

### Learning

Elastic IP persistence is critical for:

* stable DNS
* stable SSL
* stable CI/CD
* stable Ansible inventory

---

## 17. SSH Host Key Verification Errors After EC2 Recreation

### Error

```text
WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
```

### Root Cause

Terraform recreated EC2 instance while reusing same Elastic IP.

SSH fingerprint changed because the server itself changed.

### Fix

Removed old fingerprint:

```bash
ssh-keygen -R <ELASTIC_IP>
```

Reconnected manually.

### Learning

SSH host fingerprints are tied to server identity, not IP address.

---

## 18. Docker Compose Plugin Missing on Fresh EC2

### Error

```text
docker: unknown command: docker compose
```

### Root Cause

Fresh Ubuntu server installed Docker engine but not Docker Compose plugin.

### Fix

Installed:

```bash
docker-compose
```

package through Ansible.

### Learning

Fresh infrastructure recreation reveals hidden manual dependencies.

---

## 19. Docker Permission Denied Errors

### Error

```text
PermissionError: [Errno 13] Permission denied
```

### Root Cause

Ubuntu user was not part of Docker group.

### Fix

Added ubuntu user to docker group:

```yaml
- name: Add ubuntu user to docker group
  user:
    name: ubuntu
    groups: docker
    append: yes
```

### Learning

Docker socket access depends on Linux group permissions.

---

## 20. Grafana Volume Persistence Understanding

### Observation

Grafana dashboards survived container recreation but disappeared after EC2 recreation.

### Root Cause

Docker volumes persist only inside the same EC2 machine.

### Learning

Container persistence and infrastructure persistence are different concepts.

---

# Conclusion

This project provided hands-on experience with real-world DevOps workflows, debugging scenarios, deployment automation, monitoring setup, and infrastructure management.

More importantly, it helped build practical troubleshooting skills across:

* Linux
* Docker
* Networking
* Git
* CI/CD
* Cloud Infrastructure
* Automation Tools

The project evolved from a manually managed setup into a reproducible, automated DevOps deployment architecture.

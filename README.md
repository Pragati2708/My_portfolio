“Challenges Faced & Fixes Implemented”

1. Docker Compose & Container Issues
Issue: Port conflict while starting containers.
Error: Bind for 0.0.0.0:8080 failed: port is already allocated
Root Cause: Another container was already using port 8080.

Fix: Identified the running container using docker ps
Removed old container
Rebuilt Docker Compose setup
Learning

Only one container/service can bind to a host port at a time.

2. Multiple Deployment Folders on EC2
Issue

Application changes were not reflecting after successful CI/CD.

Root Cause

Two different project folders existed:

~/portfolio
~/portfolio-project

GitHub Actions deployed old folder while latest code existed in another folder.

Fix
Standardized deployment path to:
~/portfolio-project
Updated deployment workflow.
Learning

Deployment paths must remain consistent across automation tools.

3. GitHub Actions Success but Old Website Visible
Issue

GitHub Actions pipeline showed success but website displayed old code.

Root Cause
Wrong deployment directory
Old Docker images
Docker cache
Fix
Cleaned old containers/images
Rebuilt images using:
docker compose build --no-cache
Learning

Successful CI/CD does not guarantee latest application version is running.

4. Grafana Dashboards Not Persisting
Issue

Dashboards disappeared after container recreation.

Root Cause

Grafana container had no persistent Docker volume.

Fix

Added named volume:

volumes:
  - grafana-data:/var/lib/grafana
Learning

Containers are ephemeral; persistent data must use Docker volumes.

5. Docker Compose YAML Indentation Errors
Issue

Docker Compose failed because of invalid YAML structure.

Root Cause

Incorrect indentation of:

grafana service
node-exporter
volumes section
Fix

Corrected YAML hierarchy and service alignment.

Learning

YAML indentation is critical in DevOps configuration files.

6. SSH Timeout in GitHub Actions
Error
dial tcp ***:22: i/o timeout
Root Cause

EC2 instance was stopped.

Fix

Started EC2 instance and verified SSH connectivity.

Learning

CI/CD pipelines depend on infrastructure availability.

7. Ansible SSH Host Verification Failure
Error
Host key verification failed
Root Cause

EC2 SSH fingerprint was not trusted locally.

Fix
Removed old SSH host entry
Connected manually once using SSH
Learning

SSH host fingerprints are stored in:

~/.ssh/known_hosts
8. PEM Key Path Issues
Error
Identity file not accessible
Root Cause

PEM file was not inside .ssh directory.

Fix
Moved PEM into:
~/.ssh/
Applied proper permissions:
chmod 400
Learning

SSH keys require correct permissions and paths.

9. Git Permission Issues on EC2
Errors
dubious ownership
FETCH_HEAD permission denied
Root Cause

Repository files were owned by root due to mixed sudo operations.

Fix
sudo chown -R ubuntu:ubuntu /home/ubuntu/portfolio-project
Learning

Consistent Linux file ownership is critical in automation environments.

10. Ansible become_user Misconfiguration
Error
Unsupported parameters for (git) module: become_user
Root Cause

become_user was incorrectly placed inside module parameters.

Fix

Moved become_user to task level.

Learning

Ansible privilege escalation directives belong at task level.

11. Container Name Conflicts
Error
container name "/portfolio" already exists
Root Cause

Old standalone containers still existed.

Fix

Removed stale containers using:

docker rm -f portfolio
Learning

Container names must remain unique across Docker environment.

12. Monitoring Stack Accessibility Issues
Issue

Grafana/Prometheus worked on localhost but not via EC2 public IP.

Root Cause

Security group ports were not opened.

Fix

Allowed:

3000
9090

in AWS security groups.

Learning

Cloud networking/security groups directly affect observability accessibility.

13. Understanding Real DevOps Concepts

Major concepts learned:

Infrastructure as Code
Containerization
Persistent Volumes
CI/CD Pipelines
Deployment Automation
Infrastructure Reproducibility
Monitoring & Observability
Linux Permissions
SSH Authentication
Docker Networking
YAML Configuration
Git Ownership & Safe Directory Handling
Elastic IP Usage
HTTPS & SSL Automation Planning

# Secu# Secure Automated Cloud Web Architecture
**Engineered by Oscar Estudillo**

## 🔗 Professional Connections
*   **LinkedIn Profile:** https://www.linkedin.com/in/oscarestudillo/
*   **Professional Resume:** [https://drive.google.com/drive/u/0/folders/1c_B6j2Kc0POBY6_73LxbmKcq506dIBsM]

---

## 🎯 What This Project Does
This project builds a fully automated, secure cloud network environment on Amazon Web Services (AWS) using code instead of manual pointing and clicking. It launches a functional web application server inside a hardened digital perimeter and automatically runs security scans on the blueprint code to catch and fix human errors before the site ever goes live.

## 🛠️ What I Did (How It Works)

### 1. Automated Infrastructure (Terraform)
*   **Built the Network Core:** Wrote code to provision an isolated Virtual Private Cloud (VPC) network, public subnets for hosting, and an Internet Gateway to guide web traffic safely.
*   **Hardened the Perimeter:** Deployed stateful cloud firewalls (Security Groups) configured to allow global access for public web visitors (Port 80) while locking down administrative controls (Port 22 SSH) exclusively to my specific authorized home IP address.
*   **Provisioned Self-Bootstrapping Compute:** Configured a virtual Linux server that automatically updates, installs Apache, and deploys our custom "Titan FinTech" application landing page the exact second it turns on.
*   **Enforced Data Protection:** Encrypted the server's hard drive at the root block level and activated modern metadata validation protocols (IMDSv2) to block advanced cloud hacking strategies.

### 2. DevSecOps Automation (GitHub Actions)
*   **Engineered the Quality Gate:** Built an automated code testing assembly line that scans files on every push.
*   **Integrated Security Checks:** Leveraged a security analysis tool (`tfsec`) to inspect my architecture rules. The scanner is strictly configured to break the automated pipeline build if any engineer tries to push insecure settings, acting as a mandatory safety filter.

## 🧰 Technologies & Languages Used
*   **Cloud Infrastructure:** Amazon Web Services (AWS - VPC, Subnets, EC2, Cloud Firewalls)
*   **Infrastructure as Code:** Terraform (HashiCorp Configuration Language - HCL)
*   **DevSecOps Pipeline:** GitHub Actions & tfsec static code scanner
*   **System Admin & Code:** Linux Bash Scripting, HTML

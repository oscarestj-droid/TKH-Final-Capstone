# Secure Automated Cloud Web Stack: DevSecOps Infrastructure

This project designs and launches a secure, production-ready web application infrastructure inside Amazon Web Services using Infrastructure as Code (IaC). It builds an automated network perimeter, deploys a self-bootstrapping web server, and uses a DevSecOps pipeline (Tfse) to scan the blueprints for security flaws before code changes can go live.

## Technologies Used
* **AWS (Amazon Web Services):** The underlying cloud platform housing our virtual networks and web servers.
* **Terraform (HCL):** The blueprint language used to declare, version, and manage our cloud assets as text code.
* **GitHub Actions:** The automation engine that automatically runs validation checks on every code push.
* **tfsec (Static Application Security Testing):** The security inspector that scans our code to stop vulnerabilities from deploying.

## Architecture & Security Breakdown
* **Virtual Private Cloud (VPC) & Subnets:** The entire environment is isolated in a private network container, with public routing explicitly defined through an Internet Gateway.
* **Firewall Hardening:** Network Security Groups act as stateful firewalls. They allow global public traffic to view the web application on Port 80, but strictly restrict administrative SSH access on Port 22 exclusively to a single authorized home IP address.
* **Data & Platform Integrity:** The underlying virtual server is hardened with full storage root-disk encryption to prevent physical theft and enforces Metadata Service Version 2 (IMDSv2) tokens to defend against cloud-native spoofing attacks.

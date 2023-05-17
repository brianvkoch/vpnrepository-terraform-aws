# vpnrepository-terraform-aws
*** Work-In-Progress ***
Experimental deployment for an OpenVPN server

## Vision
To create a deployment framework for instances of OpenVPN server for use with the [VPN Orchestrator](https://github.com/brianvkoch/VPNOrchestrator) project.

## Goals
 - (DONE) Create a simplified deployment of OpenVPN for use with deploying to AWS via Terraform
 - Refine the OpenVPN server setup by honing the server configuration and adding associated tools
 - Dockerize the OpenVPN server instance and create a Terraform deployment to an EKS cluster
 - Integrate the VPN Orchestrator application into the final docker instance

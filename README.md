# aws-terraform-three-tier

This project demonstrates a full 3-tier AWS architecture using Ktor as the backend framework, PostgreSQL for data persistence, and Terraform for infrastructure as code.

The setup provisions:
- VPC with public/private subnets
- ECR for container image storage
- ECS (Fargate) for containerized Ktor deployment
- RDS (Postgres) for the database layer
- ALB (Application Load Balancer) for external traffic routing
- CloudWatch for logging

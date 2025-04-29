# DevOps Final Assessment Questions

This assessment is designed for students who have completed and mastered the DevOps content in this project. Answer each question thoroughly. Where applicable, provide code snippets, configuration examples, or detailed explanations.

## Ansible & Automation

1. Explain the concept of idempotency in configuration management. Why is it important, and how does the `ansible.posix.sysctl` module help achieve it compared to using `ansible.builtin.command`?
2. Given a multi-tier application, describe how you would structure your Ansible playbooks and roles for maximum reusability and maintainability.
3. Write an Ansible playbook snippet that securely manages secrets and avoids exposing sensitive data in logs or output.
4. How would you use Ansible inventories to manage different environments (e.g., staging vs production)? Provide an example.

## CI/CD (Jenkins)

5. Describe the typical stages you would include in a Jenkins pipeline for a containerized application. Why is each stage important?
6. Given a sample `Jenkinsfile`, identify and explain how environment variables and credentials should be managed securely.
7. What are the benefits of using declarative pipelines in Jenkins? Provide a simple example.

## Infrastructure as Code (Terraform & Localstack)

8. Explain the purpose of `terraform init`, `plan`, and `apply`. What is the significance of the state file?
9. How does Localstack help in local development and testing of cloud infrastructure? Provide a scenario where it would be especially useful.
10. Write a Terraform configuration snippet to provision an S3 bucket and restrict its access to a specific IAM user.
11. Describe how you would manage Terraform modules for a large project. What are the best practices for module versioning and reuse?

## Kubernetes & Orchestration

12. Explain the difference between Kubernetes Deployments, StatefulSets, and DaemonSets. When would you use each?
13. Describe the process of deploying an application using Helm. What are the advantages of using Helm charts?
14. How would you securely inject secrets into a Kubernetes deployment? Provide an example using Kubernetes Secrets.
15. Given a scenario where you need to scale an application based on CPU usage, explain how you would configure Horizontal Pod Autoscaling in Kubernetes.

## Security & Best Practices

16. What are the risks of hardcoding secrets in configuration files or code? How can you mitigate these risks in a DevOps workflow?
17. Explain the process of creating and using a self-signed Certificate Authority (CA) for internal services. What are the pros and cons?
18. How would you audit and monitor infrastructure changes in a DevOps pipeline?

## Scenario-Based

19. You are tasked with setting up a CI/CD pipeline for a microservices architecture using Kubernetes, Terraform, and Jenkins. Outline the steps you would take and the tools you would use at each stage.
20. A deployment fails due to a misconfiguration in a Helm values file. Describe your troubleshooting process and how you would prevent similar issues in the future.

---

## Final Practical Project

### Scenario: End-to-End DevOps Pipeline for a Microservices Application

You are tasked with designing, implementing, and demonstrating a complete DevOps workflow for a fictional company that is launching a new microservices-based web application. The company requires a robust, secure, and automated deployment pipeline that leverages the tools and practices covered in this course.

#### Microservices Architecture

The application consists of three microservices, each implemented in a different language and framework:

-   **Go Service:** Provides a `/health` endpoint. Acts as a core backend component, e.g., for processing or data aggregation.
-   **Python Service (Flask):** Provides a `/health` endpoint. Serves as an API gateway or intermediary, capable of calling the Go service to aggregate or transform data.
-   **Ruby on Rails Service:** Provides a `/health` endpoint. Represents a user-facing API or business logic layer, which can call the Python service to fetch or process information.

**Relationship:**

-   The Rails service should be able to make HTTP requests to the Python service.
-   The Python service should be able to make HTTP requests to the Go service.
-   Each service exposes its `/health` endpoint for health checks and service discovery.

You must containerize all three services, deploy them as part of your solution, and demonstrate inter-service communication (Rails → Python → Go) by implementing a `/chain` endpoint in each service:

-   The Rails service's `/chain` endpoint should call the Python service's `/chain` endpoint.
-   The Python service's `/chain` endpoint should call the Go service's `/health` endpoint.
-   The Go service responds to `/health`.

Document your architecture and provide sample requests that traverse the service chain, showing the response at each step.

#### Requirements:

1. **Infrastructure Provisioning:**
    - Use Terraform to provision cloud infrastructure (e.g., VMs, networking, storage). Infrastructure should be modular and reusable.
    - Use Localstack for local development and testing of cloud resources.
2. **Configuration Management:**
    - Use Ansible to automate the configuration of provisioned servers, including application dependencies and security hardening.
    - Ensure idempotency and secure handling of secrets.
3. **Application Deployment:**
    - Containerize each microservice using Docker.
    - Deploy the application to a Kubernetes cluster. Use Helm to manage deployments and configuration.
    - Implement secure secret management in Kubernetes.
4. **CI/CD Pipeline:**
    - Set up a Jenkins pipeline that automates build, test, and deployment stages for the microservices.
    - Integrate code quality checks and automated tests into the pipeline.
5. **Security:**
    - Implement a self-signed CA for internal service communication.
    - Ensure secrets are not hardcoded and are managed securely throughout the workflow.
6. **Documentation:**
    - Document your architecture, pipeline, and deployment process clearly.
    - Provide instructions for reproducing your setup locally (using Localstack, Minikube/kind, etc.).

#### Deliverables:

-   Source code and configuration files (Terraform, Ansible, Jenkinsfile, Helm charts, etc.)
-   A written report (markdown or PDF) explaining your architecture, decisions, and how each requirement was met
-   Screenshots or screencasts demonstrating the pipeline in action (optional but encouraged)

#### Evaluation Criteria:

-   Correctness and completeness of the solution
-   Use of best practices in automation, security, and infrastructure management
-   Clarity and thoroughness of documentation
-   Ability to troubleshoot and explain design decisions

---

**End of Assessment**

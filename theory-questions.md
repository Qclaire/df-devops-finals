## Ansible & Automation

1. **Explain the concept of idempotency in configuration management. Why is it important, and how does the `ansible.posix.sysctl` module help achieve it compared to using `ansible.builtin.command`?**

    Idempotency means that applying the same configuration multiple times results in the same system state without making additional changes. It's crucial because it ensures predictable, repeatable deployments. The `ansible.posix.sysctl` module is idempotent because it checks and applies settings only if they differ from the desired state. In contrast, `ansible.builtin.command` just runs shell commands without checking state, making it non-idempotent unless explicitly scripted.

2. **Given a multi-tier application, describe how you would structure your Ansible playbooks and roles for maximum reusability and maintainability.**

    I would create separate roles for each layer (e.g., `db`, `backend`, `frontend`). Each role would have tasks, handlers, templates, and vars. Playbooks would include these roles based on groupings in the inventory. Variables would be separated into environment-specific files. I'd also create common roles like `common_security` or `logging` to reuse across tiers.

3. **Write an Ansible playbook snippet that securely manages secrets and avoids exposing sensitive data in logs or output.**

    ```yaml
    - name: Manage secrets securely
      hosts: all
      vars:
          db_password: "{{ vault_db_password }}"
      tasks:
          - name: Configure database password
            ansible.builtin.template:
                src: db_config.j2
                dest: /etc/myapp/db_config
            no_log: true
    ```

4. **How would you use Ansible inventories to manage different environments (e.g., staging vs production)? Provide an example.**

    I'd create a unified inventory file with clearly grouped environments and their respective resources.
    This will allow me to select the exact host, group of hosts or entire environment to target.
    When necessary, such as during upgrades or simple liveness checks I can target all hosts by selecting `all`.

    ```yaml
    all:
        children:
        staging:
            children:
                staging_controlplane:
                hosts:
                    staging-master-1:
                    ansible_host: 10.0.2.10
                staging_workers:
                hosts:
                    staging-worker-1:
                    ansible_host: 10.0.2.11
            vars:
                environment: staging
                k8s_namespace: staging

        prod:
            children:
                prod_controlplane:
                hosts:
                    prod-master-1:
                    ansible_host: 10.0.4.10
                    prod-master-2:
                    ansible_host: 10.0.4.11
                    prod-master-3:
                    ansible_host: 10.0.4.12
                prod_workers:
                hosts:
                    prod-worker-1:
                    ansible_host: 10.0.4.13
                    prod-worker-2:
                    ansible_host: 10.0.4.14
                    prod-worker-3:
                    ansible_host: 10.0.4.15
            vars:
                environment: prod
                k8s_namespace: production

    vars:
        ansible_user: ansible
        ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ```

## CI/CD (Jenkins)

5. **Describe the typical stages you would include in a Jenkins pipeline for a containerized application. Why is each stage important?**

    - **Checkout**: Pull code from version control system
    - **Build**: Build the Docker image
    - **Test**: Run unit and integration tests
    - **Scan**: Static code analysis and vulnerability scanning
    - **Push**: Push image to registry
    - **Deploy**: Deploy to dev, staging, or production

    Each stage isolates concerns and ensures errors are caught early and are traceable.

6. **Given a sample `Jenkinsfile`, identify and explain how environment variables and credentials should be managed securely.**

    We use Jenkins credentials plugin to inject secrets. Then we can reference them where we need them:

    ```groovy
    environment {
      DOCKER_PASSWORD = credentials('docker-hub-pass')
    }
    ```

    This prevents hardcoding and masks sensitive data in logs.

7. **What are the benefits of using declarative pipelines in Jenkins? Provide a simple example.**

    Declarative pipelines are easier to read, validate, and maintain.

    ```groovy
    pipeline {
      agent any
      stages {
        stage('Build') {
          steps {
            sh 'docker build -t my-app .'
          }
        }
      }
    }
    ```

## Infrastructure as Code (Terraform & Localstack)

8. **Explain the purpose of `terraform init`, `plan`, and `apply`. What is the significance of the state file?**

    - `init`: Prepares working directory, downloads providers, installs modules and prepares the backend for storing the state file
    - `plan`: Compares the desired state to the current state to generate the proposed changes without applying it.
    - `apply`: Applies the proposed changes and updates the state file to reflect the current state of the infrastructure.

    The state file is json-formatted snapshot of the terraform-managed infrastructure. It helps track current infrastructure, allowing Terraform to determine proposed changes and to detect drift.

9. **How does Localstack help in local development and testing of cloud infrastructure? Provide a scenario where it would be especially useful.**

    Localstack mocks AWS services locally. It is especially useful when developing Lambda functions or API Gateway integrations because we can test locally without incurring AWS costs or needing internet access.

10. **Write a Terraform configuration snippet to provision an S3 bucket and restrict its access to a specific IAM user.**

    ```hcl
    resource "aws_s3_bucket" "tech4dev-bucket" {
      bucket = "my-secure-bucket"
    }

    resource "aws_s3_bucket_policy" "bucket_policy" {
      bucket = aws_s3_bucket.tech4dev-bucket.id
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::123456789012:user/MyIAMUser"
          }
          Action = ["s3:GetObject", "s3:PutObject"]
          Resource = ["${aws_s3_bucket.tech4dev-bucket.arn}/*"]
        }]
      })
    }
    ```

11. **Describe how you would manage Terraform modules for a large project. What are the best practices for module versioning and reuse?**

    I would use a module registry like Terraform Cloud registry tied to version control like github, pin versions with `source` and `version`, and design modules to be small, composable, and opinionated. I will document inputs/outputs clearly.

## Kubernetes & Orchestration

12. **Explain the difference between Kubernetes Deployments, StatefulSets, and DaemonSets. When would you use each?**
    Per the kubernetes documentation:

    -   **Deployment**: Manages stateless pods to run applications like web servers
    -   **StatefulSet**: Manages stateful pods with stable identities and/or persistent storage like databases
    -   **DaemonSet**: Defines pods that are intended to run on all nodes to provide some utility function like exporting logs

13. **Describe the process of deploying an application using Helm. What are the advantages of using Helm charts?**

    -   Package the app into a Helm chart
    -   Customize values in `values.yaml` file
    -   Install with `helm install`

    Helm charts simplify Kubernetes deployments by packaging resources into reusable, versioned templates. They enable dependency management and ensure consistent and parameterized deployments.

14. **How would you securely inject secrets into a Kubernetes deployment? Provide an example using Kubernetes Secrets.**

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
        name: db-secret
    type: Opaque
    data:
        password: cGFzc3dvcmQ= # base64 encoded
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        name: myapp
    spec:
        template:
            spec:
                containers:
                    - name: app
                      image: myapp:latest
                      env:
                          - name: DB_PASSWORD
                            valueFrom:
                                secretKeyRef:
                                    name: db-secret
                                    key: password
    ```

15. **Given a scenario where you need to scale an application based on CPU usage, explain how you would configure Horizontal Pod Autoscaling in Kubernetes.**

    -   Create deployment for the application
    -   Enable metrics server in the cluster to track the relevant metrics, in this case the CPU utilisation
    -   Deploy a Horirizontal Pod Autoscaler (HPA) resource targeting the deployment with minReplicas and maxReplicas defined

    ```yaml
    apiVersion: autoscaling/v2
    kind: HorizontalPodAutoscaler
    metadata:
        name: myapp-hpa
    spec:
        scaleTargetRef:
            apiVersion: apps/v1
            kind: Deployment
            name: myapp
        minReplicas: 2
        maxReplicas: 10
        metrics:
            - type: Resource
              resource:
                  name: cpu
                  target:
                      type: Utilization
                      averageUtilization: 70
    ```

## Security & Best Practices

16. **What are the risks of hardcoding secrets in configuration files or code? How can you mitigate these risks in a DevOps workflow?**

    Hardcoding secrets carry several risks including unauthorized access, compliance violations, accidental leaks.
    We can use secret managers like harshicorp vault, aws secrets manager or github secrets to inject secrets at runtime. We must also ensure secrets are never committed to version control.

17. **Explain the process of creating and using a self-signed Certificate Authority (CA) for internal services. What are the pros and cons?**

    -   First, we generate a CA private key and public certificate.
    -   Each internal service generates a certificate signing request (CSR)
    -   The CA generated earlier is used to sign the CSR to issue service-specific certificates
    -   We can configure trust by copying the root CA to all servers in the environment
    -   Now each service can use it's certificate to secure it's communications with other services

    Pros: Self-signed certs gives one full control and comes at no cost.
    Cons: External services would not trust the certificates and hence cannot be used with sensitive applications over the open internet. Additionally, distribute is manual and tedious and there's a risk of leaking the private keys

18. **How would you audit and monitor infrastructure changes in a DevOps pipeline?**

    -   Aggressively enforce gitops to track all infrastructure changes in Git using pull requests and protected branches.
    -   Use version controlled infrastructure as code with pull requests and approvals to ensure all changes have been reviewed
    -   Enable validations in CI pipelines before commiting changes and log the outcomes
    -   Implement pipeline audit trails and change logging. Ensure Who, What, When, Where are always answerable from logs.
    -   Use observability tools e.g., Prometheus, Datadog to track real-time resource changes and drift and set up alerts on changes
    -   Adopt immutable deployments. Thus delete and recreate resources instead of modifying them

## Scenario-Based

19. **You are tasked with setting up a CI/CD pipeline for a microservices architecture using Kubernetes, Terraform, and Jenkins. Outline the steps you would take and the tools you would use at each stage.**

    -   **Set up version control**: Use `GitHub` or similar version control system to store the code with each microservice preferably in a separater repository with branch protection and pull requests workflows defined.
    -   **Infrastructure Provisioning**: Determine the infrastructure components and their specifications including kubernetes resources necessary to run the microservices. For example postgress database with minum of 4GB memory and atleast 500GB storage. Provision the infrastructure using `Terraform` and configure them using `Ansible` where necessary.
    -   **Install and Setup Jenkins**: Install or configure `Jenkings` and connect it to the version control system's webhooks for realtime updates
    -   **Create CI/CD Pipelines**: Create the full CI/CD pipelines using `Jenkins` setting appropriate events that trigger the pipelines.

20. **A deployment fails due to a misconfiguration in a Helm values file. Describe your troubleshooting process and how you would prevent similar issues in the future.**

-   **Check CI/CD logs**: Review Jenkins or pipeline logs to identify Helm errors or Kubernetes deployment issues.

-   **Run Helm dry run**: Use `helm template` to render the chart locally and spot syntax or templating errors.

    ```bash
    helm template myapp ./chart -f values.yaml
    ```

-   **Lint the Helm chart**: Use `helm lint` to validate chart structure and detect obvious misconfigurations.

    ```bash
    helm lint ./chart -f values.yaml
    ```

-   **Inspect Kubernetes events and pod logs**: Use `kubectl` to find runtime errors, crash loops, or image pull issues.

    ```bash
    kubectl get events
    kubectl describe pod <pod-name>
    kubectl logs <pod-name>
    ```

-   **Compare with previous working config**: Use `git diff` or version control history to find recent changes in `values.yaml`.

-   **Rollback to last working release**: If deployed via Helm, roll back the last known-good release.

    ```bash
    helm rollback myapp <revision-number>
    ```

-   **Fix and redeploy**: Correct the values file and re-run the Helm upgrade.
    ```bash
    helm upgrade myapp ./chart -f corrected-values.yaml
    ```

## **Preventing Future Misconfigurations**

-   **Define a Helm values schema**: Add a `values.schema.json` to enforce required fields and types in `values.yaml`.

-   **Add Helm linting to CI**: Include `helm lint` and YAML validation steps in the CI/CD pipeline.

-   **Use Helm template validation in CI**: Render manifests and run a dry-run apply to catch issues before deploying.

    ```bash
    helm template myapp ./chart -f values.yaml | kubectl apply --dry-run=client -f -
    ```

-   **Maintain environment-specific values files**: Keep separate `values-dev.yaml`, `values-prod.yaml`, etc., under version control.

-   **Restrict manual overrides**: Limit Helm CLI overrides by using predefined and tested values files.

-   **Adopt GitOps for safe deployment**: Use Argo CD or Flux to manage config in Git and perform health checks before rollout.

-   **Monitor post-deploy health**: Automatically validate service health and trigger rollback if issues are detected.

# Reflections

## Overview
This project provided hands-on experience across the full deployment lifecycle of a microservices-based application, including Kubernetes provisioning, container orchestration, CI/CD, and GitOps methodologies. Throughout the process, I encountered several technical challenges that helped me deepen my understanding of real-world DevOps workflows.

---

## Key Challenges and How I Resolved Them

### 1. NodePort Instability Breaking the UI Service
One of the most difficult issues I faced involved my UI service constantly breaking during Helm and ArgoCD sync operations. After debugging the Kubernetes service configuration, I discovered that Kubernetes was dynamically reassigning NodePorts on each redeployment. Because my ALB was configured to forward traffic to the previously assigned port, the UI became inaccessible every time a sync occurred.

I realized the root cause was that the Helm chart did not explicitly define a fixed `nodePort`. To resolve this, I updated the service template to include a static NodePort value and reconfigured the ALB to use that stable port. Once both were aligned, the UI became stable and fully functional.

---

### 2. ImagePullBackOff Errors Across Multiple Services
Another major challenge occurred when all microservices entered `ImagePullBackOff`. After inspecting Kubernetes events, I learned that the ECR repository names did not match those configured in my Helm charts. Additionally, the imagePullSecret (`ecr-creds`) was outdated and did not contain valid ECR credentials.

By updating the repository paths in all `values.yaml` files and recreating the registry secret with correct IAM permissions, the cluster was finally able to authenticate and pull all service images successfully.

---

### 3. Helm Chart Dependency and Directory Issues
Initially, several Helm charts included dependency entries referencing charts that did not exist in the project. This caused Helm to repeatedly fail when checking chart dependencies. Removing these unnecessary `dependencies:` blocks and restructuring the charts ensured that each microservice deployed independently, as intended.

---

## GitOps Experience With ArgoCD
Implementing GitOps through ArgoCD was one of the most valuable aspects of the project. ArgoCD continuously monitored my Git repository, automatically applied changes to the cluster, and ensured that the deployed state always matched the desired state stored in Git. I especially appreciated:

- Automated syncing after each commit  
- Clear visualization of application health and deployment structure  
- Self-healing when the cluster drifted from the repository  
- Easy rollbacks simply by reverting commits  

This workflow significantly reduced manual errors and improved deployment reliability.

---

## Benefits vs. Challenges: ArgoCD vs. Manual Helm

### Benefits of ArgoCD
- Fully declarative, Git-centered deployment model  
- Continuous monitoring and automatic syncing  
- Self-healing to maintain desired state  
- Enhanced visibility through ArgoCD UI  
- Simple rollbacks through Git history  

### Challenges of ArgoCD
- Requires strict repository structure and clean charts  
- Manual cluster edits get overwritten, enforcing discipline  
- Secret management becomes more complex  
- Debugging sometimes spans both Git and the running cluster  

### When Helm Is Still Useful
- Rapid local testing  
- Debugging deployments interactively  
- Iterating on chart development before committing to Git  

---

## Conclusion
Although the project presented challenging issues—from NodePort instability to image pulling failures and Helm chart restructuring working through them greatly strengthened my understanding of Kubernetes, Helm, GitOps, and cloud-native practices. I enjoyed designing and automating the application pipeline, and the final working deployment was both rewarding and educational.


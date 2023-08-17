# DevSquad Workload Identity Project

This is a collection of sample projects for Cloud Application Developer using Azure Cloud Platform. The sample projects are arranged in different topics about microservice development and deployment on Azure Kubernetes Service supported by Secure DevOps Practices.

Kubernetes workload identity and access, reference architecture:
[Deploy AKS cluster managed identities](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
![](https://learn.microsoft.com/en-us/azure/architecture/aws-professional/eks-to-aks/media/azure-ad-workload-identity.png)

Steps to deploy:

- Deploy AKS Cluster: You can use GitHub Workflow [Deploy AKS](https://github.com/oaviles/hello_workload-identity/actions/workflows/deploy-aks.yml)
- Get OIDC URI: You can us GitHub Workflow [Get OIDC URI](https://github.com/oaviles/hello_workload-identity/actions/workflows/getOIDC.yml)
```sh
az identity show --resource-group "${RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' -otsv
```
- Deploy Identity: You can us GitHub Workflow [Deploy Identity](https://github.com/oaviles/hello_workload-identity/actions/workflows/deploy-identity-tf.yml)
- Get Access to AKS `az aks get-credentials -n spAKSCluster -g "${RESOURCE_GROUP}"`
- Create Service Account
```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${USER_ASSIGNED_CLIENT_ID}"
  name: "${SERVICE_ACCOUNT_NAME}"
  namespace: "${SERVICE_ACCOUNT_NAMESPACE}"
EOF

```
- Validate Service Account creation `kubectl get sa`
- Create Azure Storage Account and assign identity with "Contributor Role"
```sh
az storage account create -n "${STORAGE_ACCOUNT_NAME}" -g "${RESOURCE_GROUP}" -l westus --sku Standard_LRS
```
- Deploy Pod with Managed Identity support
```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pod-workload-identity
  namespace: "${SERVICE_ACCOUNT_NAMESPACE}"
  labels:
    azure.workload.identity/use: "true"
spec:
  serviceAccountName: "${SERVICE_ACCOUNT_NAME}"
  containers:
  - name: oaidentity
    image: oaviles/oaidentity:latest
    imagePullPolicy: Always
    env:
    - name: STORAGE_ACCOUNT_NAME
      value: "${STORAGE_ACCOUNT_NAME}"
    - name: STORAGE_ACCOUNT_CONTAINER_NAME
      value: "oafiles"
EOF
```
- Validate pod execution `kubectl logs pod-workload-identity`

#### More Resources
- [Use Azure AD workload identity with Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview)
- [Source Reference](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens
)

### Check More DevSquad Projects
* [DevSquad Main Project](https://github.com/microsoft/devsquad-accelerators)

> Note: This page is getting updated so make sure to check regularly for new resources.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

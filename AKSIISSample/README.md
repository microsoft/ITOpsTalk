# Azure Kubernetes Service IIS Sample

This is a sample YAML specification to deploy an IIS container on AKS. You can use it to try AKS and Windows containers.
With this sample you can:

- Try Windows containers on AKS. Simply deploy the YAML spec to a Windows enabled AKS cluster. It will deploy an IIS pod and expose the webpage via an external service. Run kubectl get service on your AKS cluster to check the IP address of the web page.
- Modify the YAML spec to:
  - Change the # of replicas
  - Change from Windows Server 2022 to Windows Server 2019

#!/usr/bin/env pwsh

#This script will create a new AKS cluster and deploy the Web Application Routing add-on.
#It will also create all the other components for the add-on to run, such as Azure Key Vault and more.
#Finally, it will deploy a sample application (IIS) on Windows Containers with HTTPS traffic enabled.
#Before finishing, the script will give you the output of the ingress so you can get its IP and hostname.

#Log into the Azure subscription
$Az_Sub = Read-Host -Prompt 'Please provide the Azure subscription ID to be used'
#az login --use-device-code
az account set --subscription $Az_Sub

# Install the aks-preview extension
az extension add --name aks-preview | Out-Null
# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview | Out-Null

# Create a self-signed SSL certificate
$Hostname = Read-Host -Prompt 'Please provide the Hostname to be used for the certificate'
openssl req -new -x509 -nodes -out aks-ingress-tls.crt -keyout aks-ingress-tls.key -subj "/CN=$Hostname" -addext "subjectAltName=DNS:$Hostname" | Out-Null
# Export the SSL certificate, skipping the password prompt
openssl pkcs12 -export -in aks-ingress-tls.crt -inkey aks-ingress-tls.key -out aks-ingress-tls.pfx | Out-Null

#Create new Resource Group
$RGName = Read-Host -Prompt 'Please provide the Resource Group name'
$RGLocation = Read-Host -Prompt 'Please provide the location of the RG and its resources'
Write-Host 'Creating RG'
az group create -n $RGName -l $RGLocation | Out-Null

#Create the Azure Key Vault
$AKVName = Read-Host -Prompt 'Please provide the name of the Azure Key Vault'
Write-Host 'Creating AKV'
az keyvault create -g $RGName -l $RGLocation -n $AKVName | Out-Null

#Import certificate to Azure Key Vault
$AKVCertName = Read-Host -Prompt 'Please provide a name for the certificate to be stored on Azure Key Vault'
Write-Host 'Creating certificate on AKV'
az keyvault certificate import --vault-name $AKVName -n $AKVCertName -f aks-ingress-tls.pfx | Out-Null

#Create the AKS cluster
Write-Host 'Next, we will create an AKS cluster'
$AKSClusterName = Read-Host -Prompt 'Please provide the name for the Azure Kubernetes Service cluster'
$WinUsername = Read-Host -Prompt 'Please create a username for the administrator credentials on your Windows Server nodes'
$WinPassword = Read-Host -Prompt 'Please create a password for the administrator credentials on your Windows Server nodes' -AsSecureString
Write-Host "Creating AKS cluster"
az aks create -g $RGName -n $AKSClusterName -l $RGLocation --node-count 2 --enable-addons azure-keyvault-secrets-provider,web_application_routing,monitoring --generate-ssh-keys --enable-secret-rotation --network-plugin azure --vm-set-type VirtualMachineScaleSets --windows-admin-username $WinUsername --windows-admin-password $WinPassword | Out-Null
$AKSNodepoolName = Read-Host -Prompt 'Please provide the name for the nodepool (max 6 characters)'
Write-Host "Creating Windows Node Pool"
az aks nodepool add -g $RGName --cluster-name $AKSClusterName --os-type Windows --name $AKSNodepoolName --node-count 2 | Out-Null

#Retrieve user managed identity object ID for the add-on
Write-Host 'Gathering AKS Managed Identity to be used for AKV access'
$ManagedIdentityName = "webapprouting-$AKSClusterName"
$MCRGName = az aks show -g $RGName -n $AKSClusterName --query nodeResourceGroup -o tsv
$UserManagedIdentity_ResourceID = "/subscriptions/$Az_Sub/resourceGroups/$MCRGName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$ManagedIdentityName"
$ManagedIdentity_ObjectID = az resource show --id $UserManagedIdentity_ResourceID --query "properties.principalId" -o tsv | tr -d '[:space:]'

#Grant the add-on permissions to retrieve certificates from Azure Key Vault
Write-Host 'Granting the add-on permission to retrieve the certificate'
az keyvault set-policy --name $AKVName --object-id $ManagedIdentity_ObjectID --secret-permissions get --certificate-permissions get | Out-Null

#Connect to your AKS cluster
Write-Host "Now, let's connect to your AKS cluster. We'll retrieve the credentials from Azure"
az aks get-credentials -g $RGName -n $AKSClusterName

#Create a namespace for the application on your AKS cluster
$NamespaceName = Read-Host -Prompt 'Please provide the name for the namespace on which the app will be deployed'
kubectl create namespace $NamespaceName | Out-Null

#Deppoy the application and Ingress
Write-Host "The next steps should only be performed after you edited the YAML files from the repo."
Write-Host "You will need to update the ingress.yaml file with <HostName>, <KeyVaultCertificateUri>, and NameSpace."
Write-Host "Based on the deployment so far, this is the information you need:"
Write-Host "The hostname is: $Hostname"
$KeyVaultCertificateURI = az keyvault certificate show --vault-name $AKVName -n $AKVCertName --query "id" --output tsv
Write-Host "The Key Vault Certificate URI is: $KeyVaultCertificateURI"
Write-Host "The namespace is: $NamespaceName"
Write-Host "DO NOT CONTINUE BEFORE DOWNLOADING THE YAML FILES AND EDITING IT"
$Edit = Read-Host -Prompt "Did you download the files and edit it? Type YES to continue"
if ($Edit.Equals('YES')) {
    kubectl apply -f deployment.yaml -n $NamespaceName
    kubectl apply -f ingress.yaml -n $NamespaceName
    Write-Host 'Your deployment finalized with success. Here is the information on the Ingress:'
    $IngressInfo = kubectl get ingress -n $NamespaceName
    Write-Host "Ingress output: $IngressInfo"
else {
    Write-Host "Thank you for using this scrit. Please check the Resource Group and assets if you wish to continue."
}
}
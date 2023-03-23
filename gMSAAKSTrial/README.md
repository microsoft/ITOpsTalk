# gMSA-on-AKS-trial

**Note**: This sample is part of the blog post [Step-by-step: Creating a new test environment for gMSA on AKS](https://techcommunity.microsoft.com/t5/itops-talk-blog/step-by-step-creating-a-new-test-environment-for-gmsa-on-aks/ba-p/3107779)

Welcome to the "Deploy AKS for gMSA validation" PowerShell script. 
Use the instructions below to deploy a new Azure environment to try out the gMSA on AKS feature.

## Intro

In a nutshell, gMSA allows applications that are Active Directory (AD) dependent to be containerized. By default, containers don’t understand AD as they can’t be domain-joined. With gMSA, we give the underlying container host the task of authenticating the application inside the container. This feature is currently on Public Preview on AKS.

However, as you can imagine, to even try gMSA on AKS you need to setup a fairly complex environment. You need an Azure vNet, an AKS cluster, a VM working as Domain Controller, and both the Windows nodes on your AKS cluster and the Domain Controller must be on the same vNet. 
With that in mind, I decided to make the process of spinning up that environment easier. If nothing else, this exercise might also give you some cool insights into how to use PowerShell to manage Azure resources.

**Disclaimer**: This script should not be used for production environments. It’s intended to facilitate the process of spinning up a test environment to try the gMSA on AKS feature. This is a personal project. No support provided by Microsoft.

## How to use

Download the ps1 files to your machine. The three files are:

- DeployAKS.ps1:
  - This file should be used first, to deploy the Azure resources. Run this file from any machine capable of running a PowerShell session and internet connectivity.
- ADDS.ps1:
  - This file should be used from inside the VM created with the previous script. It will promote the VM to a Domain Controller and deploy a new forest domain.
- Cleanup.ps1:
  - Optional file. Can be used to delete the Azure resources created in this exercise.

## Script updates

## July 13, 2022 update

- Removed the Az CLI references as the PS module has been fixed.
- Added the "-EnableManagedIdentity to the PS command that creates a new AKS cluster.

## March 22, 2022 update

- Changed the command to create the AKS cluster from AzAks PowerShell to Az CLI. This is because the PS module does not support creating a cluster with Manage Identity, which is required by gMSA. This will be reverted back once the PS module supports that.
- Added authentication for the AzCLI. You'll be prompted to authenticate twice when running this script. One for Az PowerShell and another for Az CLI.
- Removed the option for generating SSH Keys. You can add this back if needed. For gMSA testing purposes, you won't be required to SSH into the AKS nodes.

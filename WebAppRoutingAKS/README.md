# Web Application Routing with Windows containers

**Note**: This sample is part of the blog post [5 tips for IIS on containers: #1 SSL certificate lifecycle management](https://techcommunity.microsoft.com/t5/itops-talk-blog/5-tips-for-iis-on-containers-1-ssl-certificate-lifecycle/ba-p/3666499)

This repo is a companion for the #1 blog post on a blog series - 5 Tips for containerizing IIS apps on Windows containers. The first blog post is focused on SSL certificate lifecycle management and in this repo we show how to use Web Application Routing for Windows containers.

## What the script does?

This script helps you create an AKS cluster with the Web Application routing configured. It uses Azure Key Vault to store a sample certificate and configures an Nginx ingress-controller to direct HTTPS traffic to the IIS pod.

## How to use

To get started, run the CreateAKSWebAppRouting.ps1 script. You can run it from:

- Azure Cloud Shell.
  - In this case, you can run the script as-is.
- You can also run it from any PowerShell session. In this case, you'll need to change:
  - Uncomment the line #5 to properly log in to Azure from PowerShell.
  - Install OpenSSL on your machine to generate the SSL Certificate to be used.

During the script runtime, it will provide instructions to change the ingress.yaml file. Make sure you make the necessary changes before continuing.

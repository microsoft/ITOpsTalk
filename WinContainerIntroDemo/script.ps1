#Pull container image
docker pull mcr.microsoft.com/windows/servercore:ltsc2022
docker pull mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

#List all container images
docker images

#Run container image
docker run -d mcr.microsoft.com/windows/servercore:ltsc2022

#Check container status
docker ps

#Check status of all containers including stopped ones
docker ps -a

#Run container image with Service Monitor
docker run -d -p 8080:80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

#Build container image
docker build -t wincontainerintro:v1 .

#Build container image with app
docker build -t wincontainerintro:v2 .

#Run container
docker run -d -p 8080:80 wincontainerintro:v2

#Run container with Hyper-V isolation
docker run -d -p 8080:80 --isolation=hyperv wincontainerintro:

#Force stop container and remove it
docker rm -f <container_id>

#Log into container registry
docker login

#Tag container image
docker tag wincontainerintro:v2 <registry_name>/wincontainerintro:v2

#Push container image to registry
docker push <registry_name>/wincontainerintro:v2

#Check processes running inside container from container host
docker ps -a
docker inspect -f '{{.State.Pid}}' <container id>
get-process -id <container process id>
#Note service identifier from output
Get-Process | Where-Object {$_.si -eq 4} #Where 4 is service identifier

#Check nodes on a Kubernetes cluster with additional information
kubectl get nodes -o wide

#Check pods on a Kubernetes cluster with additional information
kubectl get pods -o wide

#Check services on a Kubernetes cluster with additional information
kubectl get services -o wide

#Check deployments on a Kubernetes cluster with additional information
kubectl get deployments -o wide

#Apply a deployment to a Kubernetes cluster
kubectl apply -f .\vinibeer.yaml

#Check deployment status
kubectl get deployments
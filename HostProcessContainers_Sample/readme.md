# Host Process containers sample

Host Process containers is a Windows mode with similar approach to Linux privileged containers. It allows to run processes on the container host with elevated privileges. This can be used for many scenarios, such as troubleshooting, agent installation, and more. For more information on Host Process containers, please check the [documentation page](https://learn.microsoft.com/azure/aks/use-windows-hpc).

## How to use this sample

On a kubectl targeting a Kubernetes cluster with Windows nodes, run the following command:

```powershell
kubectl apply -f hpc_sample.yaml
```

Check for the pod you just created:

```powershell
kubectl get pods --namespace kube-system
```

You should see multiple pods in the output. Your pod will have a named similar to "hpc_sample-12345". Once you get the pod name, check out the pod log:

```powershell
kubectl logs hpc-sample-12345 --namespace kube-system
```

You should see an output indicating the script inside the pod confirms the pod is running with Admin Rights:

```powershell
Process has admin rights: True
```

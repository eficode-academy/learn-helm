# Prerequisites: 

You need to have a cluster ready and kubectl configured to connect to it.

# Exercise 1 - Install and Initialize Helm

## Installing Helm

This exercise will guide you through installing Helm and exploring its components.


1. Verify that Helm has been successfully installed by running the helm version command:
```
$ helm version
```

----
## Initializing Helm v2

Before we can use Helm, we need to initialize it. By default, this sets up the `HELM_HOME` on the local machine and installs the server side component `Tiller` in the cluster where kubectl is currently pointing. This can be customized with the additional flags. 

1. Initialize Helm on the client machine only for now [ without installing Tiller].

```
helm init --client-only
```
2. You can find the location and content for your `HELM_Home` by running 

```
ls $(helm home)
```

----
## Helm Repos

Helm repositories are where you can store/retrieve charts. There are two official repos [__stable__ & __incubator__].

1. List all the currently configured repos:
 
```
helm repo list
``` 

> Official Charts are published into two public repositories (stable & incubator). But other charts can be found from other public repositories.


2. Let's search the available repos for a `tomcat`chart or your favourite apps

```
helm search tomcat 
```
----
## Deploying Tiller

Now that you have the client installed, it's time to install the `Tiller` (Helm's server side) in your cluster.

> Helm relies on `kubectl` to see your cluster. 

1. Deploy Tiller (in your specific namespace)

**Considerations**:

- If RBAC is enabled in your cluster, Tiller needs an appropriate service account.
- Where should Tiller store it's state? By default, it uses `configMaps` as a **storage backend** but a `secrets` option is available.


1.1 Initialize Helm on the server (cluster) side using the service account we created above: 

> the service account user-x-sa already exists in the training cluster.

```
helm init  --service-account user-x-sa --tiller-namespace <your-namespace>

``` 


1.2 Verify Tiller is deployed 

```
# listing all pods in your namespace
kubectl get pods -n <your-namespace>
NAME                                     READY     STATUS    RESTARTS   AGE
tiller-deploy-7ccte4n7dc-2zdzd           1/1       Running   0          2m

# inspect the Tiller K8S deployment 


# inspect the Tiller pod
kubectl describe pod -n <your-namespace> <tiller-deploy-full-pod-name>

# inspect Tiller logs 
kubectl logs -n <your-namespace> <tiller-deploy-full-pod-name>
```
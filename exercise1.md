# Prerequisites: 

You need to have a cluster ready and kubectl configured to connect to it.

# Exercise 1 - Install and Initialize Helm

## Installing Helm

This exercise will guide you through installing Helm and exploring its components.

1. Follow the instructions on the [installation page](https://docs.helm.sh/using_helm/#from-the-binary-releases) to install `v2.8.1` of Helm client for your OS.

> The latest Helm releases has a [bug](https://github.com/kubernetes/helm/issues/3722) that prevents a task in exercise 5 from working.

2. Verify that Helm has been successfully installed by running the helm version command:
```
$ helm version
```

3. Let's explore some of the client commands. Run `helm help`

----
## Initializing Helm

Before we can use Helm, we need to initialize it. By default, this sets up the `HELM_HOME` on the local machine and installs the server side component `Tiller` in the cluster where kubectl is currently pointing. This can be customized with the additional flags. 

1. Run `helm init --help` to inspect the available options.
2. Choose the right option to initialize Helm on the client machine only for now [ without installing Tiller].
3. You can find the location and content for your `HELM_Home` by running 

```
tree $(helm home)
```

----
## Helm Repos

Helm repositories are where you can store/retrieve charts. There are two official repos [__stable__ & __incubator__].

1. List all the currently configured repos:
 
```
helm repo list
``` 

> Official Charts are published into two public repositories (stable & incubator). But other charts can be found from other public repositories.


2. Let's search the available repos for a `wordpress`chart or your favourite apps

```
helm search wordpress 
```
----
## Deploying Tiller

Now that you have the client installed, it's time to install the `Tiller` (Helm's server side) in your cluster.

> Tip: Helm relies on `kubectl` to see your cluster. If not configured yet, ensure that `kubectl` is configured and you're using the right context (if you have more than one). You can verify that by running:
  ```
  # listing all configured contexts
  kubectl config get-contexts
  # switching to another context (if needed)
  kubectl config use-context <context-name>
  # verifying that your connection to this cluster is correctly configured
  kubectl get nodes
  ```

1. Deploy Tiller (by default in the `kube-system` namespace)

**Considerations**:

- If RBAC is enabled in your cluster, Tiller needs an appropriate service account.
- Where should Tiller store it's state? By default, it uses `configMaps` as a **storage backend** but a `secrets` option is available.

1.1 Create a service account for Tiller.

```
kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller 

```

1.2 Initialize Helm on the server (cluster) side using the service account we created above: 

```
helm init --service-account tiller 

``` 

> Production Tip: If you want to configure the storage backend to be secrets, you can use the `--override` flag 

```
helm init --service-account tiller --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}'
```


1.3 Verify Tiller is deployed 

```
# listing all pods in the kube-system namespace
kubectl get pods -n kube-system 
NAME                                     READY     STATUS    RESTARTS   AGE
tiller-deploy-7ccte4n7dc-2zdzd           1/1       Running   0          2m

# inspect the Tiller K8S deployment 


# inspect the Tiller pod
kubectl describe pod -n kube-system <tiller-deploy-full-pod-name>

# inspect Tiller logs 
kubectl logs -n kube-system <tiller-deploy-full-pod-name>
```
----
## Upgrading Tiller

If we want to upgrade Tiller's version to match the local Helm client:

```
helm init --upgrade 
```

----
## Uninstalling Tiller

``` 
helm reset --force
``` 
> This does not delete any helm releases. Only deletes Tiller.
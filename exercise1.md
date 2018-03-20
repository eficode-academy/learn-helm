---
Duration : 5 min
---

# Exercise 1: Installing Helm

This exercise will guide you through installing Helm and exploring its components.

1. Follow the instructions on the [installation page](https://docs.helm.sh/using_helm/#from-the-binary-releases) to install `v2.8.1` of Helm client for your OS.

> The latest Helm release (v2.8.2) has a bug that prevents a task in exercise 5 from working.

2. Verify that Helm has been successfully installed by running the helm version command:
```
$ helm version
```
3. Now that you have the client installed, it's time to install the `Tiller` (Helm's server side) in your cluster.

> Tip: Helm relies on `kubectl` to see your cluster. If not configured yet, ensure that `kubectl` is configured and you're using the right context (if you have more than one). You can verify that by running:
  ```
  # listing all configured contexts
  kubectl config get-contexts
  # switching to another context (if needed)
  kubectl config use-context <context-name>
  # verifying that your connection to this cluster is correctly configured
  kubectl get nodes
  ```

  - Once your kubectl is correctly configured, run the following commands:
  ```
  kubectl create serviceaccount -n kube-system tiller
  kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
  helm init --service-account tiller
  ```
  The first two commands create a service account named `tiller` in the `kube-system`namespace with the permissions of a cluster admin.
  The `helm init` command initializes the Helm client on your machine by setting the HELM_HOME directory and installs the Tiller in your cluster. The `--service-account tiller` flag tells helm to use the `tiller` service account which allows helm access to the kube-system namespace.

4. `HELM_HOME`is directory used by the Helm client to  store information about plugins and repositories, etc. You can find its location by running:
```
helm home
```
5. Happy Helming!! You are all set now, but let's inspect what has actually happened in the cluster:
```
# listing all pods in the kube-system namespace
kubectl get pods -n kube-system
```
You should see Tiller pod deployed as `tiller-deploy-xxxxxxxxxx-xxxxx`.
You can inspect the tiller logs:
```
kubectl logs -n kube-system <tiller-deploy-full-pod-name>
```

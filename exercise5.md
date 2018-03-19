---
Duration : 10 min
---

# Exercise 5: Deploying charts from code with helmsman

Now it's time to deploy charts to our cluster from code. [Helmsman](https://github.com/Praqma/helmsman) is a `Helm-Charts-as-Code` tool which takes a desired state of charts deployment in your cluster and achieves that state.

We will use an [example desired state file (DSF)](helmsman/dsf.toml) which describes our desire to have kubernetes dashborad installed in the `default` namespace and our own helm-echoserver chart installed in the `playground` namespace.

> For simplicity, the example DSF uses your already configured kubectl context.

So let's get down to it:

1. Download the Helmsman binary for your OS from [Github](https://github.com/Praqma/helmsman/releases).

```
curl -L https://github.com/Praqma/helmsman/releases/download/v1.0.2/helmsman_1.0.2_linux_amd64.tar.gz | tar zx
mv helmsman /bin/helmsman
chmod +x /bin/helmsman
```

2. Verify Helmsman is ready to use:

```
helmsman -v
```

3. Let's run Helmsman with our example DSF:

> Make sure to replace the kubeContext name in helmsman/dsf.toml with your context name
```
helmsman -debug -f helmsman/dsf.toml
```
This should generate a plan for you but not execute it. If all is good, you can apply the plan:

```
helmsman -debug -apply -f helmsman/dsf.toml
```

4. Now you should have both kubernetes-dashboard and helm-echoserver deployed in your cluster. Verify with the following commands:

```
# listing helm releases
helm list

# view the pods and services created in the default namespace
kubectl get pods,svc

# view the pods and services created in the playground namespace
kubectl get pods,svc --namespace playground

```

5. That's not all. We can continue to manipulate our releases from our `dsf.toml`.

- Edit the kubernetes-dashboard section under apps in dsf.toml to change the `enabled` flag to `false` so that it looks like:

```
...
[apps.kubernetes-dashboard]
name = "kubernetes-dashboard"
description = "stable/kubernetes-dashboard"
namespace = "default"
enabled = false
chart = "stable/kubernetes-dashboard"
version = "0.4.4"
valuesFile = "k8s-dashboard-values.yaml"
purge = false
...
```
- Now run helmsman again:

```
helmsman -debug -apply -f helmsman/dsf.toml

# check deployed helm releases
helm list

# check deleted helm releases
helm list --deleted
```

6. Now it's your turn to take the helm. Try making the following changes and running helmsman after each change and see what happens:

- Change the kubernetes-dashboard `enabled` flag back to `true`
- Change the namespace for one of the applications, and why not add a new namespace in the namespaces section.
- Why not add another app to the apps section. Choose any public chart from [kubeapps](https://hub.kubeapps.com/)
- Change the values files for any of the charts you have (e.g, change the kubernetes-dashboard image tag).

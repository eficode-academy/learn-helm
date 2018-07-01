# Exercise 2: Working with Helm charts

Now that you have Helm installed, it's time to install our first release and do some basic operations on it.

> A release is an installed instance of a Helm chart.

>The [Kube Apps hub](https://hub.kubeapps.com/) provides a list of official charts. While the source code of these charts is hosted on the [Kubernetes project](https://github.com/kubernetes/charts).


## Installing a Chart

1. We will install `kube-ops-view` from the `stable` official repository. You can install your favourite chart though.
To install a release, we will use the `install` command:
```
# install a release named 'ops-view' of the kube-ops-view chart from the stable repository.
helm install --name=ops-view stable/kube-ops-view --set rbac.create=true
```
2. Congratulations! You have installed your first release!  Follow the instructions you got on the terminal after executing the install command to expose and access the app in your browser. 

---

## Inspecting a Chart

Let's inspect what happened in the cluster:
```
# to list all releases deployed in the cluster
helm list

# to get the status of the release
helm status ops-view

# to get the k8s manifest(s) for a release
helm get ops-view

# to view pods, services and ingresses in the default namespace
kubectl get pods,svc
```

----

## Upgrading a Release

We installed the jenkins release with default values (except for RBAC), now let's upgrade our release with some custom config values:
```
helm upgrade --set service.type=LoadBalancer --set rbac.create=true ops-view stable/kube-ops-view 
```
The command above will change the service type to `LoadBalancer`.
Watch for the new LB IP:

```
kubectl get svc -w 
... output omitted 
ops-view-kube-ops-view   10.63.240.137   <pending>     80:30272/TCP    23m
```

 You can check all the values you could configure for the `kube-ops-view` chart [here](https://github.com/kubernetes/charts/blob/master/stable/kube-ops-view/values.yaml).

> Tip: you can also create a custom values.yaml file with your customized values and use it to override the defaults:  helm install --name ops-view -f my_custom_values.yaml stable/kube-ops-view

---

## Rolling back a Release

Let's rollback our ops-view release to the first version:

```
# get the history of a release
helm history ops-view

# rollback revision (version) number 1 of 'ops-view'
helm rollback ops-view 1

# now check the status again
helm status ops-view
```

----

## Delete a Release

Let's delete our jenkins release:
```
helm delete ops-view
```
Although the delete command removes all k8s resources created but it does not delete the release history maintained by Helm.

```
# list deleted releases
helm list --deleted

# purge delete 'ops-view' i.e. delete its k8s resource and/or history
helm delete --purge ops-view
```

----

## Inspecting a chart
Sometimes it's good to inspect what's going to be deployed in the cluster before deploying it.

```
helm inspect stable/kube-ops-view
```

For dry-run executions, we can use the `--dry-run` and `--debug` flags.

```
helm install stable/kube-ops-view --dry-run --debug 

```
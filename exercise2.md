# Exercise 2: Working with Helm charts

Now that you have Helm installed, it's time to install our first release and do some basic operations on it.

> A release is an installed instance of a Helm chart.

>The [Kube Apps hub](https://hub.kubeapps.com/charts) provides a list of official charts. While the source code of these charts is hosted on the [Kubernetes project](https://github.com/helm/charts).


## Installing a Chart

1. We will install `tomcat` from the `stable` official repository. You can install your favourite chart though.
To install a release, we will use the `install` command:
```
# install a release named 'tomcat' of the tomcat chart from the stable repository.
helm install --name=tomcat stable/tomcat --tiller-namespace <your-namespace> 
```
2. Congratulations! You have installed your first release!  Follow the instructions you got on the terminal after executing the install command to expose and access the app in your browser. 

---

## Inspecting a Chart

Let's inspect what happened in the cluster:
```
# to list all releases deployed in the your namespace 
helm list --tiller-namespace <your-namespace>

# to get the status of the release
helm status tomcat --tiller-namespace <your-namespace>

# to get the k8s manifest(s) for a release
helm get tomcat --tiller-namespace <your-namespace>

# to view pods, services and ingresses in the default namespace
kubectl get pods,svc -n <your-namespace>
```

----

## Upgrading a Release

We installed the tomcat release with default values, now let's upgrade our release with some custom config values (e.g the image tag):
```
helm upgrade --set image.tomcat.tag=8.5 tomcat stable/tomcat --tiller-namespace <your-namespace> 
```
The command above will create a new pod.
Watch for the new pod:

```
kubectl get pods -n <your-namespace> -w 
```

 You can check all the values you could configure for the `tomcat` chart [here](https://github.com/helm/charts/tree/master/stable/tomcat).

> Tip: you can also create a custom values.yaml file with your customized values and use it to override the defaults:  helm install --name tomcat -f my_custom_values.yaml stable/tomcat --tiller-namespace <your-namespace>

---

## Rolling back a Release

Let's rollback our tomcat release to the first version:

```
# get the history of a release
helm history tomcat --tiller-namespace <your-namespace>

# rollback revision (version) number 1 of 'tomcat'
helm rollback tomcat 1 --tiller-namespace <your-namespace>

# now check the status again
helm status tomcat --tiller-namespace <your-namespace>
```

----

## Delete a Release

Let's delete our tomcat release:
```
helm delete tomcat --tiller-namespace <your-namespace>
```
Although the delete command removes all k8s resources created but it does not delete the release history maintained by Helm.

```
# list deleted releases
helm list --deleted --tiller-namespace <your-namespace>

# purge delete 'tomcat' i.e. delete its k8s resource and/or history
helm delete --purge tomcat
```

<!-- ----

## Inspecting a chart
Sometimes it's good to inspect what's going to be deployed in the cluster before deploying it.

```
helm inspect stable/kube-ops-view
```

For dry-run executions, we can use the `--dry-run` and `--debug` flags.

```
helm install stable/kube-ops-view --dry-run --debug 

``` -->
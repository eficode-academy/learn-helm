---
Duration : 15 min
---

# Exercise 2: Working with Helm charts

Now that you have Helm installed, it's time to install our first release and do some basic operations on it.

> A release is an installed instance of a Helm chart.

> Official Charts are published into two public repositories (stable & incubator). But other charts can be found from other public repositories.

>The [Kube Apps hub](https://hub.kubeapps.com/) provides a list of official charts. While the source code of these charts is hosted on the [Kubernetes project](https://github.com/kubernetes/charts).

1. We will install `Jenkins` from the `stable` official repository. Helm comes preconfigured to see the two official repos (stable & incubator) and we can verify it by running:
```
# listing all configured repos in your helm client
helm repo list
```
To install a release, we will use the `install` command:
```
# install a release named 'my-release' of the jenkins chart from the stable repository.
helm install --name my-release stable/jenkins
```
2. Congratualtions! You have installed your first release! Let's test the installed jenkins. Follow the instructions you got on the terminal after executing the install command to extract the admin password and login to your jenkins in your browser.
3. Horray! you have jenkins up and running! Let's inspect what happended in the cluster:
```
# to list all releases deployed in the cluster
helm list

# to get the k8s manifest(s) for a release
helm get my-release

# to view pods, services and ingresses in the default namespace
kubectl get pods,svc
```

4. We installed the jenkins release with default values, now let's upgrade our release with some custom config values:
```
helm upgrade --set fullnameOverride=dcn-jenkins my-release stable/jenkins
```
The command above will change the names of the k8s resources created by this chart to `dcn-jenkins`. Check the names of the jenkins pods and services to verify that the new name is now being used. You can check all the values you could configure for the jenkins chart [here](https://github.com/kubernetes/charts/tree/master/stable/jenkins#jenkins-master).

> Tip: you can also create a custom values.yaml file with your customized values and use it to override the defaults:  helm install --name my-release -f my_custom_values.yaml stable/jenkins

5. Let's rollback our jenkins release to the first version:

```
# get the histroy of a release
helm history my-release

# rollback revision (version) number 1 of 'my-release'
helm rollback my-release 1
```

6. Let's delete our jenkins release:
```
helm delete my-release
```
Although the delete command removes all k8s resources created but it does not delete the release history maintained by Helm.

```
# list deleted releases
helm list --deleted

# purge delete 'my-release' i.e. delete its k8s resource and/or history
helm delete --purge my-release
```

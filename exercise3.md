---
Duration : 10 min
---

# Exercise 3: Building your own chart

Now that we know how to install/upgrade/delete and rollback a release from a 3rd party chart, it is time to build our own.

## The helm-echoserver chart

We will build a simple helm chart for a [helm-echoserver](https://github.com/Praqma/helm-echoserver). The chart will deploy a helm-echoserver container and perform a small post-installation task. This task is to wait for a configurable amount of time and then make a POST request to the helm-echoserver with a message to be stored in the file system.

1. Clone the exercises repository :
> If you don't have git installed, you can download the repository from github web interface.
```
git clone https://github.com/praqma-training/helm-workshop-dcn-2018
```
The `helm-echoserver` directory contains our custom chart. The files inside look like:

```
.
├── Chart.yaml                ## chart metadata
├── templates
│   ├── NOTES.txt             ## these notes will be displayed upon successful installation of the chart
│   ├── _helpers.tpl          ## named templates (Go templates definitions)
│   ├── deployment.yaml       ## the k8s deployment object
│   ├── post_install_pod.yaml ## the k8s pod object which will be deployed as a post-install hook
│   └── service.yaml          ## the k8s service object
└── values.yaml               ## default config values

```
In the templates, the chart uses if conditions, hook definitions, named templates, and functions like: randAlphaNum, lower, upper, indent, quote ...

2. Let's build the chart
> Tip: you can change the chart name and version in helm-echoserver/Chart.yaml

```
helm package helm-echoserver/.
```
The above command generates the compressed chart `<chart-name>-<chart-version>.tgz`

3. Horray! Our chart is ready. Let's install :

```
# this command may take a couple of minutes while waiting for the LoadBalancer to become ready.
helm install --name echoserver helm-echoserver-0.1.0.tgz --set Post_install.delay=50,Post_install.message="<your custom message here>" --wait
```

> The `--wait` forces any post-install hooks to wait for all other resources to be in ready state.
> The `Post_install.delay=50` defines how long the post-install pod will wait (in seconds) before sending the message.

If all goes well, the last command results in a list of resources created by the chart and instructions to access the helm-echoserver (these instructions come from helm-echoserver/templates/NOTES.txt).

4. Follow the instrctions to obtain the application IP

5. Let's browse to our helm-echoserver on `http://<LoadBalancer_IP>:8888/content`
This should initially show `A default content line.` and soon should have a second line with your custom message (if its not already there, keep refreshing your browser till you get it).

6. Now check `http://<LoadBalancer_IP>:8888/` to see information about the helm-echoserver.

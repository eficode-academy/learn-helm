# Exercise 3: Building your own chart

Now that we know how to install/upgrade/delete and rollback a release from a 3rd party chart, it is time to build our own.

## The helm-echoserver chart

We will build a simple helm chart for a [helm-echoserver](https://github.com/Praqma/helm-echoserver). The chart will deploy a helm-echoserver container and perform a small post-installation task. This task is to wait for a configurable amount of time and then make a POST request to the helm-echoserver with a message to be stored in the file system of the helm-echoserver container.

---

> Whenever the text below mentions the `provided` files, it refers to the files provided in helm-echoserver/ in this repo.

> You can run `helm lint ` after each step below to detect some of the common syntax errors.


## Converting the K8S manifest files

We will start from the regular yaml manifests for deploying helm-echoserver. These are available in the `helm-echoserver` directory. There is also a `values.yaml` file where the user input will be provided. 

1. Start by creating the dummy chart provided with `helm create echoserver` 
2. Replace the generated `values.yaml` with the one provided in this repo (helm-echoserver/values.yaml) 
3. Now, in the generated chart, edit the `Chart.yaml`file. Hint: check [here](https://docs.helm.sh/developing_charts/#the-chart-yaml-file) for the possible options.


### Converting deployment.yaml

Convert the provided `deployment.yaml` to a helm template in the new chart (echoserver/templates/deployment.yaml) to satisfy the following requirements:

1. Choose a dynamic `name` pattern for this deployment. Keep in mind that multiple releases could be installed from this chart in the same cluster.

2. Make the values in the `labels` section dynamic. **Hint**: utilize Helm's [built-in objects](https://docs.helm.sh/chart_template_guide/#built-in-objects)

3. Make the number of replicas value taken from the user input (the values file). Also, if the user input for this value is empty, make it default to 1. **Hint**: check the [Go Sprig functions](http://masterminds.github.io/sprig/)

4. Now, the same labels block is repeated in Line 15 with hard coded values. Why not create a reusable template and inject it where needed instead. **Hint**: create a [named template](https://docs.helm.sh/chart_template_guide/#named-templates) and add it to your _helpers.tpl

5. In the `container` section, replace the hard-coded values with Go templates to read the user input. Also, make suer the `env` section can read all environment variables (an unlimited number) passed from the user input (values file). **Hint**: check out the [Flow control](https://docs.helm.sh/chart_template_guide/#flow-control) support.

6. Replace the hard-coded values of the environment variables [__HELM_CHART_NAME__, __HELM_CHART_VERSION__, __HELM_RELEASE__] in deployment.yaml with dynamic values.


### Converting service.yaml

1. Similar to the deployment, replace hard-coded values with dynamic ones and follow the comments in the provided service.yaml file.

### Converting ingress.yaml

1. Again, follow the instructions in the comments in the provided ingress.yaml to make it dynamic.

### Converting  post_install_job.yaml

This job is intended to be run each time helm-echoserver is deployed/upgraded. It simply sends a curl request posting a text message.

1. As before, follow the comments in the provided `post_install_job.yaml` to make the job dynamic.

2. Now, let's make this a Helm life cycle hook. Check [life cycle hooks](https://docs.helm.sh/developing_charts/#hooks)


### Adding templates/NOTES.txt

1. Add some message to the user with dynamic content. Example: how the user can access the app in the browser based on the service configurations they choose. **Hint**: get inspired from the [Jenkins chart](https://github.com/kubernetes/charts/blob/master/stable/jenkins/templates/NOTES.txt)

----

## Building the chart

```
helm package echoserver/.
```
If no errors are found, the above command generates the compressed chart `<chart-name>-<chart-version>.tgz`

3. Horray! Our chart is ready. Let's install :

```
helm install --name echoserver echoserver-0.1.0.tgz --set post_install.delay=50,post_install.message="<your custom message here>" --wait
```

> The `--wait` forces any post-install hooks to wait for all other resources to be in ready state.
> The `post_install.delay=50` defines how long the post-install pod will wait (in seconds) before sending the message.

If all goes well, the last command results in a list of resources created by the chart and instructions to access the helm-echoserver (these instructions come from echoserver/templates/NOTES.txt).


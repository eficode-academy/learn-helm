---
Duration : 5 min
---

# Exercise 4: Serving your charts

You can setup helm repositories to serve your charts in many possible ways. In this exercise, we will serve the chart which we created in [exercise 3](exercise3.md) locally (on localhost).

1. Run the following command

```
# starts serving charts in $HELM_HOME/repository/local on 127.0.0.1:8879 by default.
helm serve
```

2. Let's search the local repository:

```
# lists all charts served in the local repository
helm search local
```

That was all. Now our helm-echoserver chart can be installed as `local/helm-echoserver`.


## Clean up

Before we move to the next exercise, let's clean our cluster by deleting all the releases we installed so far:

```
helm delete --purge $(helm list --all -q)
```

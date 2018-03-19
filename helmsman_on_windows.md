# Using Helmsman from a docker image on Windows 10

If you have Windows 10 with Docker installed, you can run Helmsman in a linux container on Windows.

1. Switch to the Linux containers from the docker tray icon.
2. Run the following command:

```
docker run --rm -it -v <your kubectl config location>:/root/.kube -v <your dsf.toml directory>:/tmp  praqma/helmsman:v1.0.2 /bin/sh
```
3. You are all set now, but before continuouing with [exercise 5](exercise5.md), modify your `dsf.toml` and remove the echoserver release in the apps section as it is served on local repository (not seen inside the container).
4. Now follow [exercise 5](exercise5.md).

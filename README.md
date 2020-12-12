# inlets-demo-gcp

Exposes an nginx server running in your private Kubernetes cluster (e.g using Docker Desktop in your local laptop) to Google Cloud Platform using [inlets.dev](https://inlets.dev/)

## Getting started

Getting `arkade`:

```cli
curl -sSL https://dl.get-arkade.dev | sudo sh
```

On the Kubernetes host install `inlets-pro` and `inletsctl`

```cli
curl -sLSf https://inletsctl.inlets.dev | sudo sh

sudo inletsctl download --pro
```

Configure the required permissions in your Google Cloud project:

```cli
./setup-gcp.sh
```

Provision a VM in Google Cloud Platform using `inlestctl`:

```cli
inletsctl create \
  --project-id $PROJECTID \
  --provider gce \
  --access-token-file key.json
```

![gcp-exit-node](docs/images/gcp-exit-node.PNG)

Install the `inlets-operator` and specify the path for the GCP access token:

```cli
arkade install inlets-operator \
    --provider gce \
    --project-id $PROJECTID \
    --zone us-central1-a \
    --token-file key.json \
    --license $(cat ./inlets-pro-license.txt)
```

Deploy the nginx workload to your private Kubernetes cluster:

```cli
kubectl apply -f \
 https://raw.githubusercontent.com/inlets/inlets-operator/master/contrib/nginx-sample-deployment.yaml
```

Finally, expose it with a `LoadBalancer` from Google Cloud Platform:

```cli
kubectl expose deployment nginx-1 --port=80 --type=LoadBalancer
```

![k9s](docs/images/k9s.PNG)

## Clean up

Remove the VM that was created with `inletsctl`:

```cli
inletsctl delete --provider gce \
    --id "<exit-node-name>|us-central1-a|<project-id>" \
    --access-token-file key.json
```

## References:

- https://blog.alexellis.io/get-private-kubectl-access-anywhere/
- https://blog.alexellis.io/ingress-for-your-local-kubernetes-cluster/
- https://docs.inlets.dev/#/tools/inlets-operator?id=create-exit-node-on-google-compute-engine

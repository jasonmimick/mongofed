mongofed
====

### Abstract
A concrete example of running MongoDB on federated Kubernetes clusters.

### Introduction

I've been travelling around this fall, giving talks and discussing
our new MongoDB Kubernetes integration with customers all over
the world. One of the most popular questions by far is [^footnote-2nd-question]:

[^footnote-2ns-question] Can I run MongoDB Ops Manager inside Kubernetes? Stay tuned for an upcoming post...

Can I deploy MongoDB database clusters across multiple Kubernetes clusters?

Prudent folks need this to support their disaster recovery requirements and service 
level agreements. Support for this deplopyment model easily solves problems like:

- What happens if our main data center goes down?
- How can we give users in cental Asia a great user experience?
- We must keep all our German citizen's data geographically located within German.

Efficient and solid solutions to these scenraio's are critical for todays modern enterprises.

In this post, we'll see just how we can deploy MongoDB across multiple Kubernetes clusters.

To keep costs low, as in zero - we'll use the handy `minikube` tool to simulate multiple
Kubernetes clusters. All these steps will work seamlessly with any Kubernetes cluster
deployed by you or managed by a cloud provider, as long as the cluster is running
v1.11 or greater.

__**Note:**__ Kubernetes v1.11 or greater is required for this functionality.
 
*Credits:* This post borrows heavliy from the excellent 
[userguide](https://github.com/kubernetes-sigs/federation-v2/blob/master/docs/userguide.md) 
maintained by the [Kubernetes Federation-V2 SIG](https://github.com/kubernetes-sigs/federation-v2).
### Architecture Overview

TODO: generic arch blob, insert new pic

![MongoDB Kubernetes Crane Diagram][mongodb-k8s-crane]

[moggodb-k8s-crane]: ./mongodb-k8s-crane.png
### The Setup

- minikube
- go
- kubectl

Clone the federation-v2 repository:
```bash
$cd ${GOPATH}/github.com/kebernetes-sigs [^footnote-gopath]
$git clone https://github.com/kubernetes-sigs/federation-v2
$cd federation-v2
$ # TODO - supply my patch to download for darwin
$./scripts/download-binaries.sh
```

[^footnote-gopath] Create this folder path if you don't have it already.

### Building a federated Kubernetes cluster-set

To start, we'll fire up two independant Kubernetes clusters;

```bash
$minikube start -p cluster-1 --kubernetes-version v1.12.1
$minikube start -p cluster-2 --kubernetes-version v1.12.1
```

We can check what's running with:

```bash
kubectl config use-context cluster-1
kubectl --all-namespaces get all
kubectl config use-context cluster-2
kubectl --all-namespaces get all
```

We'll use the prescribed automated script to 'federate' our 2 kubernetes clusters.
Be sure to switch the `kubectl` context back to `cluster-1` since we'll use that cluster
to "host" the federation 
( [please see](https://github.com/kubernetes-sigs/federation-v2/blob/master/docs/userguide.md#automated-deployment) ).
Here's the command to check the current context
`kubectl config current-context`.

Run the script to federate our 2 clusters:
```bash
$./scripts/deploy-federation-latest.sh cluster-2
```

Check things look right:

```bash
kubectl -n federation-system get federatedclusters
```

TODO - add note to clone this repo
TODO - change the fed-v2 sample example to be about our own 
https://github.com/kubernetes-sigs/federation-v2/blob/master/docs/userguide.md#create-the-test-namespace

Create test namespace:
kubectl apply -f example/sample1/federatednamespace-template.yaml \
    -f example/sample1/federatednamespace-placement.yaml

Create all test resources (TODO - make this new mongodb ones)
kubectl apply -R -f example/sample1

Check status:

```bash
for r in configmaps secrets service deployment serviceaccount job; do
    for c in cluster-1 cluster-2; do
        echo; echo ------------ ${c} resource: ${r} ------------; echo
        kubectl --context=${c} -n test-namespace get ${r}
        echo; echo
    done
done
```


image: gcr.io/google-samples/zone-printer:0.1
 
### Installing MongoDB Ops Manager

TODO
- create demo container with Ops Mgr 4.x & filesystem backups

### Installing the MongoDB Kubernetes Operator

### Federating the MongoDB CRD's

install crds
install federated placement and override's
enable propogation for mongodb crds FederatedTypeConfig

### Deploying a multi-cluster MongoDB replica set

### Testing your database

### Summary

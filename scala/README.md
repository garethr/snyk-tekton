# Snyk Scala Task

A [Tekton Task](https://tekton.dev/) for using [Snyk](https://snyk.io) to check for
vulnerabilities in your Scala projects.


## Installation

```
kubectl apply -f https://raw.githubusercontent.com/garethr/snyk-tekton/master/scala/scala.yaml
```

You'll also need to place your Snyk API token in a Kubernetes secret.

```
kubectl create secret generic snyk --from-literal=token=abcd1234
```

## Usage

You can use the Task as follows:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: snyk-scala-example
spec:
  taskRef:
    name: snyk-scala
  workspaces:
  - name: source
    persistentVolumeClaim:
      claimName: my-source
```

The Snyk Scala Task has parameters which are passed to the underlying image:

| Parameter | Default | Description |
| --- | --- | --- |
| args |   | Override the default arguments to the Snyk image |
| commands | test | Specify which command to run, for instance test or monitor |
| snyk-secret | snyk | The name of the secret which stores the Snyk API token |

It also has resources for loading content for testing

| Resource | Description |
| --- | --- |
| source | A git-type PipelineResource specifying the location of the source to build |

For example, you can choose to only report on high severity vulnerabilities.

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: snyk-scala-example
spec:
  taskRef:
    name: snyk-scala
  params:
  - name: args
    value: "--severity-threshold=high"
  workspaces:
  - name: source
    persistentVolumeClaim:
      claimName: my-source
```

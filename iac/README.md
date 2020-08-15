# Snyk Infrastructure as Code Task

A [Tekton Task](https://tekton.dev/) for using [Snyk](https://snyk.io) to check for
misconfigurations in your infrastructure as code files.


## Installation

```
kubectl apply -f https://raw.githubusercontent.com/garethr/snyk-tekton/master/iac/iac.yaml
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
  name: snyk-iac-example
spec:
  taskRef:
    name: snyk-iac
  params:
  - name: file
    value: deployment.yaml
  workspaces:
  - name: source
    persistentVolumeClaim:
      claimName: my-source
```

The Snyk Node Task has parameters which are passed to the underlying image:

| Parameter | Default | Description |
| --- | --- | --- |
| file |  | The file to check for misconfigurations (required) |
| args |   | Override the default arguments to the Snyk image |
| commands | test | Specify which command to run, for instance test or monitor |
| snyk-secret | snyk | The name of the secret which stores the Snyk API token |


| Workspace | Description |
| --- | --- |
| source | A [Tekton Workspace](https://github.com/tektoncd/pipeline/blob/master/docs/workspaces.md) containing the source code to test |

For example, you can choose to only report on high severity vulnerabilities.

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: snyk-iac-example
spec:
  taskRef:
    name: snyk-iac
  params:
  - name: file
    value: deployment.yaml
  - name: args
    value: 
    - --severity-threshold=high
  workspaces:
  - name: source
    persistentVolumeClaim:
      claimName: my-source
```

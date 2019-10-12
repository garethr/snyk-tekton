# Snyk Ruby Task

A [Tekton Task](https://tekton.dev/) for using [Snyk](https://snyk.io) to check for
vulnerabilities in your Ruby projects.


## Installation

```
kubectl apply -f https://raw.githubusercontent.com/garethr/snyk-tekton/master/ruby/ruby.yaml
```

You'll also need to place your Snyk API token in a Kubernetes secret.

```
kubectl create secret generic snyk --from-literal=token=abcd1234
```

## Usage

You can use the Task as follows:

```yaml
apiVersion: tekton.dev/v1alpha1
kind: TaskRun
metadata:
  name: snyk-ruby-example
spec:
  taskRef:
    name: snyk-ruby
  inputs:
    resources:
    - name: source
      resourceSpec:
        type: git
        params:
        - name: revision
          value: master
        - name: url
          value: https://github.com/instrumenta/conftest.git
```

The Snyk Ruby Task has parameters which are passed to the underlying image:

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
apiVersion: tekton.dev/v1alpha1
kind: TaskRun
metadata:
  name: snyk-ruby-example
spec:
  taskRef:
    name: snyk-ruby
  inputs:
    resources:
    - name: source
      resourceSpec:
        type: git
        params:
        - name: revision
          value: master
        - name: url
          value: https://github.com/instrumenta/conftest.git
    params:
    - name: args
      value: "--severity-threshold=high"
```

[[ TOC ]]

# Stay calm and do the cloud
- First I will assume that you have a Linux machine nearby ( it can be a Linux subsystem in Windows 10, even Alpine distro)

# Install latest KUBECTL
```

```

_source: https://kubernetes.io/docs/tasks/tools/install-kubectl/_

# Install Kubectl ALIASES

- examples:

```
k -> 'kubectl'
kg -> 'kubectl get'
kgpo -> 'kubectl get pod'
```

```

```

_source: https://github.com/ahmetb/kubectl-aliases_ 

# Install CTX and NS plugin

- examples (with color in console):
```
[patryk@PC3525 ~ (⎈ |test:default)]$ k ctx fp1
Switched to context "fp1".
[patryk@PC3525 ~ (⎈ |fp1:default)]$ k ns kube-system
Context "fp1" modified.
Active namespace is "kube-system".
[patryk@PC3525 ~ (⎈ |fp1:kube-system)]$ k ns default
Context "fp1" modified.
Active namespace is "default".
[patryk@PC3525 ~ (⎈ |fp1:default)]$ k ctx test
Switched to context "test".
[patryk@PC3525 ~ (⎈ |test:default)]$
```

```

```

_source: https://github.com/kubernetes-sigs/krew_

# Install BASH PROMPT about K8s

- example:

```

```

_source: https://github.com/jonmosco/kube-ps1_

# Install K9s

```

```

_source: https://github.com/derailed/k9s_

# Install HELM

```

```

# Install ISTIOCTL
```

```
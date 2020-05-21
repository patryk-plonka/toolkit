#! /usr/bin/env bash
#
# Author: Patryk Plonka <patrykplonka.com>
#
# Let's make your k8s toolkit working again
#
# Usage:
#
# TODOs:
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# Set magic variables for current file & dir
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
readonly __base="$(basename ${__file} .sh)"
# readonly __root="$(cd "$(dirname "${__dir}")" && pwd)" 

main () {
#  arg1="${1:-}"

#  update_linux
#  deploy_kubectl
#  deploy_kubectl_aliases
#  deploy_kubectl_plugins
#  deploy_kubectl_prompt
#  deploy_k9s
#  deploy_helm
#  deploy_istioctl

  exit 0
}

# Let's upgrade
update_linux() {
  sudo apt update
  sudo apt upgrade
}

# Get KUBECTL
deploy_kubectl() {
  local kubectl_version=`curl --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt`
  (
    cd "$(mktemp -d)"
    curl --location --remote-name "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
  )
}

# Install KUBECTL Aliases
deploy_kubectl_aliases() {
  (
    cd "${HOME}"
    curl --location --remote-name https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
    [ -f ./.kubectl_aliases ]
    source ./.kubectl_aliases
  )
}

# Install CTX and NS plugin
deploy_kubectl_plugins() {
  local krew_version="v0.3.4"
  (
    cd "$(mktemp -d)"
    curl --fail --silent --show-error --location --remote-name "https://github.com/kubernetes-sigs/krew/releases/download/${krew_version}/krew.{tar.gz,yaml}"
    tar zxvf ./krew.tar.gz
    local krew=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64"
    "${krew}" install --manifest=krew.yaml --archive=krew.tar.gz
    "${krew}" update
    export PATH="${$HOME/.krew}/bin:$PATH"
  )
  kubectl krew install ctx
  kubectl krew install ns
}

# Install BASH PROMPT about K8s
deploy_kubectl_prompt() {
  (
    cd "${HOME}"
    curl --location --remote-name "https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh"
    source ./kube-ps1.sh
    PS1='[\u@\h \W $(kube_ps1)]\$ '
  )
}

# Install K9s
deploy_k9s() {
  local k9s_version="v0.19.6"
  (
    cd "$(mktemp -d)"
    curl --location --remote-name "https://github.com/derailed/k9s/releases/download/${k9s_version}/k9s_Linux_x86_64.tar.gz"
    tar zxvf ./k9s_Linux_x86_64.tar.gz
    chmod +x ./k9s
    sudo mv ./k9s /usr/local/bin/k9s
  )
}

# Install HELM
deploy_helm() {
  local helm_version="v2.16.7"
  (
    cd "$(mktemp -d)"
    curl --location --remote-name "https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz"
    tar xvzf "helm-${helm_version}-linux-amd64.tar.gz"
    chmod +x ./linux-amd64/helm
    sudo mv ./linux-amd64/helm /usr/local/bin/helm
  )
}

# Install ISTIOCTL
deploy_istioctl() {
  (
    cd "${HOME}"
    curl --silent --location "https://istio.io/downloadIstioctl" | sh -
    source ~/istioctl.bash
    export PATH=$PATH:$HOME/.istioctl/bin
  )
}

main "${@}"

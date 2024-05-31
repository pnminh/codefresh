## Link
- https://codefresh.io/docs/docs/quick-start/gitops-quick-start/
    - helm value: https://github.com/codefresh-io/gitops-runtime-helm/blob/main/charts/gitops-runtime/values.yaml
- https://codefresh.io/docs/docs/installation/gitops/hybrid-gitops-helm-installation/
- Git token for runtime: https://codefresh.io/docs/docs/security/git-tokens/
## Installation
- Require [git token](https://codefresh.io/docs/docs/security/git-tokens/)
- Runtime:
```
helm upgrade --install cf-gitops-runtime --create-namespace --namespace codefresh --values gitops/helm/values.yaml --set global.codefresh.accountId=$CF_ACCOUNTID --set global.codefresh.userToken.token=$CF_API_KEY  --set global.runtime.name=codefresh oci://quay.io/codefresh/gitops-runtime --set global.runtime.gitCredentials.password.value=$CF_RUNTIME_GIT_TOKEN
```
## Runner
- Using [helm](https://artifacthub.io/packages/helm/codefresh-runner/cf-runtime#openshift)
```
oc adm policy add-scc-to-user privileged system:serviceaccount:codefresh:cf-runtime-runner

oc adm policy add-scc-to-user privileged system:serviceaccount:codefresh:cf-runtime-volume-provisioner
```
- To create K8s cluster integration from codefresh using load-balancer for API:
- Need CA for load-balancer: https://codefresh.io/docs/docs/kb/articles/verify-cluster-tls-ssl-configuration/

## Pipelines
- Create [Runner](#runner)
- Create cluster
- 
- Create project
```
$ codefresh create project ioc
$ codefresh create pipeline -f pipelines/create-base-image.yml
```
## References
- https://codefresh.io/docs/docs/integrations/codefresh-api/
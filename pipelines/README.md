## [Install runner](https://artifacthub.io/packages/helm/codefresh-runner/cf-runtime#openshift)
```
oc adm policy add-scc-to-user privileged system:serviceaccount:codefresh-runner:cf-runtime-runner
oc adm policy add-scc-to-user privileged system:serviceaccount:codefresh-runner:cf-runtime-volume-provisioner
helm upgrade --install cf-runtime oci://quay.io/codefresh/cf-runtime -f helm/runner-values.yaml --set global.codefreshToken=$CF_API_KEY --set global.accountId=$CF_ACCOUNTID --create-namespace --namespace codefresh-runner
```
## Retrieve OCP API PEM cert for the API server
This is used for adding cluster with API server under [load balancer](https://codefresh.io/docs/docs/kb/articles/verify-cluster-tls-ssl-configuration/)
```
openssl s_client -showcerts -verify 5  -connect api.rosa-t09xhs.1tz3.p1.openshiftapps.com:6443 2>/dev/null </dev/null |  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> ocp_certs.crt
```
** Codefresh may require root cert so may need to use Chrome to retrieve it, as server usually doesn't send back root cert, and browser retrieves the root cert from their store instead
## Retrieve SA's token
```
oc create clusterrolebinding codefresh-admin --clusterrole cluster-admin --serviceaccount codefresh-runner:deployer -n codefresh-runner
kubectl get secret -o go-template='{{index .data "token" }}' $(oc describe sa deployer|awk '/Tokens/ {print $2}')
```
## Create build secrets
```
oc create secret generic codefresh-ioc --from-literal REGISTRY_USERNAME=$QUAY_USERNAME \
--from-literal REGISTRY_PASSWORD=$QUAY_TOKEN --from-literal CODEFRESH_API_KEY=$CF_API_KEY \
--from-literal CLUSTER_SA_TOKEN=$OCP_DEPLOYER_TOKEN --from-literal CLUSTER_API_HOST=$OCP_API_HOST \
--from-literal CLUSTER_CLIENT_CA=$OCP_API_HOST_CERT --from-literal SONAR_TOKEN=$SONAR_TOKEN
```
## Pipeline
- Add cluster: requires existing cluster to be there for secret retrieval:
```
curl -s 'https://g.codefresh.io/api/clusters/local/cluster' \
            -H "content-type: application/json;charset=UTF-8" \
            -H "Authorization: $CF_API_KEY" \
            --data-raw "{\"type\":\"sat\",\"selector\":\"runner-cluster\",
            \"host\":\"$OCP_API_HOST\",\"clientCa\":\"$OCP_API_HOST_CERT\",
            \"serviceAccountToken\":\"$OCP_DEPLOYER_TOKEN\",\"provider\":\"local\",
            \"providerAgent\":\"custom\"}"
codefresh create pipeline -f 1_add-cluster.yml
```

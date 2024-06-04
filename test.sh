curl -s 'https://g.codefresh.io/api/clusters/local/cluster' \
            -H "content-type: application/json;charset=UTF-8" \
            -H "Authorization: $CF_API_KEY" \
            --data-raw "{\"type\":\"sat\",\"selector\":\"runner-cluster\",
            \"host\":\"$OCP_API_HOST\",\"clientCa\":\"$OCP_API_HOST_CERT\",
            \"serviceAccountToken\":\"$OCP_DEPLOYER_TOKEN\",\"provider\":\"local\",
            \"providerAgent\":\"custom\"}"
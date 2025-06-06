# k3s-strimzi
deploy strimzi on K3s

# install strimzi

https://artifacthub.io/packages/helm/strimzi/strimzi-kafka-operator

helm repo add strimzi https://strimzi.io/charts
helm repo update
helm dependency update
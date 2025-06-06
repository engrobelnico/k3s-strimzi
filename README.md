# k3s-strimzi
deploy strimzi on K3s

# install strimzi

https://artifacthub.io/packages/helm/strimzi/strimzi-kafka-operator

helm repo add strimzi https://strimzi.io/charts
helm repo update
helm dependency update

# test send
kctl -n strimzi run kafka-producer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server lv-cluster-kafka-bootstrap:9092 --topic my-topic

# test receive
kctl -n strimzi run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server lv-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning

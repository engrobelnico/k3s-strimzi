# k3s-strimzi
deploy strimzi on K3s

# install strimzi

https://artifacthub.io/packages/helm/strimzi/strimzi-kafka-operator

helm repo add strimzi https://strimzi.io/charts
helm repo update
helm dependency update

# check conf
kctl get kafkas -n strimzi
kctl get kafkatopic -n strimzi
kctl get kafkabridge -n strimzi


# test send
kctl -n strimzi run kafka-producer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server lv-cluster-kafka-bootstrap:9092 --topic lv-test-topic

# test receive
kctl -n strimzi run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server lv-cluster-kafka-bootstrap:9092 --topic lv-test-topic --from-beginning

kctl get pods -l 'strimzi.io/cluster=lv-cluster' --all-namespaces
kctl get pods -l 'strimzi.io/kind=KafkaBridge' --all-namespaces
kctl get pods -l 'strimzi.io/kind=cluster-operator' --all-namespaces
kctl get pods -l 'app.kubernetes.io/name=entity-operator' --all-namespaces
kctl get podmonitors -A -l app=strimzi
kctl logs -n prometheus -l app.kubernetes.io/name=prometheus | grep kafka # Adjust label selector if needed
kctl get svc lv-bridge-bridge-service -n strimzi -o yaml

kctl get prometheuses.monitoring.coreos.com --all-namespaces -o jsonpath="{.items[*].spec.serviceMonitorSelector}"

# test send message to bridge

kctl -n strimzi run kafka-producer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin//kafka-topics.sh --create --bootstrap-server lv-cluster-kafka-bootstrap:9092 --topic my-topic --partitions 3 --replication-factor 1


kctl -n strimzi run kafka-producer -ti --image=quay.io/strimzi/kafka:0.46.0-kafka-4.0.0 --rm=true --restart=Never -- bin//kafka-topics.sh  --bootstrap-server lv-cluster-kafka-bootstrap:9092 --describe --topic my-topic


curl -X POST http://kube.local/kafka-bridge/topics/my-topic -data "@./test/message.json"  -H 'content-type: application/vnd.kafka.json.v2+json' -H 'Origin: http://kube.local'\

curl -X GET  http://kube.local/kafka-bridge/topics




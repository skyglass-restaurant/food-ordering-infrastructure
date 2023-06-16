resource "helm_release" "confluent_kafka" {
  name       = "confluent-kafka"
  repository = "https://charts.confluent.io"
  chart      = "cp-helm-charts"
  version    = "0.6.0"
}
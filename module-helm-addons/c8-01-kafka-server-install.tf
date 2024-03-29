resource "helm_release" "bitnami_kafka" {
  name       = "bitnami-kafka"
  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "kafka"

}

resource "helm_release" "bitnami_kafka_schema_registry" {
  depends_on = [helm_release.bitnami_kafka]
  name       = "schema-registry"
  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "schema-registry"
}
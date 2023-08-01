resource "kubernetes_deployment_v1" "kafka_debezium_connector" {
  depends_on = [helm_release.bitnami_kafka_schema_registry]
  metadata {
    name = "kafka-debezium-connector"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "kafka-debezium-connector"
      }
    }

    template {
      metadata {
        labels = {
          app = "kafka-debezium-connector"
        }
      }

      spec {
        container {
          name  = "kafka-debezium-connector"
          image = "debezium/connect:2.4"
          
          ports {
            container_port = 8083
          }

          env {
            name  = "GROUP_ID"
            value = "1"
          }

          env {
            name  = "CONFIG_STORAGE_TOPIC"
            value = "connect-config"
          }

          env {
            name  = "OFFSET_STORAGE_TOPIC"
            value = "connect-offsets"
          }

          env {
            name  = "STATUS_STORAGE_TOPIC"
            value = "connect-status"
          }

          env {
            name  = "BOOTSTRAP_SERVERS"
            value = "bitnami-kafka:9092"
          }

          env {
            name  = "LOGGING_LEVEL"
            value = "DEBUG"
          }

          env {
            name  = "CONNECT_SCHEMA_NAME_ADJUSTMENT_MODE"
            value = "avro"
          }

          env {
            name  = "KEY_CONVERTER"
            value = "io.confluent.connect.avro.AvroConverter"
          }

          env {
            name  = "VALUE_CONVERTER"
            value = "io.confluent.connect.avro.AvroConverter"
          }

          env {
            name  = "CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL"
            value = "http://schema-registry:8081"
          }

          env {
            name  = "CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL"
            value = "http://schema-registry:8081"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "debezium_connector" {
  metadata {
    name = "debezium-connector"
  }
  spec {
    selector = {
      app = "debezium-connector"
    }
    port {
      port = 8083
    }
  }
}

resource "null_resource" "debezium_connect_script" {
  provisioner "local-exec" {
    command = "sh ${path.module}/debezium-connect.sh"
  }
  depends_on = [kubernetes_deployment_v1.kafka_debezium_connector]
}
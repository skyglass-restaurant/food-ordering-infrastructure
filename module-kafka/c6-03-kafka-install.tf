# Resource: Helm Release 
resource "helm_release" "kafka_cluster" {  
  name       = "kafka-cluster"

  repository = "https://confluentinc.github.io/cp-helm-charts/"
  chart      = "cp-helm-charts"

  namespace = "default"
        
}

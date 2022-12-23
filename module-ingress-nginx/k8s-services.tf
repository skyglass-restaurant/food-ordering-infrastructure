resource "kubernetes_service_v1" "app1_service" {
  metadata {
    name = "my-app1-service"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.app1.metadata.0.labels.app
    }
    port {
      port = 5678
    }
  }
}


resource "kubernetes_service_v1" "app2_service" {
  metadata {
    name = "my-app2-service"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.app2.metadata.0.labels.app
    }
    port {
      port = 5678
    }
  }
}

resource "kubernetes_service_v1" "order_service" {
  metadata {
    name = "order-service"
  }
  spec {
    selector = {
      app = "order-deployment"
    }
    port {
      port = 8181
    }
  }
}

resource "kubernetes_service_v1" "payment_service" {
  metadata {
    name = "payment-service"
  }
  spec {
    selector = {
      app = "payment-deployment"
    }
    port {
      port = 8182
    }
  }
}

resource "kubernetes_service_v1" "restaurant_service" {
  metadata {
    name = "restaurant-service"
  }
  spec {
    selector = {
      app = "restaurant-deployment"
    }
    port {
      port = 8183
    }
  }
}

resource "kubernetes_service_v1" "customer_service" {
  metadata {
    name = "customer-service"
  }
  spec {
    selector = {
      app = "customer-deployment"
    }
    port {
      port = 8184
    }
  }
}
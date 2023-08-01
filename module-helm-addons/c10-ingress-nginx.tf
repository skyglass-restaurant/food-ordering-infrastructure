resource "kubernetes_ingress_v1" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "simple-fanout-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "kubernetes.io/ingress.class" =  "nginx"
    }
  }

  spec {

    default_backend {
     
      service {
        name = "order-api"
        port {
          number = 8181
        }
      }
    }     

    rule {
      host = "order.greeta.net"
      http {

        path {
          backend {
            service {
              name = "order-api"
              port {
                number = 8181
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "payment.greeta.net"
      http {

        path {
          backend {
            service {
              name = "payment-api"
              port {
                number = 8182
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    } 

    rule {
      host = "restaurant.greeta.net"
      http {

        path {
          backend {
            service {
              name = "restaurant-api"
              port {
                number = 8183
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }  

    rule {
      host = "customer.greeta.net"
      http {

        path {
          backend {
            service {
              name = "customer-api"
              port {
                number = 8184
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "kafka.greeta.net"
      http {

        path {
          backend {
            service {
              name = "kafka-ui"
              port {
                number = 8080
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }           


  }
}

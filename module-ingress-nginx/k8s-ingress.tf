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
        name = "my-app1-service"
        port {
          number = 5678
        }
      }
    }     

    rule {
      host = "app1.greeta.net"
      http {
        path {
          backend {
            service {
              name = "my-app1-service"
              port {
                number = 5678
              }
            }
          }

          path = "/app1"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "app2.greeta.net"
      http {

        path {
          backend {
            service {
              name = "my-app2-service"
              port {
                number = 5678
              }
            }
          }

          path = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "order.greeta.net"
      http {

        path {
          backend {
            service {
              name = "order-service"
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
              name = "payment-service"
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
              name = "restaurant-service"
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
              name = "customer-service"
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

  }
}

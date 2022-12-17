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
      host = "todo.greeta.net"
      http {

        path {
          backend {
            service {
              name = "todo"
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

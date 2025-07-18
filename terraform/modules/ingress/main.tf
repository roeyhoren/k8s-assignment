resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "null_resource" "install_ingress_controller" {
  depends_on = [kubernetes_namespace.ingress_nginx]

  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s"
  }
}

resource "kubernetes_ingress_v1" "main" {
  depends_on = [null_resource.install_ingress_controller]
  
  metadata {
    name      = "main-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"               = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.apps
      content {
        host = var.host
        http {
          path {
            path      = "/${rule.key}/(.*)"
            path_type = "Prefix"
            backend {
              service {
                name = rule.value.service_name
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }
}
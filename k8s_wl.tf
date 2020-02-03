resource "kubernetes_deployment" "kitten" {
  metadata {
    name = "kitten-cont"
    labels = {
      test = "kitten-cont"
    }
  }
  depends_on = [aws_db_instance.kittens]
  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "kitten-cont"
      }
    }

    template {
      metadata {
        labels = {
          test = "kitten-cont"
        }
      }

      spec {
        container {
          image = "998069768433.dkr.ecr.eu-central-1.amazonaws.com/kitten-store:latest"
          name  = "kitten-cont"
          port {
            container_port = 1234
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }

          }
        }
        init_container {
          image = "998069768433.dkr.ecr.eu-central-1.amazonaws.com/kitten-store:latest"
          name  = "kitten-cont-migrate"
          args  = ["migrate.sh"]
        }
      }
    }
  }
}

resource "kubernetes_secret" "db-secret" {
  metadata {
    name = var.secret.name
  }

  data = {
    username = var.secret.username
    password = var.secret.password
  }

  type = "kubernetes.io/basic-auth"
}

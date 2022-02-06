#############################################################################
### Deployment manifests for 3 applications (frontend, backend, database) ###
### feel free to change anything and to implement any function or method  ###
#############################################################################
resource "kubernetes_deployment" "instance" {
  for_each = {for inst in var.app_info:  inst.app_name => inst}
  metadata {
    name      = "${each.value.app_name}"
    namespace = "${each.value.app_name}"
    labels = {
      name = "${each.value.name_label}"
      tier = "${each.value.tier_label}"
    }
  }
  spec {
    selector {
      match_labels = {
        name = "${each.value.name_label}"
        tier = "${each.value.tier_label}"
      }
    }
    template {
      metadata {
        name = "${each.value.app_name}"
        labels = {
          name = "${each.value.name_label}"
          tier = "${each.value.tier_label}"
        }
      }
      spec {
        container {
          name  = "${each.value.app_name}"
          image = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = var.database.db.app_name
    namespace = var.database.db.app_name
    labels = {
      name = var.database.db.name_label
      tier = var.database.db.tier_label
    }
  }
  spec {
    selector {
      match_labels = {
        name = var.database.db.name_label
        tier = var.database.db.tier_label
      }
    }
    template {
      metadata {
        name = var.database.db.app_name
        labels = {
          name = var.database.db.name_label
          tier = var.database.db.tier_label
        }
      }
      spec {
        container {
          name  = var.database.db.app_name
          image = "mongo"
        }
      }
    }
  }
}


#############################################################################
### Resource manifests for 3 namespaces reusing the application naming    ###
### feel free to change anything and to implement any function or method  ###
#############################################################################
resource "kubernetes_namespace" "instance" {
  for_each = {for inst in var.app_info:  inst.app_name => inst}

  metadata {
    name = "${each.value.app_name}"
    labels = {
      name  = "${each.value.name_label}"
      tier  = "${each.value.tier_label}"
      owner = "${each.value.owner_label}"
    }
    annotations = {
      "serviceClass"       = "${each.value.serviceClass_annotations}"
      "loadBalancer/class" = true
    }
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = var.database.db.app_name
    labels = {
      name  = var.database.db.name_label
      tier  = var.database.db.tier_label
      owner = var.database.db.owner_label
    }
    annotations = {
      "serviceClass"       = var.database.db.serviceClass_annotations
      "loadBalancer/class" = false
    }
  }
}


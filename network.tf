#################################################################################
### Resource manifests for 3 network policies (one per application namespace) ###
### feel free to change anything and to implement any fix, function or method ###
#################################################################################
resource "kubernetes_network_policy" "instance" {
  for_each = {for inst in var.app_info:  inst.app_name => inst}
  
  metadata {
    name      = format("%s-acl", "${each.value.app_name}") 
    namespace = "${each.value.app_name}"
  }
  spec {
    policy_types = ["Ingress", "Egress"]
    pod_selector {
      match_labels = {
        tier = "${each.value.tier_label}"
      }
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "${each.value.ingress}"
          }
        }
      }
      ports {
        port     = "${each.value.port}"
        protocol = "${each.value.protocol}"
      }
    }
    egress {
      to {
        ip_block {
          cidr = "${each.value.egress}"
        }
      }
    }
  }
}


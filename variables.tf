
variable "app_info" { 
  description                     = "information about the frontend and backend apps" 
  type                            = set(object({ 
    app_name                      = string 
    name_label                    = string
    tier_label                    = string
    owner_label                   = string 
    serviceClass_annotations      = string
    loadBalancer_annotations      = string
    ingress                       = string
    egress                        = string
    port                          = string
    protocol                      = string
  }))
   default = [
     {
       app_name                   = "stream-frontend"
       name_label                 = "stream-frontend"
       tier_label                 = "web"
       owner_label                = "product"
       serviceClass_annotations   = "web-frontend"
       loadBalancer_annotations   = "external"
       ingress                    = "stream-backend"
       egress                     = "0.0.0.0/0"
       port                       = "80"
       protocol                   = "TCP"
     },
     {
       app_name                   = "stream-backend"
       name_label                 = "stream-backend"
       tier_label                 = "api"
       owner_label                = "product"
       serviceClass_annotations   = "web-backend"
       loadBalancer_annotations   = "internal"
       ingress                    = "stream-frontend"
       egress                     = "172.17.0.0/24"
       port                       = "80"
       protocol                   = "TCP"
     }
   ]
}



variable "database" { 
  description                    = "infromation about the database" 
  type                           = map(object({
    app_name                     = string
    name_label                   = string
    tier_label                   = string
    owner_label                  = string
    serviceClass_annotations     = string
    loadBalancer_annotations     = string
    ingress                      = string
    egress                       = string
    port                         = string
    protocol                     = string
  }))
  default = {
    db =  {
      app_name                   = "stream-database"
      name_label                 = "stream-database"
      tier_label                 = "shared"
      owner_label                = "product"
      serviceClass_annotations   = "database"
      loadBalancer_annotations   = "disabled"
      ingress                    = "stream-backend"
      egress                     = "172.17.0.0/24"
      port                       = "27017"
      protocol                   = "TCP"
    }
  }
}


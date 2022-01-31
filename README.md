
## Solution to the Terraform DevOps assignment
My solution to each of the issues describe in the origanl README.md file will be according to the order they are written with the file name they are implamented or an example.

#### 1. Reduce varible count
I reduce the number of varibles by editing the file varible.tf.The variables for the namespace,labels,annotations for app1 and app2 were changed to a variable with type set (a list of non duplicate values). the variable for app3 were changed to a variable with type map (a key value pairs where each is identified by astring label).


#### 2. Remove duplicate code
I remove duplicated code by editing the file deployment.tf,namespace.tf,network.tf and adding the for_each (can work with both data types 'set' and 'map', creates a resource with each item in that map or set)

#### 3. Change Network ACL
In order to change the network acl you will need to update the egress and port variable.tf to their new values that the backend developer wishes to change them. (under the "acl_backend" variable in the file)
for example: 
```
variable "acl_backend" {
  description = "access allowed from this source"
  type = map(object({
    ingress = string
    egress  = string
    port     = string
    protocol = string
  }))
  default = {
    backend = {
      ingress  = "stream-frontend"
      egress   = "172.17.0.0/24"
      port     = "80"
      protocol = "TCP"
    }
  }
}
```

#### 4. Implement resource management
To implement resource management there is a need to set limits to the CPU/memory used by those resources. The file deployment.tf should be edit, under the container section.
for example:
```
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

```

#### 5. Make scaling possible
In order to make it possible for our pods to scall we define a resource that will scall them automatically to a certion number based on a observed metrics (CPU utilization).
for example: 
```
resource "kubernetes_horizontal_pod_autoscaler" "my-hpa" {
  metadata {
    name      = "my-hpa"
  }

  spec {
    max_replicas = 15
    min_replicas = 3

    target_cpu_utilization_percentage = 65

    scale_target_ref {
      kind        = "Deployment"
      name        = "deployment"
    }
  }
} 
```

#### 6. Prepare for Multi-environment
In order to manage an multi-environment we can use workspaces in terraform.
A workspace contains everything that terraform needs to manage a collection of infrastructure separatly by having differnet state files for the same code.
Each environment required it own state files.
for example:
- To create a new workspace
```
terraform workspace new <environment-name>
```
*alternative*
We can create variable for multi-environment so the application on differnet namespaces
for example:
```
variable "environment" {
  description = "multiple environments to run the app"
  type = "map"
  default = {
    "env1" = "production"
    "env2" = "devlopment"
    "env3" = "testing"
  }
}
```

#### 7. Add environment variable to service
We can create a secret and store a sensitive data (such as username and password) in a variable, and use it in our deployment inside the pod. using secret means we dont need to include confidntail data in the application code. on the varible.tf file we will create the a varibe celled "secret-db" with the sensitive data.
for example:
```
variable "secret" {
  description = "secret data to login to the db"
    name = "secret-db"
    username = "admin"
    password = "P4ssw0rd"
}
```
The varible we create will be used in the manifest file (deployment.tf) under the container spec.
```
      spec {
        container {
          name  = var.app.db.app_name
          image = "mongo"
          env {
            username = var.secret.username
            password = var.secret.password
          }
        }
      }
```

**References**
[Terraform-offical-website](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/) 
[Kubernetes offical website](https://kubernetes.io/docs/concepts/)


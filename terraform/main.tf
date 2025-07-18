provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create the cluster
module "cluster" {
  source = "./modules/cluster"
  
  cluster_name = var.cluster_name
}

# Build the webapp image
resource "null_resource" "build_webapp_image" {
  depends_on = [module.cluster]
  
  provisioner "local-exec" {
    command = <<-EOF
      docker build -t webapp:latest ../src/webapp/
      kind load docker-image webapp:latest --name ${var.cluster_name}
    EOF
  }
}

# Deploy applications
module "app1" {
  source = "./modules/apps"
  depends_on = [null_resource.build_webapp_image]
  
  app_name  = "app1"
  image     = "webapp:latest"
  namespace = "default"
  replicas  = 2
}

module "app2" {
  source = "./modules/apps"
  depends_on = [null_resource.build_webapp_image]
  
  app_name  = "app2"
  image     = "webapp:latest"
  namespace = "default"
  replicas  = 2
}

module "app3" {
  source = "./modules/apps"
  depends_on = [null_resource.build_webapp_image]
  
  app_name  = "app3"
  image     = "webapp:latest"
  namespace = "default"
  replicas  = 2
}

# Setup ingress
module "ingress" {
  source = "./modules/ingress"
  depends_on = [module.app1, module.app2, module.app3]
  
  namespace = "default"
  host     = "localhost"
  
  apps = {
    app1 = {
      service_name = module.app1.service_name
      app_name     = module.app1.app_name
      namespace    = module.app1.namespace
    }
    app2 = {
      service_name = module.app2.service_name
      app_name     = module.app2.app_name
      namespace    = module.app2.namespace
    }
    app3 = {
      service_name = module.app3.service_name
      app_name     = module.app3.app_name
      namespace    = module.app3.namespace
    }
  }
}
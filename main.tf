provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

data "google_client_config" "default" {}

locals {
  environment = terraform.workspace
}

module "networking" {
  source        = "./modules/networking"
  project_id    = var.project_id
  region        = var.region
  network_name  = "${local.environment}-vpc"
  subnet_name   = "${local.environment}-subnet"
  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
  ip_count      = 1
}

module "cluster" {
  source              = "./modules/cluster"
  name                = "${local.environment}-gke-cluster"
  project_id          = var.project_id
  region              = var.region
  node_locations      = var.node_locations
  vpc_name            = module.networking.network_name
  subnet_name         = module.networking.subnet_name
  network_id          = module.networking.network_id
  subnet_id           = module.networking.subnet_id
  pods_range_name     = module.networking.pods_range_name
  services_range_name = module.networking.services_range_name
  depends_on          = [module.networking]
}

provider "kubernetes" {
  host                   = "https://${module.cluster.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca)
}


module "node_pools" {
  source             = "./modules/node_pools"
  region             = var.region
  project_id         = var.project_id
  stable_gke_version = module.cluster.stable_gke_version
  cluster_name       = module.cluster.cluster_name
  pools              = var.node_pools
  depends_on         = [module.cluster]
}

module "namespaces" {
  source     = "./modules/namespaces"
  depends_on = [module.cluster, module.node_pools]
  namespaces = var.namespaces
}

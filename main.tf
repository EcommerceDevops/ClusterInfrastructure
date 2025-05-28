provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

data "google_client_config" "default" {}

module "network" {
  source     = "./modules/network"
  project_id = var.project_id
  region     = var.region
}

module "cluster" {
  source         = "./modules/cluster"
  region         = var.region
  node_locations = var.node_locations
  project_id     = var.project_id
  vpc_name       = module.network.vpc_name
  subnet_name    = module.network.subnet_name
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
}

module "namespaces" {
  source = "./modules/namespaces"
}

module "static_external_ip" {
  source      = "./modules/static_external_ip"
  project_id  = var.project_id
  region      = var.region
  name_prefix = "ingress-static-ip"
  ip_count    = 2
}

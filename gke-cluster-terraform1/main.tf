provider "google" {
  project = "heroic-glyph-436915-a1"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                   = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-1"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = "us-central1-c" 

  node_pool {
    name       = "default-pool"
    node_count = 1

    node_config {
      machine_type = "e2-micro" 
      disk_size_gb = 10         
    }
  }

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
}

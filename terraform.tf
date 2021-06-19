terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s"
  region  = "fra1"
  // Get available versions using: doctl kubernetes options versions
  version = "1.20.7-do.0"

  node_pool {
    name       = "test"
    // Get available sizes using: doctl kubernetes options sizes
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

# resource "digitalocean_loadbalancer" "k8s" {
#   name = "k8s"
#   region = "fra1"

#   droplet_tag = "k8s:${digitalocean_kubernetes_cluster.k8s.id}"

#   healthcheck {
#     port = 30001
#     protocol = "tcp"
#   }

#   forwarding_rule {
#     entry_port  = 80
#     target_port = 30001
#     entry_protocol = "tcp"
#     target_protocol = "tcp"
#   }

#   forwarding_rule {
#     entry_port  = 443
#     target_port = 30002
#     entry_protocol = "tcp"
#     target_protocol = "tcp"
#   }

#   forwarding_rule {
#     entry_port  = 8080
#     target_port = 30003
#     entry_protocol = "tcp"
#     target_protocol = "tcp"
#   }
# }

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  sensitive = true
}

# output "lb_ip" {
#   value = digitalocean_loadbalancer.k8s.ip
# }

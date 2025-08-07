# -----------------------------------------------------------------------------
# TERRAFORM BLOCK
# Defines required providers and their versions. Pinning versions ensures
# that future provider updates do not break your configuration unexpectedly.
# -----------------------------------------------------------------------------
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# -----------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# Configures the Docker provider. By default, it connects to the local
# Docker daemon via its socket. No explicit configuration is needed if
# Docker is running locally.
# -----------------------------------------------------------------------------
provider "docker" {}

# -----------------------------------------------------------------------------
# RESOURCE: DOCKER IMAGE
# Pulls a specific Docker image from Docker Hub.
# 'keep_locally = false' ensures that 'terraform destroy' removes the image,
# allowing Terraform to manage the entire lifecycle.
# -----------------------------------------------------------------------------
resource "docker_image" "nginx" {
  name         = "nginx:1.25-alpine"
  keep_locally = false
}

# -----------------------------------------------------------------------------
# RESOURCE: DOCKER CONTAINER
# Creates and manages the lifecycle of a Docker container.
# This configuration maps port 8080 on the host to port 80 in the container.
# -----------------------------------------------------------------------------
resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = "tutorial-nginx-server"
  ports {
    internal = 80
    external = 8888 # <-- Changed to an available port
  }
}
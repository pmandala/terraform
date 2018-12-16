provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create a container
resource "docker_container" "test-nginx" {
  image = "${docker_image.nginx.latest}"
  name  = "test-nginx"

  ports {
    internal = 80
    external = 80
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

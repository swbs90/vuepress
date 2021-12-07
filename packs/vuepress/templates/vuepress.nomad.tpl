job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .vuepress.datacenters | toPrettyJson ]]
  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "vuepress" {
    count = 1
    network {
      port "http" {
        to = [[ .vuepress.http_port ]]
      }
    }

    service {
      name = "vuepress"
      port = "http"
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "172.21.4.51/private/vuepress:[[ .vuepress.version_tag ]]"
        ports = ["http"]
      }
      resources {
        cpu    = [[ .vuepress.resources.cpu ]]
        memory = [[ .vuepress.resources.memory ]]
      }
    }
  }
}
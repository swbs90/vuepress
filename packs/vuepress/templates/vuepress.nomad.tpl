#vuepress.nomad.tpl
job "[[ .vuepress.job_name ]]" {
  region      = "[[ .vuepress.region ]]"
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
        to = 8000
      }
    }

    service {
      name = "[[ .vuepress.consul_service_name ]]"
      port = "http"
    }

    task "vuepress" {
      driver = "docker"
      config {
        image = "swbs90/vuepress:[[ .vuepress.version_tag ]]"
        ports = ["http"]
      }
      resources {
        cpu    = [[ .vuepress.resources.cpu ]]
        memory = [[ .vuepress.resources.memory ]]
      }
    }
  }
}

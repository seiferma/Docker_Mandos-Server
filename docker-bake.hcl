variable "MANDOS_VERSION" {
  # renovate: datasource=repology depName=debian_13/mandos versioning=loose
  default = "1.8.19-1"
}

variable "S6_OVERLAY_VERSION" {
  # renovate: datasource=github-releases depName=just-containers/s6-overlay versioning=loose
  default = "3.2.0.2"
}

group "default" {
  targets = ["default"]
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/mandos-server:${MANDOS_VERSION}", "quay.io/seiferma/mandos-server:latest"]
  args = {
    MANDOS_VERSION = "${MANDOS_VERSION}"
    S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
  }
}

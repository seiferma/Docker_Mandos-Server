variable "VERSION" {
  default = "1.8.16-1"
}

group "default" {
  targets = ["default"]
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/mandos-server:${VERSION}", "quay.io/seiferma/mandos-server:latest"]
  args = {
    VERSION = "${VERSION}"
  }
}

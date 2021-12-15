local "exports_directory" {
  expression = "${path.root}/../exports/"
}

locals {
  buildtime     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  manifest_date = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
}
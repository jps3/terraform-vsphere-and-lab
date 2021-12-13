local "random_password" {
  expression = sha1(uuidv4())
}

local "exports_directory" {
  expression = "${path.root}/../exports/"
}

locals {
  buildtime     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  manifest_date = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
}
module "qa" {
    source = "../modules/blog"

    environment = {
      name             = "qa"
      network_prefix   = "10.1."
    }

    min_size_slg = 0
    max_size_slg = 0
}
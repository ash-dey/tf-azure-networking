env= "dev"
extra_tags = {
    ENV = "dev"
}
address_space = "10.244.0.0/16"
subnet_prefixes = ["10.244.0.0/20","10.244.64.0/20","10.244.128.0/21","10.244.160.0/24","10.244.164.0/24"]
subnet_names = ["dev-priv-inst-sub","dev-priv-func-sub","dev-pub-func-sub","dev-priv-db-sub","dev-priv-mgmt-sub"]
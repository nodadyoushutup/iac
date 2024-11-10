# module.
module "test" {
    source  = "spacelift.io/nodadyoushutup/stack/spacelift"
    
    name = "test"
    branch = "main"
    repository = "iac"

    # administrative = true
    # space_id = "root"
}
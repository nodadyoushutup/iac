module "stack" {
    source  = "spacelift.io/nodadyoushutup/stack/spacelift"

    ## REQUIRED ##
    name = "database"    
    
    # ## OPTIONAL (FORCE DEFAULTS) ##
    # repository = "iac"
    # branch = "main"
    # terraform_version = "1.5.7"

    # ## OPTIONAL ##
    # description = null
    # labels = ["database"]
    # project_root = null
    # import_state = null
    # import_state_file = null
    # space_id = "root"
    # administrative = false
    # autodeploy = true
    # additional_project_globs = null
    # autoretry = false
    # enable_local_preview = false
    # enable_well_known_secret_masking = false
    # github_action_deploy = true
    # manage_state = true
    # protect_from_deletion = false
    # terraform_smart_sanitization = false
    # terraform_workflow_tool = "TERRAFORM_FOSS"

    # ## HOOKS ##
    # before = {
    #     apply = null
    #     destroy = null
    #     init = null
    #     perform = null
    #     plan = null
    # }
    # after = {
    #     apply = null
    #     destroy = null
    #     init = null
    #     perform = null
    #     plan = null
    #     run = null
    # }
}

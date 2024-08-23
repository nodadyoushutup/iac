# module "stack" {
#     source  = "spacelift.io/nodadyoushutup/stack/spacelift"
#     for_each = { 
#         for stack_name, stack_config in local.config.stack : stack_name => stack_config 
#         if !contains(local.config.component, stack_name)
#     }

#     ## REQUIRED ##
#     name        = each.value.name
#     repository  = each.value.repository

#     ## UNIQUE ##
#     project_root        = try(each.value.project_root, null)
#     description         = try(each.value.description, null)
#     labels              = try(each.value.labels, null)

#     ## OPTIONAL (No Global)
#     import_state = try(each.value.import_state, null)
#     import_state_file = try(each.value.import_state_file, null)

#     ## OPTIONAL ##
#     space_id = try(each.value.space_id, null)
#     administrative = try(each.value.administrative, null)
#     autodeploy = try(each.value.autodeploy, null)
#     terraform_version = try(each.value.terraform_version, null)
#     additional_project_globs = try(each.value.additional_project_globs, null)
#     autoretry = try(each.value.autoretry, null)
#     enable_local_preview = try(each.value.enable_local_preview, null)
#     enable_well_known_secret_masking = try(each.value.enable_well_known_secret_masking, null)
#     github_action_deploy = try(each.value.github_action_deploy, null)
#     manage_state = try(each.value.manage_state, null)
#     protect_from_deletion = try(each.value.protect_from_deletion, null)
#     terraform_smart_sanitization = try(each.value.terraform_smart_sanitization, null)
#     terraform_workflow_tool = try(each.value.terraform_workflow_tool, null)

#     ## HOOKS ##
#     before = {
#         apply = try(each.value.before.apply, null)
#         destroy = try(each.value.before.destroy, null)
#         init = try(each.value.before.init, null)
#         perform = try(each.value.before.perform, null)
#         plan = try(each.value.before.plan, null)
#     }
#     after = {
#         apply = try(each.value.after.apply, null)
#         destroy = try(each.value.after.destroy, null)
#         init = try(each.value.after.init, null)
#         perform = try(each.value.after.perform, null)
#         plan = try(each.value.after.plan, null)
#         run = try(each.value.run, null)
#     }

#     github_enterprise = {
#         namespace = try(each.value.github_enterprise.namespace, null)
#     }
# }
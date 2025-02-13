# locals {
#     exec = {
#         connection = {
#             development = {
#                 type = "ssh"
#                 user = var.VIRTUAL_MACHINE_GLOBAL_USERNAME
#                 private_key = file(var.SSH_PRIVATE_KEY)
#                 host = var.VIRTUAL_MACHINE_DEVELOPMENT_IP_ADDRESS
#                 port = 22
#             }
#         }
#         inline = {
#             kubeconfig = [
#                 "cat <<EOF > /tmp/config",
#                 "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
#                 "EOF",
#                 "mkdir -p /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/",
#                 "cp -p /tmp/config /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
#                 "chown ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}:${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
#                 "rm -rf /tmp/config",
#             ]
#         }   
#     }

#     node_data = {
#         controlplanes = {
#             for idx, cp in var.talos.controlplane : cp.ip_address => {
#                 ip_address = cp.ip_address
#                 hostname = format("talos-cp-%d", idx)
#                 install_disk = "/dev/sda"
#             }
#         }
#         workers = {
#             for idx, wk in var.talos.worker : wk.ip_address => {
#                 ip_address  = wk.ip_address
#                 hostname = format("talos-wk-%d", idx)
#                 install_disk = "/dev/sda"
#             }
#         }
#     }
# }
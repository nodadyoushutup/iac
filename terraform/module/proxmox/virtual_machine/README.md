
# Proxmox Virtual Machine Simple Module

This Terraform module allows you to easily create and manage a simple virtual machine in a Proxmox Virtual Environment.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "virtual_machine" {
  source = "./modules/proxmox/virtual_machine"

  vm_id           = 101
  name            = "my-vm"
  description     = "My Proxmox VM"
  tags            = ["terraform", "ubuntu"]
  node_name       = "pve"
  on_boot         = true
  started         = true
  stop_on_destroy = true
  boot_order      = ["scsi0"]
  disk = {
    datastore_id = "local-lvm"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "scsi0"
    size         = 10
  }
  memory = {
    dedicated = 4096
  }
  cpu = {
    sockets = 1
    cores   = 2
  }
  initialization = {
    ip_config = {
      ipv4 = {
        address = "dhcp"
        gateway = null
      }
      ipv6 = {
        address = "dhcp"
        gateway = null
      }
    }
    user_account = {
      username = "ubuntu"
      password = "ubuntu"
      keys     = []
    }
  }
  network_device = {
    bridge = "vmbr0"
    model  = "e1000e"
  }
}
```

## Inputs

| Name            | Description                                                    | Type           | Default                                 | Required |
|-----------------|----------------------------------------------------------------|----------------|-----------------------------------------|----------|
| `vm_id`         | The ID of the virtual machine.                                  | `number`       | N/A                                     | Yes      |
| `name`          | The name of the virtual machine.                                | `string`       | `"ubuntu"`                              | No       |
| `description`   | A description of the virtual machine.                           | `string`       | `"Virtual machine"`                     | No       |
| `tags`          | Tags associated with the virtual machine.                       | `list(string)` | `["terraform", "ubuntu"]`               | No       |
| `node_name`     | The name of the Proxmox node where the VM will run.             | `string`       | `"pve"`                                 | No       |
| `on_boot`       | Whether the VM should start on boot.                            | `bool`         | `true`                                  | No       |
| `started`       | Whether the VM should be started after creation.                | `bool`         | `true`                                  | No       |
| `stop_on_destroy`| Whether the VM should be stopped when Terraform destroys it.   | `bool`         | `true`                                  | No       |
| `boot_order`    | The boot order of the virtual machine's disks.                  | `list(string)` | `["scsi0"]`                             | No       |
| `disk`          | Configuration for the VM's disk.                                | `object`       | See [Disk Object](#disk-object)         | No       |
| `memory`        | Memory configuration for the VM.                                | `object`       | See [Memory Object](#memory-object)     | No       |
| `cpu`           | CPU configuration for the VM.                                   | `object`       | See [CPU Object](#cpu-object)           | No       |
| `initialization`| Initialization configuration for the VM.                        | `object`       | See [Initialization Object](#initialization-object) | No  |
| `network_device`| Network device configuration for the VM.                        | `object`       | See [Network Device Object](#network-device-object) | No |

### Disk Object

The `disk` object supports the following:

| Name            | Description                                  | Type     | Default                                     | Required |
|-----------------|----------------------------------------------|----------|---------------------------------------------|----------|
| `datastore_id`  | The datastore ID for the VM disk.            | `string` | `"local-lvm"`                               | No       |
| `file_id`       | The file ID for the VM disk.                 | `string` | `"local:iso/jammy-server-cloudimg-amd64.img"` | No       |
| `interface`     | The disk interface.                          | `string` | `"scsi0"`                                   | No       |
| `size`          | The size of the VM disk in GB.               | `number` | `10`                                        | No       |

### Memory Object

The `memory` object supports the following:

| Name        | Description                     | Type     | Default | Required |
|-------------|---------------------------------|----------|---------|----------|
| `dedicated` | The amount of dedicated memory. | `number` | `4096`  | No       |

### CPU Object

The `cpu` object supports the following:

| Name     | Description              | Type     | Default | Required |
|----------|--------------------------|----------|---------|----------|
| `sockets`| The number of CPU sockets.| `number` | `1`     | No       |
| `cores`  | The number of CPU cores.  | `number` | `2`     | No       |

### Initialization Object

The `initialization` object supports the following:

| Name        | Description                             | Type     | Default | Required |
|-------------|-----------------------------------------|----------|---------|----------|
| `ip_config` | IP configuration for the VM.            | `object` | See [IP Config Object](#ip-config-object) | No |
| `user_account` | User account settings for the VM.   | `object` | See [User Account Object](#user-account-object) | No |

#### IP Config Object

The `ip_config` object supports the following:

| Name     | Description                | Type     | Default | Required |
|----------|----------------------------|----------|---------|----------|
| `ipv4`   | IPv4 configuration.         | `object` | See [IPv4 Object](#ipv4-object) | No |
| `ipv6`   | IPv6 configuration.         | `object` | See [IPv6 Object](#ipv6-object) | No |

#### IPv4 Object

The `ipv4` object supports the following:

| Name     | Description           | Type     | Default | Required |
|----------|-----------------------|----------|---------|----------|
| `address`| IPv4 address.          | `string` | `"dhcp"`| No       |
| `gateway`| IPv4 gateway.          | `string` | `null`  | No       |

#### IPv6 Object

The `ipv6` object supports the following:

| Name     | Description           | Type     | Default | Required |
|----------|-----------------------|----------|---------|----------|
| `address`| IPv6 address.          | `string` | `"dhcp"`| No       |
| `gateway`| IPv6 gateway.          | `string` | `null`  | No       |

#### User Account Object

The `user_account` object supports the following:

| Name      | Description               | Type           | Default   | Required |
|-----------|---------------------------|----------------|-----------|----------|
| `username`| The username for the VM.   | `string`       | `"ubuntu"`| No       |
| `password`| The password for the VM.   | `string`       | `"ubuntu"`| No       |
| `keys`    | SSH keys for the user.     | `list(string)` | `[]`      | No       |

### Network Device Object

The `network_device` object supports the following:

| Name   | Description                 | Type     | Default | Required |
|--------|-----------------------------|----------|---------|----------|
| `bridge` | The network bridge to use. | `string` | `"vmbr0"`| No       |
| `model`  | The model of the network device. | `string` | `"e1000e"` | No       |

## Outputs

This module does not have any outputs.

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

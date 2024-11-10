
# FortiGate Firewall Policy Module

This Terraform module allows you to create and manage a firewall policy in a FortiGate device using the FortiOS provider.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "policy" {
  source = "./modules/fortigate/policy"

  action             = "accept"
  logtraffic         = "all"
  name               = "Allow All"
  policyid           = 1
  schedule           = "always"
  wanopt             = "disable"
  wanopt_detection   = "off"
  wanopt_passive_opt = "default"
  wccp               = "disable"
  webcache           = "disable"
  webcache_https     = "disable"
  wsso               = "disable"
  dstaddr = {
    name = "all"
  }
  dstintf = {
    name = "lan"
  }
  service = {
    name = "ALL"
  }
  srcaddr = {
    name = "all"
  }
  srcintf = {
    name = "wan"
  }
}
```

## Inputs

| Name                | Description                                                   | Type   | Default   | Required |
|---------------------|---------------------------------------------------------------|--------|-----------|----------|
| `action`            | The action for the firewall policy (e.g., accept, deny).       | `string`| `"accept"`| No       |
| `logtraffic`        | The logging options for the firewall policy.                  | `string`| `"all"`   | No       |
| `name`              | The name of the firewall policy.                              | `string`| N/A       | Yes      |
| `policyid`          | The ID of the firewall policy.                                | `number`| N/A       | Yes      |
| `schedule`          | The schedule for the firewall policy.                         | `string`| `"always"`| No       |
| `wanopt`            | WAN optimization settings.                                    | `string`| `"disable"`| No       |
| `wanopt_detection`  | WAN optimization detection settings.                          | `string`| `"off"`   | No       |
| `wanopt_passive_opt`| WAN optimization passive optimization settings.               | `string`| `"default"`| No       |
| `wccp`              | Web Cache Communication Protocol settings.                   | `string`| `"disable"`| No       |
| `webcache`          | Web cache settings for the firewall policy.                   | `string`| `"disable"`| No       |
| `webcache_https`    | HTTPS web cache settings for the firewall policy.             | `string`| `"disable"`| No       |
| `wsso`              | Web Single Sign-On (SSO) settings.                            | `string`| `"disable"`| No       |
| `dstaddr`           | Destination address object for the firewall policy.           | `object`| N/A       | Yes      |
| `dstintf`           | Destination interface object for the firewall policy.         | `object`| `{ name = "lan" }` | No |
| `service`           | Service object for the firewall policy.                       | `object`| `{ name = "ALL" }` | No |
| `srcaddr`           | Source address object for the firewall policy.                | `object`| `{ name = "all" }` | No |
| `srcintf`           | Source interface object for the firewall policy.              | `object`| `{ name = "wan" }` | No |

## Outputs

This module does not have any outputs.

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

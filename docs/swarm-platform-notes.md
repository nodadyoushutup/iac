## Swarm platform handling (ARM nodes)

- Several Swarm services specify explicit platforms (`aarch64`, `arm64`) because Raspberry Pi nodes report either order depending on Docker/OS. If the order changes, the Docker provider thinks the service drifted.
- Each module stores the platform list in a `terraform_data.platforms` resource and sets `ignore_changes` on `task_spec.placement.platforms` to keep plans clean while still replacing the service when the list changes (via `replace_triggered_by`).
- Keep the platform list ordered as `aarch64` then `arm64` to match Swarm’s `docker service inspect` output and avoid perpetual plan diffs.
- Services updated: grafana app, dozzle, graphite, prometheus, node exporter, nginx-proxy-manager, jenkins controller, jenkins agent.


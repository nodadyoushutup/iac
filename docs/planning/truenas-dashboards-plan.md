# TrueNAS Dashboards Refresh Plan

Goal: Rebuild all TrueNAS Grafana dashboards to match the Node Exporter style (top stat row, grouped detail rows), support multiple TrueNAS hosts, and fix broken queries/labels.

## Stage 0 – Preparation
- [x] Inventory metrics reference: `examples/truenas_metrics.txt` (generated via `scripts/graphite_inventory.py --base-url http://swarm-cp-0.internal:8081 --prefix truenas.truenas --output examples/truenas_metrics.txt`).
- [x] Confirm Graphite datasource UID: `graphite`.
- [x] Host variable: query `truenas.*`, includeAll=`*`, single-select.
- [x] Disk variable: `$host.disk_ops.*`, regex `/^.*\.disk_ops\.([^.]+)/`, includeAll=`*`, multi-select.
- [x] Identify key metric paths:
  - CPU: `$host.cpu.*.*` (per-core states); `$host.cpu.*_cpuidle.*`; `$host.cputemp.temperatures.*`.
  - RAM/Swap: `$host.system.ram.{used,free,cached,buffers}`; `$host.system.swap.{used,free}`.
  - Disk: `$host.disk_util.*.utilization`; `$host.disk_ops.$disk.{reads,writes}`; `$host.disk_mops.$disk.{reads,writes}`; `$host.disk_qops.$disk.operations`; `$host.disk_backlog.$disk.backlog`; `$host.disk_svctm.$disk.svctm`.
  - Network: only `net_events.*` observed; no octets/errors metrics present in inventory.
  - ZFS/SMART: `truenas.truenas.zfs.*`, `truenas.truenas.smart_log_smart.disktemp.*`.
- [x] Decide per-dashboard top stats and detail rows (see Stage 1 plan).

## Stage 1 – Implementation (per dashboard)
- **Stage 1a – TrueNAS Overview**
  - [x] CPU usage stat formula corrected (non-idle sum / total).
  - [x] RAM used %, Swap used %, Avg disk utilization stats validated.
  - [x] Detail rows render per host/disk (CPU usage by host, Memory usage %, Filesystem utilization, Disk ops by disk).
- **Stage 1b – TrueNAS CPU**
  - [x] Top stats: Max/Avg CPU temp, Avg CPU usage, Avg C0 active (host allValue `*`; queries prefixed with `truenas.$host`; version 8).
  - [x] Detail rows: CPU states by core, Idle residency, CPU temps (alias includes host for multi-host clarity); CPU Usage by Host panel added; CPU core filter removed.
- **Stage 1c – TrueNAS Disk Throughput**
  - [ ] Top stats: Avg disk busy %, Avg throughput (R+W bytes/s), Avg disk latency (svctm), Avg IO wait pressure (or backlog).
  - [ ] Detail rows: Disk busy by node, Throughput by node, Disk ops/merge/queue per disk.
- **Stage 1d – TrueNAS Disk Latency & Queues**
  - [ ] Top stats: Avg svctm, Avg backlog.
  - [ ] Detail rows: Latency by disk (read/write), Backlog by disk, Disk utilization %.
- **Stage 1e – TrueNAS Disk SLA & Sizes**
  - [ ] Top stats: Avg request size, Service time.
  - [ ] Detail rows: SLA metrics restyled as needed.
- **Stage 1f – TrueNAS Extended Disk Ops**
  - [ ] Extended ops/merge/iotime/wait/avg size/discards plus top stats.
- **Stage 1g – TrueNAS SMART & ZFS**
  - [ ] Top stats: Max SMART temp, ARC size %, ARC hit ratio (if available).
  - [ ] Detail rows: SMART temps, ARC/cache metrics, pool state.
- **Stage 1h – TrueNAS Services & Network**
  - [ ] Focus on net_events (carrier/collisions/frames), system clock/IO, NFS activity; top stats TBD.
- **Stage 1i – TrueNAS K3s & Diagnostics**
  - [ ] Align templating/title; add top stat row if meaningful metrics exist.

## Stage 2 – Verification
- [ ] After rebuilding each dashboard, ensure queries render data in Grafana; no raw expression legends.
- [ ] Validate templating: host All applies across hosts; disk filter works.
- [ ] Confirm versions bumped and titles/UIDs match `terraform/module/grafana/config/main.tf`.

## Stage 3 – Apply
- [ ] Run `pipeline/grafana/config.sh --apply` (or Jenkins job) to push dashboard changes.
- [ ] Spot-check in Grafana with host=All and host-specific selections.

## Notes / Findings
- No `node_network_*`-style octet/error metrics under `truenas.*`; network panels may be limited to `net_events.*`.
- CPU usage must use Graphite functions: `diffSeries(constantLine(100), asPercent(sumSeries($host.cpu.*.idle), sumSeries($host.cpu.*.*)))` or grouped per host via `groupByNode`.
- Memory/swap percent should use `asPercent(used, sumSeries(all ram))` and `asPercent(swap.used, sumSeries(swap.*))`.
- Disk utilization available via `$host.disk_util.*.utilization`; operations via `$host.disk_ops.$disk.*`; service time via `$host.disk_svctm.$disk.svctm`; backlog via `$host.disk_backlog.$disk.backlog`.

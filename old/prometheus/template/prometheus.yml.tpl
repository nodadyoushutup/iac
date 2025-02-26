global:
  scrape_interval: 15s
  evaluation_interval: 15s
  
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["${machine_required_docker_ipv4_address}:9090"]

  - job_name: "cadvisor"
    static_configs:
      - targets: ["${machine_required_docker_ipv4_address}:8082"]

  - job_name: "node_exporter"
    static_configs:
      - targets: [
        "${machine_required_docker_ipv4_address}:9100",
        "${machine_required_development_ipv4_address}:9100"
      ]
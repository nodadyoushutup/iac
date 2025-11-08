# Docker Swarm: nodes, labels, and constraints (quick guide)

> Run these on a Swarm **manager** node.

## 1) See your Docker nodes
```bash
# list all nodes in the Swarm
docker node ls

# (optional) quick view with hostname + availability + labels
docker node ls --format 'table {{.ID}}	{{.Hostname}}	{{.Availability}}	{{.ManagerStatus}}'
```

## 2) See what labels a node has
```bash
# show labels for ONE node (replace NODE with ID or hostname from `docker node ls`)
docker node inspect NODE --format '{{ json .Spec.Labels }}'

# pretty-print labels (requires jq)
docker node inspect NODE | jq '.[0].Spec.Labels'

# full human-readable inspect (labels included near the top)
docker node inspect --pretty NODE
```

## 3) Add (or change) a label (e.g., role=cicd)
```bash
# add/update label "role=cicd" on a node
docker node update --label-add role=cicd NODE

# verify
docker node inspect NODE --format '{{ json .Spec.Labels }}'
```

> Notes:
> - Use `--label-rm key` to remove a label.
> - Labels live in `.Spec.Labels`, so updates are done with `docker node update`.

## 4) Use the label in placement constraints

### A) With `docker service create`
```bash
docker service create   --name my-ci-runner   --constraint 'node.labels.role==cicd'   alpine:3.20 sleep 1d
```

### B) In a Compose/Stack file (`docker stack deploy`)
```yaml
# docker-compose.yml
version: "3.8"
services:
  my-ci-runner:
    image: alpine:3.20
    command: ["sleep","1d"]
    deploy:
      placement:
        constraints:
          - node.labels.role==cicd
```
```bash
docker stack deploy -c docker-compose.yml mystack
```

### C) In code (array style), e.g. Pulumi/Terraform/SDKs
```json
{
  "deploy": {
    "placement": {
      "constraints": ["node.labels.role==cicd"]
    }
  }
}
```

## 5) Confirm the constraint is working
```bash
# check where the task is scheduled
docker service ps my-ci-runner --no-trunc

# or for stacks
docker stack ps mystack --no-trunc
```

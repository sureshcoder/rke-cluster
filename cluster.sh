#!/bin/sh

docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-cpu-count 1 \
        --virtualbox-memory 2048 \
        master

docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-cpu-count 2 \
        --virtualbox-memory 2048 \
        node1

docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-cpu-count 2 \
        --virtualbox-memory 2048 \
        node2



MASTER_IP=$(docker-machine ip master)
NODE1_IP=$(docker-machine ip node1)
NODE2_IP=$(docker-machine ip node2)
CLUSTER_NAME=kloud
CONFIG_FILE=cluster.yml
cat > $CONFIG_FILE  << EOF
nodes:
    - address: $MASTER_IP
      user: docker
      role:
        - controlplane
        - etcd
      ssh_key_path: /Users/sureshbabushanmugam/.docker/machine/machines/master/id_rsa
    - address: $NODE1_IP
      user: docker
      role:
        - worker
      ssh_key_path: /Users/sureshbabushanmugam/.docker/machine/machines/node1/id_rsa
    - address: $NODE2_IP
      user: docker
      role:
        - worker
      ssh_key_path: /Users/sureshbabushanmugam/.docker/machine/machines/node2/id_rsa

cluster_name: $CLUSTER_NAME

network:
    plugin: calico
EOF

rke up
# ansible-k3

This is a playbook that allows to install and configure all the nodes in the k3s cluster on Raspberry Pi boards.

This cluster is configuration as follow

![Cluster Design and Ansible workstation](k3s-cluster.jpg)

This configuration is defined in the inventory/hosts.ini file but without the ansible workstation node.

## Inventory Details

The inventory contains all the ip address used on my cluster. In anyone is using my ansible playbook should be replace those with the internal network ip space address.

```
k3s-master ansible_host=192.168.0.14
k3s-slave1 ansible_host=192.168.0.13 
k3s-slave2 ansible_host=192.168.0.10 
k3s-slave3 ansible_host=192.168.0.12 

[master]
k3s-master

[slave]
k3s-slave[1:3]

[all:vars]
ansible_connection=ssh
ansible_user=pi
ansible_ssh_pass=raspberry
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
cluster_dns=192.168.0.1 8.8.8.8
cluster_secret=S8p3r53cr3t
```


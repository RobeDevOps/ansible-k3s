# ansible-k3: Kubernetes Lighweight Cluster with Ansible automation

This playbook sets up a k3s cluster on Raspberry Pi boards.

Credits and many thanks to
- [Rancher](https://rancher.com/) the creators of [k3s](https://k3s.io),
- [alexellis](https://github.com/alexellis) for [k3sup](https://k3sup.dev/),
- [RobeDevOps](https://github.com/RobeDevOps) for [ansible-k3s](https://github.com/RobeDevOps/ansible-k3s) which this is a fork of and last, not least
- [itwars](https://github.com/itwars) for the inspiring [playbook](https://github.com/rancher/k3s/tree/master/contrib/ansible)
-

This cluster is configured as follows

![Cluster Design and Ansible workstation](k3s-cluster.jpg)

This configuration is defined in the inventory/hosts.ini file but without the ansible workstation node.

SD Flash Tool
------------------
To Flash OS images to SD cards I used [balenaEtcher](https://www.balena.io/etcher/).
Another way is to use GParted to format an SD-Card and deflate NOOBS archive onto it.

Raspbian image
------------------
Downloaded the [Raspbian Lite Latest](https://downloads.raspberrypi.org/raspbian_lite_latest)
Please have a look at the [Raspbian Documentation](https://github.com/raspberrypi/documentation)

Playbook Details
=================
This playbook consist of roles executing the following main functions:

- On master and slave systems
  - When deploying to Raspbian
    - Enables cgroups 'cpu' + 'memory' in /boot/cmdline.txt
    - Disable the 'dphys-swapfile' service in systemd
  - Creates 'k3s' group and user with passwordless sudo and ssh public key login
  - Changes the configured hostnames and network configuration with static IPv4
- Only on localhost
  - Install [k3sup setup](https://get.k3sup.dev) script
    - Then install [k3sup](https://k3sup.dev) binary
  - Create [k3s](https://k3s.io) cluster (requires 'cluster_secret' variable)
  - Configure proper 'kubeconfig' to instantly enable kubectl and k9s ;o)

For more details see the roles README.md files.


Inventory details and example
-----------------
Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

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

Playbook example
-------------------
```
---
- hosts: master:slave
  gather_facts: yes
  become: yes
  roles:
    - etc_config
    - container_features
    - dphys_swapfile
    - bootstrap_k3s

- hosts: master
  gather_facts: yes
  become: yes
  roles:
    - { role: k3s_master, tags: ['master'] }

- hosts: slave
  gather_facts: yes
  become: yes
  roles:
    - { role: k3s_slave, tags: ['slave'] }
```

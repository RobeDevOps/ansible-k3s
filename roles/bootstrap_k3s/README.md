bootstrap_k3s
=========

This role only download the [k3s binary](https://github.com/rancher/k3s/releases/download/v0.2.0/k3s-armhf) for all the node in the cluster.
This role is required for all the nodes.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- hosts: master:slave
  roles:
      - bootstrap_k3s
```

# Portworx on AWS DR and Bubble Test

This pattern uses Portworx and AAP to automate the creation of a DR backup of the Boutique
chart in a secondary OpenShift cluster as well as including the ansible job to spin up
and tear down a bubble test environment to ensure the validity of the backed up data
without disrupting regular DR migrations between the primary and secondary cluster.

## Prerequisites

Before you can use this pattern you will need:

1. Two AWS OpenShift clusters.
2. AWS credentials with privileges for setting IAM policies on EC2 instances and updating EC2 security groups.
3. A Portworx Enterprise DR License
4. [An AAP manifest file](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/installing_on_openshift_container_platform/assembly-gateway-licensing-operator-copy#assembly-aap-obtain-manifest-files)
5. [An automation hub token](https://console.redhat.com/ansible/automation-hub/token)
6. [A Podman installation](https://podman.io/docs/installation)

## Updating the pattern secrets

First, you'll need to copy [the secrets template](./values-secret.yaml.template) to your home directory with the
correct name:

```bash
cp values-secret.yaml.template ~/values-secret-portworx-dr.yaml
```

Update the `aws-creds` secret with AWS credentials with the requisite privileges for updating EC2 nodes and their
security groups. This is necessary because the worker nodes of your clusters will not have all the ports open
and permissions needed by Portworx by default.

Update the `portworx` secret with your Portworx Enterprise DR license. You can provide a path, like in the template,
or a value directly. Just make sure there's no extra spaces or newlines in your license or Portworx will fail to
recognize it.

In the `kubeconfigs` secret, add your local paths to the primary and secondary cluster kubeconfigs.

Update the `aap-manifest` and `automation-hub-token` secrets after following along the documentation in
[the Prerequisites section](#prerequisites).

## Installing this Pattern

Export the `KUBECONFIG` environment variable to point to the path of your primary cluster's kubeconfig:

```bash
export KUBECONFIG="/path/to/primary/cluster/kubeconfig"
```

Then, all you need to do is install the pattern itself with the command below:

```bash
./pattern.sh make install
```

The pattern will automatically add your secondary cluster via ACM and set up the async Portworx cluster pairing
for the boutique namespace. A migration schedule will also be started with an interval of 5 minutes. This whole process can take 30 minutes or more.

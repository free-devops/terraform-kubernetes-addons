# terraform-kubernetes-addons


## About

Provides various addons that are often used on Kubernetes with AWS
It can be used with existing [EKS](https://github.com/terraform-aws-modules/terraform-aws-eks.git) terraform module
Follows clusterfrak-dynamics [terraform-kubernetes-addons](https://github.com/clusterfrak-dynamics/terraform-kubernetes-addons.git) approach


## Main features

* Common addons with associated IAM permissions if needed:
  * [kubernetes-external-secrets](https://github.com/godaddy/kubernetes-external-secrets.git): external secret management systems
  * [filebeat](https://github.com/elastic/beats.git): open source file harvester
  * [metricbeat](https://github.com/elastic/beats.git): Metricbeat fetches a set of metrics
  * [wave/pusher](https://github.com/pusher/wave.git): Kubernetes configuration tracking controller

## Requirements

* [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* [Terragrunt](https://github.com/gruntwork-io/terragrunt#install-terragrunt)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [helm](https://helm.sh/)
* [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)

## Documentation

User guides, feature documentation and examples are available [here](https://clusterfrak-dynamics.github.io/teks/)

## IAM permissionsww

This module can use either [IRSA](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/) which is the recommanded method or [Kiam](https://github.com/uswitch/kiam).

## About Kiam

Kiam prevents pods from accessing EC2 instances IAM role and therefore using the instances role to perform actions on AWS. It also allows pods to assume specific IAM roles if needed. To do so `kiam-agent` acts as an iptables proxy on nodes. It intercepts requests made to EC2 metadata and redirect them to a `kiam-server` that fetches IAM credentials and pass them to pods.

Kiam is running with an IAM user and use a secret key and a access key (AK/SK).

### Addons that require specific IAM permissions

Some addons interface with AWS API, for example:

* `external-secrets`

## Terraform docs

### Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | n/a |
| http | n/a |
| kubectl | n/a |
| kubernetes | n/a |
| random | n/a |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws | AWS provider customization | `any` | `{}` | no |
| external-secrets | Customize external-secrets chart, see `external-secrets.tf` for supported values | `any` | `{}` | no |
| pusher-wave | Customize external-secrets chart, see `pusher-wave.tf` for supported values | `any` | `{}` | no |
| filebeat | Customize filebeat chart, see `filebeat.tf` for supported values | `any` | `{}` | no |
| metricbeat | Customize external-secrets chart, see `metricbeat.tf` for supported values | `any` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| example_output | n/a |


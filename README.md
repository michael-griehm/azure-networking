# Azure Networking

This repo contains the core hub and spoke network shared service for my Azure Subscription.

## Workloads Deployed

- Delta Lakehouse

## Used Address Ranges

- Hub: 10.0.0.0/16
  - 10.0.0.0 thru 10.0.255.255
  - 65,536
  - Subnets:
    - Github Self-Hosted Runners: 10.0.1.0/24
      - 10.0.1.0 thru 10.0.1.255
      - 256
    - Jumpboxes: 10.0.2.0/24
      - 10.0.2.0 thru 10.0.2.255
      - 256
- Delta Lakehouse Spoke: 10.1.0.0/16
    - 10.1.0.0 thru 10.1.255.255
    - 65,534
    - Subnets:
      - Databricks Public: 10.1.0.0/24 
        - 10.1.0.0 thru 10.1.0.255
        - 256
      - Databricks Private: 10.1.1.0/24 
        - 10.1.1.0 thru 10.2.1.255
        - 256
      - Storage Private Endpoints: 10.1.2.0/24 
        - 10.1.2.0 thru 10.1.2.255
        - 256

## References

- [Create a hub and spoke hybrid network topology in Azure using Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/hub-spoke-introduction)
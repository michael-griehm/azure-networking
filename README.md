# Azure Networking

This repo contains the core hub and spoke network shared service for my Azure Subscription.

## Workloads Deployed

- Delta Lakehouse

## Used Address Ranges

- Hub: 10.0.0.0/16
  - 10.0.0.0 thru 10.0.255.255
  - 65,536
- Delta Lakehouse Storage Spoke: 10.1.0.0/24
  - 10.1.0.0 thru 10.1.0.255
  - 256
  - Subnets
    - Private Endpoint: 10.1.0.0/25
      - 10.1.0.0 thru 10.1.0.127
      - 128
- Github Self-Hosted Runners: 10.1.1.0/24
  - 10.1.1.0 thru 10.1.1.255
  - 256
  - Subnets
    - Ubuntu: 10.1.1.0/25
      - 10.1.1.0 thru 10.1.1.127
      - 128
- Azure Bastion Hosts: 10.1.2.0/24
  - 10.1.2.0 thru 10.1.2.255
  - 256
  - Subnets
    - Bastion: 10.1.2.0/25
      - 10.1.2.0 thru 10.1.2.127
      - 128
- Delta Lakehouse Databricks Spoke
  - 10.2.0.0/16
    - 10.2.0.0 thru 10.2.255.255
    - 65,534
    - Subnets:
      - Databricks Public: 10.2.0.0/24 
        - 10.2.0.0 thru 10.2.0.255
        - 256
      - Databricks Private: 10.2.1.0/24 
        - 10.2.1.0 thru 10.2.1.255
        - 256

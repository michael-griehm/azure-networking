# Azure Networking

This repo contains the core hub and spoke network shared service for my Azure Subscription.

## Hub and Spoke Network Architecture

A hub and spoke topology is a way to isolate workloads while sharing common services. These services include identity and security. The hub is a virtual network (VNet) that acts as a central connection point to an on-premises network. The spokes are VNets that peer with the hub. Shared services are deployed in the hub, while individual workloads are deployed inside spoke networks.

### The Hub Network

The hub of this network topology will contain the Shared Services of:

- GitHub Self Hosted Runners
- Jumpboxes for private network access

### The Spoke Workload Networks

The following are the spoke workload networks:

- Delta Lakehouse Workload

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

## The Self Hosted Github Runner

The github self hosted runner is a virtual machine using the operation system of `Ubuntu 20.04 LTS`.

Below is the commands used to install the runner and other needed software.

### Install GitHub Runner

Download

    mkdir actions-runner && cd actions-runner

    curl -o actions-runner-linux-x64-2.296.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.296.1/actions-runner-linux-x64-2.296.1.tar.gz
    
    echo "bc943386c499508c1841bd046f78df4f22582325c5d8d9400de980cb3613ed3b  actions-runner-linux-x64-2.296.1.tar.gz" | shasum -a 256 -c
    
    tar xzf ./actions-runner-linux-x64-2.296.1.tar.gz

Configure

    ./config.sh --url https://github.com/michael-griehm/azure-delta-lakehouse --token AXFBR4Q722AXT2TWP5MLLBTDC6JM2

    ./run.sh

### Install Azure CLI

    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

### Install Unzip

    sudo apt install unzip

### Install Nodejs

    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

Might need to use the latest in the future.

    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

## The Jumpbox

The jumpbox is a virtual machine using the operation system of `Windows 2019 Datacenter`.

Below are the commands executed against the virtual machine.

### Install Chrome

    $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

## References

- [Create a hub and spoke hybrid network topology in Azure using Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/hub-spoke-introduction)

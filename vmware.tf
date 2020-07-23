provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "datacenter-1"
}

data "vsphere_datastore" "datastore" {
  name          = "Datastore-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi_host" {
  name          = "vmware.esxihost"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "DPortGroup-network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "centos7-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

terraform {
  backend "remote" {
    organization = "company name"

    workspaces {
      name = "terraform"
    }
  }
}

resource "vsphere_virtual_machine" "vm" {
  name                        = "terraform-vmware-vm"
  resource_pool_id            = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id                = data.vsphere_datastore.datastore.id
  wait_for_guest_net_routable = false
  wait_for_guest_net_timeout  = 0
  num_cpus                    = 2
  memory                      = 1024
  guest_id                    = data.vsphere_virtual_machine.template.guest_id
  scsi_type                   = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}

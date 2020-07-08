provider "openstack" {
  user_name   = "sunilka"
  tenant_name = "webapps-project"
  password    = "Ellucian1234#"
  auth_url    = "https://iadosvip01.ece.ellucian.com:5000/v3"
  tenant_id   =  "78e00e3a402a4d5e8b50f593e92db117"
  region      = "iadprod"
  user_domain_name    =   "Corp"
  project_domain_id   =   "4fbe9bec195c4f4c85dbb68d7c529088"
}

resource "openstack_compute_instance_v2" "terraform-vm" {

  name            = "terraform-provisioned-vm"
  count =         1
  image_id        = "7fcd7e2a-7dba-437d-b57f-f368a97ef476"
  flavor_id       = "3"
  key_pair        = "mykey"
  security_groups = ["default"]

  network {
    name = "webapps-network"
  }
}

variable "firewalls" {
  default = {
      maestro-fw1  = {
        interfaces = [{
          name = "maestro-fw1-mgmt"
          index = "0"
          source_dest_check = true
          subnet_name = "management"
          nsg = "mgmt_x"
          private_ip_address_allocation = "dynamic"
          pip = {
            name = "mgmt-PIP"
            sku = "standard"
          }
          primary = true
        }, 
        {
          name = "maestro-fw1-untrust"
          index = "1"
          source_dest_check = false
          subnet_name = "public"
          nsg = "mgmt_x"
          private_ip_address_allocation = "dynamic"
          pip = {
            name = "mgmt-PIP"
            sku = "standard"
          }
          primary = true
        }, {
          name = "maestro-fw2-untrust"
          index = "2"
          subnet_name = "private"
          nsg = "mgmt_x"
          private_ip_address_allocation = "dynamic"
          pip = {
            name = "mgmt-PIP"
            sku = "standard"
          }
          primary = true
        }]
    }
}

variable "eni_ids" {
  default = {
      maestro-fw1-mgmt = "eni-12345"
      maestro-fw1-untrust = "eni-12345" 
      maestro-fw2-untrust = "eni-12346"
  }
} 

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "fw_key_name" {
  description = "SSH Public Key to use w/firewall"
  default     = ""
}

# Firewall version for AMI lookup

variable "fw_version" {
  description = "Select which FW version to deploy"
  default     = "9.0.5"
  # Acceptable Values Below
}

# License type for AMI lookup
variable "fw_license_type" {
  description = "Select License type (byol/payg1/payg2)"
  default     = "byol"
}

# Product code map based on license type for ami filter

variable "fw_license_type_map" {
  type = map(string)
  default = {
    "byol"  = "6njl1pau431dv1qxipg63mvah"
    "payg1" = "6kxdw3bbmdeda3o6i1ggqt4km"
    "payg2" = "806j2of0qy5osgjjixq9gqc6g"
  }
}

variable "fw_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "m5.xlarge"
}

variable "bootstrap_profile" {
  default = ""
}

variable "bootstrap_s3bucket" {
  default = []
}


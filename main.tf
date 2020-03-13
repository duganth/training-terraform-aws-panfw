#### PA VM AMI ID Lookup based on license type, region, version ####

data "aws_ami" "pa-vm" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name = "product-code"
    values = [var.fw_license_type_map[lookup(each.value, "fw_license_type", null) != null ? each.value.fw_license_type: var.fw_license_type]]
  }


  filter {
    name   = "name"
    values = ["PA-VM-AWS-${lookup(each.value, "fw_version", null) != null ? each.value.fw_version: var.fw_version}*"]
  }
}

#### Create the Firewall Instances ####

resource "aws_instance" "pa-vm-series" {
  for_each                             = var.firewalls
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = data.aws_ami.pa-vm[each.value.name].id
  instance_type                        = lookup(each.value, "fw_instance_type", var.fw_instance_type)
  tags = merge(
    {
      "Name" = format("%s", each.key)
    }
  )

  root_block_device {
    delete_on_termination = true
  }

  key_name   = lookup(each.value, "fw_key_name", var.fw_key_name)
  monitoring = false
  dynamic "network_interface"{
    for_each = each.value.interfaces
    content{
      device_index = network_interface.value.index
      network_interface_id = var.eni_ids[network_interface.value.name]
    }
  }
}

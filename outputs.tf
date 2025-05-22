output "ec2_instance_ids" {
  value = {
    for k, mod in module.ec2_instances :
    k => mod.instance_id
  }
}

output "ec2_public_ips" {
  value = {
    for k, mod in module.ec2_instances :
    k => mod.public_ip
  }
}

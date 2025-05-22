variable "instances" {
  type = map(object({
    ami            = string
    instance_type  = string
    subnet_index   = number
    instance_name  = string
  }))
}

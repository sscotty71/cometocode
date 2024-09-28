variable "filename" {
  type = string
}

variable "template_file" {
  type = string
}

variable "vms" {
  type = list(map(any))
}
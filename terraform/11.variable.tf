<<<<<<< HEAD
variable "instance_ami_type" {
  description = "The Image ID to be used"
  type        = string
  default     = "ami-03bb6d83c60fc5f7c"
}

variable "region" {
  description = "The regions used"
  type        = string
  default     = "ap-south-1"

}

variable "instance_type_bastion" {
  description = "Instance type for the dev instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_master" {
  description = "Instance type for the test instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_lb" {
  description = "Instance type for the prod instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_worker" {
  description = "Instance type for the test instance"
  type        = string
  default     = "t2.medium"
}
variable "instance_type_nfs" {
  description = "The instance type for the NFS server"
  type        = string
  default     = "t2.medium"
}
variable "master_instance_count" {
  type        = number
  default     = 3
  description = "Number of master instances to create"
}

variable "worker_instance_count" {
  type        = number
  default     = 3
  description = "Number of worker instances to create"
}
=======
variable "instance_ami_type" {
  description = "The Image ID to be used"
  type        = string
  default     = "ami-03bb6d83c60fc5f7c"
}

variable "region" {
  description = "The regions used"
  type        = string
  default     = "ap-south-1"

}

variable "instance_type_bastion" {
  description = "Instance type for the dev instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_master" {
  description = "Instance type for the test instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_lb" {
  description = "Instance type for the prod instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_worker" {
  description = "Instance type for the test instance"
  type        = string
  default     = "t2.medium"
}
variable "instance_type_nfs" {
  description = "The instance type for the NFS server"
  type        = string
  default     = "t2.medium"
}
variable "master_instance_count" {
  type        = number
  default     = 3
  description = "Number of master instances to create"
}

variable "worker_instance_count" {
  type        = number
  default     = 3
  description = "Number of worker instances to create"
}
>>>>>>> 8268c6b (added files)

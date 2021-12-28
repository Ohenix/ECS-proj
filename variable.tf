
variable "region" {
  type = string
  description = "name of region"
  default = "eu-west-2"
}

variable "main_cidr" {
  type        = string
  description = "cidr for main Vpc"
  default     = "10.0.0.0/16"
}

variable "public_cidr1" {
  type        = string
  description = "cidr for public subnet1"
  default     = "10.0.1.0/24"
}

variable "public_cidr2" {
  type        = string
  description = "cidr for public subnet2"
  default     = "10.0.2.0/24"
}


variable "private_cidr1" {
  type        = string
  description = "cidr for private subnet1"
  default     = "10.0.3.0/24"
}


variable "private_cidr2" {
  type        = string
  description = "cidr for private subnet2"
  default     = "10.0.4.0/24"
}

variable "destination_cidr"{
  type = string
  description = "cidr block for destination"
  default = "0.0.0.0/0"
  
  
}
/*variable "Zone" {
    description = "availabilty zones"
    type = list(string)
    default = ["eu-west-2a", "eu-west-2b"]  
}*/
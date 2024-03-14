# Make a change according to your VPC ID
variable "sm_vpc_id" {
  default = "vpc-5526172f"
}

# Make a change according to your Subnet IDs
variable "sm_subnets" {
  default = ["subnet-a12a9fec","subnet-9e7492c1"]
}

# Make a change according to your Security Groups
variable "sm_sec_group" {
  default = "sg-d1ace6fa"
}

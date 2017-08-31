variable "user_data" { default = "userdata.txt" }
variable "key_name" { description = "The EC2 key pair name" }
variable "db_instance_size" { description = "EC2 instance size for DB instance types" }
variable "vpc_id" { description = "VPCs are pre-provisioned outside of Terraform's control. Provide the VPC ID to use." }
variable "subnet_id" { description = "Subnets are pre-provisioned outside of Terraform's control. Provide the Subnet ID to use." }
variable "cloud_account_name" { description = "AWS Cloud Account name" }
variable "environment_number_range" { description = "Environment range start number" }
variable "chef_server_url" {}
variable "chef_environment" { description = "Chef environment" }
variable "chef_user_name" {}
variable "chef_user_key" {}
variable "chef_run_list" {}
variable "admin_password" {}
variable "octopus_db_name" {}
variable "octopus_db_username" {}
variable "octopus_db_password" {}
variable "octopus_server_instance_sg_name" {}
variable "octopus_skip_final_snapshot" {}
variable "octopus_final_snapshot_identifier" {}
variable "octopus_rds_instance_size" {}
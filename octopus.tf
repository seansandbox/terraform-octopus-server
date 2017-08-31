terraform {
  backend "atlas" {
    name    = "umgdevops/octopus-server-uat"
    address = "https://atlas.hashicorp.com"
  }
}

module "server" {
    source = "github.com/seansandbox/terraform-example-modules//server"
    number_of_instances = 1
    cloud_account_name = "${var.cloud_account_name}"
    ec2_instance_guest_os_type = "WV"
    hosted_application = "APP"
    environment_number_range = "${var.environment_number_range}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.db_instance_size}"
    key_name = "${var.key_name}"
    vpc_id = "${var.vpc_id}"
    chef_server_url = "${var.chef_server_url}"
    chef_environment = "${var.chef_environment}"
    chef_user_name = "${var.chef_user_name}"
    chef_user_key = "${var.chef_user_key}"
    chef_run_list = "${var.chef_run_list}"
    admin_password = "${var.admin_password}"
    server_instance_sg_name = "${var.octopus_server_instance_sg_name}"
    instance_remote_data = "${aws_db_instance.octopus_rds_instance.endpoint};${var.octopus_db_username};${var.octopus_db_password}"
}

resource "aws_db_instance" "octopus_rds_instance" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "sqlserver-ex"
  engine_version            = "13.00.4422.0.v1"
  instance_class            = "${var.octopus_rds_instance_size}"
  identifier                = "${var.octopus_db_name}"
  username                  = "${var.octopus_db_username}"
  password                  = "${var.octopus_db_password}"
  db_subnet_group_name      = "default"
  parameter_group_name      = "default.sqlserver-ex-13.0"
  skip_final_snapshot       = "${var.octopus_skip_final_snapshot}"
  final_snapshot_identifier = "${var.octopus_final_snapshot_identifier}"
  publicly_accessible       = "true"
  vpc_security_group_ids    = ["${aws_security_group.octopus_rds_sg.id}"]
}

resource "aws_security_group" "octopus_rds_sg" {
  name        = "${var.octopus_db_name}SG"
  description = "Provisioned by terraform"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.octopus_db_name}SG"
  }

  # MSSQL access from anywhere
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server_address" { value = "${module.server.server_address}" }
output "public_ip" { value = "${module.server.public_ip}" }
output "instance_name" { value = "${module.server.name}" }
output "db_endpoint" { value = "${aws_db_instance.octopus_rds_instance.endpoint}" }
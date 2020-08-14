variable "vpc_id" {
  type        = string
  description = "The VPC id for the VPC to deploy in"
}

variable "zone" {
  default     = ""
  description = "The R53 zone for your DNS records"
}

variable "subdomain" {
  type        = string
  description = "The subdomain to get to Cachet"
}

variable "ses_region" {
  default     = "us-east-1"
  description = "The zone for the ses endpoint you want to use"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets of your vpc"
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets of your vpc"
}

variable "postgres_version" {
  description = "The version number to use for the postgres databases"
  default     = "9.5.15"
}

variable "backup_retention" {
  default = 7
}

variable "db_instance_type" {
  description = "The instance type for the db server (db.m5.large, db.r5.xlarge, etc...)"
  default     = "db.t3a.small"
}

variable "db_storage_size" {
  description = "The size of the disk for the DB"
  default     = 10
}

variable "cachet_db_pass" {
  type = string
}

variable "instance_type" {
  default = "t3a.small"
}

variable "debug" {
  default = true
}

variable "app_key" {
  type        = string
  description = "The app key for Cachet. See Cachet docs for more info"
}

variable "ssh_key" {
  type        = string
  description = "The name of the ssh key to use for ssh access to the instance"
}

variable "personal_cidr_ranges" {
  type        = list(string)
  description = "The cidr address to use for allowing ssh access to the instance and database"
}

variable "admin_email" {
  default     = "admin@example.com"
  description = "The email address for the administrator of the page (cachet will send email from this address)"
}

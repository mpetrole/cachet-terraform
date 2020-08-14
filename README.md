This will deploy an alb, an ec2 instance, ses configuration, and related infrastructures for running a Cachet installation. The EC2 will be deployed with userdata that will set up docker, pull the cachet container, and run it.  

You will need to pass some vars to terraform: app_key and cachet_db_pass. app_key is the hashed key to encrypt your cachet install, it can any sha256 hashed value. cachet_db_pass is the password that you want the cachet db to use. These can be set in terraform.tfvars but I don't recommend it for security reasons.  

Also make sure that you set the values in terraform.rfvars to your needs.

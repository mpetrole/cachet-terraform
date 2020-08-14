resource "aws_kms_key" "key" {
  description         = "Cachet Encryption Key"
  enable_key_rotation = true
}

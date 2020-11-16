variable "region" {
  default = "eu-west-1"
}
variable "bucket_name" {
  default = "bucket-for-terraform-test"
}
variable "ec2_key_name" {
  default = "id_rsa"
}
variable "ec2_public_key" {
  default = "ssh-rsa ..."
}
variable "ec2_private_key_file_path" {
  default = "~/.ssh/id_rsa"
}
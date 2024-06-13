resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids
  key_name = var.key_name

  user_data = templatefile("./scripts/user_data.sh",{})

  tags = {
    Name = "Terraform_ec2"
  }
}

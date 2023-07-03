resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name               = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  tags = {
    "Name"      = "${var.name}-andrii",
    "andriitag" = "true",
  }

  volume_tags = {
    "Name"      = "${var.name}-andrii",
    "andriitag" = "true",
  }

  connection {
    user = "ubuntu"
    type = "ssh"
    #     private_key = "${file("~/.ssh/id_rsa")}"
    private_key = file(var.key_path)
    host        = self.public_ip
  }

  /* provisioner "remote-exec" {
    script = "${path.module}/scripts/provision.sh"
  }
 */
}


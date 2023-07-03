# SSH key for provision

variable "key_path" {
  description = "Local SSH key path (public part)"
}

variable "name" {
  description = "Name of the key"
}

resource "aws_key_pair" "sshkey" {
  key_name = var.name
  #   public_key = "${file("~/.ssh/id_rsa.pub")}"
  public_key = file(var.key_path)
}

output "key_id" {
  value = aws_key_pair.sshkey.id
}

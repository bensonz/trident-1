############################
# Amazon EC2 machines setup
############################
resource "aws_instance" "ec2" {
  count                       = "${var.count}"

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"

  root_block_device = {
    volume_type = "gp2"
    volume_size               = "${var.volume_size }"
  }

  vpc_security_group_ids      = ["${var.sg_id}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  iam_instance_profile        = "${var.iam_profile_name}"
  key_name                    = "${var.ssh_key_name}"

  # Simply way to make sure ec2 instances are ssh connectable
  connection {
     type = "ssh",
     user                     = "${var.ssh_user_name}",
     private_key              = "${file(var.ssh_private_key_path)}"
  }

  # This provisioner is used to ensure SSH connection to our machines
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World'"
    ]
  }

  tags {
    Name = "k8s-${var.type}-${count.index}"
  }
}

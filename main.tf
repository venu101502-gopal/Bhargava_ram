provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "foo" {
  ami                         = "ami-0f9de6e2d2f067fca"
  instance_type               = "t2.micro"
  key_name                    = "Blue-key"  # Ensure this key exists in us-east-2
  subnet_id                   = "subnet-0987dcdded8589a51"
  vpc_security_group_ids      = ["sg-054788bd6d2edbc82"]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  dynamic "ebs_block_device" {
    for_each = {
      "/dev/xvdf" = 10,
      "/dev/xvdg" = 20,
      "/dev/xvdh" = 30
    }

    content {
      device_name           = ebs_block_device.key
      volume_size           = ebs_block_device.value
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1

    mkfs.xfs -f /dev/xvdf
    mkfs.xfs -f /dev/xvdg
    mkfs.xfs -f /dev/xvdh

    mkdir -p /home/ibtbackup /opt/sutisoftapps /var/lib/mysql

    mount /dev/xvdf /home/ibtbackup
    mount /dev/xvdg /opt/sutisoftapps
    mount /dev/xvdh /var/lib/mysql

    echo "$(blkid -s UUID -o value /dev/xvdf) /home/ibtbackup xfs defaults,nofail 0 2" >> /etc/fstab
    echo "$(blkid -s UUID -o value /dev/xvdg) /opt/sutisoftapps xfs defaults,nofail 0 2" >> /etc/fstab
    echo "$(blkid -s UUID -o value /dev/xvdh) /var/lib/mysql xfs defaults,nofail 0 2" >> /etc/fstab
  EOF

  tags = {
    Name = "Bhrgava_Ram"
  }
}

output "venugopal_public_ip" {
  value = aws_instance.foo.public_ip
}

output "venugopal_private_ip" {
  value = aws_instance.foo.private_ip
}

output "venugopal_key_name" {
  value = aws_instance.foo.key_name
}

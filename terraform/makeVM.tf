resource "proxmox_vm_qemu" "cloudinit-example" {
  vmid        = 0 
  name        = "test-terraform0"
  target_node = "pve0"
  agent       = 1
  cores       = 2
  memory      = 1024
  boot        = "order=scsi0;net0" # has to be the same as the OS disk of the template
  clone       = "debian12-cloudinit" # The name of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  # /var/lib/vz/snippets/qemu-guest-agent.yml
  # cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" 
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "Enter123!"
  sshkeys    = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtGZSB6WDLLTFTjitudd5WmZq/YiTUNif8rstbXtUL0frcq6LgbaJrqg6o7iXZQgMRDaB8MGEELt1C+F9Qz8YEdZWkZfIJlocIbJwNppS0mXSavK6lSCuCYh/40FX4UdvQSCDD99w5ZGMob0RuPAxKy6CDva4AHpDyu+sue0JHn6i3GIf/Nv8uHWcrW20vFA4nLBCCd9IwGF7Ih2ctEHUPNxkCN28Fjs1/t9D8+tMFRNDnNsoV3YfL5HnJnOmS5KmwChju7k+HZhMusA9v+9HHwuuwIFEWj/UMJSTJdrj95V/SOTRLc2Jb83lTpkAf8OnxgHtb9SFpY7lWRGX6kKWswBetcH9fH7Zr+YpjKRexHxuQPRiF4KVZt6xym2+NgiHqW0ksvU1zEZD8j6NpbvEs5tyV3+a2g5rDOx1V2hJsuIvrvgFdh3ftD+vkJmoKpUgpROHt6aTYUDcHPJok2BcDkgwurEDdk7fab9aIcGxSUY69NhaY7NGFoNo71FYd2G5FW9BLuY8f1i9XrgKsFXORG87KZ6D0eDkxmilra+mEH6ERuHZ2GzXb745RIzFSPMrqFYUX8Z5wiNnsiTL9BhAwSJHByk+zI4lvEGbnsvMJL/lVpetnf2vACX9rq+lmAHnSf1ulTzLwH0zJXnCfOK7XcPEbY+WkujrM8iIvmaeTnQ== root@pve0
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCk+GOCwpqwiHmIVYPeNLrjo/KuyQBaLRu3e11k1PuHAOTJNa7XP87rkpHSnOBuf6KC2cB2VXSX6pxwZXuFlt1YC0ox/XmcAClClGZRNgJtZYgNWXbihNOYzYTyydIMAUWJIf0XZBpIDDKFC8ekZOyiO5GWrnM32DcAWYQmqqGpsxHnuiWGG3TWbD8AjkiJMw0/Rjzlm/msXRltrHSFYhJ+FsiYbvckl1wrgy3FDdHptkVTFVHdYjjSxdZpJFFi0KQ3pZP1YdZeynxDUNFtdZQ1ghstlTMcLNBpnRTY39KAeFvfCKpw5uuhA7nueN7fCbY+adfc9bzQRaMxjM4hmbDFnXNvIx9pK5hMj2KMXUzl0T50o4f1TwVzCRouR+3d3Q+BjjzN1Tl0E6omaCfBWPC8OnAIdzhlt/ioXjoYAqReFkianxu7zamaQMzxL3vpVsxv3EK6Tj7jkJ6UXPWx8x5SEhkvg1vRKHE3lQ70II6EWYD1jJg2H9U9KyGUZxL+uKBKW5rE181IjAJWtlXL4VdzfB6DTtx2TBlVF+MmcHyF2LSFK/lSwPUoLlMhZNVYWKlC8mip4KkDQfYnVFI/K8FQdcZMzpxOLvi2tbqMBJIChCks7Wbphml1ENozq9yYQAMzw/d2FVKvP1O93wPBx6zwTrSF/fwD5gMTswez/9JorQ== crdeveloper@outlook.com
  EOF
  
  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "local-lvm"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = "2G" 
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"
    tag = 2
    ipconfig0  = "ip=dhcp"
  }
}

terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.2.243:8006/api2/json"
  pm_api_token_id = "SA-terraform@pam!SA_Terraform_Token"
  pm_api_token_secret = "9c069376-95a5-4f86-931e-3897a4e1584f"
  pm_tls_insecure = true
}

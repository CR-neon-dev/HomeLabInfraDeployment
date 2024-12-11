resource "proxmox_vm_qemu" "cloudinit-example" {
  vmid        = 100
  name        = "test-terraform0"
  target_node = "pve0"
  agent       = 1
  cores       = 2
  memory      = 1024
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = "debian12-cloudinit" # The name of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=dhcp,gw=192.168.0.1,ip6=dhcp"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "Enter123!"
  sshkeys    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtGZSB6WDLLTFTjitudd5WmZq/YiTUNif8rstbXtUL0frcq6LgbaJrqg6o7iXZQgMRDaB8MGEELt1C+F9Qz8YEdZWkZfIJlocIbJwNppS0mXSavK6lSCuCYh/40FX4UdvQSCDD99w5ZGMob0RuPAxKy6CDva4AHpDyu+sue0JHn6i3GIf/Nv8uHWcrW20vFA4nLBCCd9IwGF7Ih2ctEHUPNxkCN28Fjs1/t9D8+tMFRNDnNsoV3YfL5HnJnOmS5KmwChju7k+HZhMusA9v+9HHwuuwIFEWj/UMJSTJdrj95V/SOTRLc2Jb83lTpkAf8OnxgHtb9SFpY7lWRGX6kKWswBetcH9fH7Zr+YpjKRexHxuQPRiF4KVZt6xym2+NgiHqW0ksvU1zEZD8j6NpbvEs5tyV3+a2g5rDOx1V2hJsuIvrvgFdh3ftD+vkJmoKpUgpROHt6aTYUDcHPJok2BcDkgwurEDdk7fab9aIcGxSUY69NhaY7NGFoNo71FYd2G5FW9BLuY8f1i9XrgKsFXORG87KZ6D0eDkxmilra+mEH6ERuHZ2GzXb745RIzFSPMrqFYUX8Z5wiNnsiTL9BhAwSJHByk+zI4lvEGbnsvMJL/lVpetnf2vACX9rq+lmAHnSf1ulTzLwH0zJXnCfOK7XcPEbY+WkujrM8iIvmaeTnQ== root@pve0"
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
    bridge = "vmbr0"
    model  = "virtio"
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
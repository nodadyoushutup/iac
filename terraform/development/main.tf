resource "linux_file" "test" {
    depends_on = [proxmox_virtual_environment_vm.development]
    

    path = "/tmp/test.txt"
    content = <<-EOF
        hello world test
    EOF
    owner = 1000
    group = 1000
    mode = "777"
    overwrite = true
}
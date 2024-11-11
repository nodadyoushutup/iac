locals {
    base64 = {
        config = try(filebase64(var.CONFIG_PATH), filebase64("/mnt/workspace/source/config/default/config.yaml"))
        private_key = try(filebase64(var.PRIVATE_KEY), filebase64("/mnt/workspace/source/config/default/id_rsa"))
    }
    flag = {
        pyvenv = var.PYVENV == 2 ? var.PYVENV : var.PYVENV + 1
    }
}
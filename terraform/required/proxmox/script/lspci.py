#!/usr/bin/env python3
import os
import sys
import json
import argparse
import paramiko
import traceback

def remote_read_file(sftp, remote_path):
    try:
        with sftp.open(remote_path, "r") as f:
            # Read as bytes, then decode to string
            data = f.read().decode("utf-8").strip()
            return data
    except Exception as e:
        raise Exception(f"Error reading {remote_path}: {str(e)}")

def get_remote_lspci_info(ssh_client):
    try:
        stdin, stdout, stderr = ssh_client.exec_command("lspci -Dnn")
        output = stdout.read().decode("utf-8")
    except Exception as e:
        raise Exception(f"Error executing 'lspci -Dnn': {str(e)}")
    
    info = {}
    for line in output.strip().splitlines():
        parts = line.split(" ", 1)
        if len(parts) == 2:
            pci_addr, rest = parts
            info[pci_addr] = rest.strip()
    return info

def get_remote_hostname(ssh_client):
    try:
        stdin, stdout, stderr = ssh_client.exec_command("hostname")
        hostname = stdout.read().decode("utf-8").strip()
        return hostname
    except Exception as e:
        raise Exception(f"Error retrieving hostname: {str(e)}")

def get_remote_pci_devices(sftp, lspci_dict, node):
    devices = []
    remote_base_path = "/sys/bus/pci/devices/"
    try:
        device_list = sftp.listdir(remote_base_path)
    except Exception as e:
        raise Exception(f"Error listing remote PCI devices: {str(e)}")
    
    for dev in device_list:
        dev_path = remote_base_path + dev
        try:
            vendor = remote_read_file(sftp, dev_path + "/vendor")
            device_id = remote_read_file(sftp, dev_path + "/device")
        except Exception:
            continue  # Skip if vendor/device files are not accessible

        if vendor is None or device_id is None:
            continue

        vendor = vendor.replace("0x", "").lower()
        device_id = device_id.replace("0x", "").lower()
        id_field = f"{vendor}:{device_id}"

        # Try to read subsystem info (if available)
        subsystem_vendor = None
        subsystem_device = None
        try:
            subsystem_vendor = remote_read_file(sftp, dev_path + "/subsystem_vendor")
            subsystem_device = remote_read_file(sftp, dev_path + "/subsystem_device")
        except Exception:
            pass
        subsystem_id = ""
        if subsystem_vendor and subsystem_device:
            subsystem_vendor = subsystem_vendor.replace("0x", "").lower()
            subsystem_device = subsystem_device.replace("0x", "").lower()
            subsystem_id = f"{subsystem_vendor}:{subsystem_device}"

        # Try to determine iommu_group
        iommu_group = 0
        try:
            group_link = sftp.readlink(dev_path + "/iommu_group")
            group = os.path.basename(group_link)
            iommu_group = int(group)
        except Exception:
            iommu_group = 0

        comment = lspci_dict.get(dev, "")

        device_info = {
            "comment": comment,
            "id": id_field,
            "iommu_group": iommu_group,
            "node": node,
            "path": dev,
            "subsystem_id": subsystem_id
        }
        devices.append(device_info)
    return devices

def main():
    parser = argparse.ArgumentParser(
        description="Collect PCI device info from a remote machine via SSH."
    )
    parser.add_argument("--host", default="192.168.1.10",
                        help="Remote host (default: 192.168.1.10)")
    parser.add_argument("--port", type=int, default=22,
                        help="Remote SSH port (default: 22)")
    parser.add_argument("--password", required=True,
                        help="SSH password (required)")
    parser.add_argument("--user", default="root",
                        help="SSH username (default: root)")
    args = parser.parse_args()

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(args.host, port=args.port, username=args.user, password=args.password)
    sftp = ssh.open_sftp()

    lspci_dict = get_remote_lspci_info(ssh)
    node = get_remote_hostname(ssh)
    devices = get_remote_pci_devices(sftp, lspci_dict, node)

    sftp.close()
    ssh.close()
    return devices

if __name__ == "__main__":
    output = {}
    try:
        devices = main()
        output["result"] = {"success": "true", "data": devices}
    except Exception as e:
        output["result"] = {"success": "false", "data": traceback.format_exc()}
    print(json.dumps(output))

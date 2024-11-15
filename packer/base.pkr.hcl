{
  "builders": [
    {
      "type": "qemu",
      "iso_url": "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img",
      "headless": true,
      "format": "qcow2",
      "output_directory": "./"
    }
  ],

  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo apt-get update -y",
        "sudo apt-get install -y qemu-guest-agent"
      ]
    }
  ]
}

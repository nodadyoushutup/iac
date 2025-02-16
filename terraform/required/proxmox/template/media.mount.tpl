[Unit]
Description=Mount Media Share

[Mount]
What=192.168.1.100:/mnt/epool/media
Where=/mnt/epool/media
Type=nfs
Options=defaults

[Install]
WantedBy=multi-user.target

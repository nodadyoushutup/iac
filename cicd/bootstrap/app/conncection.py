import socket
import time
import paramiko

class Connection:
    def __init__(self, endpoint, username, password):
        self.endpoint = endpoint
        self.username = username
        self.password = password
        
        # Wait until port 22 is accepting connections.
        while not self.ping():
            print(f"Port 22 on {self.endpoint} is not accepting connections. Retrying in 5 seconds...")
            time.sleep(5)
        print(f"Port 22 on {self.endpoint} is accepting connections. Proceeding with SSH connection.")

        # Create an SSH client and connect.
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.client.connect(
            hostname=self.endpoint, 
            username=self.username,
            password=self.password, 
            port=22
        )
    
    def ping(self):
        """Check if port 22 is accepting connections on the endpoint."""
        try:
            with socket.create_connection((self.endpoint, 22), timeout=5) as sock:
                return True
        except (socket.timeout, socket.error):
            return False

    def command(self, cmd):
        """
        Execute a command on the remote machine.
        
        :param cmd: The command to be executed.
        :return: A tuple of (stdout, stderr) from the command.
        """
        stdin, stdout, stderr = self.client.exec_command(cmd)
        out = stdout.read().decode('utf-8').strip()
        err = stderr.read().decode('utf-8').strip()
        if err:
            print("Error executing command:", err)
        return out, err

    def close(self):
        """Close the SSH connection."""
        if self.client:
            self.client.close()

import textwrap


class CloudConfig:
    def __init__(self, connection, hostname="cicd", username="nodadyoushutup", github=None):
        self.connection = connection
        self.hostname = self.get_hostname(hostname)
        self.groups = self.get_groups("docker")
        self.users = self.get_users(username)
        self.runcmd = self.get_runcmd(github)
        self.create_cloud_snippet()

    def get_hostname(self, hostname):
        return f"hostname: {hostname}"

    def get_groups(self, username):
        return f"""
        groups:
            - {username}
        """

    def get_users(self, username):
        return f"""
        users:
        - default
        - name: {username}
            groups: sudo
            shell: /bin/bash
            sudo: ALL=(ALL) NOPASSWD:ALL
        """

    def get_runcmd(self, github=None):
        if github:
            return f"""
            runcmd:
                - su - cicd -c 'ssh-import-id gh:{github}'
            """
        return f"""
            runcmd:
                - echo 'No SSH Import'
            """
    
    def create_cloud_snippet(self):
        snippet = snippet = textwrap.dedent(f"""\
        cat <<EOF > /mnt/pve/config/snippets/cicd-cloud-config.yaml
        #cloud-config
        {self.hostname}
        {self.groups}
        {self.users}
        {self.runcmd}
        EOF
        """)
        print(snippet)
        self.connection.command(snippet)
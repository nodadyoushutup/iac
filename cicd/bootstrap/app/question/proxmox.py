from app.question.base import Question
import re


class QuestionProxmoxEndpoint(Question):
    def validate(self):
        ip_pattern = re.compile(
            r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"
        )
        if not ip_pattern.match(self.data):
            print("Proxmox endpoint must be a valid IP address (example: 192.168.1.10)")
            return False
        return True
    
    def inject(self):
        if self.data[-1] == "/":
            self.data = self.data[:-1]
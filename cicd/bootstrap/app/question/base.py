from app.config import Config
import getpass


class Question:
    def __init__(self, id, text, default=None, sensitive=None, help=None):
        self.id = id
        self.default = default
        self.text = self.set_text(text)
        self.sensitive = sensitive
        self.help = help

    def __str__(self):
        return str(vars(self))
    
    def __repr__(self):
        return str(vars(self))
    
    def set_response(self):
        return input(self.text)
    
    def set_data(self):
        if self.sensitive:
            data = getpass.getpass(self.text)
        else:
            data = input(self.text)
        if data:
            self.data = data
        elif not data and self.default == "null":
            self.data = None
        elif not data and self.default:
            self.data = self.default
        else:
            print("Response required...")
            self.set_data()
        if self.data == "--help":
            print(self.help)
            self.set_data()
        if not self.validate():
            self.set_data()
        self.inject()
        setattr(Config, self.id, self.data)
        return self.data

    def set_text(self, text):
        if self.default:
            return f"{text} (default: {self.default}): "
        return f"{text} (required): "
    
    def validate(self):
        return True

    def inject(self):
        return True
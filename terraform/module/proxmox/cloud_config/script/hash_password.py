import sys
import json
from passlib.hash import sha512_crypt

def main():
    try:
        input_data = json.load(sys.stdin)
        password = input_data.get("password", "")
        if not password:
            raise ValueError("Password not provided")
        hashed_pw = sha512_crypt.hash(password)
        output = {"data": hashed_pw}
    except Exception as e:
        output = {"data": None}
    
    print(json.dumps(output))

if __name__ == "__main__":
    main()

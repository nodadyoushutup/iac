import sys
import json
from passlib.hash import sha512_crypt

def main():
    if len(sys.argv) < 2:
        sys.exit(1)
    
    password = sys.argv[1]
    
    try:
        hashed_pw = sha512_crypt.hash(password)
        output = {"data": hashed_pw}
    except Exception as e:
        output = {"error": str(e)}
    
    print(json.dumps(output))

if __name__ == "__main__":
    main()

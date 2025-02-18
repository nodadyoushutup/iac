import random
import string
import json

def main():
    random_string = ''.join(random.choice(string.ascii_letters) for _ in range(6))
    print(json.dumps({"value": random_string}))

if __name__ == "__main__":
    main()

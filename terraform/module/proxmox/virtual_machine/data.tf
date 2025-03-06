data "external" "random_string" {
    program = ["python3", "${path.module}/script/random_string.py"]
}
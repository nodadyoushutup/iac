data "aws_s3_object" "config" {
    bucket = "config"
    key = "config.json"
}

output "config" {
    value = jsondecode(data.aws_s3_object.config.body)
    sensitive = true
}
terraform {
    backend "s3" {
        key = "debug.tfstate"
    }
}
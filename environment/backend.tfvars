terraform {
    backend "s3" {
        encrypt = false
        bucket = "ghost-bucket-1223"
        dynamodb_table = "ghost-dynamo-1223"
        key = "./terra/terraform.tfstate.d/dev/terraform.tfstate"
        region = "us-east-1"
    }
}
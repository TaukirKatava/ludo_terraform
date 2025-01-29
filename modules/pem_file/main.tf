data "aws_key_pair" "pem_file" {
    key_name = "taukir-demo"
    include_public_key = true  
}

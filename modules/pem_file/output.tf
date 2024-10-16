output "pem_file" {
    value = data.aws_key_pair.pem_file.key_name
}
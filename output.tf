output "ami_id" {
    value = data.aws_ami.this.id
}

output "ec2" {
    value = aws_instance.this.id
}

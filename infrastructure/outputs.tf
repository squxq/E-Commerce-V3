output "http_to_lb" {
    value = "http://${aws_lb.applb.dns_name}"
}
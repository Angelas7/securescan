output "jenkins_public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "Open this IP:8080 for Jenkins"
}

output "elastic_beanstalk_url" {
  value       = aws_elastic_beanstalk_environment.securescan_env.endpoint_url
  description = "Your live website URL"
}
output "vpc-id" {
    value = aws_vpc.vpc.id
}


output "private-subnets-ids" {
  value = [for subnet in aws_subnet.private-subnet : subnet.id]
}

output "pub-subnet-id" {
  value = aws_subnet.pub-subnet.id
}

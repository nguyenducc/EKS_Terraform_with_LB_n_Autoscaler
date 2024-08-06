output "all-sub-net-id" {
  value = [
    aws_subnet.public-subnet-02.id, 
    aws_subnet.public-subnet-01.id,
    aws_subnet.private-subnet-02.id,
    aws_subnet.private-subnet-01.id
    ]
}

output "all-private-subnet-id" {
  value = [
    aws_subnet.private-subnet-02.id,
    aws_subnet.private-subnet-01.id
  ]
}
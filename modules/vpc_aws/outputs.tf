# Outputs for "sslcert_letsencrypt" module
# note that if you want the full 

output "subnet_id" {
  value = aws_subnet.ag_test.id
}

output "security_group_id" {
  value = aws_security_group.ag_test.id
}

output "id" {
  value = aws_vpc.ag_test.id
}

output "route_table_id" {
  value = aws_route_table.ag_test_route_table.id
}
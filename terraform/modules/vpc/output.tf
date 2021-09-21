output "vpc_id" {
    value = aws_vpc.vpc.id 
}
output "public_subnets" {
    value = aws_subnet.vpc_public_subnet.*.id
}
output "private_subnets" {
    value = aws_subnet.vpc_private_subnet.*.id
}
output "igw" {
    value = aws_internet_gateway.vpc_igw.id
}
output "nat_gateways" {
    value = aws_nat_gateway.vpc_nat_gw.*.id
}
output "public_rt" {
    value = aws_route_table.vpc_public_rt.*.id
}
output "private_rt" {
    value = aws_route_table.vpc_private_rt.*.id
}
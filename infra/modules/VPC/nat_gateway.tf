
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]

  tags = {
      Name = format("%s-EIP-%s", var.prefix, var.environment)
    }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = {
      Name = format("%s-Nat-%s", var.prefix, var.environment)
    }
}

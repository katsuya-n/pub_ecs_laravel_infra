resource "aws_vpc_endpoint" "ecr_api" {
  tags = {
    Name = "${var.name_prefix}-vpce-ecr-api"
  }
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.sg_id
  ]

  private_dns_enabled = true
  subnet_ids = [
    var.subnet_vpce_1a_id,
    var.subnet_vpce_1b_id
  ]
}
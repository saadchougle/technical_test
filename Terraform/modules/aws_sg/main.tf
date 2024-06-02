resource "aws_security_group" "sg" {
  name        = "${var.name}-${var.env}-${var.sg_name}"
  description = "${var.description}"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-${var.env}-${var.sg_name}"
  }
}

resource "aws_security_group_rule" "inbound_ip" {
  count             = length(var.inbound_ip_sources)
  type              = "ingress"
  from_port         = var.inbound_ip_sources[count.index].from
  to_port           = var.inbound_ip_sources[count.index].to
  protocol          = var.protocol
  cidr_blocks       = [var.inbound_ip_sources[count.index].source]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "inbound_sg" {
  count                    = length(var.inbound_sg_sources)
  type                     = "ingress"
  from_port                = var.inbound_sg_sources[count.index].from
  to_port                  = var.inbound_sg_sources[count.index].to
  protocol                 = var.protocol
  source_security_group_id = var.inbound_sg_sources[count.index].source
  security_group_id        = aws_security_group.sg.id
}
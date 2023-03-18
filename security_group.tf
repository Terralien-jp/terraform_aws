resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks_cluster_sg"
  vpc_id      = aws_vpc.this.id
  
  ingress {
    description = "Allow node access to cluster endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow communication between worker nodes"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]    
  }
}

resource "aws_security_group" "eks_worker_nodes_sg" {
  name_prefix = "${local.app_name}-${local.environment}-eksnodes-sg"
  vpc_id      = aws_vpc.main.id

  # Inbound rules
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = ["${aws_security_group.workers.id}"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 1023
    protocol    = "tcp"
    security_groups = ["${aws_security_group.workers.id}"]
  }
  
  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = "${local.app_name}-${local.environment}-eks-worker-nodes-sg"
}

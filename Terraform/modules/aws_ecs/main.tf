# Create ECS Cluster
resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name
  tags = {
    Name = "${var.name}-${var.env}-cluster"
  }
}

#Create Task Definition
resource "aws_ecs_task_definition" "ecs" {
  family                   = var.task_family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = jsonencode([
    {
      name         = var.container_name
      image        = var.container_image
      cpu          = var.container_cpu
      memory       = var.container_memory
      essential    = true
      environment  = var.container_environment
      portMappings = var.portMappings
    }
  ])
  tags = {
    Name = "${var.name}-${var.env}-task"
  }
}

resource "aws_ecs_service" "ecs" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }
  tags = {
    Name = "${var.name}-${var.env}-service"
  }
}
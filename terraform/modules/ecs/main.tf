# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.region_suffix}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight           = 50
  }
  
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight           = 50
  }
}

# Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.region_suffix}-ecs-task-execution"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-${var.region_suffix}"
  retention_in_days = 7
}

# ECS Task Definition
resource "aws_ecs_task_definition" "web" {
  family                   = "${var.project_name}-${var.region_suffix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  
  container_definitions = jsonencode([
    {
      name  = "web-app"
      image = "nginx:latest"
      
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
      
      environment = [
        {
          name  = "REGION"
          value = data.aws_region.current.name
        },
        {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      ]
    }
  ])
}

# Security Group for ECS
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.project_name}-${var.region_suffix}-ecs-tasks-"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_alb.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.region_suffix}-ecs-tasks-sg"
  }
}

resource "aws_security_group" "ecs_alb" {
  name_prefix = "${var.project_name}-${var.region_suffix}-ecs-alb-"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.region_suffix}-ecs-alb-sg"
  }
}

# Application Load Balancer for ECS
resource "aws_lb" "ecs" {
  name               = "${var.project_name}-${var.region_suffix}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_alb.id]
  subnets            = var.public_subnets
  
  enable_deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-${var.region_suffix}-ecs-alb"
  }
}

resource "aws_lb_target_group" "ecs" {
  name        = "${var.project_name}-${var.region_suffix}-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  
  tags = {
    Name = "${var.project_name}-${var.region_suffix}-ecs-tg"
  }
}

resource "aws_lb_listener" "ecs" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

# ECS Service
resource "aws_ecs_service" "web" {
  name            = "${var.project_name}-${var.region_suffix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.public_subnets
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "web-app"
    container_port   = 80
  }
  
  depends_on = [aws_lb_listener.ecs]
  
  tags = {
    Name = "${var.project_name}-${var.region_suffix}-ecs-service"
  }
}

data "aws_region" "current" {}

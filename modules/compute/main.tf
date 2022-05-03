#Load Balancer
resource "aws_security_group" "alb" {
  name        = "lb_http_default"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id =  var.vpc_id
  #idle_timeout = "65"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-default-security_group-ALB"
  }
}
resource "aws_alb" "alb" {
  name = "GhostLoadBalancer"
  load_balancer_type = "application"
  security_groups =  var.albsecuritygroups
    # allow inboud http 80 traffic for default security group in the app instance security group
  subnets = var.elbsubnets
  tags = {
    Name = "${terraform.workspace}-Ghost-ALB"
  }

}

#Target Group
resource "aws_alb_target_group" "group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # Alter the destination of the health check to be the login page.
  health_check {
    healthy_threshold = 2  
    unhealthy_threshold = 10
    timeout = 50
    interval = 60
    port = 80
    path = "/"
    matcher = "200" # has to be HTTP 200 or fails
  }
   tags = {
    Name = "${terraform.workspace}-Ghost-targetgroup"
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}

#Launch Template
resource "aws_launch_template" "launch_template" {
  name = "GhostLaunchTemplate"
  instance_type = "t2.micro"
  image_id = "ami-005de95e8ff495156"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = var.appsecurtiygroup
  user_data = base64encode(data.template_file.userdata.rendered)
  iam_instance_profile {
      name = aws_iam_instance_profile.ec2_profile.name
    }
   tags = {
    Name = "${terraform.workspace}-LaunchTemplate"
  }
}

data "template_file" "userdata" {
  template = file("../shell/ghost_init.sh")
  vars = {
        DB_NAME                    = var.database_name
        DB_HOSTNAME                = var.db_writer_endpoint
        DB_USERNAME                = var.database_username
        DB_PASSWORD                = var.database_password
        LB_HOSTNAME                = aws_alb.alb.dns_name
        ADMIN_URL                  = var.website_admin_url
        URL                        = var.website_url
  }
}
#AutoScaling Group
resource "aws_autoscaling_group" "wp_autoscaling_group" {
  name = "${aws_launch_template.launch_template.name}-asg"

  min_size             = 1
  desired_capacity     = 1
  max_size             = 1
  
  health_check_type    = "ELB"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  vpc_zone_identifier  =  var.asg_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-AutoscalingGroup"
    propagate_at_launch = true
  }
    target_group_arns = [aws_alb_target_group.group.arn]

}

#IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile-ghost"
  role = aws_iam_role.ec2_role.name
}
#role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-ghost"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Policy needed
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:amazon:iam::amazon:policy/AmazonSSMManagedInstanceCore"
}
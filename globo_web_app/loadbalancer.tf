#aws_elb_service_account
data "aws_elb_service_account" "root" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "my-elb-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "elb_logs_acl" {
  bucket = aws_s3_bucket.elb_logs.id
  acl    = "private"
}
# Grant access to the S3 bucket to the load balancer

resource "aws_s3_bucket_policy" "allow_elb_logging" {
  bucket = aws_s3_bucket.elb_logs.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-elb-tf-test-bucket/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.root.arn}"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_elb" "bar" {
  name               = "my-foobar-terraform-elb"
  availability_zones = ["us-west-2a"]

  access_logs {
    bucket   = aws_s3_bucket.elb_logs.bucket
    interval = 5
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

## aws_alb

resource "aws_lb" "ngingx" {
  name               = "globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.subnets[*].id

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.web_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}
## aws_lb_target_group

resource "aws_lb_target_group" "ngingx" {
  name     = "ngingx-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  tags     = local.common_tags
}

## aws_lb_listener

resource "aws_lb_listener" "ngingx" {
  load_balancer_arn = aws_lb.ngingx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ngingx.arn
  }
  tags = local.common_tags
}


## aws_lb_target_group_attachment

resource "aws_lb_target_group_attachment" "nginx1" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.ngingx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}

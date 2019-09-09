locals {
    image = data.aws_ami.ubuntu.id
    type = var.instance_type
    sg = data.aws_security_group.prod_webserver.id
    subnets = module.prod.subnet_ids
    volume_size = "50"
    tags = [
        {
      key                 = "Environment"
      value               = "Production"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "Webserver"
      propagate_at_launch = true
    },
    ]
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name = "opa"
  # Launch configuration
  lc_name = "example-lc"
  image_id        = local.image
  instance_type   = local.type
  security_groups = [ local.sg ]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = local.volume_size
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size = local.volume_size
      volume_type = "gp2"
    },
  ]
 
  # Auto scaling group
  asg_name                  = "opa"
  vpc_zone_identifier       = local.subnets
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  tags = local.tags
  
}


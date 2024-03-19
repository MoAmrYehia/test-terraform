data "aws_iam_policy_document" "idt_domain" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sagemaker_domain_execution_role" {
  name               = "aws-test-sagemaker-domain-execution-iam-role"
  path               = "/"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker-canvas-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"
}
resource "aws_iam_role_policy_attachment" "cloudformation-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}
resource "aws_iam_role_policy_attachment" "sagemaker-pipelineintegrations-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerPipelinesIntegrations"
}


resource "aws_sagemaker_domain" "aws_dugb_sagemaker_domain" {
  domain_name = "aws-retailmass-domain"
  auth_mode   = "IAM"
  vpc_id = var.sm_vpc_id
  subnet_ids = var.sm_subnets
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
  default_space_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_user_profile" "retailmass_rpc" {
  domain_id         = aws_sagemaker_domain.aws_dugb_sagemaker_domain.id
  user_profile_name = "aws-dugb-mlops-rpc"
  user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_app" "rpc_sagemaker_pipeline" {
  domain_id         = aws_sagemaker_domain.aws_dugb_sagemaker_domain.id
  user_profile_name = aws_sagemaker_user_profile.retailmass_rpc.user_profile_name
  app_name          = "rpc-aws-dugb-sagemaker-pipeline"
  app_type          = "JupyterServer"
}

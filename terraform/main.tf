
data "aws_iam_role" "lambda_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"
}
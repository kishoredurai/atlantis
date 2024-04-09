## Create an EC2 Instance
resource "aws_instance" "web" {
  ami               = "ami-0851b76e8b1bce90b"
  instance_type     = "t2.smallg"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "atlantis-medium"
  }
}
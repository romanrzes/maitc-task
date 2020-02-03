
resource "aws_iam_role" "tf-eks-master" {
  name = "terraform-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.tf-eks-master.name}"
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.tf-eks-master.name}"
}


resource "aws_eks_cluster" "tf_eks" {
  name     = "kitten-cluster"
  role_arn = "${aws_iam_role.tf-eks-master.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.tf-eks-master.id}"]
    subnet_ids         = ["${aws_subnet.eu-central-1-public.id}", "${aws_subnet.eu-central-2-public.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSServicePolicy",
  ]
}


resource "aws_iam_role" "tf-eks-nodes" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.tf-eks-nodes.name}"
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.tf-eks-nodes.name}"
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.tf-eks-nodes.name}"
}


resource "aws_eks_node_group" "kitten_nodes" {
  cluster_name    = "${aws_eks_cluster.tf_eks.name}"
  node_group_name = "kitten_node"
  node_role_arn   = "${aws_iam_role.tf-eks-nodes.arn}"
  subnet_ids      = ["${aws_subnet.eu-central-1-public.id}", "${aws_subnet.eu-central-2-public.id}"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.tf-cluster-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.tf-cluster-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.tf-cluster-AmazonEC2ContainerRegistryReadOnly,
  ]
}

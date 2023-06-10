module "vpc" {
  
  source = "./Network"
  vpc-name = "my-vpc"
  vpc-cidr = "10.0.0.0/16"
  pub-subnet-cider = "10.0.0.0/24"
  pub-subnet-tag-name = "pub-subnet-1"
  private-subnet-cider =["10.0.1.0/24","10.0.3.0/24"]
  private-subnet-tag-names = ["private-subnet-1","private-subnet-2"]
  nat-name="my-nat"
  igw-name="igw-id"
  route-cider = ["0.0.0.0/0" , "::/0"]  
  AZ=["us-east-1a","us-east-1b"]

}


module "eks" {
  source      = "./EKS"
  eks-name = "eks-cluster"
  endpoint_public_access  = true
  endpoint_private_access = true

  public_access_cidrs = [ "0.0.0.0/0" ]
  node_group_name = "Worker-node"
  instance_types = ["t3.small"]
  ec2_ssh_key="ssh-final-task" 
  private-subnets-ids = module.vpc.private-subnets-ids
}


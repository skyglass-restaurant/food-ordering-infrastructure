
variable "cluster_id" {
  description = "Name of the EKS cluster where the ingress nginx will be deployed"
  type        = string

}

variable "cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "environment" {
  description = "EKS Cluster Environment"
  type        = string
}
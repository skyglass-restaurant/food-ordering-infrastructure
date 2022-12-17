resource "aws_sqs_queue" "movies_to_parse_sqs" {
  name                 = "movies_to_parse_${var.cluster_name}"
   tags = {
    Author = var.author
    Environment = var.cluster_name
  }
}
output "ClusterName" {
  value = aws_rds_cluster.Ghostdatabase-cluster.database_name
}

output "reader-cluster-endpoint" {
  value = aws_rds_cluster.Ghostdatabase-cluster.reader_endpoint
}

output "writer-cluster-endpoint" {
  value = aws_rds_cluster.Ghostdatabase-cluster.endpoint
}

output "cache-endpoint" {
  value = aws_elasticache_cluster.elasticcache-ghost.configuration_endpoint
}

output "dbname" {
  value = aws_rds_cluster.Ghostdatabase-cluster.database_name
}

output "dbusername" {
  value = aws_rds_cluster.Ghostdatabase-cluster.master_username
}

output "dbpassword" {
  value = aws_rds_cluster.Ghostdatabase-cluster.master_password
}
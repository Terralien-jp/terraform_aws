resource "aws_config_configuration_aggregator" "this" {
  name = "aggregator-this"

  account_aggregation_source {
    account_ids = ["123456789012"]
    all_regions = true
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# modules/security/main.tf
variable "env" { type = string }
variable "cloudtrail_s3_bucket" { type = string }

# Enable GuardDuty
resource "aws_guardduty_detector" "this" {
  enable = true
}

# KMS key for encryption
resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.env} encryption"
  deletion_window_in_days = 30
}
resource "aws_kms_alias" "this" {
  name          = "alias/${var.env}-key"
  target_key_id = aws_kms_key.this.id
}

# CloudTrail for audit logging
resource "aws_cloudtrail" "this" {
  name                          = "${var.env}-trail"
  s3_bucket_name                = var.cloudtrail_s3_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

# AWS Config rule: S3 bucket encryption enforced
resource "aws_config_config_rule" "s3_encryption" {
  name = "${var.env}-s3-encryption"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}

# WAFv2 Web ACL for ALB protection
resource "aws_wafv2_web_acl" "this" {
  name  = "${var.env}-waf"
  scope = "REGIONAL"

  default_action { allow {} }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action { none {} }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled  = true
      cloudwatch_metrics_enabled = true
      metric_name                = "awswafcommon"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.env}-waf"
    sampled_requests_enabled   = true
  }
}

# VPC Flow Logs for networking audit
resource "aws_flow_log" "this" {
  log_destination      = var.cloudtrail_s3_bucket
  traffic_type         = "ALL"
  arn                  = aws_vpc.this.id
}

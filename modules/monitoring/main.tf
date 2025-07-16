# modules/monitoring/main.tf
variable "alarm_definitions" {
  type = list(object({
    name        = string
    metric_name = string
    namespace   = string
    threshold   = number
    period      = number
    evaluation_periods = number
  }))
}

resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each            = { for a in var.alarm_definitions : a.name => a }
  alarm_name          = each.value.name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  threshold           = each.value.threshold
  alarm_actions       = [var.ops_sns_topic_arn]
}

resource "aws_guardduty_detector" "guardduty_detector" {
  enable = true
}

resource "aws_guardduty_organization_configuration" "guardduty_org_config" {
  auto_enable = true
}

resource "aws_guardduty_invite_accepter" "guardduty_invite_accepter" {
  detector_id = aws_guardduty_detector.guardduty_detector.id
}

resource "aws_guardduty_member" "guardduty_member" {
  detector_id = aws_guardduty_detector.guardduty_detector.id
  account_id  = "<member-account-id>"
  email       = "<member-email>"
}

resource "aws_guardduty_threat_intel_set" "guardduty_threat_intel_set" {
  name = "MyThreatIntelSet"
  format = "TXT"
  location = "s3://mybucket/threatintelset.txt"
}

resource "aws_guardduty_ipset" "guardduty_ipset" {
  name = "MyIPSet"
  format = "TXT"
  location = "s3://mybucket/ipset.txt"
}

resource "aws_guardduty_filter" "guardduty_filter" {
  name          = "MyFilter"
  detector_id   = aws_guardduty_detector.guardduty_detector.id
  description   = "My GuardDuty Filter"
  rank          = 1
  action        = "NOOP"
  finding_criteria {
    criterion {
      category     = "Recon:EC2/PortProbeUnprotectedPort"
      service      = "EC2"
      severity     = "LOW"
      description  = "Port probe"
      id           = "PUP"
      type         = "STATIC"
    }
  }
}

resource "aws_sns_topic_subscription" "guardduty_sns_topic_subscription" {
  topic_arn = aws_sns_topic.guardduty_notifications.arn
  protocol  = "email"
  endpoint  = "<email-address>"
}

resource "aws_sns_topic_subscription" "guardduty_sns_subscription" {
  topic_arn = aws_sns_topic.guardduty_notifications.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

resource "aws_guardduty_filter" "high_severity_filter" {
  name          = "HighSeverityFilter"
  detector_id   = aws_guardduty_detector.detector.id
  description   = "Filter for high severity findings"
  rank          = 1
  finding_criteria {
    criterion {
      field ="severity"
      greater_than_or_equal = "7"
    }
  }
}

resource "aws_guardduty_publishing_destination" "sns_destination" {
  destination_type   = "sns"
  security_group_ids = [aws_security_group.publishing_destination_sg.id]
  sns_destination {
    topic_arn = aws_sns_topic.guardduty_notifications.arn
  }
}

resource "aws_guardduty_configuration" "guardduty_configuration" {
  detector_id = aws_guardduty_detector.detector.id
  publishing_destination {
    destination_id = aws_guardduty_publishing_destination.sns_destination.id
    destination_type = aws_guardduty_publishing_destination.sns_destination.destination_type
  }
}

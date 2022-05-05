//monitoring with terraform

provider "aws" {
    region = "eu-central-1"
}

resource "aws_cloudwatch_dashboard" "lambdadash" {
    dashboard_name = "lambda-dashboard-pedram"
    dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 15,
            "properties": {
                "metrics": [
                    {
                        "metricName": "Duration",
                        "resourceType": "AWS::Lambda::Function",
                        "stat": "p90"
                    },
                    {
                        "metricName": "Errors",
                        "resourceType": "AWS::Lambda::Function",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "Invocations",
                        "resourceType": "AWS::Lambda::Function",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "Throttles",
                        "resourceType": "AWS::Lambda::Function",
                        "stat": "Sum"
                    }
                ],
                "labels": [
                    {
                        "key": "FunctionName"
                    },
                    {
                        "key": "owner",
                        "value": "pedram@hashicorp.com"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 50,
                    "widgetsPerRow": 2
                },
                "period": 300,
                "splitBy": "Runtime",
                "region": "eu-west-1"
            }
        }
    ]
}
EOF
}
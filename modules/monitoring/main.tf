//monitoring with terraform
provider "aws" {
    region      = "eu-west-1"
}
resource "aws_cloudwatch_dashboard" "lambdadash" {
    dashboard_name = "lambda-dashboard-pedram"
    dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 15,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "explorer",
            "properties": {
                "metrics": [
                    {
                        "metricName": "ExecutionTime",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ExecutionsSucceeded",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "ExecutionsFailed",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "ExecutionsThrottled",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "ExecutionsAborted",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "ExecutionsTimedOut",
                        "resourceType": "AWS::StepFunctions::StateMachine",
                        "stat": "Sum"
                    }
                ],
                "labels": [
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
                "splitBy": "",
                "region": "eu-west-1"
            }
        }
    ]
}
EOF
}
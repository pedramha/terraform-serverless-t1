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
            "height": 15,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "explorer",
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
        },
        {
            "type": "explorer",
            "x": 0,
            "y": 15,
            "width": 24,
            "height": 15,
            "properties": {
                "metrics": [
                    {
                        "metricName": "Count",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "5XXError",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "4XXError",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "Latency",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Average"
                    },
                    {
                        "metricName": "IntegrationLatency",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Average"
                    },
                    {
                        "metricName": "CacheHitCount",
                        "resourceType": "AWS::ApiGateway::RestApi",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "CacheMissCount",
                        "resourceType": "AWS::ApiGateway::RestApi",
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
        },
        {
            "type": "explorer",
            "x": 0,
            "y": 30,
            "width": 24,
            "height": 15,
            "properties": {
                "metrics": [
                    {
                        "metricName": "BucketSizeBytes",
                        "resourceType": "AWS::S3::Bucket",
                        "stat": "Average"
                    },
                    {
                        "metricName": "NumberOfObjects",
                        "resourceType": "AWS::S3::Bucket",
                        "stat": "Average"
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
        },
        {
            "type": "explorer",
            "x": 0,
            "y": 45,
            "width": 24,
            "height": 15,
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
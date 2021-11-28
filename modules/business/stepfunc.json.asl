{
  "Comment": "A Hello World example demonstrating various state types of the Amazon States Language",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
      "Type": "Pass",
      "Next": "SchufaPositive"
    },
    "SchufaPositive": {
      "Comment": "A Choice state adds branching logic to a state machine. Choice rules can implement 16 different comparison operators, and can be combined using And, Or, and Not",
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.risk",
          "BooleanEquals": true,
          "Next": "Yes"
        },
        {
          "Variable": "$.risk",
          "BooleanEquals": false,
          "Next": "No"
        }
      ],
      "Default": "Yes"
    },
    "Yes": {
      "Type": "Pass",
      "Next": "organize pickup"
    },
    "No": {
      "Type": "Fail",
      "Cause": "Not Hello World"
    },
    "organize pickup": {
      "Comment": "A Wait state delays the state machine from continuing for a specified time.",
      "Type": "Wait",
      "Seconds": 3,
      "Next": "Parallel State"
    },
    "Parallel State": {
      "Comment": "A Parallel state can be used to create parallel branches of execution in your state machine.",
      "Type": "Parallel",
      "Next": "return",
      "Branches": [
        {
          "StartAt": "book",
          "States": {
            "book": {
              "Type": "Pass",
              "End": true
            }
          }
        },
        {
          "StartAt": "calculate damage",
          "States": {
            "calculate damage": {
              "Type": "Pass",
              "End": true
            }
          }
        }
      ]
    },
    "return": {
      "Type": "Pass",
      "End": true
    }
  }
}
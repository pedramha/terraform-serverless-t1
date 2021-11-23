{
    "Comment": "A Hello World example demonstrating various state types of the Amazon States Language",
    "StartAt": "PlaceOrder",
    "States": {
      "PlaceOrder": {
        "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
        "Type": "Pass",
        "Next": "Parallel State"
      },
      
      "Parallel State":
        {
            "Comment": "A Parallel state is useful when you want to execute multiple state machines in parallel.",
            "Type": "Parallel",
            "Next": "Calculate Risk",
            "Branches": [
                {
                        "StartAt": "VerifySchufa",
                        "States": {
                          "VerifySchufa": {
                            "Type": "Pass",
                            "End": true
                          }
                        }
                      },
                      {
                        "StartAt": "VerifyCreditCard",
                        "States": {
                          "VerifyCreditCard": {
                            "Type": "Pass",
                            "End": true
                          }
                        }
                      },
                      {
                        "StartAt": "VerifyDriverLicence",
                        "States": {
                          "VerifyDriverLicence": {
                            "Type": "Pass",
                            "End": true
                          }
                        }
                      }
                      
            ]
        },


        "Calculate Risk": {
            "Comment": "A Choice state is useful when you want to execute different branches of a state machine based on the value of an input.",
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.risk",
                    "StringEquals": "Low",
                    "Next": "Low Risk"
                },
                {
                    "Variable": "$.risk",
                    "StringEquals": "High",
                    "Next": "High Risk"
                }
            ],
            "Default": "High Risk"
        },

        "Low Risk": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "Organize Pick Up"
        },
        
        "Organize Pick Up": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "Wait for Return"
        },

        "Wait for Return": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "Renew Contract?"
        },
        
        "Renew Contract?": {
            "Comment": "A Choice state is useful when you want to execute different branches of a state machine based on the value of an input.",
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.renew",
                    "StringEquals": "Yes",
                    "Next": "Wait for Return"
                },
                {
                    "Variable": "$.renew",
                    "StringEquals": "No",
                    "Next": "Calculate Damages"
                }
            ],
            "Default": "Calculate Damages"
        },

        "Calculate Damages": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "Book Fees"
        },

        "Book Fees": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "End"
        },

        "High Risk": {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "Next": "Send Message"
        },
        "Send Message":
        {
            "Comment": "A Pass state passes its input to its output, without performing work. Pass states are useful when constructing and debugging state machines.",
            "Type": "Pass",
            "End": true
        },

        "End": {
            "Comment": "The End state is the final state of a state machine. If you don't specify a Next state, the state machine will terminate.",
            "Type": "Pass",
            "End": true
        }
    }
}
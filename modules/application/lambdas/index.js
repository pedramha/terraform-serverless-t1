const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = 'myDB';
const PRIMARY_KEY = 'id';
exports.handler = async (event = {}) => {
    const ID = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    const item = {
        "TableName": TABLE_NAME,
        "Item": {
            "id": ID,
            "Order": "toyota",
        }
    };
    try {
        await db.put(item).promise();
    }
    catch (dbError) {
        return { statusCode: 500, body: JSON.stringify(dbError) };
    }
    //invoke step function
    var params = {
        stateMachineArn: 'arn:aws:states:eu-central-1:833915806704:stateMachine:my_state_machine',
        input: JSON.stringify({})
      }
      var stepfunctions = new AWS.StepFunctions()
      stepfunctions.startExecution(params, function (err, data) {
        if (err) {
          console.log('err while executing step function')
        } else {
          console.log('started execution of step function')
        }
        })
};

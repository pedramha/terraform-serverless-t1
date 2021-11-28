const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const stepfunctions= new AWS.StepFunctions();
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
        stateMachineArn: 'arn:aws:states:eu-central-1:833915806704:stateMachine:my_state_machine', /* required */
        input: 'STRING_VALUE',
        name: 'STRING_VALUE',
        traceHeader: 'STRING_VALUE'
      };
      stepfunctions.startExecution(params, function(err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else     console.log(data);           // successful response
      });
};

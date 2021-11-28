module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, World!';

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
// // Load the AWS SDK for Node.js
// var AWS = require('aws-sdk');
// // Set the region 

// // Create the DynamoDB service object
// var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

// var params = {
//   TableName: 'myDB',
//   Item: {
//     'CUSTOMER_ID' : {N: '001'},
//     'CUSTOMER_NAME' : {S: 'Richard Roe'}
//   }
// };

// // Call DynamoDB to add the item to the table
// ddb.putItem(params, function(err, data) {
//   if (err) {
//     console.log("Error", err);
//   } else {
//     console.log("Success", data);
//   }
// });

// var AWS = require('aws-sdk');
// var dynamo = new AWS.DynamoDB.DocumentClient();

// exports.handler = function(event, context, callback) {

//     var operation = event.operation;

//     if (event.tableName) {
//         event.payload.TableName = event.tableName;
//     }

//     switch (operation) {
//         case 'create':
//             dynamo.put(event.payload, callback);
//             break;
//         case 'read':
//             dynamo.get(event.payload, callback);
//             break;
//         default:
//             callback('Unknown operation: ${operation}');
//     }
// };
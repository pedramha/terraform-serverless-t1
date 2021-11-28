const AWS = require('aws-sdk');

const dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  console.log('Event: ', event);

  let body = {"test":"1"};
  let statusCode = '200';
  const headers = {
      'Content-Type': 'application/json',
  };

  try {
    body = await dynamo.put(JSON.parse(body)).promise();
      // switch (event.httpMethod) {
      //     case 'DELETE':
      //         body = await dynamo.delete(JSON.parse(event.body)).promise();
      //         break;
      //     case 'GET':
      //         body = await dynamo.scan({ TableName: event.queryStringParameters.TableName }).promise();
      //         break;
      //     case 'POST':
      //         body = await dynamo.put(JSON.parse(event.body)).promise();
      //         break;
      //     case 'PUT':
      //         body = await dynamo.update(JSON.parse(event.body)).promise();
      //         break;
      //     default:
              // throw new Error(`Unsupported method "${event.httpMethod}"`);
      // }
  } catch (err) {
      statusCode = '400';
      body = err.message;
  } finally {
      body = JSON.stringify(body);
  }

  return {
      statusCode,
      body,
      headers,
  };
};
  

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
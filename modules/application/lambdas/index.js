const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = 'myDB';
const PRIMARY_KEY = 'id';
exports.handler = async (event = {}) => {
    const item = typeof event.body == 'object' ? event.body : JSON.parse(event.body);
    const ID = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    item[PRIMARY_KEY] = ID;
    const params = {
        TableName: TABLE_NAME,
        Item: item
    };
    try {
        await db.put(params).promise();
        return { statusCode: 200, body: 'success' };
    }
    catch (dbError) {
        return { statusCode: 500, body: JSON.stringify(dbError) };
    }
};

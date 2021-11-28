const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = 'myDB';
const PRIMARY_KEY = 'id';
exports.handler = async (event = {}) => {
    const ID = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    const item = {
            "id": ID,
            "Order": "toyota",
    };
    try {
        await db.put(item).promise();
    }
    catch (dbError) {
        return { statusCode: 500, body: JSON.stringify(dbError) };
    }
};

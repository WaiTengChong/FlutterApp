'use strict';
const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient({ apiVersion: '2012-08-10' });
const { v4: uuid } = require('uuid');

const postsTable = process.env.POSTS_TABLE;
const usersTable = process.env.USERS_TABLE;

function response(statusCode, message) {
  return {
    statusCode: statusCode,
    body: JSON.stringify(message)
  };
}

function sortByDate(a, b) {
  if (a.createdAt > b.createdAt) {
    return -1;
  } else return 1;
}

module.exports.createPost = (event, context, callback) => {
  const reqBody = JSON.parse(event.body);

  //Check if the input is empty
  if (
    !reqBody.title ||
    reqBody.title.trim() === '' ||
    !reqBody.body ||
    reqBody.body.trim() === '' ||
    !reqBody.userName ||
    reqBody.userName.trim() === ''
  ) {
    return callback(
      null,
      response(400, {
        error: 'Post must have a title, body and userName, they must not be empty'
      })
    );
  }

  const post = {
    id: uuid(),
    createdAt: new Date().toISOString(),
    userName: reqBody.userName,
    title: reqBody.title,
    body: reqBody.body,
    image: reqBody.image,
    comment: reqBody.comment
  };

  return db
    .put({
      TableName: postsTable,
      Item: post
    })
    .promise()
    .then(() => {
      callback(null, response(201, post));
    })
    .catch((err) => response(null, response(err.statusCode, err)));
};

//get all posts
module.exports.getAllPosts = (event, context, callback) => {
  return db
    .scan({
      TableName: postsTable
    })
    .promise()
    .then((res) => {
      callback(null, response(200, res.Items.sort(sortByDate)));
    })
    .catch((err) => callback(null, response(err.statusCode, err)));
};

//Get number of posts
module.exports.getPosts = (event, context, callback) => {
  const numberOfPosts = event.pathParameters.number;
  const params = {
    TableName: postsTable,
    Limit: numberOfPosts
  };
  return db
    .scan(params)
    .promise()
    .then((res) => {
      callback(null, response(200, res.Items.sort(sortByDate)));
    })
    .catch((err) => callback(null, response(err.statusCode, err)));
};

//Fatch selected post
module.exports.getPost = (event, context, callback) => {
  const id = event.pathParameters.id;

  const params = {
    Key: {
      id: id
    },
    TableName: postsTable
  };

  return db
    .get(params)
    .promise()
    .then((res) => {
      if (res.Item) callback(null, response(200, res.Item));
      else callback(null, response(404, { error: 'Post not found' }));
    })
    .catch((err) => callback(null, callback(err.statusCode, err)));
};

// Update a post
module.exports.updatePost = (event, context, callback) => {
  const id = event.pathParameters.id;
  const reqBody = JSON.parse(event.body);
  const { body, title } = reqBody;

  const params = {
    Key: {
      id: id
    },
    TableName: postsTable,
    ConditionExpression: 'attribute_exists(id)',
    UpdateExpression: 'SET title = :title, body = :body',
    ExpressionAttributeValues: {
      ':title': title,
      ':body': body
    },
    ReturnValues: 'ALL_NEW'
  };
  console.log('Updating');

  return db
    .update(params)
    .promise()
    .then((res) => {
      console.log(res);
      callback(null, response(200, res.Attributes));
    })
    .catch((err) => callback(null, response(err.statusCode, err)));
};

// Delete a post
module.exports.deletePost = (event, context, callback) => {
  const id = event.pathParameters.id;
  const params = {
    Key: {
      id: id
    },
    TableName: postsTable
  };
  return db
    .delete(params)
    .promise()
    .then(() =>
      callback(null, response(200, { message: 'Post deleted successfully' }))
    )
    .catch((err) => callback(null, response(err.statusCode, err)));
};

// Create a user
module.exports.createUser = (event, context, callback) => {
  const reqBody = JSON.parse(event.body);

  //Check if the input is empty
  if (
    !reqBody.password ||
    reqBody.password.trim() === '' ||
    !reqBody.userName ||
    reqBody.userName.trim() === '' ||
    !reqBody.gender ||
    reqBody.gender.trim() === '' ||
    !reqBody.email ||
    reqBody.email.trim() === ''
  ) {
    return callback(
      null,
      response(400, {
        error: 'User must have a UserName, password and email, they must not be empty'
      })
    );
  }

  if (!reqBody.email.includes('@') || !reqBody.email.includes('.com')) {
    return callback(
      null,
      response(400, {
        error: 'Please enter correct email address'
      })
    );
  }

  const user = {
    id: uuid(),
    createdAt: new Date().toISOString(),
    userName: reqBody.userName,
    password: reqBody.password,
    email: reqBody.email,
    gender: reqBody.gender
  };

  const params = {
    Key: {
      userName: reqBody.userName
    },
    TableName: usersTable
  };

  return db
    .get(params)
    .promise()
    .then((res) => {
      if (res.Item) {
        callback(null, response(404, { error: 'User already exists' }));
      } else {
        return db.put({
          TableName: usersTable,
          Item: user
        })
          .promise()
          .then((res) => {
            callback(null, response(201, { success: 'User Created' }));
          })
      }
    })
    .catch((err) => callback(null, response(err.statusCode, err)));

};

//Fatch selected user
module.exports.getUser = (event, context, callback) => {
  const userName = event.pathParameters.userName;
  const password = event.pathParameters.password;

  const params = {
    Key: {
      userName: userName
    },
    TableName: usersTable
  };

  return db
    .get(params)
    .promise()
    .then((res) => {
      if (res.Item) {
        if (res.Item.password == password) {
          callback(null, response(200, { success: true, userName: res.Item.userName, email: res.Item.email, gender: res.Item.gender, id: res.Item.id }));
        } else {
          callback(null, response(400, { success: false, error: 'Wrong password' }));
        }
      }
      else callback(null, response(404, { error: 'User not found' }));
    })
    .catch((err) => callback(null, response(err.statusCode, err)));
};
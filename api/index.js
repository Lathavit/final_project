const bcrypt = require('bcrypt');
const express = require('express');
const cors = require('cors');
const fs = require('fs');

const app = express();
app.use(express.json());
app.use(cors());

app.post('/regist', (req, res) => {
    const { userName, password } = req.body;

    // Read user data from file
    const userData = JSON.parse(fs.readFileSync('users.json'));

    // Check if user already exists
    const userExists = userData.some(user => user.name === userName);
    if (userExists) {
        return res.json({ status: 'failure' });
    }

    // Add new user
    const newUser = {
        name: userName,
        password: password
    };
    userData.push(newUser);

    // Write updated data back to file
    fs.writeFileSync('users.json', JSON.stringify(userData, null, 2));

    return res.json({ status: 'success' });
});

app.post('/login', (req, res) => {
    const { userName } = req.body;

    // Read user data from file
    const userData = JSON.parse(fs.readFileSync('users.json'));

    // Find user by username
    const user = userData.find(user => user.name === userName);
    if (user) {
        return res.json({ status: 'success', hash: user.password });
    }

    return res.json({ status: 'failure' });
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
